
  ;; Parameters:
  ;; Returns:
  ;; hl - bg ram address
  ;; de - positionX
  ;; bc - positionY
CalculateBGRAMAddr::

   ;; See how many cycles this will take
DB $EB

  ;; Calculate BG RAM address we'd be on
  ld h, d
  ld l, e

  DB $E3

  call DivHLBy8

  DB $E3

  ;; Wrap X position around BGRAM
  ld a, l
  and $1F

  ld  h, 0
  ld  l, a
  push hl

  ;; Now calculate for Y
  ld h, b
  ld l, c
  DB $E3

  ;; Multiply by 4
  add hl, hl
  add hl, hl
  DB $E3

  ;; Add together hl and b (Y + X)

  pop de
  add hl, de
  DB $E3

  ;; Add the offset + BG RAM address
  ld de, $9800
  add hl, de

;; DUMP_REG instruction
DB $E3

;; See how many cycles all that took
DB $EB

;; Causes LOCKUP, which exits the emulator
DB $E4


DivHLBy8:
  sra h
  rr l
  sra h
  rr l
  sra h
  rr l
  ret

