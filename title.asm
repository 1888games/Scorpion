.namespace GAME {

DrawTitleScreen:

        sei
        lda #$8D
        sta COLOUR_REG

        ldx #SCREEN_ROWS - 1

    RowLoop:

        jsr GetRowScreenColourAddressX

        ldy #SCREEN_COLS - 1

    ColumnLoop:

        lda #SOLID_CHAR

        cpx #$07
        beq SkipBlank

        cpy #0
        beq SkipBlank

        cpy #$15
        beq SkipBlank

        lda #0

    SkipBlank:

        sta (ZP.ScreenAddress),y

        lda #GREEN
        sta (ZP.ColourAddress),y
        dey 
        bpl ColumnLoop

        dex
        bpl RowLoop

        jsr EditTwoChars

        jsr PrintRowOfCharData

    CopyrightMessage: // x, y, colour, chars, null term, return

        .byte $03,$15,$83,$28,$03
        .byte $29,$20,$31,$39,$38,$33,$20,$20,$14,$12,$0f,$0e,$09,$18,$00

        * = * "Return2"
    
        lda #0
        sta ZP.Temp07

        jsr Reset32BytesTo1

    L_b5bc:

        lda #64
        sta ZP.Table_50_32Bytes + 1

        lda #$14
        sta ZP.Address + 1

        ldx #$00
        stx ZP.Address


        // puts 0 at 02 and 200
        // puts $14 at 03 and 240 ??
        jsr L_ad63

        jsr CopyScorpionChars

        lda ZP.Temp07
        eor #$01
        sta ZP.Temp07


    TronixPresents:

        jsr PrintRowOfCharData
        .byte $03,$01,$83
        .text @"tronix  presents\$00"  
     
    FromDragonFly:

        jsr PrintRowOfCharData

        .byte $04,$05
        .text @"from dragonfly\$00" 

        .label LOGO_ROW = 3 
        .label LOGO_X = 7
        .label LOGO_CHARS = 7
  
        ldx #LOGO_ROW
        jsr GetRowScreenColourAddressX

        ldy #LOGO_X
        ldx #LOGO_CHARS

    LogoLoop:
        lda #BLUE
        sta (ZP.ColourAddress),y

        lda ZP.Temp07
        beq SkipChar
        lda ScorpionCharIDs,x
    SkipChar:
        sta (ZP.ScreenAddress),y
        iny 
        dex 
        bpl LogoLoop


    
    Row1_75:
        
        jsr PrintRowOfCharData
        .byte $07,$09,$86
        .text @"75\$00" 

    Row1_300:

        jsr PrintRowOfCharData
        .byte $10,$09
        .text  @"300\$00"

    Row2_1000:

        jsr PrintRowOfCharData
        .byte $05,$0b
        .text  @"1000\$00"

    Row2_400_:

        jsr PrintRowOfCharData
        .byte $10,$0b
        .text  @"400-\$00"

    Row3_200:
  
        jsr PrintRowOfCharData
        .byte $06,$0d
        .text  @"200\$00"
   
    Row_4_Worm:
    
        jsr PrintRowOfCharData  
        .byte $10,$0e
        .text @"worm\$00"
    
    Row_4_50:

        jsr PrintRowOfCharData 
        .byte $07,$0f
        .text @"50\$00"

    Row_5_Egg:

        jsr PrintRowOfCharData
        .byte $10,$0f
        .text @"egg\$00"

    Row_5_10:

         jsr PrintRowOfCharData
        .byte $07,$11
        .text @"10\$00"

    Row_6_Home:

        jsr PrintRowOfCharData
        .byte $10,$11
        .text @"home\$00"

    Row_6_150:

        jsr PrintRowOfCharData
        .byte $06,$13
        .text @"150\$00"

    Row_7_Life:

        jsr PrintRowOfCharData
        .byte $10,$13
         .text @"life\$00"

    Row_3_3200:

        jsr PrintRowOfCharData
        .byte $10,$0c
         .text @"3200\$00"


        ldx #21

    DrawSprites:

    SpriteLoop:

        lda IconXTable,x
        sta ZP.Address
        lda IconYTable, x
        sta ZP.Address_MSB

        jsr GetScreen_Col2_Row3

        lda IconCharIDs,x
        sta (ZP.ScreenAddress),y

    MoveOnToColourAddress:

        tay 
        lda ZP.ScreenAddress + 1
        clc 
        adc #144
        sta ZP.ScreenAddress + 1

        lda (ZP.ScreenAddress),y
        cpx #14

        bcs IsCorner
        lda ColourLookup,y
        
        ldy #0
        sta (ZP.ColourAddress),y

    IsCorner:
        dex 
        bpl SpriteLoop


    L_b6be:

    TitleScreenLoop:

    .break

        lda #32
        jsr DelayByA

        jsr ReadJoystick
        
        beq FirePressed
        dec $50
        bne L_b6d7
        lda #$20
        sta $50
        jsr AnimateChars
        dec $51
        beq L_b712

    L_b6d7:

        lda $07
        bne TitleScreenLoop
        dec $52
        bne TitleScreenLoop
        lda #$08
        sta $52
        jsr L_b6f9
        jmp TitleScreenLoop

    FirePressed:
        .break
       cli 

}
