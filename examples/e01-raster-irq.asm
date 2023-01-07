/*
 * MIT License
 *
 * Copyright (c) 2017-2032 c64lib
 * Copyright (c) 2017-2023 Maciej Małecki
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
 * Copper demo 1.
 */

#import "common/lib/mem-global.asm"
#import "../lib/cia.asm"
#import "../lib/vic2-global.asm"
#import "../lib/mos6510-global.asm"

.label IRQ_1 = 150
.label IRQ_2 = 200

.pc = $0801 "Basic Upstart"
:BasicUpstart(start) // Basic start routine

// Main program
.pc = $0810 "Program"

start:
  sei                         // disable IRQ, otherwise C64 will crash
  lda #$7f                    // stop CIA from producing IRQ
  sta c64lib.CIA1_IRQ_CONTROL
  sta c64lib.CIA2_IRQ_CONTROL
  lda c64lib.CIA1_IRQ_CONTROL
  lda c64lib.CIA2_IRQ_CONTROL
  lda #c64lib.IMR_RASTER      // VIC-II is about to produce raster interrupt
  sta c64lib.IMR
  c64lib_setRaster(IRQ_1)
  lda #<irq1
  sta c64lib.IRQ_LO
  lda #>irq1
  sta c64lib.IRQ_HI
  lda #<irqFreeze
  sta c64lib.NMI_LO
  lda #>irqFreeze
  sta c64lib.NMI_HI
  c64lib_configureMemory(c64lib.RAM_IO_RAM)  // turn off kernal, so that our vector becomes visible
  cli
block:
  jmp block                   // go into endless loop
  
irq1: {  
  c64lib_irqEnter()
  inc c64lib.BG_COL_0         // change background color 
  inc c64lib.BORDER_COL       // change border color
  c64lib_irqExit(irq2, IRQ_2, false)
}  

irq2: {
  c64lib_irqEnter()
  dec c64lib.BG_COL_0         // change it back
  dec c64lib.BORDER_COL       // change it back
  c64lib_irqExit(irq1, IRQ_1, false)
}
  
irqFreeze: {
  rti
}


