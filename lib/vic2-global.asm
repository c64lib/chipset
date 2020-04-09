#import "vic2.asm"
#importonce
.filenamespace c64lib

.function @c64lib_getTextOffset(xPos, yPos) { .return getTextOffset(xPos, yPos) }
.function @c64lib_getTextMemory(screenMem, charSet) { .return getTextMemory(screenMem, charSet) }
.function @c64lib_getBitmapMemory(video, bitmap) { .return getBitmapMemory(video, bitmap) }
.macro @c64lib_detectNtsc(onPalCallback, onNtscCallback) { detectNtsc(onPalCallback, onNtscCallback) }
.macro @c64lib_debugBorderStart() { debugBorderStart() }
.macro @c64lib_debugBorderEnd() { debugBorderEnd() }
.macro @c64lib_setRaster(rasterLine) { setRaster(rasterLine) }
.macro @c64lib_irqEnter() { irqEnter() }
.macro @c64lib_irqExit(intVector, rasterLine, memory) { irqExit(intVector, rasterLine, memory) }
.macro @c64lib_rotateCharRight(charPointer) { rotateCharRight(charPointer) }
.macro @c64lib_rotateCharBottom(charPointer, store) { rotateCharBottom(charPointer, store) }
