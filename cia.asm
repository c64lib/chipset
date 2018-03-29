#importonce
.filenamespace c64lib

.label CIA1_BASE 				= $DC00 
.label CIA2_BASE 				= $DD00
.label CIA1_DATA_PORT_A = CIA1_BASE + 0
.label CIA1_DATA_PORT_B	= CIA1_BASE + 1
.label CIA2_DATA_PORT_A = CIA2_BASE + 0

.label JOY_UP 					= %00001
.label JOY_DOWN 				= %00010
.label JOY_LEFT 				= %00100
.label JOY_RIGHT 				= %01000
.label JOY_FIRE 				= %10000

.label BANK_0 				= %00000011
.label BANK_1 				= %00000010
.label BANK_2 				= %00000001
.label BANK_3 				= %00000000

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
