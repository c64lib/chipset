#importonce

.filenamespace c64lib

/*
 * MOS6510 Registers.
 */
.label MOS_6510_DIRECTION       = $00
.label MOS_6510_IO              = $01

/*
 * I/O Register bits.
 */
.label CASETTE_MOTOR_OFF        = %00100000
.label CASETTE_SWITCH_CLOSED    = %00010000
.label CASETTE_DATA             = %00001000
.label PLA_CHAREN               = %00000100
.label PLA_HIRAM                = %00000010
.label PLA_LORAM                = %00000001

/*
 * Possible I/O & PLA configurations.
 */
.label RAM_RAM_RAM              = %000
.label RAM_CHAR_RAM             = PLA_LORAM
.label RAM_CHAR_KERNAL          = PLA_HIRAM
.label BASIC_CHAR_KERNAL        = PLA_LORAM | PLA_HIRAM
.label RAM_IO_RAM               = PLA_CHAREN | PLA_LORAM
.label RAM_IO_KERNAL            = PLA_CHAREN | PLA_HIRAM
.label BASIC_IO_KERNAL          = PLA_CHAREN | PLA_LORAM | PLA_HIRAM

.macro configureMemory(config) {
  lda MOS_6510_IO
  and #%11111000
  ora #[config & %00000111]
  sta MOS_6510_IO
}

.macro disableNMI() {
    lda #<nmi
    sta c64lib.NMI_LO
    lda #>nmi
    sta c64lib.NMI_HI
    jmp end
  nmi: 
    rti
  end:
}
