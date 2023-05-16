#define __SFR_OFFSET 0x00
#include "avr/io.h"
.global main

;------------------------
main:
LDI R20, 0xFF
OUT DDRB, R20 ;set port D as o/p for low byte result
OUT DDRD, R20
LDI R20, 0b00000011 ;
OUT DDRC, R20 ;A0 A1 sebagai o/p sisanya sebagai input
;--------------------------------------------------------------
LDI R20, 0b11000010 ;internal 2.56V, right-justified data, ADC2
STS ADMUX, R20
LDI R20, 0x87 ;enable ADC, ADC prescaler CLK/128
STS ADCSRA, R20
RCALL SPI_MAX7219_INIT
;-----------------------------------------------------------------

read_ADC:
LDI R20, 0xC7 ;set ADSC in ADCSRA to start conversion
STS ADCSRA, R20
;--------------------------------------------------------------
wait_ADC:
LDS R21, ADCSRA ;check ADIF flag in ADCSRA
SBRS R21, 4 ;skip jump when conversion is done (flag set)
RJMP wait_ADC ;loop until ADIF flag is set
;--------------------------------------------------------------
LDI R17, 0xD7 ;set ADIF flag again
STS ADCSRA, R17 ;so that controller clears ADIF
;--------------------------------------------------------------
LDS R18, ADCL ;get low-byte result from ADCL
LDS R19, ADCH ;get high-byte result from ADCH
;RJMP check_LDR
;-----------------------------------------------------------------
;
CPI R19, 1 ;compare r19 dengan nilai 1
BRGE first ;jika >= maka branch ke sub-routine first
CPI R19, 3 ;compare r19 dengan nilai 3
BRLO second ;jika < maka branch ke sub-routine second

first:
CPI R18, 255 ;compare r18 dengan nilai 256
BRLO two ;jika < branchke sub-routine one
RJMP one ;jika tidak branch ke sub-routine one

second:
CPI R18, 64 ;compare r18 dengan nilai 127
BRLO five ;jika < branchke sub-routine five
CPI R18, 127 ;compare r18 dengan nilai 127
BRLO four ;jika < branchke sub-routine four
RJMP three ; jika > maka branch three

one:
LDI R27, 0xFF ;isi register dengan 1
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB, 0 ;output portb bit 1 high
RCALL MAX7219_disp_text_Malam
RJMP read_ADC ;kembali membaca input


two:
LDI R27, 0xC7 ;isi register dengan 131
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB,0 ;output portb bit 1 high
RCALL MAX7219_disp_text_Malam
RJMP read_ADC ;kembali membaca input

three:
LDI R27,0x83 ;isi register dengan 199
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB,0 ;output portb bit 1 high
RCALL MAX7219_disp_text_Siang
RJMP read_ADC ;kembali membaca input

four:
LDI R27,0x01
 ;isi register dengan 239
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB,0 ;output portb bit 1 high
RCALL MAX7219_disp_text_Siang
RJMP read_ADC ;kembali membaca input

five:
LDI R27, 0x00 ;isi register dengan 255
OUT PORTD,R27 ;output portd sama dengan r27
OUT PORTB,R27 ;output portb bit 1 high
RCALL MAX7219_disp_text_Siang
RJMP read_ADC ;kembali membaca input

SPI_MAX7219_INIT:
  .equ  SCK, 5
  .equ  MOSI, 3
  .equ  SS, 2
  LDI   R17, (1<<MOSI)|(1<<SCK)|(1<<SS)
  OUT   DDRB, R17       ;set MOSI, SCK, SS as o/p
  ;--------------------------------------------------------
  LDI   R17, (1<<SPE)|(1<<MSTR)|(1<<SPR0)
  OUT   SPCR, R17       ;enable SPI as master, fsck=fosc/16
  ;--------------------------------------------------------
  LDI   R17, 0x0A       ;set segment intensity (0 to 15)
  LDI   R18, 8          ;intensity level = 8
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x09       ;set decoding mode command
  LDI   R18, 0b00000000 ;decoding byte
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x0B       ;set scan limit command
  LDI   R18, 0x07       ;8 digits connected to MAX7219
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x0C       ;set turn ON/OFF command
  LDI   R18, 0x01       ;turn ON MAX7219
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  RET

MAX7219_disp_text_Malam:
  ; Sending the bytes to MAX 7219 Display
  LDI   R17, 0x08       ;select digit 6
  LDI   R18, 0b01100110       ;data = (paruh kedua karakter 'm')
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x07       ;select digit 5
  LDI   R18, 0b01110010       ;data = (paruh pertama karakter 'm')
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x06       ;select digit 4
  LDI   R18, 0b01110111      ;data = A
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x05       ;select digit 3
  LDI   R18, 0b00001110      ;data = L
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x04       ;select digit 2
  LDI   R18, 0b01110111      ;data = A
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x03       ;select digit 1
  LDI   R18, 0b01100110       ;data = (paruh kedua karakter 'm')
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x02       ;select digit 0
  LDI   R18, 0b01110010       ;data = (paruh kedua karakter 'm')
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
    LDI   R17, 0x01       ;select digit 0
  LDI   R18, 0x0       ;data = (paruh kedua karakter 'm')
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  RET
  
MAX7219_disp_text_Siang:
  ; Sending the bytes to MAX 7219 Display
  LDI   R17, 0x08      ;select digit 4
  LDI   R18, 0b01011011       ;data = S
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x07       ;select digit 3
  LDI   R18, 0b00000110       ;data = I
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x06       ;select digit 2
  LDI   R18, 0b01110111      ;data = A
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x05       ;select digit 1
  LDI   R18, 0b01110110      ;data = n
  RCALL send_bytes      ;send command & data to MAX7219
  ;--------------------------------------------------------
  LDI   R17, 0x04       ;select digit 0
  LDI   R18, 0b01011111      ;data = G
  RCALL send_bytes      ;send command & data to MAX7219
  LDI   R17, 0x03       ;select digit 0
  LDI   R18, 0x00      ;data = G
  RCALL send_bytes      ;send command & data to MAX7219
  LDI   R17, 0x02       ;select digit 0
  LDI   R18, 0x00      ;data = G
  RCALL send_bytes      ;send command & data to MAX7219
  LDI   R17, 0x01       ;select digit 0
  LDI   R18, 0x00      ;data = G
  RCALL send_bytes      ;send command & data to MAX7219
  RET
send_bytes:
    CBI   PORTB, SS       ;enable slave device MAX7219
    OUT   SPDR, R17       ;transmit command
    ;--------------------------------------------------------
ll2:IN    R19, SPSR
    SBRS  R19, SPIF       ;wait for byte transmission
    RJMP  ll2             ;to complete
    ;--------------------------------------------------------
    OUT   SPDR, R18       ;transmit data
    ;--------------------------------------------------------
ll3:IN    R19, SPSR
    SBRS  R19, SPIF       ;wait for byte transmission
    RJMP  ll3             ;to complete
    ;--------------------------------------------------------
    SBI   PORTB, SS       ;disable slave device MAX7219
    RET