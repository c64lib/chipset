#importonce
.filenamespace c64lib

// CIA1
.label CIA1               = $DC00 
.label CIA1_DATA_PORT_A   = CIA1 + $00
.label CIA1_DATA_PORT_B   = CIA1 + $01
.label CIA1_DATA_DIR_A    = CIA1 + $02
.label CIA1_DATA_DIR_B    = CIA1 + $03
.label CIA1_TIMER_A_LO    = CIA1 + $04 
.label CIA1_TIMER_A_HI    = CIA1 + $05 
.label CIA1_TIMER_B_LO    = CIA1 + $06 
.label CIA1_TIMER_B_HI    = CIA1 + $07 
.label CIA1_TOD_SEC10     = CIA1 + $08 
.label CIA1_TOD_SEC       = CIA1 + $09
.label CIA1_TOD_MIN       = CIA1 + $0A
.label CIA1_TOD_HOUR      = CIA1 + $0B
.label CIA1_IO_BUFFER     = CIA1 + $0C
.label CIA1_IRQ_CONTROL   = CIA1 + $0D
.label CIA1_CONTROL_A     = CIA1 + $0E
.label CIA1_CONTROL_B     = CIA1 + $0F

// CIA2
.label CIA2               = $DD00
.label CIA2_DATA_PORT_A   = CIA2 + $00
.label CIA2_DATA_PORT_B   = CIA2 + $01
.label CIA2_DATA_DIR_A    = CIA2 + $02
.label CIA2_DATA_DIR_B    = CIA2 + $03
.label CIA2_TIMER_A_LO    = CIA2 + $04 
.label CIA2_TIMER_A_HI    = CIA2 + $05 
.label CIA2_TIMER_B_LO    = CIA2 + $06 
.label CIA2_TIMER_B_HI    = CIA2 + $07 
.label CIA2_TOD_SEC10     = CIA2 + $08 
.label CIA2_TOD_SEC       = CIA2 + $09
.label CIA2_TOD_MIN       = CIA2 + $0A
.label CIA2_TOD_HOUR      = CIA2 + $0B
.label CIA2_IO_BUFFER     = CIA2 + $0C
.label CIA2_IRQ_CONTROL   = CIA2 + $0D
.label CIA2_CONTROL_A     = CIA2 + $0E
.label CIA2_CONTROL_B     = CIA2 + $0F

// Joystick flags
.label JOY_UP           = %00001
.label JOY_DOWN         = %00010
.label JOY_LEFT         = %00100
.label JOY_RIGHT        = %01000
.label JOY_FIRE         = %10000

// VIC-II memory banks
.label BANK_0           = %00000011
.label BANK_1           = %00000010
.label BANK_2           = %00000001
.label BANK_3           = %00000000

/*
 * Configures memory "bank" (16K) which is directly addressable by VIC2 chip.
 *
 * MOD: A
 */
.macro setVICBank(bank) {
  lda CIA2_DATA_PORT_A
  and #%11111100
  ora #[bank & %00000011]
  sta CIA2_DATA_PORT_A
}
.assert "setVICBank(BANK_0) sets 11", { :setVICBank(BANK_0) }, {
  lda $DD00
  and #%11111100
  ora #%00000011
  sta $DD00
}
.assert "setVICBank(BANK_3) sets 00", { :setVICBank(BANK_3) }, {
  lda $DD00
  and #%11111100
  ora #%00000000
  sta $DD00
}

.macro disableCIAInterrupts() {
  lda #$7F                     
  sta CIA1_IRQ_CONTROL
  sta CIA2_IRQ_CONTROL
  lda CIA1_IRQ_CONTROL
  lda CIA2_IRQ_CONTROL
}
