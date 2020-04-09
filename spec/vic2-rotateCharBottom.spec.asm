#import "64spec/lib/64spec.asm"
#import "../lib/vic2-global.asm"

.label charPtr = $FB

sfspec: init_spec()

    describe("rotateCharRight")

    it("rotates character to the right"); {
        lda #<characterActual
        sta charPtr
        lda #>characterActual
        sta charPtr + 1

        jsr rotateCharBottom

        assert_bytes_equal 8: characterActual: characterExpected
    }

finish_spec()

* = * "Data"

rotateCharBottom:
    c64lib_rotateCharBottom(charPtr, store); rts;

store: .byte $00

characterActual:
    .byte %00000000
    .byte %10000001
    .byte %01111110
    .byte %11111111
    .byte %10101010
    .byte %10000000
    .byte %00000001
    .byte %01010101

characterExpected:
    .byte %01010101
    .byte %00000000
    .byte %10000001
    .byte %01111110
    .byte %11111111
    .byte %10101010
    .byte %10000000
    .byte %00000001
