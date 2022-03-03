 .namespace GAME {

    * = * "Bullet"

    FireBullet:

        lda #BULLET_TILE
        sta EnemyType,x

        lda #$ff
        sta $85

        bmi ContinueBullet


    ProcessBullets:
 
        dec ZP.BulletTimer
        bne ExitPlayer
        lda #BULLET_UPDATE_TIME
        sta ZP.BulletTimer

        ldx #MIN_BULLET_ID

    L_a540:

        jsr GetPositionDirection

        bmi EndBulletLoop

   CheckIfHitting:

        jsr GetCharFromMap
        
        cmp #BALL_CHAR
        beq NotEnemy

        cmp #BULLET_HORIZ_CHAR
        beq NotEnemy

        cmp #BULLET_VERTI_CHAR
        beq NotEnemy

        cmp #FIRST_ENEMY_CHAR
        bcs HitEnemy

    NotEnemy:

        jsr DeleteChar
        dec EnemyType,x
        beq L_a574

    ContinueBullet:

        jsr L_a6ef
        bcs L_a574
        cmp #$23
        beq L_a579
        cmp #$07
        bcc L_a579

    HitEnemy:
        stx $16
        jsr L_a87b
        ldx $16
    L_a574:
        jsr DeleteEnemy
        bmi EndBulletLoop

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

    EndBulletLoop:

        inx 
        cpx #MAX_BULLET_ID + 1
        bne L_a540
        rts 




   }