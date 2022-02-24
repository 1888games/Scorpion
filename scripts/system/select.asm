.namespace GAME {


    * = * "Level Select Pt 1"

	LevelSelectScreen:

        ldx #SCREEN_ROWS - 1

    SelectRowLoop:

        jsr GetRowScreenColourAddressX
        ldy #SCREEN_COLS - 1

    SelectCharLoop:

        lda #SOLID_CHAR
        cpx #2
        beq ClearRow

        cpx #5
        bcs ClearRow

        lda #$00

    ClearRow:

        sta (ZP.ScreenAddress),y

        lda #GREEN
        sta (ZP.ColourAddress),y

        dey 
        bpl SelectCharLoop
        dex 
        bpl SelectRowLoop

        jsr PrintRowOfCharData
        .byte $12,$0b,$80
        .text @"scan\$00"

        jsr PrintRowOfCharData
        .byte $12,$13
        .text @"next\$00"

        jsr PrintRowOfCharData
        .byte $12,$14
        .text @"egg+\$00"

        jsr PrintRowOfCharData 
        .byte $12, $07
        .text @"air+\$00"
       
    ClearMainWindow:

        ldx #6
   RowLoop2:
  
        jsr GetRowScreenColourAddressX

        ldy #16
    CharLoop2:

        lda #$00
        sta (ZP.ScreenAddress),y

        lda #GREEN
        sta (ZP.ColourAddress),y
        dey 
        bpl CharLoop2
        inx 
        cpx #SCREEN_ROWS
        bne RowLoop2
        rts 

}