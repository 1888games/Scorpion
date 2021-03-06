.namespace GAME {

	Reset32BytesTo1:

        ldx #31
        lda #1

    Loop32:
        sta ZP.Table_50_32Bytes,x

        dex 
        bpl Loop32
        rts 

    SetupScoreSidePanel:

        jsr Reset32BytesTo1

        lda #255
        sta ZP.NumberLives

        ldx #START_LIVES - 1

    LivesLoop:

        jsr IncreaseLives
        dex 
        bpl LivesLoop

    ResetScore:

        ldx #5

    ResetScoreLoop:

        lda #$00
        sta ZP.Score,x
        ora #DIGIT_TO_CHAR_MASK
        sta SCORE_POSITION,x
        lda #PURPLE
        sta SCORE_COLOUR_POSITION,x
        dex 
        bpl ResetScoreLoop


   // L_a157:
    SidePanel:

        ldx #127
    ClearDataLoop:
        lda #255
        sta CHAR_RAM_MINI_MAP,x
        cpx #64
        bcs SkipPage2

        sta Direction,x

        lda #0
        sta TABLE_64_2C0,x

    SkipPage2:
        dex 
        bpl ClearDataLoop

        ldy #$ff
        jsr PlaceMiniMapChars
        jsr ClearAirIndicator
        

    ResetEgg:
        //nop
        lda #FIRST_EGG_BONUS_ID - 6
        sta ZP.EggBonusLookup

    UpdateEggBonus:

        lda ZP.EggBonusLookup
        cmp #MAX_EGG_BONUS_ID
        bcs Exit2

        adc #DIGITS_IN_SCORE
        sta ZP.EggBonusLookup
        tay 

        ldx #EGG_BONUS_DIGITS - 1

    EggDisplayLoop:

        lda NextEggLookup,y
        ora #DIGIT_TO_CHAR_MASK
        sta NEXT_EGG_POSITION,x
        
        lda #CYAN
        sta NEXT_EGG_COLOUR_POS,x
        dey 
        dex 
        bpl EggDisplayLoop

  Exit2:

       rts 

}