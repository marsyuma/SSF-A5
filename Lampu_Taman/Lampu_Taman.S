#define __SFR_OFFSET 0x00
#include "avr/io.h"
#include "avr/interrupt.h"

.global start
.global reset
;------------------------
start:
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
;-----------------------------------------------------------------
reset:
LDI R27, 0xFF
OUT PORTB, R27
OUT PORTD, R27
RJMP read_ADC ;kembali membaca input

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
LDI R27, 0x01 ;isi register dengan 1
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB,0 ;output portb bit 1 high
RJMP read_ADC ;kembali membaca input

two:
LDI R27, 0x83 ;isi register dengan 131
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB,0 ;output portb bit 1 high
RJMP read_ADC ;kembali membaca input

three:
LDI R27,0xC7 ;isi register dengan 199
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB,0 ;output portb bit 1 high
RJMP read_ADC ;kembali membaca input

four:
LDI R27,0xEF ;isi register dengan 239
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB,0 ;output portb bit 1 high
RJMP read_ADC ;kembali membaca input

five:
LDI R27, 0xFF ;isi register dengan 255
OUT PORTD,R27 ;output portd sama dengan r27
SBI PORTB,0 ;output portb bit 1 high
RJMP read_ADC ;kembali membaca input