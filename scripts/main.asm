

#import "data/labels.asm"


.namespace GAME {

  //  BASICStub(Entry2)

    *=$1201
    BasicUpstart(GAME.Entry2)

     * = $a00C "Program Start"
    Entry2:

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

  

    L_a09a:

        ldx #1
        stx $18
        stx $1b
        dex 
        stx $1a

        jsr L_b7e4 + $1

        jsr SetupScoreSidePanel
    L_a0a9:

        lda $1a
        and #$03
        tax 
        jsr L_b07f
        jsr SidePanel
        jsr L_a3a0
        jsr L_a27f
        lda #$1f
        sta $8b
    L_a0be:
        jsr L_a3a0


   // L_a0c1:
    GameLoop:
        lda $cf
        jsr DelayByA
        jsr L_a43d
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
    L_a10f:
        ldy ZP.NumberLives
        bmi L_a122
        cpy #$04
        bcs L_a11c
        lda #$00
        sta $1e1e,y
    L_a11c:
        dey 
        sty ZP.NumberLives
        jmp L_a0be
    L_a122:
        jsr L_a198
        jsr TurnSoundOff
        jmp L_a09a

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

        sta TABLE_64_280,x

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
        lda #41
        sta $80
    L_a179:
        lda $80
        cmp #65
        bcs Exit2
        adc #6
        sta $80
        tay 
        ldx #3
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
        jsr L_b0d1
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
        jsr L_b4e7
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


    L_a27f:
        lda $1a
        lsr 
        tay 
        lda $a335,y
        sta $cf
        lda L_a359,y
        sta $d4
        lda $1a
        and #$03
        tay 
        lda L_a331,y
        sta $c8
        lda $1a
        and #$0f
        tay 
        lda L_a321,y
        sta $c7
        lda $a345,y
        pha 
        lda $1a
        and #$0f
        lsr 
        lsr 
        tay 
        lda L_a355,y
        sta $c9
        lda L_a331,y
        sta $d3
        ldx #$07
    L_a2b8:
        lda #$ff
        sta $38,x
        sta $f0,x
        lda #$00
        sta $9658,x
        dex 
        bpl L_a2b8
        lda #$04
        sta $19
        ldx #$06
    L_a2cc:
        jsr L_a369
        lda #$2c
        jsr L_a9d2
        lda #$00
        jsr $af3e
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
        jsr L_b32c
        dex 
        bne L_a315
        rts 



    L_a321:
         .byte $30,$2e
        .byte $2c,$2a,$28,$26,$24,$22,$20,$1e,$1c,$1a,$18,$16,$14,$12

    L_a331:
        php 

        .byte $04,$02,$01,$1c,$1a,$18,$10,$0e,$0c,$0a,$09,$08,$07,$06,$05,$04
        .byte $03,$02,$01,$40,$3c,$34,$34,$30,$30,$30,$30,$2c,$2c,$2c,$2c,$2c
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
        jsr L_b32c
        ldy #$03
        jsr L_b438
        clc 
        adc #$10
        sta $97,x
        lda #$03
        sta $8f,x
        sta $93,x
        rts 


    L_a3a0:
        lda #$20
        sta $03
        lda #$18
        sta $02
        lda #$02
        sta $04
        ldx #$00
        jsr Copy_2_4ZP_To_2_4_800X
        stx $09
        stx $82
        stx $1c
        jsr ResetEgg
        lda #$1f
        sta $ce
        jsr L_ac05

   
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
        bne L_a434
        lda $03
        cmp #$20
        bne L_a434
        ldx $8c
        jsr L_ada0

        .byte $a5,$82,$c9,$2b,$90,$09,$a5,$80,$48,$20,$79,$a1,$68,$a8,$2c,$a0
        .byte $11,$c6,$19,$20,$7b,$b2,$a0,$00,$84,$82,$88,$84,$88

    L_a434:
        rts 


    L_a435:
        lda $04
        eor #$04
        tay 
        jmp L_b35a
    L_a43d:
        dec $50
        bne L_a434
        lda #$10
        sta $50
        lda $1618
        bne L_a44f
        lda #$02
        sta $1618
    L_a44f:
        ldx #$00
        jsr Copy2_4_800X_To_ZP
        jsr L_b325
        lda #$04
        jsr L_af3b
        lda $18
        beq L_a493
        lda $09
        beq L_a493
        cmp #$28
        bcc L_a46d
        pla 
        pla 
        jmp L_a10f
    L_a46d:
        lda $900e
        beq L_a47a
        dec $900e
        lda #$c8
        sta $900d
    L_a47a:
        lda #$01
        jsr L_b32c
        inc $09
        lda $09
        cmp #$10
        bcs L_a4cf
        ldy #$02
        jsr L_b438
        tay 
        jsr L_b35a
        jmp L_a932
    L_a493:
        lda $cd
        bpl L_a4de
        lda $82
        beq L_a4b4
        jsr L_a435
        jsr L_b325
        ldx $8c
        lda $02c0,x
        bne L_a4ac
        sta $82
        beq L_a4b4
    L_a4ac:
        ldx #$00
        jsr Copy2_4_800X_To_ZP
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
    L_a4cf:
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
        jsr L_b32c
        lda #$04
        jsr $af3e
        ldx #$00
        jsr Copy_2_4ZP_To_2_4_800X
        lda $82
        beq L_a505
        jsr L_a435
        ldx $8c
        jsr L_a3ff
        jsr Copy_2_4ZP_To_2_4_800X
        lda $82
        jsr L_b32c
    L_a505:
        lda $18
        beq L_a512
        jsr L_b4e7
        bne L_a4cd
        lda $1c
        beq L_a4cf
    L_a512:
        lda $cd
        bmi L_a519
        jsr L_ac5f
    L_a519:
        ldx #$00
        jsr Copy2_4_800X_To_ZP
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
        bne L_a4cf
        lda #$09
        sta $51
    L_a53e:
        ldx #$20
    L_a540:
        jsr Copy2_4_800X_To_ZP
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
        jsr L_b325
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
        jsr L_b32c
        jsr Copy_2_4ZP_To_2_4_800X
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
        jmp Copy2_4_800X_To_ZP
    L_a5d2:
        stx $8c
        lda #$00
        jsr L_af3b
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
        jsr Copy2_4_800X_To_ZP

        .byte $30,$3c,$bd,$c0,$02,$f0,$37,$10,$1d,$fe,$c0,$02,$bd,$c0,$02,$49
        .byte $ff,$18,$69,$01,$c9,$10,$b0,$09,$a5,$68,$29,$01,$a8,$b9,$85,$a6
        .byte $2c,$a9,$29,$4c,$5c,$a6,$de,$c0,$02,$bd,$c0,$02,$c9,$10,$b0,$09
        .byte $a5,$68,$29,$03,$a8,$b9,$81,$a6,$2c,$a9,$2c

    L_a65c:
        jsr L_b32c
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
        jsr L_b32c
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
        jsr Copy2_4_800X_To_ZP
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
        lda #$00
        jsr L_af3b
        ldx #$03
    L_a6ce:
        lda $97,x
        bmi L_a6da
        dex 
        bpl L_a6ce
        ldx $13
        jmp L_b325
    L_a6da:
        jsr L_a382
        ldx $13


    // L_a6df

    Copy2_4_800X_To_ZP:

        lda $0200,x
        sta $02
        lda $0240,x
        sta $03
        lda $0280,x
        sta $04
        rts 


    L_a6ef:
        ldy $04
    L_a6f1:
        jsr L_b35a
    L_a6f4:
        lda $03
        cmp #$40
        bcs L_a706
        lda $02
        cmp #$30
        bcs L_a706
    L_a700:
        jsr L_b334
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
        jsr L_b35c
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
        lda #$00
        jsr L_af3b
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
        jmp L_b32c
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
        jsr L_b325
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
        jsr Copy2_4_800X_To_ZP
        bmi L_a9a5
        jsr L_b325
        jsr L_a9c9
    L_a9a5:
        jsr L_a9c0
        dex 
        jsr Copy2_4_800X_To_ZP
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
        jsr Copy2_4_800X_To_ZP
        inx 
        lsr 
        clc 
        adc #$0e
    L_a9d2:
        jsr L_b32c
        jsr Copy_2_4ZP_To_2_4_800X
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
        jmp Copy2_4_800X_To_ZP

    L_aa4b:
         .byte $13,$17,$1b,$1f,$02
        .byte $06,$00,$04,$02,$06,$00

    L_aa56:
        .byte $04,$04,$00,$04,$00

    L_aa5b:
        jsr Copy2_4_800X_To_ZP
        bmi L_aa6f
        lda.a $0093,y
        eor #$ff
        clc 
        adc #$01
        tay 
        lda L_aa8e,y
        jsr L_b32c
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
        jsr Copy2_4_800X_To_ZP
        and #$04
        bne L_aab9
        jsr L_b325
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
        jsr Copy2_4_800X_To_ZP
        jsr L_afb7
        bcs L_aaf6
        lda #$f0
        sta $d2
    L_aaf6:
        lda $04
        eor $05
        sta $04
    L_aafc:
        jmp Copy_2_4ZP_To_2_4_800X
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
        jsr Copy_2_4ZP_To_2_4_800X
        lda $c8
        sta $02c0,x
        ldx $05
        lda #$01
        jmp L_b32c
    L_ab20:
        dec $59
        bne L_ab5a
        lda #$30
        sta $59
        ldx #$24
    L_ab2a:
        jsr Copy2_4_800X_To_ZP
        bmi L_ab55
        and #$04
        beq L_ab55
        jsr L_b325
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
        jsr L_b32c
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
        jsr L_b325
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
    L_ac05:
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
        jsr Copy2_4_800X_To_ZP
        bmi L_acfe
        jsr L_b325
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
        jsr Copy2_4_800X_To_ZP
    L_acec:
        jsr L_a6ef
        bcs L_acf5
        cmp #$07
        bcc L_acfb
    L_acf5:
        jsr Copy2_4_800X_To_ZP
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
    //Copy_2_4ZP_To_2_4_800X:

    // l_ad63
    Copy_2_4ZP_To_2_4_800X:
        lda $02
        sta TABLE_64_200,x
        lda $03
        sta TABLE_64_240,x
        lda $04
        sta TABLE_64_280,x
    L_ad72:
        rts 


    L_ad73:
        dec $61
        bne L_ad72
        lda #$18
        sta $61
        ldx #$0e
        jsr Copy2_4_800X_To_ZP
        bmi L_ad72
        jsr L_b325
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
        jsr Copy2_4_800X_To_ZP
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
        inc $1a
        lda $1a
        and #$1f
        sta $1a
        jsr L_b981
        jsr Reset32BytesTo1
    L_af2a:
        jsr TurnSoundOff
        lda #$8d
        jmp L_b0d1

   CycleColour:
        inc ZP.ColourTemp
        lda ZP.ColourTemp
        and #%00000111
        sta ZP.ColourTemp
        rts 


    L_af3b:
        ldy #$00
        bit $ffa0
        sty $06
        stx $13
        sta $05
        lda $02
        clc 
        adc #$08
        pha 
        and #$0f
        lsr 
        lsr 
        clc 
        adc $05
        tay 
        lda L_af8e,y
        sta $05
        pla 
        lsr 
        lsr 
        lsr 
        lsr 
        tay 
        lda $af96,y
        tay 
        lda $03
        lsr 
        and #$fe
        tax 
        jsr L_af73
        inx 
        jsr L_af73
        ldx $13
        rts 


    L_af73:
        txa 
        ora #$80
        sta $00
        lda #$1d
        sta $01
        lda $05
        bit $06
        beq L_af87
        and ($00),y
        sta ($00),y
        rts 


    L_af87:
        eor #$ff
        ora ($00),y
        sta ($00),y
        rts 



    L_af8e:
         .byte $3f,$cf,$f3,$fc,$bf,$ef,$fb
        .byte $fe,$00,$20,$40,$60

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
        jsr Copy2_4_800X_To_ZP
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


    L_b07f:
        lda L_b0c9,x
        sta $a2
        lda #$10
        sta $a4
        lda L_b0c9 + $4,x
        sta $a1
        ldy #$00
        sty $a3
    L_b091:
        lda $a4
        cmp #$1c
        beq L_b0c8
        jsr L_b0a1
        iny 
        bne L_b091
        inc $a2
        bne L_b091
    L_b0a1:
        sty $14
        lda ($a1),y
        sta $05
        ldx #$07
    L_b0a9:
        lda #$1e
        asl $05
        bcs L_b0b1
        lda #$00
    L_b0b1:
        ldy #$00
        sta ($a3),y
        iny 
        sta ($a3),y
        lda $a3
        clc 
        adc #$02
        sta $a3
        bcc L_b0c3
        inc $a4
    L_b0c3:
        dex 
        bpl L_b0a9
        ldy $14
    L_b0c8:
        rts 



    L_b0c9:
         .byte $bc,$bc,$bd,$be,$00,$c0,$80
        .byte $40

    L_b0d1:
        pha 
        ldy #$21
        jsr L_b0dc
        pla 
        sta ZP.DefaultColours
        ldy #$00
    L_b0dc:
        sty $8d
        lda #$08
        sta $02
        lda #$0e
        sta $03
        lda #$01
        sta $05
        sta $12
    L_b0ec:
        ldy #$06
    L_b0ee:
        jsr L_b10d
        dey 
        dey 
        bpl L_b0ee
        lda #$a0
        jsr DelayByA
        jsr CycleColour
        ldy #$01
        jsr L_b35a
        inc $05
        inc $05
        lda $05
        cmp #$13
        bcc L_b0ec
        rts 


    L_b10d:
        sty $07
        ldx $05
    L_b111:
        jsr GetScreen_Col2_Row3
        lda $8d
        sta ($00),y
        lda $12
        sta ($0a),y
        dex 
        beq L_b127
        ldy $07
        jsr L_b35a
        jmp L_b111
    L_b127:
        ldy $07
        rts 

    #import "system/anim.asm"

    #import "system/select.asm"


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

    L_b325:
        jsr L_b334
        tya 
        sta ($00),y
        rts 


    L_b32c:
        pha 
        jsr L_b334
        pla 
        sta ($00),y
        rts 


    L_b334:
        lda $02
        ldy $03
        clc 
        adc $0340,y
        sta $00
        lda $0380,y
        adc #$00
        sta $01
        ldy #$00
        rts 



    L_b348:
         .byte $00,$00,$ff
        .byte $01,$01,$01,$ff

    L_b34f:
        .byte $00,$ff,$ff,$00,$00,$00,$ff
        .byte $01,$01,$01,$ff

    L_b35a:
        lda #$01
    L_b35c:
        sta $16
        lda L_b348,y
        bmi L_b374
        beq L_b36d
        lda $02
        clc 
        adc $16
        jmp L_b372
    L_b36d:
        lda $02
        sec 
        sbc $16
    L_b372:
        sta $02
    L_b374:
        lda L_b34f + $2,y
        bmi L_b38a
        beq L_b383
        lda $03
        clc 
        adc $16
        sta $03
        rts 


    L_b383:
        lda $03
        sec 
        sbc $16
        sta $03
    L_b38a:
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
        jsr L_b4e7
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

       // .byte $03,$15,$83,$28,$03
      //  .byte $29,$20,$31,$39,$38,$33,$20,$20,$14,$12,$0f,$0e,$09,$18,$00,$a9
      //  .byte $00,$85,$07,$20,$2b,$a1

    PrintRowOfCharData:
        pla 
        sta ZP.ReturnAddress
        pla 
        sta ZP.ReturnAddress + 1

        ldy #1
        lda (ZP.ReturnAddress),y  // 03
        pha 
        iny 
        lda (ZP.ReturnAddress),y  // 15 to Y
        tay             // y = 15, a = 15
        pla            // a = 3
        jsr GetScreenAddressCol_A_Row_Y  // row 15 column 3


    MoveToData:

        lda ZP.ReturnAddress
        clc 
        adc #$03
        sta ZP.ReturnAddress 

        bcc NoWrap1

        inc ZP.ReturnAddress + 1

    NoWrap1:

        lda (ZP.ReturnAddress),y
        beq NullTerminate
        bpl PositiveIsChar

    ChangeColour:

        and #%01111111
        sta ZP.ColourTemp

    MoveToNextData:

        inc ZP.ReturnAddress
        bne NoWrap1
        inc ZP.ReturnAddress + 1
        bne NoWrap1

    PositiveIsChar:

        ora #%10000000
        sta (ZP.ScreenAddress),y

        lda ZP.ColourTemp
        sta (ZP.ColourAddress),y
        iny 
        bne NoWrap1

   NullTerminate:

        tya 
        sec 
        adc ZP.ReturnAddress
        sta ZP.ReturnAddress
        bcc NoWrap2
        inc ZP.ReturnAddress + 1

    NoWrap2:
 
        jmp (ZP.ReturnAddress)
         //`.byte $6c,$10,$00



   // L_b4ab:
    GetScreen_Col2_Row3:

        lda $02
        ldy $03

    GetScreenAddressCol_A_Row_Y:
  // AddScr
        clc 
        adc SCREEN_LSB_LOOKUP,y
        sta ZP.ScreenAddress
        sta ZP.ColourAddress
        lda SCREEN_MSB_LOOKUP,y
        adc #0
        sta ZP.ScreenAddress + 1
        clc 
        adc #$78
        sta ZP.ColourAddress + 1
        ldy #0
        rts 


    L_sb4c6:
    ReadJoystick:

        ldy #3

    DirectionLoop:

        lda #255
        cpy ZP.JOY_HAND_SWITCH  // was 2
        beq ReadRight

    ReadOtherDirections:

        sta DATA_DIRECTION_REG_B
        lda PORT_A_OUTPUT
        jmp ProcessRead

    ReadRight:

        lsr // a = 127
        sta DATA_DIRECTION_REG_B
        lda PORT_B_OUTPUT

    ProcessRead:

        // y = 3 00f
        // y = 2 00e

        and ZP.JOYSTICK_MASKS,y
        sta ZP.JoystickReadings,y
      
        dey 
        bpl DirectionLoop
    L_b4e7:
        lda PORT_A_OUTPUT
        and #%00100000
        rts 



    ZP_Defaults:
        .byte $a1,$45,$f7
        .byte $81,$08,$10,$04,$80,$10,$04,$80
        .byte $08 
        .byte $30,$31
        .byte $30, $30
        .byte $30,$30,$20,$20

       .text  @"arl"

   // L_b504:

    DelayByA:
        sec 
    DelayLoop1:
        pha 
    DelayLoop2:
        sbc #1
        bne DelayLoop2
        pla 
        sbc #1
        bne DelayLoop1
        rts 


    //L_b510:
    InitialiseRegistersLookups: 

        ldx #15

    SetVICDefaults:
 
    ResetLoop:

        lda VIC_Defaults, x
        sta VIC_REGISTER_START,x
        dex 
        bpl ResetLoop

    InitialiseZP:

        ldx #22

    InitialiseLoop:

        lda ZP_Defaults,x
        sta ZP.Table_B0,x
        dex 
        bpl InitialiseLoop

    SetupScreenLookup:

        ldx #<SCREEN_RAM
        stx ZP.ScreenAddress

        lda #>SCREEN_RAM

    ScreenLoop:

        sta ZP.ScreenAddress + 1    
        sta SCREEN_MSB_LOOKUP,x

        lda ZP.ScreenAddress
        sta SCREEN_LSB_LOOKUP,x

        clc 
        adc #COLUMNS
        sta ZP.ScreenAddress

        lda ZP.ScreenAddress + 1
        adc #0

        inx 
        cpx #ROWS
        bne ScreenLoop

    SetupMapLookup:

        ldx #<MAP_DATA
        stx ZP.ScreenAddress

        lda #>MAP_DATA

    MapLoop:

        sta ZP.ScreenAddress + 1
        sta MAP_LOOKUP_MSB,x

        lda ZP.ScreenAddress
        sta MAP_LOOKUP_LSB,x
        clc 
        adc #MAP_COLUMNS
        sta ZP.ScreenAddress

        lda ZP.ScreenAddress + 1
        adc #0

        inx 
        cpx #MAP_ROWS
        bne MapLoop
        rts 



    VIC_Defaults:

        .byte $0c
        .byte $19,$96,$ae,$4f,$ff,$00,$00,$ff,$ff,$00,$00,$00,$00,$00,$8d

    #import "system/title.asm"






    L_b7c7:
         .byte $00
        .byte $01,$02,$03,$16,$17,$18,$19,$2c,$2d,$2e,$2f,$30,$33,$36,$39,$31
        .byte $34,$37,$3a,$32,$35,$38

    L_b7de:
        .byte $3b

    LookupTimer5:

        .byte $00,$30,$60
        .byte $90,$60,$30

    L_b7e4:
        .byte $a9

    L_b7e5:

        adc $d120 // #$2A from kernal rom????
        bcs PixelRowLoop
        and ($B2), y
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
        ldx #$01
    L_b8ef:
        lda $a5,x
        sta $1fc6,x
        dex 
        bpl L_b8ef
        lda #$78
        jsr DelayByA
        jsr L_b911
        jsr L_b4e7
        bne SettingsLoop
        lda ZP.Difficulty 
        and #$03
        cmp #$03
        bne L_b90e
        dec $18
    L_b90e:
        jmp L_af2a
    L_b911:
        lda $05
        beq L_b920
        inc $900e
        lda $900e
        cmp #$0f
        beq L_b925
    L_b91f:
        rts 


    L_b920:
        dec $900e
        bne L_b91f
    L_b925:
        lda $05
        eor #$01
        sta $05
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
    L_b981:
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
    * = * "dd"
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


         

    CopyScorpionChars:

        ldx #63

    CopyLoop2:

        lda ScorpionLogoChars,x
        sta CHAR_RAM_SCORPION_LOGO,x
        dex 
        bpl CopyLoop2
        rts 

    IconCharIDs:

         .byte $0a,$0e,$0e,$0e,$15,$26,$2c,$22,$2b,$27
        .byte $25,$02,$1f,$05,$e9,$df,$12,$13,$e9,$df
        .byte $12,$13

    IconXTable:

        .byte $02,$03,$04
        .byte $05,$0d,$02,$0d,$02,$0d,$02,$02,$0d,$02,$0d,$01,$14,$01,$14,$01
        .byte $14,$01,$14

    IconYTable:

        .byte $09, $09, $09, $09, $09,$0b 
        .byte $0b,$0d,$0e,$0f,$11,$11,$13,$13,$00,$00,$06,$06,$08,$08,$16,$16

    ScorpionCharIDs_Shifted:
        .byte $38 

    ScorpionCharIDs:
        .byte $37
        .byte $36,$35,$34,$33,$32,$31,$30,$00

    L_ba40:
        ora ($07,x)

        .byte $1f,$07,$01,$00,$00,$00,$18,$3f,$7f,$c7,$83,$80,$80,$00

    L_ba50:
        sed 
        inc $fbf7,x

        .byte $ff,$ff,$7e,$7e,$ff,$ff,$ff,$ff,$fe,$f8,$00

    L_ba5f:
        .byte $00,$00,$00,$80
        .byte $c0,$80,$00,$38,$7c,$fa,$ce,$8b,$05,$02,$00,$00,$00,$00,$00,$00
        .byte $01,$07,$0f,$01,$00,$30,$7f,$df,$8f,$83,$40,$00,$00,$00,$00,$3e
        .byte $ff,$ff,$f9,$ff,$ff,$ff,$ff,$ff,$ff,$fe,$f8,$00,$00,$00,$00,$00
        .byte $80,$c0,$80,$38,$7c,$fa,$ce,$8b,$05,$02,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$03,$2f,$7b,$df,$8f,$87,$43,$00,$00,$00,$00,$00,$00
        .byte $00,$7c,$ff,$fd,$b7,$7d,$f3,$cf,$ff,$fe,$f8,$00,$00,$00,$00,$00
        .byte $00,$00,$b8,$7c,$ea,$cf,$8b,$04,$02,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$67,$ff,$9f,$8f,$9f,$5b,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$7c,$ff,$b7,$7f,$fd,$f3,$cf,$f8,$00,$00,$00,$00,$00
        .byte $00,$1c,$3a,$ef,$c9,$c4

    L_baf9:
        .byte $82,$00,$00,$00,$00,$00,$00

      * = * "Chars"
        CART_CHARSET:
         .import binary "../assets/chars1.bin" 

        .byte $42,$0f,$00,$00,$0f,$00,$00,$0f,$00,$00,$0f,$00,$06,$0f,$00,$06
        .byte $0f,$00,$06,$0f,$07,$c6,$00,$07,$c0,$00,$07,$c0,$00,$07,$c0,$e0
        .byte $07,$c6,$e0,$07,$c6,$e0,$07,$c6,$e0,$07,$c6,$e3,$f0,$00,$03,$f0
        .byte $00,$03,$f0,$00,$03,$f0,$00,$03,$00,$00,$03,$00,$00,$03,$00,$00
        .byte $03,$00,$00,$33,$00,$00,$33,$6e,$f8,$30,$6e,$f8,$30,$6e,$f8,$30
        .byte $6e,$f8,$30,$6e,$f8,$30,$00,$00,$30,$00,$00,$31,$80,$00,$31,$80
        .byte $00,$31,$80,$e0,$31,$80,$e0,$01,$80,$e0,$01,$80,$e0,$01,$80,$00
        .byte $01,$80,$00,$01,$80,$03,$01,$80,$03,$01,$fb,$c3,$c1,$fb,$c3,$c1
        .byte $fb,$c3,$c1,$fb,$c3,$c1,$fb,$c3,$c1,$fb,$c0,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$3c,$00,$00,$3d,$fb,$c0,$3d,$fb,$c0,$3d,$fb,$c0
        .byte $01,$fb,$c0,$01,$fb,$c0,$00,$00,$00,$00,$00,$0f,$00,$00,$0f,$38
        .byte $60,$0f,$38,$60,$0f,$38,$60,$0f,$00,$60,$0f,$00,$60,$00,$00,$60
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$9f,$1f
        .byte $39,$9f,$1f,$39,$9f,$1f,$39,$9f,$1f,$39,$98,$18,$39,$98,$18,$39
        .byte $98,$1b,$39,$98,$1b,$39,$98,$1b,$39,$83,$1b,$39,$83,$1b,$39,$83
        .byte $00,$39,$83,$00,$00,$03,$00,$00,$03,$1e,$00,$03,$1e,$00,$f3,$9e

        .byte $00

        .byte $f3,$9e,$18,$f3,$80,$18,$f3,$80,$18,$30

    L_bd0b:
        clc 
        bmi L_bd0e
    L_bd0e:
        clc 
        bmi L_bd11
    L_bd11:
        clc 
        bmi L_bd14
    L_bd14:
        clc 

        .byte $30,$00,$df,$b0,$00,$df,$b0,$00,$df,$b3,$ff,$df,$b3,$ff,$00,$03
        .byte $ff,$00,$03,$ff,$00,$03,$00,$db,$83,$00,$db,$83,$00,$db,$83,$07
        .byte $db,$83,$77,$01,$83,$77,$01,$83,$70,$01

    L_bd3f:
        .byte $80,$70,$39,$80
        .byte $40,$39,$80,$46,$39,$80,$46,$39,$80,$46,$00,$00,$06,$00,$18,$06
        .byte $00,$18,$06,$00,$18,$06,$39,$99,$ee,$39,$99,$ee,$39,$99,$ee,$39
        .byte $99,$ee,$39,$98,$6e,$39,$98,$60,$39,$9e,$60,$01,$9e,$60,$01,$9e
        .byte $60,$01,$9e,$60,$01,$80,$60,$01,$80,$60,$01,$80,$60,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$f6,$00,$00,$f6,$00,$00,$f6,$7f
        .byte $e0,$06,$7f,$e6,$06,$00,$26,$06,$00,$26,$f6,$00,$26,$f6,$73,$26
        .byte $f6,$73,$26,$f6,$73,$26,$f6,$03,$26,$06,$03,$26,$06,$03,$26,$06
        .byte $03,$26,$06,$03,$26,$06,$fb,$27,$d0,$fb,$27,$d0,$f8,$00,$10,$18
        .byte $00,$10,$18,$00,$16,$1a,$f7,$96,$1a,$f7,$96,$1a,$80,$96,$1a,$80
        .byte $96,$1a,$80,$96,$02,$80,$96,$02,$80,$96,$02,$80,$80,$02,$00,$00
        .byte $1e,$00,$00,$1e,$00,$1e,$1e,$80,$9e,$1e,$80,$9e,$00,$80,$90,$00
        .byte $80,$90,$00,$80,$90,$00,$80,$96,$00,$f7,$96,$76,$f7,$96,$76,$00
        .byte $16,$76,$00,$16,$76,$00,$10,$76,$00,$10,$76,$00,$10,$07,$fe,$df
        .byte $07,$fe,$df,$07,$fe,$df,$07,$fe,$c0,$70,$06,$c0,$70,$06,$c0,$70
        .byte $06,$c0,$77,$56,$c0,$77,$56,$c0,$70,$56,$fe,$70,$56,$fe,$00,$56
        .byte $fe,$07,$56,$00,$07,$56,$00,$00,$06,$00,$00,$06,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$3f,$98,$00,$3f,$98,$f6,$3f
        .byte $98,$f6,$3f,$98,$f6,$3f,$98,$f6,$01,$98,$06,$01,$98,$06,$01,$98
        .byte $06,$01,$98,$06,$31,$9f,$f6,$31,$9f,$f6,$31,$9f,$f6,$31,$80,$00
        .byte $31,$80,$00,$31,$80,$00,$31,$80,$00,$31,$ff,$3f,$31,$ff,$3f,$31
        .byte $ff,$3f,$31,$ff,$3f,$30,$00

    L_be8a:
        jsr.a $0030
        jsr.a $0030
        jsr.a $0030
        jsr $833f
        rol $833f
        asl $833f
        asl $0300
        asl $0300
        asl $0300
        rol $3f00
        rol L_bfff
        rol L_bfff
        rol L_bfff
        rol.a $0000
        jsr.a $0000
        jsr.a $0000
        jsr.a $0000
        jsr $3def

        .byte $3f,$ef,$3d,$3f,$ef,$3d,$3f,$ef,$3d,$3f,$ef,$3d,$3f,$03,$00,$00
        .byte $03,$00,$00,$03,$00,$00,$03,$3d,$00,$03,$3d,$00,$03,$3d,$6c,$73
        .byte $3d,$6c,$73,$01,$6c,$73,$01,$6c,$73,$01,$6c,$73,$3d,$6c,$03,$3d
        .byte $6c,$03,$3d,$6c,$03,$3d,$6c,$03,$01,$00,$03,$01,$00,$03,$01,$00

    //L_bf00:
    ColourLookup:
        .byte $00,$00,$00,$00,$00,$00,$00
        .byte $31,$01,$01,$46,$16,$06,$16,$57,$07,$17,$27,$00,$30,$35,$25,$55
        .byte $15,$25,$15,$15,$25,$07,$37,$a6,$80,$20,$1a,$40,$40

    L_bf24:
        .byte $29,$03,$85,$56,$76,$05,$11,$43,$01,$01,$11,$63

    ScorpionLogoChars:

        .byte $3e,$60,$f0,$fc
        .byte $7e,$1e,$0c,$f8,$fe,$72,$60,$60,$60,$60,$72,$fe,$fe,$76,$62,$62
        .byte $62,$62,$76,$fe,$fc,$66,$62,$66,$7c,$6e,$6e,$ee,$fc,$66,$62,$66
        .byte $7c,$60,$60,$e0,$fe,$38,$38,$38,$38,$38,$38,$fe,$fe,$76,$62,$62
        .byte $62,$62,$76,$fe,$e6,$76,$76,$76,$6e,$6e,$6e,$e6

    CharEorTable:

        .byte $80,$d0,$d0,$8e
        .byte $86,$cc,$ee,$ff,$01,$0b,$0b,$71,$61

    L_bf7d:
        .byte $33,$77,$ff

           * = * "Chars2"
    CART_CHARSET_2:
     .import binary "../assets/chars2.bin" 


     L_bfff:

    }
    