/*
 * Copper demo 1.
 */

#import "common/lib/mem.asm"
#import "../lib/cia.asm"
#import "../lib/vic2.asm"
#import "../lib/mos6510.asm"

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
  setRaster(IRQ_1)
  lda #<irq1
  sta c64lib.IRQ_LO
  lda #>irq1
  sta c64lib.IRQ_HI
  lda #<irqFreeze
  sta c64lib.NMI_LO
  lda #>irqFreeze
  sta c64lib.NMI_HI
  configureMemory(c64lib.RAM_IO_RAM)  // turn off kernal, so that our vector becomes visible
  cli
block:
  jmp block                   // go into endless loop
  
irq1: {  
  irqEnter()
  inc c64lib.BG_COL_0         // change background color 
  inc c64lib.BORDER_COL       // change border color
  irqExit(irq2, IRQ_2, false)
}  

irq2: {
  irqEnter()
  dec c64lib.BG_COL_0         // change it back
  dec c64lib.BORDER_COL       // change it back
  irqExit(irq1, IRQ_1, false)
}
  
irqFreeze: {
  rti
}


