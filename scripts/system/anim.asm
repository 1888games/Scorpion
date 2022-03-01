
 .namespace GAME {

    * = * "Animation"

    CharAnimEorTable:
         .byte $55,$ab,$fc,$1c,$82,$9f,$f9,$02,$12,$28
        

    DragonEorTable:
        .byte $00,$00,$06,$00,$02,$01,$00,$01,$00
        .byte $00,$60,$00,$40,$80,$00,$80
       
    StalkerEorTable:

        .byte $c3,$00, $81

    ScorpionEorTable:
        
        .byte $82,$81,$01,$00,$01,$81,$82,$00,$63,$00,$00,$00,$00,$00,$41
        .byte $36,$00,$41,$81,$80,$00,$80,$81,$41,$6c,$82,$00,$00,$00,$00
        .byte $00,$c6
        
    HomeCharLookup:

        .byte $ff,$81,$81,$81,$81,$81,$81,$ff,$00,$7e,$42,$42,$42,$42,$7e
        .byte $00,$00,$00,$3c,$24,$24, $3c,$00,$00

    BallStartByte:

         .byte $07,$0f,$17,$0f


    * = * "sjsj"
         
    GameAnimateChars: 

        dec ZP.GameAnimateTimer 
        bne Exit
        lda #32
        sta ZP.GameAnimateTimer 

    AnimateChars:

        ldy #2

    ThreeRowLoop:

        lda CharAnimEorTable,y
        eor VENUS_START + 3,y
        sta VENUS_START + 3,y

        lda StalkerEorTable,y
        eor STALKER_START,y
        sta STALKER_START,y

        dey 
        bpl ThreeRowLoop

        ldy #6

    SevenRowLoop:

        lda CharAnimEorTable + 3,y
        eor DEAD_START,y
        sta DEAD_START,y
        dey 
        bpl SevenRowLoop

        ldy #15

    DragonLoop:

        lda DragonEorTable,y
        eor DRAGON_START,y
        sta DRAGON_START,y
        dey 
        bpl DragonLoop

        ldy #31

    ScorpionLoop:

        lda ScorpionEorTable,y
        eor SCORPION_START,y
        sta SCORPION_START,y
        dey 
        bpl ScorpionLoop

        inc ZP.AnimCounter
        lda ZP.AnimCounter
        and #%00000011
        tay 
        ldx BallStartByte, y

        ldy #7

    CharByteLoop:

        lda BALL_CHAR_SOURCE,x
        sta BALL_CHAR_USE,y

        lda HomeCharLookup,x
        sta HOME_CHAR_USE,y
        dex 
        dey 
        bpl CharByteLoop

    Exit:
        rts 

    
}
