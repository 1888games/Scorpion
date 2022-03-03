 .namespace GAME {

    * = * "Player"

     CheckEggDraggedHome:

        lda ZP.TileX
        cmp #START_X
        bne QuitOut

        lda ZP.TileY
        cmp #START_Y
        bne QuitOut

    PlayerAtHome:

        ldx ZP.CarriedID
        jsr DeleteEnemy

        lda ZP.CarriedCharID
        cmp #EGG_CHAR
        bcc IsFrog

    IsEgg:

        lda ZP.EggBonusLookup
        pha

        jsr UpdateEggBonus

        pla
        tay

        bit IsFrog: $11A0  // ldy #17
        dec ZP.EggsRemaining

        jsr L_b27b

        ldy #0
        sty ZP.CarriedCharID
        dey
        sty $88

    QuitOut:

        rts 


    MoveScreenPointerCarried:
    
        lda ZP.Direction
        eor #%00000100
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
        cmp #DEATH_ANIMATION_TIME
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
        cmp #DEATH_PARTICLE_TIME

        bcs ExitPlayer

        ldy #RANDOM_0_7
        jsr GetRandomNumber
        tay 

        jsr MoveLocationByOne
        jmp SpawnParticle


    PlayerNotDead:


        lda ZP.PlayerWaitingFire
        bpl SkipControls

    PlayerAllowedMove:


        lda ZP.CarriedCharID    
        beq NotCarryingAnything

        jsr MoveScreenPointerCarried

        jsr DeleteChar

        ldx ZP.CarriedID

        lda EnemyType,x
        bne StillCarrying

        sta ZP.CarriedCharID
        beq NotCarryingAnything

    StillCarrying:

        ldx #PLAYER_ID
        jsr GetPositionDirection
        jsr CheckEggDraggedHome

    NotCarryingAnything:

        lda ZP.PlayRealGame
        bne IsNotDemoMode

        jsr HandleDemoMode
        jmp SkipControls

    IsNotDemoMode:

        jsr ReadJoystick

        ldx #3

    JoyDirectionLoop:

        lda ZP.JoystickReadings,x
        beq JoystickDirection
        dex 
        bpl JoyDirectionLoop
        jmp SkipControls

    NotFired:

        sta ZP.FireLastFrame

    ExitPlayer:

        rts 


     JoystickDirection:

        txa 
        asl 
        sta ZP.Direction
        ldy ZP.CarriedCharID
        bne CarryingSomethingMoved
        sta Direction

    CarryingSomethingMoved:

        jsr L_a58f

    SkipControls:

        lda ZP.Direction
        lsr 
        clc 
        adc #SCORPION_START_CHAR
        jsr DrawChar

        lda #PLAYER_MINI_MAP
        jsr ClearFromMiniMap

        ldx #PLAYER_ID
        jsr SavePositionDirection

        lda ZP.CarriedCharID
        beq NotCarrying2

    DrawThingCarrying:

        jsr MoveScreenPointerCarried

        ldx ZP.CarriedID

        jsr ReverseDirection

        jsr SavePositionDirection
        lda ZP.CarriedCharID
        jsr DrawChar

    NotCarrying2:

        lda ZP.PlayRealGame
        beq IsDemoMode

        jsr CheckFireButton
        bne NotFired

        lda ZP.FireLastFrame
        beq ExitPlayer

    IsDemoMode:


        lda ZP.PlayerWaitingFire
        bmi NotWaiting
        jsr L_ac5f

    NotWaiting:

        ldx #PLAYER_ID
        jsr GetPositionDirection
        ldx #MAX_BULLET_ID

    CheckBulletLoop:

        lda Direction,x
        bmi FireBullet
        dex 
        cpx #MIN_BULLET_ID + 1
        bne CheckBulletLoop
        rts 

    

  }