/*
 * Set of variables, functions and macros 
 * for handling VIC-II graphic processor.
 * 
 * Requires KickAssembler v4.x
 * (c) 2017-2018 Maciej Malecki
 */
#import "common/common.asm"
#importonce
.filenamespace vic2

.function neg(value) {
	.return value ^ $FF
}

/* ------------------------------------
 * VIC-II registers.
 * ------------------------------------ */
.label BASE 				= $D000	
.label SPRITE_0_X			= $D000 
.label SPRITE_0_Y			= $D001 
.label SPRITE_1_X			= $D002 
.label SPRITE_1_Y			= $D003 
.label SPRITE_2_X			= $D004 
.label SPRITE_2_Y			= $D005 
.label SPRITE_3_X			= $D006 
.label SPRITE_3_Y			= $D007 
.label SPRITE_4_X			= $D008
.label SPRITE_4_Y			= $D009 
.label SPRITE_5_X			= $D00A 
.label SPRITE_5_Y			= $D00B 
.label SPRITE_6_X			= $D00C 
.label SPRITE_6_Y			= $D00D
.label SPRITE_7_X			= $D00E 
.label SPRITE_7_Y			= $D00F 
.label SPRITE_MSB_X 		= $D010
.label CONTROL_1 			= $D011
.label RASTER 				= $D012
.label LIGHTPEN_X			= $D013
.label LIGHTPEN_Y			= $D014
.label SPRITE_ENABLE 		= $D015
.label CONTROL_2 			= $D016
.label SPRITE_EXPAND_Y 		= $D017
.label MEMORY_CONTROL 		= $D018
.label IRR 					= $D019
.label IMR 					= $D01A
.label SPRITE_PRIORITY		= $D01B
.label SPRITE_COL_MODE		= $D01C
.label SPRITE_EXPAND_X		= $D01D
.label SPRITE_2S_COLLISION	= $D01E
.label SPRITE_2B_COLLISION	= $D01F
.label BORDER_COL 			= $D020
.label BG_COL_0 			= $D021
.label BG_COL_1 			= $D022
.label BG_COL_2 			= $D023
.label BG_COL_3				= $D024
.label SPRITE_COL_0			= $D025
.label SPRITE_COL_1			= $D026
.label SPRITE_0_COLOR 		= $D027
.label SPRITE_1_COLOR 		= $D028
.label SPRITE_2_COLOR 		= $D029
.label SPRITE_3_COLOR 		= $D02A
.label SPRITE_4_COLOR 		= $D02B
.label SPRITE_5_COLOR 		= $D02C
.label SPRITE_6_COLOR 		= $D02D
.label SPRITE_7_COLOR 		= $D02E

.label COLOR_RAM 			= $D800

.label TOP_SCREEN_RASTER_POS = 50

/* ------------------------------------
 * CONTROL_1 bits
 * ------------------------------------ */
.label CONTROL_1_RASTER8	= %10000000
.label CONTROL_1_ECM		= %01000000
.label CONTROL_1_BMM		= %00100000
.label CONTROL_1_DEN		= %00010000
.label CONTROL_1_RSEL		= %00001000

/* ------------------------------------
 * CONTROL_2 bits
 * ------------------------------------ */
.label CONTROL_2_RES		= %00100000
.label CONTROL_2_MCM		= %00010000
.label CONTROL_2_CSEL		= %00001000

/* ------------------------------------
 * IRR bits
 * ------------------------------------ */
.label IRR_IRQ				= %10000000
.label IRR_ILP				= %00001000
.label IRR_IMMC				= %00000100
.label IRR_IMBC				= %00000010
.label IRR_IRST				= %00000001

/* ------------------------------------
 * IMR bits
 * ------------------------------------ */
.label IMR_ELP				= %00001000
.label IMR_EMMC				= %00000100
.label IMR_EMBC				= %00000010
.label IMR_ERST				= %00000001

/* ------------------------------------
 * Graphic modes
 * ------------------------------------ */
.label STANDARD_TEXT_MODE		= %000 
.label MULTICOLOR_TEXT_MODE		= %001 
.label STANDARD_BITMAP_MODE 	= %010 
.label MULTICOLOR_BITMAP_MODE 	= %011
.label EXTENDED_TEXT_MODE		= %100 
 
.label MODE_ECM					= %100 
.label MODE_BMM					= %010 
.label MODE_MCM					= %001 

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
 * Configures memory for text mode
 *
 * Params:
 * video: location of video ram: 0..15
 * charSet: location of charset definition: 0..7
 *
 * MOD: A
 */
.macro configureTextMemory(video, charSet) {
	lda #[charSet<<1 | video<<4]
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
 * Configure memory for bitmap mode
 *
 * Params:
 * video: location of video ram: 0..15
 * bitmap: location of bitmap definition: 0..1
 *
 * MOD: A
 */
.macro configureBitmapMemory(video, bitmap) {
	lda #[bitmap<<3 | video<<4]
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
.macro setVideoMode(mode) {
	lda CONTROL_2
	and #neg(CONTROL_2_MCM)
	ora #calculateControl2ForMode(mode)
	sta CONTROL_2

	lda CONTROL_1
	and #neg(CONTROL_1_ECM | CONTROL_1_BMM)
	ora #calculateControl1ForMode(mode)
	sta CONTROL_1
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

.macro IRQ_ENTER() {
	pha
	tya
	pha
	txa
	pha
}

.macro IRQ_EXIT(intVector, rasterLine, memory) {
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
