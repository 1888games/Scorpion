.namespace GAME {


	  * = * "Char Data"
         

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
}