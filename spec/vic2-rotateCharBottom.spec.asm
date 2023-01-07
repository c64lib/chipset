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
