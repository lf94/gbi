/*************************************************************************
 *   Cboy, a Game Boy emulator
 *   Copyright (C) 2012 jkbenaim
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ************************************************************************/

/*
 * bootrom.s
 * A GBC bootrom replacement.
 */

.include "regs.i"

.RAMSIZE 0
.EMPTYFILL $E4	; lockup

.memorymap
slotsize $4000
defaultslot 0
slot 0 $0000
slot 1 $4000
.endme

.ROMBANKSIZE $4000
.ROMBANKS 2


.bank 0
.org $0000

init:
  ld sp, $fffe		; set up stack
  ld a, $91		; turn on lcd
  ldh (R_LCDC), a
  call set_system_mode
  xor a
  ldh (R_SVBK), a
  
  ; These are set by a real CGB during bootup.
  ld hl, $d000
  ld a, (hl)
  ld b, a
  
  ld hl, $0080
  push hl
  pop af
  
  xor a
  ld c,a
  ld d,a
  
  ld a,$08
  ld e,a

  ; The game can check the initial value of
  ; the A and B registers to determine the
  ; machine type.
  ld a, $11     ; $01= DMG,SGB1  $11= CGB,GBA, $FF= SGB2,MGB
  
  jp chainload

.org $fe
chainload:
  ldh ($50), a

.org $200
set_system_mode:
  call wait_for_vblank
  ld a, ($0143)	; load CGB flag from cart rom
  bit 7, a	; is this a CGB game?
  jr z, _dmg_game	; if not, jump to _dmg_game
			; otherwise, fall through to _cgb_game
  
  _cgb_game:
  ; cgb game
  ; all we have to do is copy the
  ; CGB flag ($0143) from the cart rom
  ; to $FF4C.
  ldh ($4c), a
  
  ; $d000 stores the bootup value of the B register
  ld hl, $d000
  ld a, $00     ; $00= CGB   $01= GBA
  ld (hl), a
  
  jr _return
  
  
  _dmg_game:
  ; dmg game
  
  call compute_name_checksum
  
  ; set palette
  ld a,$fc
  ldh (R_BGP), a
  xor a
  ldh (R_OBP0), a
  ldh (R_OBP1), a
  
  ; write $04 to $FF4C.
  ld a, $04
  ldh ($4c), a
  ld a, $01
  ldh ($6c), a
  
  ; load grayscale palettes
  
  ; background palette
  ld a, $80	; prepare BGPI
  ldh (R_BGPI), a
  ld b, 8
  ld hl, dmg_palette_bgp
  _loop_1:
  ld a, (hl+)
  ldh (R_BGPD), a
  dec b
  jr nz, _loop_1
  ; done setting up background palette
  
  ; object palettes
  ld a, $80	; prepare OGPI
  ldh (R_OBPI), a
  
  ; object palette 0
  ld b, 8
  ld hl, dmg_palette_obp0
  _loop_2:
  ld a, (hl+)
  ldh (R_OBPD), a
  dec b
  jr nz, _loop_2
  
  ; object palette 1
  ld b, 8
  ld hl, dmg_palette_obp1
  _loop_3:
  ld a, (hl+)
  ldh (R_OBPD), a
  dec b
  jr nz, _loop_3
  
  
  _return:
  ret

wait_for_vblank:
  push hl
  ld hl, IF
  res 0, (hl)
  _loop_vblank:
  bit 0, (hl)
  jr z, _loop_vblank
  pop hl
  ret

; A real CGB takes the checksum of a game's name if
; it is not a CGB-aware game. The checksum is used
; for three purposes:
;       1. Setting the palette.
;       2. Showing the original DMG logo or not.
;       3. The checksum is stored both at
;          $D000 and as the contents of the B
;          register at bootup.
; Since we want to simulate the initial register state
; of a real CGB, we have to calculate this to set the B
; register.
; Note that this only applies to DMG games; in the case
; of CGB-aware games, the intial value of the B register
; is either $00 (CGB) or $01 (GBA).
; This function returns the checksum in the A and E registers.
compute_name_checksum:
  ld de, $1000
  ld hl, $0134
  _loop_compute_name_checksum:
  ld a, (hl+)
  add e
  ld  e,a
  dec d
  jr nz, _loop_compute_name_checksum
  ld hl, $d000
  ld (hl), a
  ret

; This palette data was shamelessly stolen from BGB.
; Many thanks to Beware.
dmg_palette_bgp:
  .db $BD,$77,$94,$52,$6B,$2D,$42,$08
dmg_palette_obp0:
  .db $BD,$77,$94,$52,$6B,$2D,$42,$08
dmg_palette_obp1:
  .db $BD,$77,$94,$52,$6B,$2D,$42,$08
