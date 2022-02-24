.namespace GAME {



	DisableNMI:

        lda #%01111111
        sta INTERRUPT_ENABLE
        sta ZP.LastKeyPressed


        ldx #255

    CopyCharset:
    CopyLoop:

        lda CHAR_SET_P1,x
        sta CHAR_RAM, x
        lda CHAR_SET_P2,x
        sta CHAR_RAM + $100,x
        dex 
        cpx #255
        bne CopyLoop

    SetInterruptAddress:

        lda #<IRQ
        sta IRQ_VECTOR_LSB
        lda #>IRQ
        sta IRQ_VECTOR_MSB

        lda Timer_LSB
        sta TIMER_1_LSB
        lda Timer_MSB
        sta TIMER_1_MSB

        lda #RASTER_SPLIT_1
        sta ZP.Raster_Split_1

        lda #RASTER_SPLIT_2
        sta ZP.Raster_Split_2

        lda #INVERTED + GREEN_BORDER + BLUE_BG
        sta ZP.DefaultColours

        jsr WaitRaster128

    WaitRaster0:
        lda RASTER_Y
        bmi WaitRaster0
        cli 

        jsr InitialiseRegistersLookups

    SetupSomeValues:
    
        ldx #1
        stx ZP.Difficulty
        inx 
        stx ZP.JOY_HAND_SWITCH


    StartTitleScreen:

        jsr DrawTitleScreen
        jsr LevelSelectScreen
        jsr DrawBonus

        jsr PrintRowOfCharData
        .byte $04,$03,$87
        .text @"next bonus at:\$00"

        jsr PrintRowOfCharData

        .byte $03,$01,$86
        .text @"life:    01:wave\$00"

        ldx #RIGHT_ARROW_CHAR
        stx LIFE_ARROW_POSITION

        dex
        stx WAVE_ARROW_POSITION

        jsr SetupScoreSidePanel

    ResetGame:

        ldx #1
        stx ZP.PlayRealGame
        stx ZP.Wave
        dex 
        stx ZP.Level

        jsr CompleteSettingsScreen

        jsr SetupScoreSidePanel



}