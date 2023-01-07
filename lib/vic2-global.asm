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
