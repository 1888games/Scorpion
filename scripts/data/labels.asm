ZP: { 

    .label Raster_Split_1 = $9F
    .label Raster_Split_2 = $CA
    .label LastKeyPressed = $D7
    .label DefaultColours = $CC
    .label Table_B0 = $B0

    .label ScreenAddress = $00
    .label ScreenAddress_MSB = $01
    .label Address = $02
    .label Address_MSB = $03
    .label Backup280 = $04
    .label ScorpionLogoFlag = $07

    .label NumberLives = $08




    .label ColourAddress = $0A
    .label ColourAddress_MSB = $0B
    .label JOY_LEFT_NOW = $0C
    .label JoystickReadings = $0C
    .label JOY_RIGHT_NOW = $0E
    .label JOY_UP_NOW = $0D
    .label JOY_DOWN_NOW = $0F
    .label ReturnAddress = $10
    .label ColourTemp = $12

    .label Level = $1A
     .label Wave = $1B
    .label JOY_HAND_SWITCH = $1D
    .label Score = $1e

    .label HighScoreString = $bc

    .label Difficulty = $D0
    

    .label Table_50_32Bytes = $50
   

    .label JOYSTICK_MASKS = $B8
 
    .label Timer1 = $50
    .label Timer2 = $51
    .label Timer3 = $52
    .label Timer4 = $53
    .label Timer5 = $68

    .label CharAnimTimer = $5C

    .label GameAnimateTimer = $57

    .label AnimCounter = $69

    .label BonusStorage1 = $24
    .label BonusStorage2 = $2A

    .label WaveDigit1 = $a5
    .label WaveDigit2 = $a6


}

.label DIGIT_TO_CHAR_MASK = $b0
.label CHAR_TO_ROM_CHAR_MARK = $80
.label CHAR_SET_P1 = $BB00
.label CHAR_SET_P2 = $BF80

.label IRQ_VECTOR_MSB = $315
.label IRQ_VECTOR_LSB = $314
.label SCREEN_MSB_LOOKUP = $3E0
.label SCREEN_LSB_LOOKUP = $3C0
.label MAP_LOOKUP_MSB = $380
.label MAP_LOOKUP_LSB = $340

.label TABLE_64_200 = $200
.label TABLE_64_240 = $240
.label TABLE_64_280 = $280

.label LOGO_COPY =    $0280
.label TABLE_64_2C0 = $02c0


.label RIGHT_ARROW_CHAR = 19
.label LEFT_ARROW_CHAR = 18

.label RASTER_Y = $9004
.label INTERRUPT_ENABLE = $911E
.label TIMER_1_LSB = $9126
.label TIMER_1_MSB = $9127
.label COLOUR_REG = $900F
.label VERTICAL_TOP_LOCATION = $9001
.label HORIZONTAL_START_LOCATION = $9000
.label VIC_REGISTER_START = HORIZONTAL_START_LOCATION
.label DATA_DIRECTION_REG_B = $9122
.label PORT_A_OUTPUT = $9111
.label PORT_B_OUTPUT = $9120
.label PORT_B_KEYBOARD_COL = $9120
.label PORT_A_KEYBOARD_ROW = $9121
.label SOUND_CHANNEL_1 = $900a
.label SOUND_CHANNEL_2 = $900b
.label SOUND_CHANNEL_3 = $900c
.label SOUND_CHANNEL_4 = $900d
.label SOUND_VOLUME_AUX_COLOR = $900e

.label VENUS_START = $1d28
.label STALKER_START = $1cf8
.label DEAD_START = $1c08
.label DRAGON_START = $1d38
.label SCORPION_START = $1c18

.label BALL_CHAR_SOURCE = $1c38
.label BALL_CHAR_USE = $1d30
.label HOME_CHAR_USE = $1c10


.label BONUS_SCREEN_POSITION = $1e60
.label LIFE_ARROW_POSITION = $1E1D
.label WAVE_ARROW_POSITION = $1E24
.label LIFE_INDICATOR_COLOUR_POS = $961e

.label LIFE_INDICATOR_POSITION = $1e1e
.label SCORE_POSITION = $1e08
.label SCORE_COLOUR_POSITION = $9608

.label AIR_INDICATOR_POSITION = $1ec2
.label AIR_INDICATOR_COLOUR_POS = $96c2

.label NEXT_EGG_POSITION = $1fe0
.label NEXT_EGG_COLOUR_POS = $97e0
.label DIFFICULTY_POSITION = $1fd1
.label DIFFICULTY_COLOUR_POS = $97d1

.label WAVE_NUMBER_POSITION = $1e22


.label CHAR_RAM = $1C00
.label SCREEN_RAM = $1E00

.label MAP_DATA = $1000

.label CHAR_EOR_TABLE = $bf70
.label CHAR_EDIT_ADDRESS = $1C90

.label CHAR_RAM_SCORPION_LOGO = $1d80
.label CHAR_RAM_SCORPION_LOGO_END = $1dc0
.label CHAR_RAM_MINI_MAP = $1d80


.label Timer_LSB = 177
.label Timer_MSB = 1
.label RASTER_SPLIT_1 = 45
.label RASTER_SPLIT_2 = 34
.label COLUMNS = 22
.label ROWS = 32
.label MAP_ROWS = 64
.label MAP_COLUMNS = 48

.label SOLID_CHAR = 33
.label SCORPION_UP_CHAR = 4

.label SCREEN_ROWS = 23
.label SCREEN_COLS = 22

.label BLACK_BORDER = 0
.label WHITE_BORDER = 1
.label RED_BORDER = 2
.label CYAN_BORDER = 3
.label PURPLE_BORDER = 4
.label GREEN_BORDER = 5
.label BLUE_BORDER = 6
.label YELLOW_BORDER = 7

.label BLACK_BG = 0
.label WHITE_BG = 16
.label RED_BG = 32
.label CYAN_BG = 48
.label PURPLE_BG = 64
.label GREEN_BG = 80
.label BLUE_BG = 96
.label YELLOW_BG = 112
.label ORANGE_BG = 128
.label LIGHT_ORANGE_BG = 144
.label PINK_BG = 160
.label LIGHT_CYAN_BG = 176
.label LIGHT_PURPLE_BG = 192
.label LIGHT_GREEN_BG = 208
.label LIGHT_BLUE_BG = 224
.label LIGHT_YELLOW_BG = 240

.label INVERTED = 8

.label START_LIVES = 4
.label SCANNER_ROW = 12



