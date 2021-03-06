	INCLUDE	"Hardware.inc"

; Cartridge header

	SECTION	"Org $00",HOME[$00]
RST_00:
	jp	$100

	SECTION	"Org $08",HOME[$08]
RST_08:
	jp	$100

	SECTION	"Org $10",HOME[$10]
RST_10:
	jp	$100

	SECTION	"Org $18",HOME[$18]
RST_18:
	jp	$100

	SECTION	"Org $20",HOME[$20]
RST_20:
	jp	$100

	SECTION	"Org $28",HOME[$28]
RST_28:
	jp	$100

	SECTION	"Org $30",HOME[$30]
RST_30:
	jp	$100

	SECTION	"Org $38",HOME[$38]
RST_38:
	jp	$100

; Interrupt vectors
	SECTION	"V-Blank IRQ Vector",HOME[$40]
VBL_VECT:
	reti

	SECTION	"LCD IRQ Vector",HOME[$48]
LCD_VECT:
	reti

	SECTION	"Timer IRQ Vector",HOME[$50]
TIMER_VECT:
	reti

	SECTION	"Serial IRQ Vector",HOME[$58]
SERIAL_VECT:
	reti

	SECTION	"Joypad IRQ Vector",HOME[$60]
JOYPAD_VECT:
	reti

	SECTION	"Start",HOME[$100]
	nop
	jp	Start

	; Nintendo logo
	NINTENDO_LOGO

	DB	"CRYSYS E   " ; $0140 (Game title)
	DB	"CSYS" ; $0141-$0142 (Product ID)
	DB	$00 ; $0143 (GB compatibility - DMG only)
	DB	$13 ; $0144 (High-nibble of license code - normally $00 if $014B != $33)
	DB	$37 ; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
	DB	$00	; $00 - GameBoy ; $0146 (GameBoy/Super GameBoy indicator)
	DB	$00	; $00 - ROM Only ; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
	DB	$00	; $00 - 256Kbit = 32Kbyte = 2 banks ; $0148 (ROM size)
	DB	$00	; $00 - None ; $0149 (RAM size)
	DB	$01	; $01 - All others ; $014A (Destination code)
	DB	$33	; $33 - Check $0144/$0145 for Licensee code.  ; $014B (Licensee code - this _must_ be $33)
	DB	$00 ; $014C (Mask ROM version - handled by RGBFIX)
	DB	$00 ; $014D (Complement check - handled by RGBFIX)
	DW	$00 ; $014E-$014F (Cartridge checksum - handled by RGBFIX)

	SECTION "Program Start", HOME[$0150]
Start::
