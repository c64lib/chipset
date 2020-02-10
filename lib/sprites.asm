#import "vic2.asm"
#importonce
.filenamespace c64lib

/* 
 * Calculates sprite X position register address
 */
.function spriteXReg(spriteNo) {
  .return VIC2 + spriteNo * 2
}
.assert "Reg address for sprite0 X pos", spriteXReg(0), SPRITE_0_X
.assert "Reg address for sprite7 X pos", spriteXReg(7), SPRITE_7_X


/* 
 * Calculates sprite Y position register address
 */
.function spriteYReg(spriteNo) {
  .return spriteXReg(spriteNo) + 1
}
.assert "Reg address for sprite0 Y pos", spriteYReg(0), SPRITE_0_Y
.assert "Reg address for sprite7 Y pos", spriteYReg(7), SPRITE_7_Y


/* 
 * Calculates sprite bit position
 */
.function spriteMask(spriteNo) {
  .return pow(2, spriteNo)
}
.assert "Bit mask for sprite 0", spriteMask(0), %00000001
.assert "Bit mask for sprite 7", spriteMask(7), %10000000


/* 
 * Calculate sprite color register address
 */
.function spriteColorReg(spriteNo) {
  .return SPRITE_0_COLOR + spriteNo
}
.assert "Reg address for sprite0 color", spriteColorReg(0), SPRITE_0_COLOR
.assert "Reg address for sprite7 color", spriteColorReg(7), SPRITE_7_COLOR


/* 
 * Sets X position of given sprite (uses sprite MSB register if necessary)
 * MOD: A
 */
.macro locateSpriteX(x, spriteNo) {
  .if (x > 255) {
    lda #<x
    sta spriteXReg(spriteNo)
    lda SPRITE_MSB_X
    ora #spriteMask(spriteNo)
    sta SPRITE_MSB_X
  } else {
    lda #x
    sta spriteXReg(spriteNo)
  }
}
.assert "locateSpriteX stores X in SPRITE_X reg", { locateSpriteX(5, 3) }, { 
  lda #$05
  sta SPRITE_3_X 
}
.assert "locateSpriteX stores X in SPRITE_X and MSB regs", { locateSpriteX(257, 3) },  {
  lda #$01
  sta SPRITE_3_X
  lda SPRITE_MSB_X
  ora #%00001000
  sta SPRITE_MSB_X
}

/* 
 * Sets Y position of given sprite
 * MOD: A
 */
.macro locateSpriteY(y, spriteNo) {
  lda #y
  sta spriteYReg(spriteNo)
}
.assert "locateSpriteY stores Y in SPRITE_Y reg", { locateSpriteY(5, 3) },  {
  lda #$05
  sta SPRITE_3_Y
}

/* 
 * Sets X,Y position of given sprite
 * MOD A
 */
.macro locateSprite(x, y, spriteNo) {
  locateSpriteX(x, spriteNo)
  locateSpriteY(y, spriteNo)
}

.macro sh(data) {
  .assert "Hires sprite line length must be 24", data.size(), 24
  .byte convertHires(data.substring(0, 8)), convertHires(data.substring(8, 16)), convertHires(data.substring(16,24))
}

.macro sm(data) {
  .assert "Multicolor sprite line length must be 12", data.size(), 12
  .byte convertMultic(data.substring(0, 4)), convertMultic(data.substring(4, 8)), convertMultic(data.substring(8,12))
}
