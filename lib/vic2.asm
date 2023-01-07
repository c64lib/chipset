/*
 * MIT License
 *
 * Copyright (c) 2018-2032 c64lib
 * Copyright (c) 2018-2023 Maciej Małecki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
/*
 * Set of variables, functions and macros
 * for handling VIC-II graphic processor.
 *
 * Requires KickAssembler v4.x
 * (c) 2017-2018 Maciej Malecki
 */
#import "common/lib/common.asm"
#importonce
.filenamespace c64lib

/* ------------------------------------
 * VIC-II registers.
 * ------------------------------------ */
.label VIC2                 = $D000
.label SPRITE_0_X           = VIC2 + $00
.label SPRITE_0_Y           = VIC2 + $01
.label SPRITE_1_X           = VIC2 + $02
.label SPRITE_1_Y           = VIC2 + $03
.label SPRITE_2_X           = VIC2 + $04
.label SPRITE_2_Y           = VIC2 + $05
.label SPRITE_3_X           = VIC2 + $06
.label SPRITE_3_Y           = VIC2 + $07
.label SPRITE_4_X           = VIC2 + $08
.label SPRITE_4_Y           = VIC2 + $09
.label SPRITE_5_X           = VIC2 + $0A
.label SPRITE_5_Y           = VIC2 + $0B
.label SPRITE_6_X           = VIC2 + $0C
.label SPRITE_6_Y           = VIC2 + $0D
.label SPRITE_7_X           = VIC2 + $0E
.label SPRITE_7_Y           = VIC2 + $0F
.label SPRITE_MSB_X         = VIC2 + $10
.label CONTROL_1            = VIC2 + $11
.label RASTER               = VIC2 + $12
.label LIGHTPEN_X           = VIC2 + $13
.label LIGHTPEN_Y           = VIC2 + $14
.label SPRITE_ENABLE        = VIC2 + $15
.label CONTROL_2            = VIC2 + $16
.label SPRITE_EXPAND_Y      = VIC2 + $17
.label MEMORY_CONTROL       = VIC2 + $18
.label IRR                  = VIC2 + $19
.label IMR                  = VIC2 + $1A
.label SPRITE_PRIORITY      = VIC2 + $1B
.label SPRITE_COL_MODE      = VIC2 + $1C
.label SPRITE_EXPAND_X      = VIC2 + $1D
.label SPRITE_2S_COLLISION  = VIC2 + $1E
.label SPRITE_2B_COLLISION  = VIC2 + $1F
.label BORDER_COL           = VIC2 + $20
.label BG_COL_0             = VIC2 + $21
.label BG_COL_1             = VIC2 + $22
.label BG_COL_2             = VIC2 + $23
.label BG_COL_3             = VIC2 + $24
.label SPRITE_COL_0         = VIC2 + $25
.label SPRITE_COL_1         = VIC2 + $26
.label SPRITE_0_COLOR       = VIC2 + $27
.label SPRITE_1_COLOR       = VIC2 + $28
.label SPRITE_2_COLOR       = VIC2 + $29
.label SPRITE_3_COLOR       = VIC2 + $2A
.label SPRITE_4_COLOR       = VIC2 + $2B
.label SPRITE_5_COLOR       = VIC2 + $2C
.label SPRITE_6_COLOR       = VIC2 + $2D
.label SPRITE_7_COLOR       = VIC2 + $2E

.label COLOR_RAM            = $D800
.label TOP_SCREEN_RASTER_POS = 50

.label RASTER_MAX_PAL       = 312
.label RASTER_MAX_NTSC      = 263

/* ------------------------------------
 * CONTROL_1 bits
 * ------------------------------------ */
.label CONTROL_1_RASTER8  = %10000000
.label CONTROL_1_ECM      = %01000000
.label CONTROL_1_BMM      = %00100000
.label CONTROL_1_DEN      = %00010000
.label CONTROL_1_RSEL     = %00001000

/* ------------------------------------
 * CONTROL_2 bits
 * ------------------------------------ */
.label CONTROL_2_RES      = %00100000
.label CONTROL_2_MCM      = %00010000
.label CONTROL_2_CSEL     = %00001000

/* ------------------------------------
 * IRR bits
 * ------------------------------------ */
.label IRR_IRQ            = %10000000
.label IRR_LIGHTPEN       = %00001000
.label IRR_SPR_SPR        = %00000100
.label IRR_SPR_BG         = %00000010
.label IRR_RASTER         = %00000001

/* ------------------------------------
 * IMR bits
 * ------------------------------------ */
.label IMR_LIGHTPEN       = %00001000
.label IMR_SPR_SPR        = %00000100
.label IMR_SPR_BG         = %00000010
.label IMR_RASTER         = %00000001

/* ------------------------------------
 * Graphic modes
 * ------------------------------------ */
.label STANDARD_TEXT_MODE     = %000
.label MULTICOLOR_TEXT_MODE   = %001
.label STANDARD_BITMAP_MODE   = %010
.label MULTICOLOR_BITMAP_MODE = %011
.label EXTENDED_TEXT_MODE     = %100

.label MODE_ECM               = %100
.label MODE_BMM               = %010
.label MODE_MCM               = %001

/* ------------------------------------
 * Misc. constants
 */
.label TEXT_SCREEN_WIDTH = 40

/*
 * Calculates memory offset of text cell specified by given coordinates.
 *
 * Params:
 * xPos - X coord
 * yPos - Y coord
 */
.function getTextOffset(xPos, yPos) {
  .return xPos + TEXT_SCREEN_WIDTH * yPos
}
.assert "getTextOffset(0,0) gives 0", getTextOffset(0, 0), 0
.assert "getTextOffset(39,0) gives 39", getTextOffset(39, 0), 39
.assert "getTextOffset(0,1) gives 40", getTextOffset(0, 1), 40
.assert "getTextOffset(19,12) gives 499", getTextOffset(19, 12), 499
.assert "getTextOffset(39,24) gives 999", getTextOffset(39, 24), 999

/*
 * Combines screen and charset slots for memory control register.
 *
 * Params:
 * screenMem: location of screen memory: 0..15
 * charSet: location of charset definition: 0..7
 */
.function getTextMemory(screenMem, charSet) {
  .return charSet<<1 | screenMem<<4
}
.assert "getTextMemory(0, 0) returns $00",  getTextMemory(0, 0), %00000000
.assert "getTextMemory(15,7) returns $FE", getTextMemory(15, 7), %11111110
.assert "getTextMemory(4,2) returns %01000100", getTextMemory(4, 2), %01000100

/*
 * Configures memory for text mode
 *
 * Params:
 * video: location of video ram: 0..15
 * charSet: location of charset definition: 0..7
 *
 * MOD: A
 */
.macro configureTextMemory(video, charSet) {
  lda #getTextMemory(video, charSet)
  sta MEMORY_CONTROL
}
.assert "configureTextMemory(0, 0) sets $00 to MEMORY_CONTROL reg",  { :configureTextMemory(0, 0) }, {
  lda #%00000000
  sta MEMORY_CONTROL
}
.assert "configureTextMemory(15,7) sets $FE to MEMORY_CONTROL reg", { :configureTextMemory(15, 7) }, {
  lda #%11111110
  sta MEMORY_CONTROL
}
.assert "configureTextMemory(4,2) sets %01000100 to MEMORY_CONTROL reg", { :configureTextMemory(4, 2) }, {
  lda #%01000100
  sta MEMORY_CONTROL
}

/*
 * Combines video and bitmap slots into value of memory control register.
 *
 * Params:
 * video: location of video ram: 0..15
 * bitmap: location of bitmap definition: 0..1
 */
.function getBitmapMemory(video, bitmap) {
  .return bitmap<<3 | video<<4
}
.assert "getBitmapMemory(0, 0) returns $00", getBitmapMemory(0, 0), %00000000
.assert "getBitmapMemory(15, 1) returns %11111000", getBitmapMemory(15, 1), %11111000
.assert "getBitmapMemory(4, 1) returns %01001000", getBitmapMemory(4, 1), %01001000

/*
 * Configure memory for bitmap mode
 *
 * Params:
 * video: location of video ram: 0..15
 * bitmap: location of bitmap definition: 0..1
 *
 * MOD: A
 */
.macro configureBitmapMemory(video, bitmap) {
  lda #getBitmapMemory(video, bitmap)
  sta MEMORY_CONTROL
}
.assert "configureBitmapMemory(0, 0) sets $00 to MEMORY_CONTROL reg", { :configureBitmapMemory(0, 0) }, {
  lda #%00000000
  sta MEMORY_CONTROL
}
.assert "configureBitmapMemory(15, 1) sets %11111000 to MEMORY_CONTROL reg", { :configureBitmapMemory(15, 1) }, {
  lda #%11111000
  sta MEMORY_CONTROL
}
.assert "configureBitmapMemory(4, 1) sets %01001000 to MEMORY_CONTROL reg", { :configureBitmapMemory(4, 1) }, {
  lda #%01001000
  sta MEMORY_CONTROL
}

/*
 * Calculates set bits for control 1 reg and specified gfx mode
 *
 * Params:
 * mode mode designator according to predefined labels
 */
.function calculateControl1ForMode(mode) {
  .var result = $00
  .if ((mode & MODE_ECM) == MODE_ECM) .eval result = result | CONTROL_1_ECM
  .if ((mode & MODE_BMM) == MODE_BMM) .eval result = result | CONTROL_1_BMM
  .return result
}
.assert "calculateControl1ForMode(STANDARD_TEXT_MODE) returns 0" , calculateControl1ForMode(STANDARD_TEXT_MODE), $00
.assert "calculateControl1ForMode(MULTICOLOR_TEXT_MODE) returns 0", calculateControl1ForMode(MULTICOLOR_TEXT_MODE), $00
.assert "calculateControl1ForMode(STANDARD_BITMAP_MODE) returns %00100000", calculateControl1ForMode(STANDARD_BITMAP_MODE), %00100000
.assert "calculateControl1ForMode(MULTICOLOR_BITMAP_MODE) returns %00100000", calculateControl1ForMode(MULTICOLOR_BITMAP_MODE), %00100000
.assert "calculateControl1ForMode(EXTENDED_TEXT_MODE) returns %01000000", calculateControl1ForMode(EXTENDED_TEXT_MODE), %01000000

/*
 * Calculates set bits for control 2 reg and specified gfx mode
 *
 * Params:
 * mode mode designator according to predefined labels
 */
.function calculateControl2ForMode(mode) {
  .var result = $00
  .if ((mode & MODE_MCM) == MODE_MCM) .eval result = result | CONTROL_2_MCM
  .return result
}
.assert "calculateControl2ForMode(STANDARD_TEXT_MODE) returns 0", calculateControl2ForMode(STANDARD_TEXT_MODE), $00
.assert "calculateControl2ForMode(MULTICOLOR_TEXT_MODE) returns %00010000", calculateControl2ForMode(MULTICOLOR_TEXT_MODE), %00010000
.assert "calculateControl2ForMode(STANDARD_BITMAP_MODE) returns 0", calculateControl2ForMode(STANDARD_BITMAP_MODE), %00000000
.assert "calculateControl2ForMode(MULTICOLOR_BITMAP_MODE) returns %00010000", calculateControl2ForMode(MULTICOLOR_BITMAP_MODE), %00010000
.assert "calculateControl2ForMode(EXTENDED_TEXT_MODE) returns 0", calculateControl2ForMode(EXTENDED_TEXT_MODE), %00000000

/*
 * Sets given video mode according to predefined labels. Works in each and every case
 * but might be not so optimal if modification of both CONTROL_1 and CONTROL_2 regs is
 * not required. Use when precise timing is not critical.
 *
 * Params:
 * mode: VIC-II video mode designator according to predefined labels
 *
 * MOD: A
 */
.macro setVideoMode(mode) {                // 24
  lda CONTROL_2                             // 4
  and #neg(CONTROL_2_MCM)                   // 2
  ora #calculateControl2ForMode(mode)       // 2
  sta CONTROL_2                             // 4

  lda CONTROL_1                             // 4
  and #neg(CONTROL_1_ECM | CONTROL_1_BMM)   // 2
  ora #calculateControl1ForMode(mode)       // 2
  sta CONTROL_1                             // 4
}
.assert "setVideoMode(STANDARD_TEXT_MODE) sets 0/0/0", { :setVideoMode(STANDARD_TEXT_MODE) }, {
  lda CONTROL_2;and #%11101111;ora #$00;sta CONTROL_2
  lda CONTROL_1;and #%10011111;ora #$00;sta CONTROL_1
}
.assert "setVideoMode(MULTICOLOR_TEXT_MODE) sets 0/0/1", { :setVideoMode(MULTICOLOR_TEXT_MODE) }, {
  lda CONTROL_2;and #%11101111;ora #%00010000;sta CONTROL_2
  lda CONTROL_1;and #%10011111;ora #$00;sta CONTROL_1
}
.assert "setVideoMode(STANDARD_BITMAP_MODE) sets 0/1/0", { :setVideoMode(STANDARD_BITMAP_MODE) }, {
  lda CONTROL_2;and #%11101111;ora #$00;sta CONTROL_2
  lda CONTROL_1;and #%10011111;ora #%00100000;sta CONTROL_1
}
.assert "setVideoMode(MULTICOLOR_BITMAP_MODE) sets 0/1/1", { :setVideoMode(MULTICOLOR_BITMAP_MODE) }, {
  lda CONTROL_2;and #%11101111;ora #%00010000;sta CONTROL_2
  lda CONTROL_1;and #%10011111;ora #%00100000;sta CONTROL_1
}
.assert "setVideoMode(EXTENDED_TEXT_MODE) sets 1/0/0", { :setVideoMode(EXTENDED_TEXT_MODE) }, {
  lda CONTROL_2;and #%11101111;ora #$00;sta CONTROL_2
  lda CONTROL_1;and #%10011111;ora #%01000000;sta CONTROL_1
}

/*
 * Configures VIC-II so that it fire IRQ when given "rasterLine" is drawn.
 *
 * MOD: A
 */
.macro setRaster(rasterLine) {
  lda #<rasterLine
  sta RASTER
  lda CONTROL_1
  .if (rasterLine > 255) {
    ora #CONTROL_1_RASTER8
  } else {
    and #neg(CONTROL_1_RASTER8)
  }
  sta CONTROL_1
}
.assert "setRaster(0)", { :setRaster(0) }, {
  lda #0; sta RASTER; lda CONTROL_1; and #neg(CONTROL_1_RASTER8); sta CONTROL_1
}
.assert "setRaster($FF)", { :setRaster($FF) }, {
  lda #$FF; sta RASTER; lda CONTROL_1; and #neg(CONTROL_1_RASTER8); sta CONTROL_1
}
.assert "setRaster($100)", { :setRaster($100) }, {
  lda #00; sta RASTER; lda CONTROL_1; ora #CONTROL_1_RASTER8; sta CONTROL_1
}
.assert "setRaster($1F7)", { :setRaster($1F7) }, {
  lda #$F7; sta RASTER; lda CONTROL_1; ora #CONTROL_1_RASTER8; sta CONTROL_1
}
.assert "setRaster($1FF)", { :setRaster($1FF) }, {
  lda #$FF; sta RASTER; lda CONTROL_1; ora #CONTROL_1_RASTER8; sta CONTROL_1
}

/*
 * Call it when entering raster interrupt.
 *
 * MOD: A
 */
.macro irqEnter() {
  pha
  tya
  pha
  txa
  pha
}

/*
 * Call it at the end of raster interrupt.
 *
 * intVector - address of next interrupt handling routine
 * rasterLine - at which raster line should we fire next interrupt
 * memory - if true, rasterLine is taken from memory address, if false - absolute addressing is used
 */
.macro irqExit(intVector, rasterLine, memory) {
  ldx #>intVector
  ldy #<intVector
  stx $FFFF
  sty $FFFE
  .if (memory) {
    lda rasterLine
    sta RASTER
    lda CONTROL_1
    ror rasterLine+1
    bcc doAnd
    ora #CONTROL_1_RASTER8
    jmp next
  doAnd:
    and #neg(CONTROL_1_RASTER8)
  next:
    sta CONTROL_1
  } else {
    :setRaster(rasterLine)
  }
  sec
  dec IRR
  pla
  tax
  pla
  tay
  pla
  rti
}

.macro debugBorder(color) {
  #if VISUAL_DEBUG
  lda #color
  sta BORDER_COL
  #endif
}

.macro debugBorderStart() {
  #if VISUAL_DEBUG
  inc BORDER_COL
  #endif
}

.macro debugBorderEnd() {
  #if VISUAL_DEBUG
  dec BORDER_COL
  #endif
}

/*
 * NTSC detection routine written by J0X (https://csdb.dk/scener/?id=1221).
 * It is so short and will be called only once so that I will code it as simple
 * macro and not subroutine.
 *
 * This macro takes callback addresses for PAL and NTSC events as parameters. Callback
 * will be ignored (not jumped into) if its value is 0 or less.
 *
 * Params:
 *   onPalCallback   subroutine address, it will be called (JSR) when PAL is detected
 *   onNtscCallback  subroutine address, it will be called (JSR) when NTSC is detected
 */
.macro detectNtsc(onPalCallback, onNtscCallback) {
  nextLine:
    lda RASTER
    busyWait:
      cmp RASTER
    beq busyWait
  bmi nextLine
  cmp #$20
  bcc ntsc
    .if (onPalCallback > 0) {
      jsr onPalCallback
    }
  jmp end
  ntsc:
    .if (onNtscCallback > 0) {
      jsr onNtscCallback
    }
  end:
}

/**
 * Rotates pointed character to the right.
 * This is a hosted subroutine.
 * This subroutine should be first installed by calling this macro with appropriate parameter (see below).
 *
 * Parameters:
 * charPointer - should point to zero-page location (2 bytes). Location should contain address of the character to be rotated.
 *
 * Mod: A, Y
 */
.macro rotateCharRight(charPointer) {
  ldy #0
  !:
    lda (charPointer),y
    clc
    lsr
    bcc next
      ora #%10000000
    next:
    sta (charPointer),y
    iny
    cpy #8
  bne !-
}

/**
 * Rotates pointed character to the bottom.
 * This is a hosted subroutine.
 * This subroutine should be first installed by calling this macro with appropriate parameter (see below).
 *
 * Parameters:
 * charPointer - should point to zero-page location (2 bytes). Location should contain address of the character to be rotated.
 * store - should point to zero or non-zero location (1 byte). This location is used internaly, it's content will be destroyed after calling the subroutine.
 *
 * Mod: A, Y
 */
.macro rotateCharBottom(charPointer, store) {
  ldy #7
  lda (charPointer),y
  sta store
  !:
    dey
    lda (charPointer),y
    iny
    sta (charPointer),y
    dey
  bne !-
  lda store
  sta (charPointer),y
}