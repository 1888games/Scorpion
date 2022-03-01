.namespace GAME {

* = * "Level Select Pt 2"


CompleteSettingsScreen:

        lda #$6D
        jsr ColourAnimation
        jsr ClearMainWindow // #$2A from kernal rom????
      //  bcs PixelRowLoop
      //  and ($B2), y
        ldy #0
        jsr PlaceMiniMapChars
        jsr CopyScorpionChars

    StartMenuSound:

        lda #128
        sta SOUND_CHANNEL_1
        jsr MainVolume
    
        lda #0
        sta $05

        ldx #7
 
    MoveScorpionLogo1:

        sta CHAR_RAM_SCORPION_LOGO_END,x
        dex 
        bpl MoveScorpionLogo1
        ldy #3

    MoveOver3Pixels:

    PixelRowLoop:

        ldx #7

    PixelRightLoop:
     
        lsr CHAR_RAM_SCORPION_LOGO,x
        ror CHAR_RAM_SCORPION_LOGO_END - 56,x
        ror CHAR_RAM_SCORPION_LOGO_END - 48,x
        ror CHAR_RAM_SCORPION_LOGO_END - 40,x
        ror CHAR_RAM_SCORPION_LOGO_END - 32,x
        ror CHAR_RAM_SCORPION_LOGO_END - 24,x
        ror CHAR_RAM_SCORPION_LOGO_END - 16,x
        ror CHAR_RAM_SCORPION_LOGO_END - 8,x
        ror CHAR_RAM_SCORPION_LOGO_END,x

        dex 
        bpl PixelRightLoop

        dey 
        bpl PixelRowLoop

        jsr PrintRowOfCharData
        .byte $02,$09,$81
        .text  @"by jimmy huey\$00"
       
        jsr PrintRowOfCharData
        .byte $03,$0c,$85
        .text  @"press  fire\$00"

        jsr PrintRowOfCharData
        .byte $04,$0d
        .text  @"to  start\$00"

        jsr PrintRowOfCharData
        .byte $03,$10,$81
        .text  @"high  score\$00"
   
        jsr DrawHighScore
      
        jsr PrintRowOfCharData
        .byte $01,$14,$87
         .text  @"select level\$00"
        
        jsr PrintRowOfCharData
        .byte $0a,$15,$85
        .text  @"game\$00"


      
    SettingsLoop:
    
        jsr CycleColour

        .label LOGO_ROW_2= 7
        .label LOGO_CHARS_2 = 8
        .label LOGO_START_COL = 4

        ldx #LOGO_ROW_2
        jsr GetRowScreenColourAddressX

        ldx #LOGO_CHARS_2
        ldy #LOGO_START_COL

    LogoCharLoop:

        lda ZP.ColourTemp
        sta (ZP.ColourAddress),y

        lda ScorpionCharIDs_Shifted,x
        sta (ZP.ScreenAddress),y
        iny 
        dex 
        bpl LogoCharLoop

        lda #%11011111
        jsr CheckKey
       
        bne NoF3

    F3Pressed:

        lda $1C
        beq RecalcBonus

        inc ZP.Difficulty

        lda #0
        .byte $2c

     NoF3:

        lda #1
        sta $1C

    RecalcBonus:

        jsr CalculateBonusIndex
        ldy #$05

    DifficultyLoop:

       // jmp L_b8c8

        lda DifficultyText,x
        ora #CHAR_TO_ROM_CHAR_MARK
        sta DIFFICULTY_POSITION,y

        lda #CYAN
        sta DIFFICULTY_COLOUR_POS,y
        dex 
        dey 

        bpl DifficultyLoop

        jsr DrawBonus

        dec ZP.CharAnimTimer
        bne NotAnimYet

        lda #2
        sta ZP.CharAnimTimer

        jsr AnimateChars
        jsr CheckLevelChange

   NotAnimYet:
        jsr DrawWaveNumberTop

        ldx #1

    LevelNumberLoop:

        lda ZP.WaveDigit1,x
        sta WAVE_NUMBER_BOTTOM,x
        dex 

        bpl LevelNumberLoop

        lda #$78
        jsr DelayByA
        jsr PulseSound

        jsr CheckFireButton
        bne SettingsLoop

        lda ZP.Difficulty 
        and #%00000011
        cmp #3
        bne NotDemo
        dec ZP.PlayRealGame

    NotDemo:
        jmp SetupNewLevel

    PulseSound:
        lda ZP.SoundEffectToggle
        beq DecreaseVolume

    IncreaseVolume:

        inc SOUND_VOLUME_AUX_COLOR
        lda SOUND_VOLUME_AUX_COLOR
        cmp #15
        beq ToggleVolume

    ExitVolume:
        rts 


    DecreaseVolume:

        dec SOUND_VOLUME_AUX_COLOR
        bne ExitVolume

    ToggleVolume:

        lda ZP.SoundEffectToggle
        eor #%00000001
        sta ZP.SoundEffectToggle
        rts 

    DrawBonus:

        jsr CalculateBonusIndex
        ldy #$05

    DigitLoop:

        lda BonusLookup,x
        sta ZP.BonusStorage2,y
        sta ZP.BonusStorage1,y

        ora #%10110000
        sta BONUS_SCREEN_POSITION,y

        dex 
        dey 
        bpl DigitLoop
        rts 

    CalculateBonusIndex:

        lda ZP.Difficulty
        and #%00000011
        asl 
        asl 
        asl 
        clc 
        adc #$05
        tax 
        rts 



    BonusLookup:

        .byte $00,$00,$04,$00,$00,$00,$00,$00,$00,$00
        .byte $08,$00,$00,$00,$00,$00,$00,$01,$06,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00

    CheckLevelChange:
        jsr ReadJoystick
        lda ZP.JOY_LEFT_NOW
        beq LevelDown
        lda ZP.JOY_RIGHT_NOW
        bne DrawWaveNumberTop
        lda ZP.Level
        cmp #31
        beq DrawWaveNumberTop
        inc ZP.Level
    IncreaseLevel:
        sed 
        lda ZP.Wave
        clc 
        adc #1
        jmp StoreExit
    LevelDown:
        lda ZP.Level
        beq LevelExit
        dec ZP.Level
        sed 
        lda ZP.Wave
        sec 
        sbc #1
    StoreExit:
        sta ZP.Wave
   
    DrawWaveNumberTop:
        cld 
        lda ZP.Wave
        lsr 
        lsr 
        lsr 
        lsr 
        ora #DIGIT_TO_CHAR_MASK
        sta WAVE_NUMBER_POSITION
        sta ZP.WaveDigit1
        lda ZP.Wave
        and #%00001111
        ora #DIGIT_TO_CHAR_MASK
        sta WAVE_NUMBER_POSITION + 1
        sta ZP.WaveDigit2
    LevelExit:
        rts 


    DrawHighScore:

        .label HIGH_SCORE_ROW = 17
        .label HIGH_SCORE_X_END = 14
        .label HIGH_SCORE_LENGTH = 10
    
        ldx #HIGH_SCORE_ROW
        jsr GetRowScreenColourAddressX

        ldx #HIGH_SCORE_LENGTH
        ldy #HIGH_SCORE_X_END

    HighScoreLoop:

        lda ZP.HighScoreString ,x
        ora #CHAR_TO_ROM_CHAR_MARK
        sta (ZP.ScreenAddress),y

        lda #CYAN
        sta (ZP.ColourAddress),y

        dey 
        dex 

        bpl HighScoreLoop
        rts 



    DifficultyText:

         .text  @"easy    "
         .text  @"normal  "
         .text  @"hard    "
         .text  @"demo  "

}