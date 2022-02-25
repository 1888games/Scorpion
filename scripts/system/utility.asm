   .namespace GAME {


   * = * "Utility"

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
   CheckFireButton:
        lda PORT_A_OUTPUT
        and #%00100000
        rts 

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

  }
