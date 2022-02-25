.namespace GAME {


    * = * "ColourLookup"
    //L_bf00:
    ColourLookup:
        .byte $00,$00,$00,$00,$00,$00,$00
        .byte $31,$01,$01,$46,$16,$06,$16,$57,$07,$17,$27,$00,$30,$35,$25,$55
        .byte $15,$25,$15,$15,$25,$07,$37,$a6,$80,$20,$1a,$40,$40
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
        .byte $33,$77,$ff

           * = * "Chars2"
    CART_CHARSET_2:
     .import binary "../assets/chars2.bin" 


     L_bfff:

}