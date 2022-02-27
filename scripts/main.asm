

#import "data/labels.asm"


.namespace GAME {

  //  BASICStub(Entry2)

    *=$1201 "Basic"
    BasicUpstart(GAME.Entry2)

     * = $a00C "Program Start"
    Entry2:

    #import "system/startup.asm"

    * = * "Gameplay"

    L_a0a9:

        lda ZP.Level
        and #%00000011
        tax 

   
        jsr SetupMap
        jsr SidePanel
        jsr ResetMoreVariables
        jsr MoreLevelData

        lda #$1f
        sta $8b

    StartLevel:

        jsr ResetMoreVariables


   // L_a0c1:
    GameLoop:

        lda ZP.GameSpeed
        jsr DelayByA

        jsr ProcessPlayer
        jsr L_a536

        lda $cd
        bmi L_a0d3

        jsr L_abe4

    L_a0d3:

        jsr L_a72c
        jsr L_a94a
        jsr L_b38b
        jsr $a828
        jsr GameAnimateChars
        jsr L_a612
        jsr L_a687
        jsr L_aa93
        jsr L_ab20
        jsr L_abab
        jsr $ac8e
        jsr L_acc1
        jsr L_ad11
        jsr L_ad73
        jsr L_ac17 + $e
        jsr L_ae2a

        jsr $aff7
        lda $19
        bne GameLoop


        jsr $ae81
        bcs L_a0a9


    LoseLife:

        ldy ZP.NumberLives
        bmi GameOver

        cpy #MAX_LIVES_DISPLAY 
        bcs NoDeleteLifeIcon
        lda #$00
        sta $1e1e,y

    NoDeleteLifeIcon:
        dey 
        sty ZP.NumberLives
        jmp StartLevel

    GameOver:
        jsr L_a198
        jsr TurnSoundOff
        jmp ResetGame


    #import "system/sidepanel.asm"

    

    L_a198:
      //  nop
      lda $18
      beq L_a1af
        ldx #$00
    L_a19e:
        lda $1e,x
        ora #$30
        cmp $bc,x
        bcc L_a1af
        beq L_a1aa
        bcs L_a1b0
    L_a1aa:
        inx 
        cpx #$06
        bne L_a19e
    L_a1af:
        rts 


    L_a1b0:
        ldx #$05
    L_a1b2:
        lda $1e,x
        ora #$30
        sta $bc,x
        dex 
        bpl L_a1b2
        jsr ResetZPValues
        lda #$0c
        sta $9e
        lda #$4d
        jsr ColourAnimation
        jsr PrintRowOfCharData

        .byte $02,$09,$81,$07,$12,$05,$01,$14,$20,$20,$13,$03,$0f,$12,$05,$21
        .byte $00,$20,$63,$b4,$02,$0d,$87,$10,$0c,$05,$01,$13,$05,$20,$20,$05
        .byte $0e,$14,$05,$12,$00,$20,$63,$b4,$02,$0e,$19,$0f,$15,$12,$20,$09
        .byte $0e,$09,$14,$09,$01,$0c

    L_a200:
        rol $01
        jsr PrintRowOfCharData

        .byte $07,$12,$80,$01,$2d,$2d,$00,$a2,$12,$20,$6d,$a2,$a0,$07,$a2,$01

    L_a215:
        lda #$00
        sta $1c
    L_a219:
        lda #$28
        jsr DelayByA
        stx $13
        jsr L_a72c
        ldx $13
        cpy #$0a
        bcc L_a230
        lda $a7
        cmp #$a0
        bcs L_a219
        rts 


    L_a230:
        txa 
        ora #$80
        sta ($00),y
        dec $5c
        bne L_a219
        lda #$10
        sta $5c
        sty $14
        jsr ReadJoystick
        ldy $14
        lda $0c
        bne L_a24d
        cpx #$01
        beq L_a256
        dex 
    L_a24d:
        lda $0e
        bne L_a256
        cpx #$1a
        beq L_a256
        inx 
    L_a256:
        jsr CheckFireButton
        bne L_a215
        lda $1c
        bne L_a219
        inc $1c
        txa 
        sta.a $00bd,y
        lda #$f0
        sta $a7
        iny 
        bne L_a219
        rts 


    //GetRowScreenColourAddressX:
    GetRowScreenColourAddressX:

        lda SCREEN_LSB_LOOKUP,x
        sta ZP.ScreenAddress
        sta ZP.ColourAddress

        lda SCREEN_MSB_LOOKUP,x
        sta ZP.ScreenAddress + 1

        clc 
        adc #$78
        sta ZP.ColourAddress + 1
        
        rts 


    MoreLevelData:

    CalculateFrameDelay:
    
    
        lda ZP.Level
        lsr 
        tay 
        lda LevelSpeeds,y
        sta ZP.GameSpeed

        lda L_a359,y
        sta $d4

        lda ZP.Level
        and #%00000011
        tay 

        lda L_a331,y
        sta $c8

        lda ZP.Level
        and #%00001111
        tay 

        lda L_a321,y
        sta $c7

        lda L_a345,y
        pha 


    CalculateAnotherSpeed:

        lda ZP.Level
        and #%00001111
        lsr 
        lsr 
        tay 
        lda L_a355,y
        sta $c9

        lda L_a331,y
        sta $d3


        ldx #7
    SevenLoop:
        lda #255
        sta $38,x
        sta $f0,x

        lda #$00
        sta $9658,x
        dex 
        bpl SevenLoop

        
        lda #$04
        sta $19

        ldx #6
    L_a2cc:
        jsr L_a369
        lda #$2c
        jsr L_a9d2
        lda #$00
        jsr ClearFromMiniMap
        ldy #$05
        jsr L_b438
        clc 
        adc #$20
        sta $02c0,x
        inx 
        cpx #$0a
        bne L_a2cc

        ldx #$03
    L_a2eb:
        jsr L_a37f
        dex 
        bpl L_a2eb
        pla 
        cmp #$40
        beq L_a313
        tax 

    L_a2f7:

        jsr L_a369
        ldy #$01
        jsr L_b438
        sta $04
        lda #$ff
        sta $02c0,x
        lda #$26
        jsr L_a9d2
        inx 
        inx 
        inx 
        inx 
        cpx #$40
        bne L_a2f7

    L_a313:

        ldx #$20

    L_a315:

        jsr L_a369
        lda #$25
        jsr DrawChar
        dex 
        bne L_a315
        rts 



    L_a321:
         .byte $30,$2e
        .byte $2c,$2a,$28,$26,$24,$22,$20,$1e,$1c,$1a,$18,$16,$14,$12

    L_a331:
        .byte $08
        .byte $04,$02,$01

    LevelSpeeds:
        .byte $1c,$1a,$18,$10,$0e,$0c,$0a,$09,$08,$07,$06,$05,$04
        .byte $03,$02,$01

    L_a345:

        .byte $40,$3c,$34,$34,$30,$30,$30,$30,$2c,$2c,$2c,$2c,$2c
        .byte $24,$24,$24

    L_a355:
        .byte $0c
        .byte $0a,$09,$08

    L_a359:
        .byte $0b,$0c
        .byte $0d,$11,$13,$15,$15,$17,$18,$19,$1a,$1c,$1d,$26,$28,$18

    L_a369:
        ldy #$05
    L_a36b:
        jsr L_b438
        cmp #$30
        bcs L_a36b
        sta $02
        jsr L_b438
        sta $03
        jsr L_a700
        bne L_a369
        rts 


    L_a37f:
        jsr L_a369
    L_a382:
        lda $02
        sta $a8,x
        lda $03
        sta $ac,x
        lda #$2b
        jsr DrawChar
        ldy #$03
        jsr L_b438
        clc 
        adc #$10
        sta $97,x
        lda #$03
        sta $8f,x
        sta $93,x
        rts 


    ResetMoreVariables:

        lda #START_X
        sta ZP.TileX

        lda #START_Y
        sta ZP.TileY
   
        lda #Y_UP_ONLY
        sta ZP.Direction

        ldx #PLAYER_ID
        jsr SavePositionDirection

        stx ZP.PlayerDeathProgress
        stx $82
        stx $1c

        jsr ResetEgg

        lda #$1f
        sta $ce

        jsr S40_To_CD

    ClearAirIndicator:

        ldx #$03

    ClearAirLoop:

        lda #SOLID_CHAR
        sta AIR_INDICATOR_POSITION,x

        lda #BLUE
        sta AIR_INDICATOR_COLOUR_POS,x
        dex 
        bpl ClearAirLoop

    //L_a3d0
    ResetZPValues:

        ldx #0

        stx $8a
        stx $85
        stx $9d
        stx $88
        stx $d1
        stx $d2

        dex 

        stx $89
        stx $9c
        stx $9e
        stx $cb
        stx $d5

        ldx #192
        stx $86
        stx $87

    //l_a3ef:
    TurnSoundOff:
        ldx #3
    SoundOffLoop:
        lda #$00
        sta SOUND_CHANNEL_1,x
        dex 
        bpl SoundOffLoop

    MainVolume:
        lda #15
        sta SOUND_VOLUME_AUX_COLOR
        rts 

    L_a3ff:
        lda $04
    L_a401:
        eor #$04
        sta $04
        rts 


    L_a406:
        lda $02
        cmp #$18
        bne QuitOut
        lda $03
        cmp #$20
        bne QuitOut
        ldx $8c
        jsr L_ada0

        .byte $a5,$82,$c9,$2b,$90,$09,$a5,$80,$48,$20,$79,$a1,$68,$a8,$2c,$a0
        .byte $11,$c6,$19,$20,$7b,$b2,$a0,$00,$84,$82,$88,$84,$88

    QuitOut:
        rts 


    L_a435:
    
        lda $04
        eor #$04
        tay 
        jmp MoveLocationByOne

    ProcessPlayer:

        dec ZP.PlayerDisplayTimer
        bne QuitOut
        lda #PLAYER_UPDATE_TIME
        sta ZP.PlayerDisplayTimer
        
        lda MAP_HOME_POSITION
        bne UpdateMiniMap

    AwayFromHome:

        lda #HOME_TILE
        sta MAP_HOME_POSITION

    UpdateMiniMap:

        ldx #PLAYER_ID
        jsr GetPositionDirection

        jsr DeleteChar

        lda #PLAYER_MINI_MAP
        jsr DrawIntoMiniMap


    CheckPlayerStatus:

        lda ZP.PlayRealGame
        beq PlayerNotDead

    CheckAirWhileWaiting:

        lda ZP.PlayerDeathProgress
        beq PlayerNotDead
        cmp #40
        bcc StillDoingDeath

    RunOutDisableRTS:

        pla 
        pla 
        jmp LoseLife

    StillDoingDeath:

        lda SOUND_VOLUME_AUX_COLOR
        beq VolumeAlreadyZero
        dec SOUND_VOLUME_AUX_COLOR
        lda #200
        sta SOUND_CHANNEL_4

    VolumeAlreadyZero:

        lda #DEATH_CHAR
        jsr DrawChar

        inc ZP.PlayerDeathProgress
        lda ZP.PlayerDeathProgress
        cmp #16

        bcs ExitPlayer

        ldy #$02
        jsr L_b438
        tay 
        jsr MoveLocationByOne
        jmp L_a932


    PlayerNotDead:
        lda $cd
        bpl L_a4de
        lda $82
        beq L_a4b4
        jsr L_a435
        jsr DeleteChar
        ldx $8c
        lda $02c0,x
        bne L_a4ac
        sta $82
        beq L_a4b4
    L_a4ac:
        ldx #$00
        jsr GetPositionDirection
        jsr L_a406
    L_a4b4:
        lda $18
        bne L_a4be
        jsr L_a5db
        jmp L_a4de
    L_a4be:
        jsr ReadJoystick
        ldx #$03
    L_a4c3:
        lda $0c,x
        beq L_a4d0
        dex 
        bpl L_a4c3
        jmp L_a4de
    L_a4cd:
        sta $1c
    ExitPlayer:
        rts 


    L_a4d0:
        txa 
        asl 
        sta $04
        ldy $82
        bne L_a4db
        sta $0280
    L_a4db:
        jsr L_a58f
    L_a4de:
        lda $04
        lsr 
        clc 
        adc #$03
        jsr DrawChar
        lda #$04
        jsr ClearFromMiniMap
        ldx #$00
        jsr SavePositionDirection
        lda $82
        beq L_a505
        jsr L_a435
        ldx $8c
        jsr L_a3ff
        jsr SavePositionDirection
        lda $82
        jsr DrawChar
    L_a505:
        lda $18
        beq L_a512
        jsr CheckFireButton
        bne L_a4cd
        lda $1c
        beq ExitPlayer
    L_a512:
        lda $cd
        bmi L_a519
        jsr L_ac5f
    L_a519:
        ldx #$00
        jsr GetPositionDirection
        ldx #$23
    L_a520:
        lda $0280,x
        bmi L_a52b
        dex 
        cpx #$1f
        bne L_a520
        rts 


    L_a52b:
        lda #$08
        sta $02c0,x
        lda #$ff
        sta $85
        bmi L_a560
    L_a536:
        dec $51
        bne ExitPlayer
        lda #$09
        sta $51
    L_a53e:
        ldx #$20
    L_a540:
        jsr GetPositionDirection
        bmi L_a589
        jsr L_a700
        cmp #$23
        beq L_a558
        cmp #$1c
        beq L_a558
        cmp #$1d
        beq L_a558
        cmp #$07
        bcs L_a56d
    L_a558:
        jsr DeleteChar
        dec $02c0,x
        beq L_a574
    L_a560:
        jsr L_a6ef
        bcs L_a574
        cmp #$23
        beq L_a579
        cmp #$07
        bcc L_a579
    L_a56d:
        stx $16
        jsr L_a87b
        ldx $16
    L_a574:
        jsr L_ada0
        bmi L_a589
    L_a579:
        ldy #$1c
        lda $04
        and #$02
        beq L_a582
        iny 
    L_a582:
        tya 
        jsr DrawChar
        jsr SavePositionDirection
    L_a589:
        inx 
        cpx #$24
        bne L_a540
        rts 


    L_a58f:
        jsr L_a6ef
        bcs L_a5cc
        cmp #$0a
        bcc L_a5d9
        cmp #$29
        bcc L_a5cc
        cmp #$2f
        beq L_a5cc
        cmp #$2b
        beq L_a5cc
        ldy $82
        bne L_a5cc
        sta $82
        lda #$02
        sta $89
        lda #$80
        sta $8a
        ldx #$0d
    L_a5b4:
        lda $0280,x
        bmi L_a5c7
        lda $0200,x
        cmp $02
        bne L_a5c7
        lda $0240,x
        cmp $03
        beq L_a5d2
    L_a5c7:
        dex 
        cpx #$05
        bne L_a5b4
    L_a5cc:
        ldx #$00
        sec 
        jmp GetPositionDirection
    L_a5d2:
        stx $8c

        lda #ENEMY_MINI_MAP
        jsr DrawIntoMiniMap
    L_a5d9:
        clc 
        rts 


    L_a5db:
        lda $04
        sta $06
        jsr L_a58f
        bcc L_a611
        ldy #$00
        jsr L_b438
        clc 
        adc $06
        tay 
        lda L_aa4b + $4,y
        sta $04
        sta $0280
        jsr L_a58f
        bcc L_a611
        jsr L_a3ff
        jsr L_a58f
        bcc L_a611
        lda $06
        jsr L_a401
        jsr L_a58f
        bcc L_a611
        lda $06
        sta $0280
    L_a611:
        rts 


    L_a612:
        dec $53
        bne L_a680
        lda #$38
        sta $53
        inc $68
        ldx #$0d
    L_a61e:
        jsr GetPositionDirection

        .byte $30,$3c,$bd,$c0,$02,$f0,$37,$10,$1d,$fe,$c0,$02,$bd,$c0,$02,$49
        .byte $ff,$18,$69,$01,$c9,$10,$b0,$09,$a5,$68,$29,$01,$a8,$b9,$85,$a6
        .byte $2c,$a9,$29,$4c,$5c,$a6,$de,$c0,$02,$bd,$c0,$02,$c9,$10,$b0,$09
        .byte $a5,$68,$29,$03,$a8,$b9,$81,$a6,$2c,$a9,$2c

    L_a65c:
        jsr DrawChar
        dex 
        cpx #$05
        bne L_a61e
        ldx #$03
    L_a666:
        lda $97,x
        bmi L_a67d
        beq L_a67d
        dec $97,x
        bne L_a67d
        lda $a8,x
        sta $02
        lda $ac,x
        sta $03
        lda #$2f
        jsr DrawChar
    L_a67d:
        dex 
        bpl L_a666
    L_a680:
        rts 


    L_a681:
        bit $2c2d
        rol $2a29
    L_a687:
        dec $52
        bne L_a680
        lda #$20
        sta $52
        inc $6a
        lda #$07
        sta $8d
        ldx #$0d
    L_a697:
        jsr GetPositionDirection
        bmi L_a6c1
        lda $02c0,x
        bne L_a6c1
        jsr L_a6c7
        jsr L_a9f1

        .byte $a5,$04,$4a,$85,$05,$a5,$6a,$4a,$90,$03,$a9,$14,$2c,$a9,$18,$18
        .byte $65,$05,$20,$d2,$a9,$a9,$00,$20,$3e,$af

    L_a6c1:
        dex 
        cpx #$05
        bne L_a697
        rts 


    L_a6c7:
        lda #ENEMY_MINI_MAP
        jsr DrawIntoMiniMap

        ldx #$03
    L_a6ce:
        lda $97,x
        bmi L_a6da
        dex 
        bpl L_a6ce
        ldx $13
        jmp DeleteChar
    L_a6da:
        jsr L_a382
        ldx $13


    // L_a6df

    GetPositionDirection:

        lda TileX,x
        sta ZP.TileX

        lda TileY,x
        sta ZP.TileY

        lda Direction,x
        sta ZP.Direction

        rts 


    L_a6ef:
        ldy $04
    L_a6f1:
        jsr MoveLocationByOne
    L_a6f4:
        lda $03
        cmp #$40
        bcs L_a706
        lda $02
        cmp #$30
        bcs L_a706
    L_a700:
        jsr ConvertTileToScreen
        lda ($00),y
        clc 
    L_a706:
        rts 



    L_a707:
         .byte $a5,$83,$10,$03
        .byte $a0,$00,$2c,$a0,$04,$60

    L_a711:
        .byte $a5,$84,$10,$03
        .byte $a0,$02,$2c,$a0,$06,$60

    L_a71b:
        lda $0240
        sec 
        sbc $03
        sta $84
        lda $0200
        sec 
        sbc $02
        sta $83
        rts 



    L_a72c:
         .byte $a5,$18,$f0,$29,$a5,$d5,$30,$15,$4a,$90,$03
        .byte $a9,$c0,$2c,$a9,$e0,$8d,$0a,$90,$ce,$0e,$90,$d0,$15,$c6,$d5

    L_a746:
        jmp TurnSoundOff
        lda $9e
        bmi L_a76c
        lda $9d
        bpl L_a75a
        sec 
        sbc #$02
        sta $9d
        sta $900c
    L_a759:
        rts 


    L_a75a:
        lda #$ff
        sta $9d
        lda $900e
        beq L_a759
        dec $900e
        dec $9e
        bpl L_a759
        bmi L_a746
    L_a76c:
        lda $86
        sec 
        sbc #$02
        cmp $87
        bcc L_a77c
        sta $86
        sta $900a
        bne L_a78b
    L_a77c:
        lda #$c0
        sta $86
        lda $87
        sec 
        sbc #$02
        bmi L_a789
        lda #$b0
    L_a789:
        sta $87
    L_a78b:
        lda $9c
        bmi L_a7a1
        lda $900d
        sec 
        sbc #$0a
        sta $900d
        dec $9c
        bpl L_a7b7
        lda #$00
        sta $900d
    L_a7a1:
        lda $d1
        bpl L_a7ac
        sec 
        sbc #$04
        sta $d1
        bne L_a7b4
    L_a7ac:
        lda $88
        bpl L_a7b7
        dec $88
        lda $88
    L_a7b4:
        sta $900d
    L_a7b7:
        lda $a7
        cmp #$a0
        bcc L_a7d4
        dec $54
        bne L_a7f6
        lda #$06
        sta $54
        dec $a7
        lda $a7
        cmp #$a0
        bcs L_a7cf
        lda #$01
    L_a7cf:
        sta $900b
        bne L_a7f6
    L_a7d4:
        lda $cb
        bmi L_a7ea
        lda $a0
        clc 
        adc #$08
        sta $a0
        sta $900b
        bmi L_a7f6
        dec $cb
        lda #$80
        sta $a0
    L_a7ea:
        lda $d2
        bpl L_a7f6
        sec 
        sbc #$03
        sta $d2
        sta $900b
    L_a7f6:
        lda $89
        bmi L_a815
        ldy $89
        lda $8a
        cmp L_a824,y
        bcs L_a80b
        adc #$02
        sta $8a
        sta $900c
        rts 


    L_a80b:
        dec $89
        lda #$7f
        sta $900c
        sta $8a
        rts 


    L_a815:
        lda $85
        bpl L_a823
        lda $85
        sec 
        sbc #$02
        sta $85
        sta $900c
    L_a823:
        rts 



    L_a824:
         .byte $f0,$cf
        .byte $ae,$a0,$c6,$55,$d0,$24,$a5,$d4,$85,$55

    L_a830:
        ldx #$07
    L_a832:
        lda $38,x
        bmi L_a84d
        ldy #$00
        jsr L_a851
        ldy #$ff
        inc $48,x
        lda $48,x
        cmp #$10
        bne L_a84a
        tya 
        sta $38,x
        bmi L_a84d
    L_a84a:
        jsr L_a851
    L_a84d:
        dex 
        bpl L_a832
        rts 


    L_a851:
        sty $06
        ldy #$07
    L_a855:
        lda $38,x
        sta $02
        lda $40,x
        sta $03
        sty $14
        lda $48,x
        jsr MoveLocationByA
        jsr L_a6f4
        bcs L_a875
        beq L_a86f
        cmp #$09
        bne L_a875
    L_a86f:
        lda #$09
        and $06
        sta ($00),y
    L_a875:
        ldy $14
        dey 
        bpl L_a855
        rts 


    L_a87b:
        cmp #$25
        bne L_a885
        jsr L_ac0a
        jmp L_a91f
    L_a885:
        ldx #$02
    L_a887:
        lda $0280,x
        bmi L_a89a
        lda $02
        cmp $0200,x
        bne L_a89a
        lda $03
        cmp $0240,x
        beq L_a8a0
    L_a89a:
        inx 
        cpx #$40
        bne L_a887
    L_a89f:
        rts 



    L_a8a0:
         .byte $e0,$06,$90,$1b,$e0,$0e,$90,$3b,$e0,$10,$90,$16
        .byte $e0,$20,$90,$5e,$e0,$24,$90,$eb,$bd,$80,$02,$29,$04,$f0,$0e,$a0
        .byte $23,$d0,$05,$a0,$05,$2c,$a0,$17

    L_a8c4:
        jsr L_ada0
        bmi L_a921
    L_a8c9:
        lda $02c0,x
        bpl L_a89f
        lda #$04
        sta $02c0,x
        lda #$7f
        sta $9c
        lda $d7
        clc 
        adc #$21
        sta $03f7
        ldy #$1d
        bne L_a92f
        lda $02c0,x
        bmi L_a89f
        beq L_a8f5

        lda #ENEMY_MINI_MAP
        jsr DrawIntoMiniMap

        dec $19
        ldy #$05
        bne L_a8c4
    L_a8f5:
        ldy #$05
        jsr L_b438
        clc 
        adc #$10
        eor #$ff
        clc 
        adc #$01
        sta $02c0,x
        lda #$f0
        sta $a7
        lda #$29
        jmp DrawChar
    L_a90e:
        ldy $02c0,x
        lda.a $0093,y
        bmi L_a89f
        lda #$fc
        sta.a $0093,y
        ldy #$29
        bne L_a92b
    L_a91f:
        ldy #$0b
    L_a921:
        sty $05
        jsr DeleteChar
        jsr L_a932
        ldy $05
    L_a92b:
        lda #$f0
        sta $88
    L_a92f:
        jmp L_b27b
    L_a932:
        ldx #$07
    L_a934:
        lda $38,x
        bmi L_a93d
        dex 
        bpl L_a934
        bmi L_a949
    L_a93d:
        lda $02
        sta $38,x
        lda $03
        sta $40,x
        lda #$00
        sta $48,x
    L_a949:
        rts 


    L_a94a:
        dec $58
        bne L_a9bf
        lda $c7
        sta $58
        ldx #$03
    L_a954:
        lda $97,x
        bne L_a979
        lda $8f,x
        bmi L_a979
        lda L_aa4b,x
        sec 
        sbc $8f,x
        tay 
        dec $8f,x
        lda $a8,x
        sta $0200,y
        lda $ac,x
        sta $0240,y
        lda L_aa56 + $1,x
        sta $0280,y
        txa 
        sta $02c0,y
    L_a979:
        dex 
        bpl L_a954
        lda #$13
        sta $8d
        ldy #$03
    L_a982:
        sty $07
        lda.a $0097,y
        bne L_a9ba
        ldx L_aa4b,y
        lda.a $0093,y
        bpl L_a99a
        txa 
        sec 
        sbc #$04
        sta $8e
        jmp L_aa5b
    L_a99a:
        jsr GetPositionDirection
        bmi L_a9a5
        jsr DeleteChar
        jsr L_a9c9
    L_a9a5:
        jsr L_a9c0
        dex 
        jsr GetPositionDirection
        bmi L_a9ba
        jsr L_a9f1
        lda $04
        lsr 
        clc 
        adc #$0a
        jsr L_a9d2
    L_a9ba:
        ldy $07
        dey 
        bpl L_a982
    L_a9bf:
        rts 


    L_a9c0:
        jsr L_a9c3
    L_a9c3:
        dex 
        lda $0280,x
        bmi L_a9bf
    L_a9c9:
        dex 
        jsr GetPositionDirection
        inx 
        lsr 
        clc 
        adc #$0e
    L_a9d2:
        jsr DrawChar
        jsr SavePositionDirection
    L_a9d8:
        lda $02
        cmp $0200
        bne L_a9f0
        lda $03
        cmp $0240
        bne L_a9f0
        lda $cd
        bpl L_a9f0
        lda $09
        bne L_a9f0
        inc $09
    L_a9f0:
        rts 


    L_a9f1:
        lda $04
        sta $06
        jsr L_a71b
        bne L_aa00
        jsr L_a711
        jmp L_aa07
    L_aa00:
        lda $84
        bne L_aa09
        jsr L_a707
    L_aa07:
        sty $04
    L_aa09:
        lda $06
        eor #$04
        cmp $04
        beq L_aa16
        jsr L_aa39
        bcc L_a9bf
    L_aa16:
        ldy #$00
        jsr L_b438
        clc 
        adc $06
        tay 
        lda L_aa4b + $4,y
        sta $04
        sta $0280,x
        jsr L_aa39
        bcc L_a9bf
        jsr L_a3ff
        jsr L_aa39
        bcc L_a9bf
        lda $06
        jsr L_a401
    L_aa39:
        jsr L_a6ef
        bcs L_aa48
        cmp #$02
        beq L_aa47
        cmp $8d
        bcs L_aa48
        rts 


    L_aa47:
        sec 
    L_aa48:
        jmp GetPositionDirection

    L_aa4b:
         .byte $13,$17,$1b,$1f,$02
        .byte $06,$00,$04,$02,$06,$00

    L_aa56:
        .byte $04,$04,$00,$04,$00

    L_aa5b:
        jsr GetPositionDirection
        bmi L_aa6f
        lda.a $0093,y
        eor #$ff
        clc 
        adc #$01
        tay 
        lda L_aa8e,y
        jsr DrawChar
    L_aa6f:
        ldy $07
        dex 
        cpx $8e
        bne L_aa5b
        tya 
        tax 
        inc $93,x
        bne L_aa8b
        lda #$ff
        sta $97,x
        ldx L_aa4b,y
    L_aa83:
        jsr L_ada0
        dex 
        cpx $8e
        bne L_aa83
    L_aa8b:
        jmp L_a9ba

    L_aa8e:
         .byte $00,$00
        .byte $09,$08,$07

    L_aa93:
        dec $56
        bne L_aac1
        lda #$28
        sta $56
        ldx #$24
    L_aa9d:
        jsr GetPositionDirection
        and #$04
        bne L_aab9
        jsr DeleteChar
        lda $02c0,x
        bmi L_aab1
        jsr L_aaff
        bne L_aab9
    L_aab1:
        jsr L_aac2
        lda #$26
        jsr L_a9d2
    L_aab9:
        inx 
        inx 
        inx 
        inx 
        cpx #$40
        bne L_aa9d
    L_aac1:
        rts 



    L_aac2:
         .byte $a5,$04,$29,$01,$d0,$03
        .byte $a0,$00,$2c,$a0,$04,$a9,$01,$20,$df,$aa,$a5,$04,$29,$02,$d0,$03
        .byte $a0,$02,$2c,$a0,$06,$a9,$02

    L_aadf:
        sta $05
        jsr L_a6f1
        bcs L_aaea
        cmp #$1e
        bcc L_aafc
    L_aaea:
        jsr GetPositionDirection
        jsr L_afb7
        bcs L_aaf6
        lda #$f0
        sta $d2
    L_aaf6:
        lda $04
        eor $05
        sta $04
    L_aafc:
        jmp SavePositionDirection
    L_aaff:
        stx $05
        dec $02c0,x
        lda $02c0,x
        pha 
        ora #$04
        sta $04
        pla 
        clc 
        adc $05
        tax 
        jsr SavePositionDirection
        lda $c8
        sta $02c0,x
        ldx $05
        lda #$01
        jmp DrawChar
    L_ab20:
        dec $59
        bne L_ab5a
        lda #$30
        sta $59
        ldx #$24
    L_ab2a:
        jsr GetPositionDirection
        bmi L_ab55
        and #$04
        beq L_ab55
        jsr DeleteChar
        jsr L_aac2
        lda #$22
        jsr L_a9d2
        jsr L_afb7
        bcs L_ab55
        ldy #$01
        jsr L_b438
        bne L_ab52
        lda #$80
        sta $a0
        lda #$05
        sta $cb
    L_ab52:
        jsr L_ab5b
    L_ab55:
        inx 
        cpx #$40
        bne L_ab2a
    L_ab5a:
        rts 


    L_ab5b:
        txa 
        pha 
        dec $02c0,x
        bne L_ab97
        lda $c8
        sta $02c0,x
    L_ab67:
        ldx #$07
    L_ab69:
        lda $f0,x
        bmi L_ab72
        dex 
        bpl L_ab69
        bmi L_ab97
    L_ab72:
        jsr L_afc9
        sta $04
        jsr L_a6f1
        bcs L_ab97
        cmp #$07
        bcs L_ab97
        ldy #$02
        jsr L_b438
        clc 
        adc #$04
        sta $30,x
        sta $f8,x
        lda $04
        sta $f0,x
        jsr L_ab9a
        lda #$c0
        sta $d1
    L_ab97:
        pla 
        tax 
        rts 


    L_ab9a:
        lda #$23
        jsr DrawChar
        jsr L_a9d8
        lda $02
        sta $e0,x
        lda $03
        sta $e8,x
        rts 


    L_abab:
        dec $5b
        bne L_abe3
        lda #$08
        sta $5b
        ldx #$07
    L_abb5:
        lda $f0,x
        bmi L_abe0
        sta $04
        dec $f8,x
        bne L_abe0
        lda $30,x
        sta $f8,x
        lda $e0,x
        sta $02
        lda $e8,x
        sta $03
        jsr DeleteChar
        jsr L_a6ef
        bcs L_abd7
        cmp #$07
        bcc L_abdd
    L_abd7:
        lda #$ff
        sta $f0,x
        bmi L_abe0
    L_abdd:
        jsr L_ab9a
    L_abe0:
        dex 
        bpl L_abb5
    L_abe3:
        rts 


    L_abe4:
        jsr CycleColour
        sta $973c
        dec $5d
        bne L_abe3
        lda #$10
        sta $5d
        lda $cd
        ora #$80
        sta $900c
        sta $900b
        lda #$0a
        sta $900e
        dec $cd
        bpl L_abe3

    S40_To_CD:
        lda #$40
        sta $cd
        rts 


    L_ac0a:
        lda $ce
        and #$07
        cmp #$07
        bcc L_ac17
        lda #$21
        jsr L_ac7a

    L_ac17:
         .byte $e6,$ce,$a5,$ce,$c9,$20,$90,$49,$a9,$1f,$85,$ce,$d0,$43,$c6,$65
        .byte $d0,$5c,$a9,$20,$85,$65,$c6,$5e,$d0,$54,$a5,$c9,$85,$5e,$a5,$ce
        .byte $c9,$07,$b0,$0b,$a5,$d6,$f0,$0b,$a9,$10,$85,$d5,$a9,$00,$2c,$a9
        .byte $01,$85,$d6

    L_ac4a:
        lda $ce
        and #$07
        bne L_ac55
        lda #$00
        jsr L_ac7a
    L_ac55:
        lda $ce
        bne L_ac66
        lda $09
        bne L_ac85
        inc $09
    L_ac5f:
        lda #$ff
        sta $cd
        jmp ResetZPValues
    L_ac66:
        dec $ce
        lda $ce
        and #$07
        tay 
        lda L_ac86,y
        ldy #$07
    L_ac72:
        sta $1e58,y
        dey 
        bpl L_ac72
        lda #$4b
    L_ac7a:
        pha 
        lda $ce
        lsr 
        lsr 
        lsr 
        tay 
        pla 
        sta $1ec2,y
    L_ac85:
        rts 



    L_ac86:
         .byte $80
        .byte $c0,$e0,$f0,$f8,$fc,$fe,$ff,$c6,$5a,$d0,$f3,$a9,$a0,$85,$5a,$a5
        .byte $1a,$29,$0f,$c9,$03,$90,$e7,$a2,$05

    L_aca0:
        lda $0280,x
        bmi L_acab
        dex 
        cpx #$01
        bne L_aca0
    L_acaa:
        rts 


    L_acab:
        jsr L_a369
        jsr L_afb7
        bcc L_acab
        ldy #$00
        jsr L_b438
        beq L_acbc
        lda #$04
    L_acbc:
        sta $04
        jmp L_ad04
    L_acc1:
        dec $5f
        bne L_acaa
        lda #$20
        sta $5f
        ldx #$05
    L_accb:
        jsr GetPositionDirection
        bmi L_acfe
        jsr DeleteChar
        ldy #$01
        jsr L_b438
        beq L_acec
        jsr L_a71b
        jsr L_a711
        jsr L_a6f1
        bcs L_ace9
        cmp #$07
        bcc L_acec
    L_ace9:
        jsr GetPositionDirection
    L_acec:
        jsr L_a6ef
        bcs L_acf5
        cmp #$07
        bcc L_acfb
    L_acf5:
        jsr GetPositionDirection
        jsr L_a3ff
    L_acfb:
        jsr L_ad04
    L_acfe:
        dex 
        cpx #$01
        bne L_accb
        rts 


    L_ad04:
        ldy $04
        lda L_ad0c,y
        jmp L_a9d2

    L_ad0c:
         .byte $27,$00,$00,$00
        .byte $28

    L_ad11:
        ldx #$0e
        lda $0280,x
        bpl L_ad72
        lda $1a
        and #$0f
        cmp #$02
        bcc L_ad72
        dec $60
        bne L_ad72
        lda #$c0
        sta $60
        lda #$10
        sta $16
    L_ad2c:
        dec $16
        beq L_ad72
        ldy #$03
        jsr L_b438
        tay 
        lda L_adfa,y
        clc 
        adc $0200
        sta $02
        ldy #$03
        jsr L_b438
        tay 
        lda L_adfa,y
        clc 
        adc $0240
        sta $03
        jsr L_a6f4
        bcs L_ad2c
        bne L_ad2c
        lda #$fb
        sta $02c0,x
        ldy #$05
        jsr L_b438
        sta $62
        sta $04
    //SavePositionDirection:

    // l_ad63
    SavePositionDirection:
        lda $02
        sta TileX,x
        lda $03
        sta TileY,x
        lda $04
        sta Direction,x
    L_ad72:
        rts 


    L_ad73:
        dec $61
        bne L_ad72
        lda #$18
        sta $61
        ldx #$0e
        jsr GetPositionDirection
        bmi L_ad72
        jsr DeleteChar
        lda $02c0,x
        beq L_adc8
        bpl L_ad99
        inc $02c0,x
        beq L_adc8
        lda $02c0,x
        eor #$ff
        jmp L_adaf
    L_ad99:
        lda $02c0,x
        cmp #$04
        bne L_ada6
    L_ada0:
        lda #$ff
        sta $0280,x
        rts 


    L_ada6:
        lda $02c0,x
        sec 
        sbc #$01
        inc $02c0,x
    L_adaf:
        asl 
        asl 
        asl 
        tay 
        ldx #$00
    L_adb5:
        lda L_ae0a,y
        sta $1d00,x
        iny 
        inx 
        cpx #$08
        bne L_adb5
        lda #$20
        ldx #$0e
        jmp L_a9d2
    L_adc8:
        dec $62
        bne L_add1
        lda #$01
        sta $02c0,x
    L_add1:
        ldy #$02
        jsr L_b438
        tay 
        jsr L_a6f1
        bcs L_adde
        beq L_ade1
    L_adde:
        jsr GetPositionDirection
    L_ade1:
        lda #$1f
        ldx #$0e
        jsr L_a9d2
        jsr L_afb7
        bcs L_ad72
        dec $63
        bne L_ad72
        lda $d3
        sta $63
        txa 
        pha 
        jmp L_ab67

    L_adfa:
         .byte $f8,$f9,$fa,$fb,$fc
        .byte $fe,$fe,$ff,$01,$02,$03,$04,$05,$06,$07,$08

    L_ae0a:
        .byte $c3,$e7
        .byte $66,$18,$e7,$66,$99,$42,$00,$00,$14,$36,$08,$36,$49,$22,$00,$00
        .byte $00,$14,$08,$1c,$08,$00,$00,$00,$00,$00,$08,$08,$00,$00

    L_ae2a:
        dec $66
        bne L_ae70
        lda #$04
        sta $66
        lda $8b
        bmi L_ae70
        ldx #$07
        lda #$00
    L_ae3a:
        sta $1cf0,x
        dex 
        bpl L_ae3a
        lda #$20
        sec 
        sbc $8b
    L_ae45:
        pha 
        ldy #$02
        jsr L_b438
        tax 
        ldy #$02
        jsr L_b438
        tay 
        lda L_ae78 + $1,y
        eor $1cf0,x
        sta $1cf0,x
        pla 
        sec 
        sbc #$01
        bne L_ae45
        dec $8b
        bpl L_ae70
        ldx #$07
    L_ae67:
        lda L_ae71,x
        sta $1cf0,x
        dex 
        bpl L_ae67
    L_ae70:
        rts 



    L_ae71:
         .byte $cc,$cc,$33,$33
        .byte $cc,$cc,$33

    L_ae78:
        .byte $33,$80
        .byte $40,$20,$10,$08,$04,$02,$01,$20,$ef,$a3,$20,$30,$a8,$20,$ff,$af
        .byte $20,$8b,$b1,$20,$3e,$a5,$a9,$70,$20,$04,$b5,$20,$4a,$ac,$a5,$ce
        .byte $f0,$11,$a9,$e8,$8d,$0c,$90,$a0,$05,$20,$7b,$b2,$a9,$70,$20,$04
        .byte $b5,$f0,$d4

    L_aead:
        jsr L_ac4a
        jsr ClearMainWindow
        ldy #$00
        jsr PlaceMiniMapChars
        jsr Reset32BytesTo1
        lda #$3c
        sta $02
        lda #$28
        sta $03
        bne L_aed7
    L_aec5:
        lda #$16
        jsr DelayByA
        lda $900e
        beq L_aedc
        inc $900c
        bmi L_aedc
        dec $900e
    L_aed7:
        lda #$a0
        sta $900c
    L_aedc:
        dec $51
        bne L_aec5
        lda #$0c
        sta $51
        jsr WaitRaster128
        dec $50
        bne L_af0b
        lda #$03
        sta $50
        lda $03
        cmp #$68
        bcc L_af0b
        jsr PrintRowOfCharData
        ora ($0c,x)
        stx $17
        ora ($16,x)
        ora $20
        jsr $0504

        .byte $13,$14,$12,$0f,$19,$05,$04,$00

    L_af0b:
        jsr L_b7a1
        inc $03
        lda $03
        cmp #$b9
        bcs L_af1c
        jsr L_b71a
        jmp L_aec5
    L_af1c:
        inc ZP.Level
        lda ZP.Level
        and #%00011111
        sta ZP.Level
        jsr IncreaseLevel
        jsr Reset32BytesTo1

    SetupNewLevel:
        jsr TurnSoundOff
        lda #$8d
        jmp ColourAnimation

   CycleColour:
        inc ZP.ColourTemp
        lda ZP.ColourTemp
        and #%00000111
        sta ZP.ColourTemp
        rts 


    DrawIntoMiniMap:

        ldy #0
        bit ClearFromMiniMap: $ffa0  // ldy #255
        sty ZP.ObjectType

        stx ZP.X_Reg
        sta ZP.TempData

        lda ZP.TileX
        clc 
        adc #8
        pha 

        and #%00001111
        lsr 
        lsr 
        clc 
        adc ZP.TempData
        tay 
        lda PixelMaskLookup,y

        sta ZP.TempData

        pla 
        lsr 
        lsr 
        lsr 
        lsr 
        tay 
        lda ColumnByteStart,y
        tay 

        lda ZP.TileY
        lsr 
        and #%11111110  
        tax 

        jsr DrawPixel

        inx 
        jsr DrawPixel

        ldx ZP.X_Reg
        rts 

    DrawPixel:

        txa 
        ora #<CHAR_RAM_MINI_MAP
        sta ZP.DataAddress

        lda #>CHAR_RAM_MINI_MAP
        sta ZP.DataAddress + 1

        lda ZP.TempData
        bit ZP.ObjectType
        beq EnemyColour
        and (ZP.DataAddress),y
        sta (ZP.DataAddress),y
        rts 

    EnemyColour:

        eor #%11111111
        ora (ZP.DataAddress),y
        sta (ZP.DataAddress),y
        rts 


    PixelMaskLookup:     .byte $3f,$cf,$f3,$fc,$bf,$ef,$fb,$fe
        
    ColumnByteStart:     .byte 0, 32, 64, 96
       

    * = * "IRQ"

    IRQ:
      
        lda ZP.DefaultColours
        ldx RASTER_Y
        cpx ZP.Raster_Split_1
        bcs L_afab

        lda #INVERTED + BLACK_BORDER + LIGHT_BLUE_BG
        cpx ZP.Raster_Split_2
        bcs L_afab

        lda #INVERTED + GREEN_BORDER + LIGHT_BLUE_BG

    L_afab:
        sta COLOUR_REG
        bit $9124
        pla 
        tay 
        pla 
        tax 
        pla 
        rti 


      * = * "Game continued"

    L_afb7:
        jsr L_a71b
        clc 
        adc #$08
        cmp #$10
        bcs L_afc8
        lda $84
        clc 
        adc #$08
        cmp #$10
    L_afc8:
        rts 


    L_afc9:
        jsr L_a71b

        .byte $a9,$00,$a4,$83,$f0,$07,$30,$03,$09,$04,$2c,$09,$01,$a4,$84,$f0
        .byte $07,$30,$03,$09,$08,$2c,$09,$02

    L_afe4:
        tay 
        lda L_afea,y
        tay 
        rts 



    L_afea:
         .byte $08,$00,$02
        .byte $01,$04,$08,$03,$08,$06,$07,$08,$08,$05,$c6,$64,$d0,$cd,$a9,$08
        .byte $85,$64

    L_afff:
        ldx #$00
        jsr GetPositionDirection
        lda $03
        sec 
        sbc #$08
        tax 
        clc 
        adc #$11
        sta $05
        lda $02
        clc 
        adc #$08
        sta $02
        lda #$84
        sta $a3
        sta $0a
        lda #$1e
        sta $a4
        lda #$96
        sta $0b
    L_b024:
        lda $0340,x
        sta $a1
        lda $0380,x
        sta $a2
        lda $02
        sta $06
        stx $13
        ldy #$10
        cpx #$40
        bcc L_b049
    L_b03a:
        lda #$24
        sta ($a3),y
        tax 
        lda ColourLookup,x
        sta ($0a),y
        dey 
        bpl L_b03a
        bmi L_b064
    L_b049:
        lda #$24
        sty $14
        ldy $06
        cpy #$30
        bcs L_b055
        lda ($a1),y
    L_b055:
        ldy $14
        sta ($a3),y
        tax 
        lda ColourLookup,x
        sta ($0a),y
        dec $06
        dey 
        bpl L_b049
    L_b064:
        lda $a3
        clc 
        adc #$16
        sta $a3
        sta $0a
        lda $a4
        adc #$00
        sta $a4
        adc #$78
        sta $0b
        ldx $13
        inx 
        cpx $05
        bne L_b024
        rts 


    SetupMap:

        lda LevelDataPointers_MSB,x
        sta ZP.LevelDataPointer + 1

        lda #>MAP_DATA
        sta ZP.MapDataPointer + 1

        lda LevelDataPointers_LSB, x
        sta ZP.LevelDataPointer

        ldy #0
        sty ZP.MapDataPointer

    NextByte:

        lda ZP.MapDataPointer + 1
        cmp #>MAP_DATA_END
        beq ExitThis

        jsr ProcessByte

        iny 
        bne NextByte
        inc ZP.LevelDataPointer + 1
        bne NextByte

    ProcessByte:

        sty ZP.TempY

        lda (ZP.LevelDataPointer),y
        sta ZP.TempData

        ldx #7
    BitLoop:

        lda #WALL_TILE
        asl ZP.TempData
        bcs IsWallTile

    IsEmptyTile:

        lda #EMPTY_TILE

    IsWallTile:

        ldy #0
        sta (ZP.MapDataPointer),y
        iny 
        sta (ZP.MapDataPointer),y

        lda ZP.MapDataPointer
        clc 
        adc #2
        sta ZP.MapDataPointer

        bcc NoDataWrap
        inc ZP.MapDataPointer + 1

   NoDataWrap:
        dex 
        bpl BitLoop
        ldy ZP.TempY
    ExitThis:
        rts 

    LevelDataPointers_MSB:      .byte $bc,$bc,$bd,$be
    LevelDataPointers_LSB:      .byte $00,$c0,$80,$40
        
     

    * = * "Do the colour animation" 
    ColourAnimation:

        pha 
        ldy #SOLID_CHAR
        jsr DoACycle

    DoSecondCycle:

        pla 
        sta ZP.DefaultColours

        ldy #BLANK_CHAR

    DoACycle:

        sty ZP.CharToUse

        lda #8
        sta ZP.ScreenCol 

        lda #14
        sta ZP.ScreenRow

        lda #1
        sta ZP.NumChars
        sta ZP.ColourTemp

    StillLayersToDraw:

        ldy #Y_DOWN_ONLY

    DrawAnotherLine:

        jsr DrawLine
        dey 
        dey 
        bpl DrawAnotherLine

        lda #$a0
        jsr DelayByA
        jsr CycleColour

        ldy #X_LEFT_Y_UP
        jsr MoveLocationByOne
        
        inc ZP.NumChars
        inc ZP.NumChars

        lda ZP.NumChars

        cmp #19
        bcc StillLayersToDraw
        rts 


    DrawLine:

        sty ZP.DirectionToMove
        ldx ZP.NumChars

    DrawChar2:

        jsr GetScreen_Col2_Row3

        lda ZP.CharToUse
        sta (ZP.ScreenAddress),y

        lda ZP.ColourTemp
        sta (ZP.ColourAddress),y

        dex 
        beq DoneALine

        ldy ZP.DirectionToMove
        jsr MoveLocationByOne

        jmp DrawChar2

    DoneALine:

        ldy ZP.DirectionToMove

        rts 


    #import "system/anim.asm"
    #import "system/select.asm"

   * = * "Game continued"

    PlaceMiniMapChars:
 
         sty $06
       ldx #12
    L_b24d:
        jsr GetRowScreenColourAddressX

    L_b250:

        txa
        clc
        adc #48
        sta $05

        ldy #21

     MapDrawLoop:
        lda $06
        beq $b25f

        lda $05
    
        .byte $2C
        and ($A9, x)

      //  bit $21A9
        sta (ZP.ScreenAddress), y

        lda $05
        sec
        sbc #4
        sta $05

        lda #11
        and $06
        sta (ZP.ColourAddress), y

        dey
        cpy #17
        bne MapDrawLoop

        inx
        cpx #16
        bne L_b24d

        rts



    L_b27b:
        stx $13
        clc 
        ldx #$05
    L_b280:
        lda NextEggLookup,y
        adc $1e,x
        cmp #$0a
        bcc L_b28c
        sbc #$0a
        sec 
    L_b28c:
        sta $1e,x
        ora #$b0
        sta $1e08,x
        dey 
        dex 
        bpl L_b280
        ldx #$00
    L_b299:
        lda $1e,x
        cmp $24,x
        bcc L_b2ca
        beq L_b2a3
        bcs L_b2a8
    L_b2a3:
        inx 
        cpx #$06
        bne L_b299
    L_b2a8:
        jsr IncreaseLives
        jsr ResetZPValues
        lda #$0a
        sta $9e
        clc 
        ldx #$05
    L_b2b5:
        lda $2a,x
        adc $24,x
        cmp #$0a
        bcc L_b2c0
        sbc #$0a
        sec 
    L_b2c0:
        sta $24,x
        ora #$b0
        sta $1e60,x
        dex 
        bpl L_b2b5
    L_b2ca:
        ldx $13
        rts 


 //   L_b2cd:
    IncreaseLives:

        ldy ZP.NumberLives
        iny 
        bmi ExitLives
        sty ZP.NumberLives
        cpy #4
        bcs ExitLives

        lda #BLACK
        sta LIFE_INDICATOR_COLOUR_POS,y

        lda #SCORPION_UP_CHAR
        sta LIFE_INDICATOR_POSITION,y

    ExitLives:
        rts 



    NextEggLookup:
         .byte $00,$00,$00,$00 // 0-3
        .byte $05,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$03,$00,$00,$00,$00 // 4-19
        .byte $00,$01,$05,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$02,$00,$00 // 20-35
        .byte $00,$00,$00,$00,$07,$05,$00,$00,$00,$04,$00,$00,$00,$00,$00,$08 // 36-51
        .byte $00,$00,$00,$00,$01,$06,$00,$00,$00,$00,$03,$02,$00,$00 //52-65

    DeleteChar:
        jsr ConvertTileToScreen
        tya 
        sta (ZP.ScreenAddress),y
        rts 


    DrawChar:
        pha 
        jsr ConvertTileToScreen
        pla 
        sta (ZP.ScreenAddress),y
        rts 


    ConvertTileToScreen:

        lda ZP.TileX
        ldy ZP.TileY
        clc 
        adc MAP_LOOKUP_LSB,y
        sta ZP.ScreenAddress
        lda MAP_LOOKUP_MSB,y
        adc #0
        sta ZP.ScreenAddress + 1
        ldy #0
        rts 


        // minus = skip
        // equal = subtract
        // plus = add

    .label X_LEFT_ONLY = 0
    .label X_LEFT_Y_UP = 1
    .label Y_UP_ONLY = 2
    .label X_RIGHT_Y_UP = 3
    .label X_RIGHT_Y_DOWN= 4
    .label X_RIGHT_ONLY = 5
    .label Y_DOWN_ONLY = 6
    .label X_LEFT_Y_DOWN = 7
    .label NO_MOVEMENT = 8

    XDirection:
         .byte $00,$00,$ff,$01,$01
        .byte  $01,$ff,$00,$ff

    YDirection:
        .byte $ff,$00,$00,$00,$ff
        .byte $01,$01,$01,$ff

    MoveLocationByOne:
        lda #1
    MoveLocationByA:
        sta ZP.CharsToMove

        lda XDirection, y
        bmi CheckY

        beq DecX

    AddX:

        lda ZP.ScreenCol
        clc 
        adc ZP.CharsToMove
        jmp StoreX

    DecX:
        lda ZP.ScreenCol
        sec 
        sbc ZP.CharsToMove

    StoreX:
        sta ZP.ScreenCol

    CheckY:
        lda YDirection,y
        bmi ExitCharMove

        beq DecY

        lda ZP.ScreenRow
        clc 
        adc ZP.CharsToMove
        sta ZP.ScreenRow
        rts 

    DecY:

        lda ZP.ScreenRow
        sec 
        sbc ZP.CharsToMove
        sta ZP.ScreenRow

    ExitCharMove:
        rts 


    L_b38b:
        jsr L_b3df
        bne L_b3a2
        lda #$01
        sta $07
        jsr TurnSoundOff
    L_b397:
        jsr L_b3ea
        jsr L_b3bc
        jsr CheckFireButton
        bne L_b397
    L_b3a2:
        lda #$ef
        jsr CheckKey
        bne L_b3bc
        jsr TurnSoundOff
    L_b3ac:
        jsr L_b3e4
        beq L_b3ac
        pla 
        pla 
        jsr L_a198
        jsr TurnSoundOff
        jmp StartTitleScreen
    L_b3bc:
        lda #$bf
        jsr CheckKey
        bne L_b3e9
        ldx #$03
    L_b3c5:
        ldy $b8,x
        lda $b4,x
        sta $b8,x
        tya 
        sta $b4,x
        dex 
        bpl L_b3c5

    SwitchBetween2_3:

        lda ZP.JOY_HAND_SWITCH
        eor #$01
        sta ZP.JOY_HAND_SWITCH
        
        jsr TurnSoundOff
    L_b3da:
        jsr L_b3e4
        beq L_b3da
    L_b3df:
        lda #$7f
    CheckKey:
        sta PORT_B_KEYBOARD_COL
    L_b3e4:
        lda PORT_A_KEYBOARD_ROW
        and #%10000000
    L_b3e9:
        rts 


    L_b3ea:
        jsr ReadJoystick
        dec $07
        bne L_b40e
        lda #$04
        sta $07
        lda $9000
        cmp #$01
        beq L_b403
        ldx $0c
        bne L_b403
        dec $9000
    L_b403:
        cmp #$0c
        bcs L_b40e
        ldx $0e
        bne L_b40e
        inc $9000
    L_b40e:

        lda VERTICAL_TOP_LOCATION
        beq L_b41e
        ldx $0d
        bne L_b41e
        dec VERTICAL_TOP_LOCATION
        dec ZP.Raster_Split_1
        dec ZP.Raster_Split_2
    L_b41e:
        cmp #$30
        bcs L_b42d
        ldx $0f
        bne L_b42d
        inc VERTICAL_TOP_LOCATION
        inc ZP.Raster_Split_1
        inc ZP.Raster_Split_2
    L_b42d:
        lda #$40
        jsr DelayByA
   // L_b432:
    WaitRaster128:
        lda RASTER_Y
        bpl WaitRaster128
        rts 


    L_b438:
        clc 
        lda $b3
        adc $b2
        sta $b2
        adc $b1
        sta $b1
        adc $b0
        sta $b0
        inc $b3
        bne L_b455
        inc $b2
        bne L_b455
        inc $b1
        bne L_b455
        inc $b0
    L_b455:
        lda $b0
        and L_b45b,y
        rts 



    L_b45b:
         .byte $01,$03,$07,$0f,$1f,$3f,$7f,$ff


    #import "system/utility.asm"
    #import "system/initialise.asm"
    #import "system/title.asm"
    #import "system/select2.asm"
    #import "data/char_data_2.asm"

      * = * "Chars"
    CART_CHARSET:
    .import binary "../assets/chars1.bin" 
    #import "data/level_data.asm" 
    #import "data/char_data.asm" 
 

    }
    
