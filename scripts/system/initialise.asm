.namespace GAME {

	* = * "Initialise"


	
	ZP_Defaults:
        .byte $a1,$45,$f7
        .byte $81,$08,$10,$04,$80,$10,$04,$80
        .byte $08 
        .byte $30,$31
        .byte $30, $30
        .byte $30,$30,$20,$20

       .text  @"arl"

    

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

}

