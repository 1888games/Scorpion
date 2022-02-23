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
        sta ZP.ScorpionLogoFlag

        jsr Reset32BytesTo1

    DrawTitleChars:

        lda #64
        sta ZP.Table_50_32Bytes + 1

        lda #$14
        sta ZP.Address + 1

        ldx #$00
        stx ZP.Address


        // puts 0 at 02 and 200
        // puts $14 at 03 and 240 ??
        jsr Copy_2_4ZP_To_2_4_800X

        jsr CopyScorpionChars

        lda ZP.ScorpionLogoFlag
        eor #$01
        sta ZP.ScorpionLogoFlag


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

        lda ZP.ScorpionLogoFlag
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

        lda #32
        jsr DelayByA

        jsr ReadJoystick
        
        beq FirePressed

    FireNotPressed:

        dec ZP.Timer1
        bne NotTimer1

    Timer1:

        lda #32
        sta ZP.Timer1

        jsr AnimateChars

        dec ZP.Timer2
        beq DrawTitleChars_Jmp

    NotTimer1:

        lda ZP.ScorpionLogoFlag
        bne TitleScreenLoop

        dec ZP.Timer3
        bne TitleScreenLoop

        lda #8
        sta ZP.Timer2

        jsr HideLogo
      

        jmp TitleScreenLoop

    FirePressed:

       cli 


    EditTwoChars:

        ldx #15

    CharLoop:

        lda CHAR_EOR_TABLE,x
        eor CHAR_EDIT_ADDRESS,x
        sta CHAR_EDIT_ADDRESS,x
        dex 
        bpl CharLoop

        rts 




    UNKNOWN_CODE:


     //L_b6f9:
    HideLogo:

        ldx #0
        jsr Copy2_4_800X_To_ZP

    WaitForRaster1:

        lda RASTER_Y
        cmp ZP.Raster_Split_1
        bcc WaitForRaster1

    //jmp DrawTitleChars

    NoIdea:

        jsr L_b7a1
        inc $02
        lda $02

   
        cmp #$98
        bcc ThisDoesNothing
       
        pla 
        pla 


    DrawTitleChars_Jmp:
        jmp DrawTitleChars

    ThisDoesNothing:

        //jmp DrawTitleChars
        ldx #$00
        jsr Copy_2_4ZP_To_2_4_800X
    L_b71a:

        // Timer4 goes 3-1
        // Timer5 goes 0-5
        dec ZP.Timer4
        bne NoWrapTimer4

        lda #3
        sta ZP.Timer4

        inc ZP.Timer5
        lda ZP.Timer5
        cmp #6
        bcc NoResetTimer5

        lda #0
        sta ZP.Timer5

    NoResetTimer5:

        tay 
        lda LookupTimer5 ,y  // 0, 48, 96, 144, 96, 48  
        sta $06

     NoWrapTimer4:
     Clear96BytesLogo:

        ldx #95
        lda #0
     ClearLoop:

        sta CHAR_RAM_SCORPION_LOGO,x
        dex 
        bpl ClearLoop

        
        lda $03
        and #$07
        tax 
        clc 
        adc #$10
        sta $05
        lda $02
        and #$07
        sta $16
        ldy $06
    L_b750:
        lda L_ba40,y
        sta $1d80,x
        lda L_ba50,y
        sta $1d98,x
        lda L_ba5f + $1,y
        sta $1db0,x
        lda #$00
        sta $1dc8,x
        sty $13
        ldy $16
        beq L_b77c
    L_b76d:
        lsr $1d80,x
        ror $1d98,x
        ror $1db0,x
        ror $1dc8,x
        dey 
        bne L_b76d
    L_b77c:
        ldy $13
        inx 
        iny 
        cpx $05
        bne L_b750
        jsr Divide2_3_By_3_GetScreen
        ldx #$0b
    L_b789:
        ldy L_b7c7,x
        lda ($00),y
        beq L_b794
        cmp #$30
        bcc L_b79d
    L_b794:
        lda $b7d3,x
        lda ($00),y

      lda #$05
      //nop
      //nop
 
        sta ($0a),y
    L_b79d:
        dex 
        bpl L_b789
        rts 


    L_b7a1:
        jsr Divide2_3_By_3_GetScreen
        ldx #$0b
    L_b7a6:
        ldy L_b7c7,x
        lda ($00),y
        beq L_b7b1
        cmp #$30
        bcc L_b7b5
    L_b7b1:
        lda #$00
        lda ($00),y
    L_b7b5:
        dex 
        bpl L_b7a6

        rts 

    // L_b7b9:

    Divide2_3_By_3_GetScreen:

        lda $03
        lsr 
        lsr 
        lsr 
        tay 
        lda $02
        lsr 
        lsr 
        lsr 
        jmp GetScreenAddressCol_A_Row_Y

        


}
