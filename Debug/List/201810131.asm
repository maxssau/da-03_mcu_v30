
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega48PA
;Program type           : Application
;Clock frequency        : 1,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega48PA
	#pragma AVRPART MEMORY PROG_FLASH 4096
	#pragma AVRPART MEMORY EEPROM 256
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x02FF
	.EQU __DSTACK_SIZE=0x0080
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _StartUp=R4
	.DEF _i2c_address=R3
	.DEF _last_SR=R6
	.DEF _last_DF=R5
	.DEF _rx_wr_index0=R8
	.DEF _rx_rd_index0=R7
	.DEF _rx_counter0=R10
	.DEF _tx_wr_index0=R9
	.DEF _tx_rd_index0=R12
	.DEF _tx_counter0=R11

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _twi_int_handler
	RJMP 0x00

__4490_def_values:
	.DB  0x87,0xA,0x0,0x0,0x0,0x0,0x82,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
__4493_def_values:
	.DB  0x8F,0x2,0x0,0xFF,0xFF,0x40,0x2,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x43,0x75,0x72,0x72,0x65,0x6E,0x74,0x20
	.DB  0x6D,0x6F,0x64,0x65,0x3A,0x20,0x25,0x69
	.DB  0xA,0x0,0x44,0x69,0x67,0x69,0x74,0x61
	.DB  0x6C,0x20,0x46,0x69,0x6C,0x74,0x65,0x72
	.DB  0x3A,0x20,0x53,0x4C,0x4F,0x57,0x3D,0x25
	.DB  0x69,0x2C,0x20,0x53,0x44,0x3D,0x25,0x69
	.DB  0x2C,0x20,0x53,0x53,0x4C,0x4F,0x57,0x3D
	.DB  0x25,0x69,0xA,0x0
_0x2020003:
	.DB  0x7

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x180

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : DA-03s v2.0 FW v1.00
;Version : 1.00
;Date    : 31.10.2018
;Author  : Maximov Evgeny
;Company : L & Z Audio
;Comments:
;
;
;Chip type               : ATmega48PA
;AVR Core Clock frequency: 1,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*******************************************************/
;
;void Write_To_DAC (unsigned char,unsigned char,unsigned char);
;void SampleRateCheck(unsigned char);
;void ResetChip();
;void DF_Check();
;char getchar(void);
;void putchar(char);
;
;#include <mega48pa.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;
;// Declare your global variables here
;
;unsigned char dac_reg[22];
;
;//unsigned char _4490_dac_reg[10];
;//unsigned char _4493_dac_reg[22];
;
;flash unsigned char _4490_def_values[]={0x87,0xA,0,0,0,0,130,0,0,0,0,0,0,0,0};
;flash unsigned char _4493_def_values[]={143,2,0,255,255,64,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
;
;_Bool StartUp=0;
;unsigned char i2c_address=0;
;
;//_Bool _4493_mode; // hardware define
;//_Bool Scale;      // hardware define
;
;// logick vars
;unsigned char last_SR=0;
;unsigned char last_DF=0;
;
;// GPIO Defines
;#define F0 PIND.3
;#define F1 PIND.2
;#define F2 PINC.3
;#define F3 PINC.2
;#define DSD PIND.6
;#define Scale PIND.3
;#define _4493 PIND.4
;#define DAC_reset PORTB.2
;#define Mute PINB.6
;#define SSLOW PIND.7
;#define SD PINB.0
;#define SLOW PINB.1
;#define Scale_44 PORTC.0
;#define Scale_48 PORTC.1
;
;_Bool _getbit(unsigned char data,unsigned char pos)
; 0000 0046 {

	.CSEG
; 0000 0047     if((1<<pos)&data)
;	data -> Y+1
;	pos -> Y+0
; 0000 0048     {
; 0000 0049         return 1;
; 0000 004A     }
; 0000 004B     else
; 0000 004C     {
; 0000 004D         return 0;
; 0000 004E     }
; 0000 004F }
;
;unsigned char _setbit(unsigned char data, unsigned char pos)
; 0000 0052 {
__setbit:
; .FSTART __setbit
; 0000 0053     return (data | (1<<pos));
	RCALL SUBOPT_0x0
;	data -> Y+1
;	pos -> Y+0
	LDD  R26,Y+1
	OR   R30,R26
	RJMP _0x2080005
; 0000 0054 }
; .FEND
;
;unsigned char _clrbit(unsigned char data, unsigned char pos)
; 0000 0057 {
__clrbit:
; .FSTART __clrbit
; 0000 0058     return (data & ~(1<<pos));
	RCALL SUBOPT_0x0
;	data -> Y+1
;	pos -> Y+0
	COM  R30
	LDD  R26,Y+1
	AND  R30,R26
_0x2080005:
	ADIW R28,2
	RET
; 0000 0059 }
; .FEND
;
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0=0,rx_rd_index0=0;
;#else
;unsigned int rx_wr_index0=0,rx_rd_index0=0;
;#endif
;
;#if RX_BUFFER_SIZE0 < 256
;unsigned char rx_counter0=0;
;#else
;unsigned int rx_counter0=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0077 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0078 char status,data;
; 0000 0079 status=UCSR0A;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 007A data=UDR0;
	LDS  R16,198
; 0000 007B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x5
; 0000 007C    {
; 0000 007D    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 007E #if RX_BUFFER_SIZE0 == 256
; 0000 007F    // special case for receiver buffer size=256
; 0000 0080    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0081 #else
; 0000 0082    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0x6
	CLR  R8
; 0000 0083    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x6:
	INC  R10
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x7
; 0000 0084       {
; 0000 0085       rx_counter0=0;
	CLR  R10
; 0000 0086       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 0087       }
; 0000 0088 #endif
; 0000 0089 
; 0000 008A 
; 0000 008B     if(rx_counter0==2)
_0x7:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xA
; 0000 008C     {
; 0000 008D         //receive 3 bytes
; 0000 008E         switch(rx_buffer0[0])
	LDS  R30,_rx_buffer0
	LDI  R31,0
; 0000 008F         {
; 0000 0090             case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE
; 0000 0091             {
; 0000 0092                 //write to reg
; 0000 0093                 if(_4493)
	SBIS 0x9,4
	RJMP _0xF
; 0000 0094                 {
; 0000 0095                     if(rx_buffer0[1]<22) //check overflow
	__GETB2MN _rx_buffer0,1
	CPI  R26,LOW(0x16)
	BRSH _0x10
; 0000 0096                     {
; 0000 0097                         dac_reg[rx_buffer0[1]]=rx_buffer0[2];
	RCALL SUBOPT_0x1
; 0000 0098                     }
; 0000 0099                 }
_0x10:
; 0000 009A                 else
	RJMP _0x11
_0xF:
; 0000 009B                 {
; 0000 009C                     if(rx_buffer0[1]<10) //check overflow
	__GETB2MN _rx_buffer0,1
	CPI  R26,LOW(0xA)
	BRSH _0x12
; 0000 009D                     {
; 0000 009E                         dac_reg[rx_buffer0[1]]=rx_buffer0[2];
	RCALL SUBOPT_0x1
; 0000 009F                     }
; 0000 00A0                 }
_0x12:
_0x11:
; 0000 00A1 
; 0000 00A2             }
; 0000 00A3             break;
	RJMP _0xD
; 0000 00A4             case 2:
_0xE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD
; 0000 00A5             {
; 0000 00A6                 putchar('@');
	LDI  R26,LOW(64)
	RCALL _putchar
; 0000 00A7                 putchar(dac_reg[rx_buffer0[1]]);
	__GETB1MN _rx_buffer0,1
	RCALL SUBOPT_0x2
	RCALL _putchar
; 0000 00A8             }
; 0000 00A9             break;
; 0000 00AA 
; 0000 00AB         }
_0xD:
; 0000 00AC         rx_counter0=0; //flush buffer
	CLR  R10
; 0000 00AD     }
; 0000 00AE    }
_0xA:
; 0000 00AF }
_0x5:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 00B6 {
; 0000 00B7 char data;
; 0000 00B8 while (rx_counter0==0);
;	data -> R17
; 0000 00B9 data=rx_buffer0[rx_rd_index0++];
; 0000 00BA #if RX_BUFFER_SIZE0 != 256
; 0000 00BB if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 00BC #endif
; 0000 00BD #asm("cli")
; 0000 00BE --rx_counter0;
; 0000 00BF #asm("sei")
; 0000 00C0 return data;
; 0000 00C1 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0=0,tx_rd_index0=0;
;#else
;unsigned int tx_wr_index0=0,tx_rd_index0=0;
;#endif
;
;#if TX_BUFFER_SIZE0 < 256
;unsigned char tx_counter0=0;
;#else
;unsigned int tx_counter0=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 00D7 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D8 if (tx_counter0)
	TST  R11
	BREQ _0x18
; 0000 00D9    {
; 0000 00DA    --tx_counter0;
	DEC  R11
; 0000 00DB    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	STS  198,R30
; 0000 00DC #if TX_BUFFER_SIZE0 != 256
; 0000 00DD    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x19
	CLR  R12
; 0000 00DE #endif
; 0000 00DF    }
_0x19:
; 0000 00E0 }
_0x18:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00E7 {
_putchar:
; .FSTART _putchar
; 0000 00E8 while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0x1A:
	LDI  R30,LOW(8)
	CP   R30,R11
	BREQ _0x1A
; 0000 00E9 #asm("cli")
	cli
; 0000 00EA if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R11
	BRNE _0x1E
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BRNE _0x1D
_0x1E:
; 0000 00EB    {
; 0000 00EC    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00ED #if TX_BUFFER_SIZE0 != 256
; 0000 00EE    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x20
	CLR  R9
; 0000 00EF #endif
; 0000 00F0    ++tx_counter0;
_0x20:
	INC  R11
; 0000 00F1    }
; 0000 00F2 else
	RJMP _0x21
_0x1D:
; 0000 00F3    UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 00F4 #asm("sei")
_0x21:
	sei
; 0000 00F5 }
	RJMP _0x2080004
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// TWI functions
;#include <twi.h>
;
;void main(void)
; 0000 0100 {
_main:
; .FSTART _main
; 0000 0101 // Declare your local variables here
; 0000 0102 
; 0000 0103 // Crystal Oscillator division factor: 1
; 0000 0104 #pragma optsize-
; 0000 0105 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0106 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0107 #ifdef _OPTIMIZE_SIZE_
; 0000 0108 #pragma optsize+
; 0000 0109 #endif
; 0000 010A 
; 0000 010B // Input/Output Ports initialization
; 0000 010C // Port B initialization
; 0000 010D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 010E DDRB=(0<<DDB7) | (1<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(68)
	OUT  0x4,R30
; 0000 010F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=P Bit0=P
; 0000 0110 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(3)
	OUT  0x5,R30
; 0000 0111 
; 0000 0112 // Port C initialization
; 0000 0113 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0114 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
	OUT  0x7,R30
; 0000 0115 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0116 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0117 
; 0000 0118 // Port D initialization
; 0000 0119 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 011A DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0xA,R30
; 0000 011B // State: Bit7=P Bit6=T Bit5=T Bit4=P Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 011C PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(144)
	OUT  0xB,R30
; 0000 011D 
; 0000 011E // Timer/Counter 0 initialization
; 0000 011F // Clock source: System Clock
; 0000 0120 // Clock value: Timer 0 Stopped
; 0000 0121 // Mode: Normal top=0xFF
; 0000 0122 // OC0A output: Disconnected
; 0000 0123 // OC0B output: Disconnected
; 0000 0124 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0125 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 0126 TCNT0=0x00;
	OUT  0x26,R30
; 0000 0127 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0128 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0129 
; 0000 012A // Timer/Counter 1 initialization
; 0000 012B // Clock source: System Clock
; 0000 012C // Clock value: Timer1 Stopped
; 0000 012D // Mode: Normal top=0xFFFF
; 0000 012E // OC1A output: Disconnected
; 0000 012F // OC1B output: Disconnected
; 0000 0130 // Noise Canceler: Off
; 0000 0131 // Input Capture on Falling Edge
; 0000 0132 // Timer1 Overflow Interrupt: Off
; 0000 0133 // Input Capture Interrupt: Off
; 0000 0134 // Compare A Match Interrupt: Off
; 0000 0135 // Compare B Match Interrupt: Off
; 0000 0136 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 0137 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 0138 TCNT1H=0x00;
	STS  133,R30
; 0000 0139 TCNT1L=0x00;
	STS  132,R30
; 0000 013A ICR1H=0x00;
	STS  135,R30
; 0000 013B ICR1L=0x00;
	STS  134,R30
; 0000 013C OCR1AH=0x00;
	STS  137,R30
; 0000 013D OCR1AL=0x00;
	STS  136,R30
; 0000 013E OCR1BH=0x00;
	STS  139,R30
; 0000 013F OCR1BL=0x00;
	STS  138,R30
; 0000 0140 
; 0000 0141 // Timer/Counter 2 initialization
; 0000 0142 // Clock source: System Clock
; 0000 0143 // Clock value: Timer2 Stopped
; 0000 0144 // Mode: Normal top=0xFF
; 0000 0145 // OC2A output: Disconnected
; 0000 0146 // OC2B output: Disconnected
; 0000 0147 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0148 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 0149 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 014A TCNT2=0x00;
	STS  178,R30
; 0000 014B OCR2A=0x00;
	STS  179,R30
; 0000 014C OCR2B=0x00;
	STS  180,R30
; 0000 014D 
; 0000 014E // Timer/Counter 0 Interrupt(s) initialization
; 0000 014F TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 0150 
; 0000 0151 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0152 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 0153 
; 0000 0154 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0155 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 0156 
; 0000 0157 // External Interrupt(s) initialization
; 0000 0158 // INT0: Off
; 0000 0159 // INT1: Off
; 0000 015A // Interrupt on any change on pins PCINT0-7: Off
; 0000 015B // Interrupt on any change on pins PCINT8-14: Off
; 0000 015C // Interrupt on any change on pins PCINT16-23: Off
; 0000 015D EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 015E EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 015F PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 0160 
; 0000 0161 // USART initialization
; 0000 0162 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0163 // USART Receiver: On
; 0000 0164 // USART Transmitter: On
; 0000 0165 // USART0 Mode: Asynchronous
; 0000 0166 // USART Baud Rate: 4800
; 0000 0167 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	STS  192,R30
; 0000 0168 UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	STS  193,R30
; 0000 0169 UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 016A UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 016B UBRR0L=0x0C;
	LDI  R30,LOW(12)
	STS  196,R30
; 0000 016C 
; 0000 016D // Analog Comparator initialization
; 0000 016E // Analog Comparator: Off
; 0000 016F // The Analog Comparator's positive input is
; 0000 0170 // connected to the AIN0 pin
; 0000 0171 // The Analog Comparator's negative input is
; 0000 0172 // connected to the AIN1 pin
; 0000 0173 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0174 ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0175 // Digital input buffer on AIN0: On
; 0000 0176 // Digital input buffer on AIN1: On
; 0000 0177 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 0178 
; 0000 0179 // ADC initialization
; 0000 017A // ADC disabled
; 0000 017B ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 017C 
; 0000 017D // SPI initialization
; 0000 017E // SPI disabled
; 0000 017F SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0180 
; 0000 0181 // TWI initialization
; 0000 0182 // Mode: TWI Master
; 0000 0183 // Bit Rate: 62 kHz
; 0000 0184 twi_master_init(62);
	LDI  R26,LOW(62)
	LDI  R27,0
	RCALL _twi_master_init
; 0000 0185 
; 0000 0186 // Global enable interrupts
; 0000 0187 #asm("sei")
	sei
; 0000 0188 
; 0000 0189 while (1)
_0x22:
; 0000 018A       {
; 0000 018B       // Place your code here
; 0000 018C         if(!StartUp)
	TST  R4
	BRNE _0x25
; 0000 018D         {
; 0000 018E             // first start up
; 0000 018F 
; 0000 0190             // unreset
; 0000 0191             Mute=1;
	SBI  0x3,6
; 0000 0192             delay_ms(100);
	RCALL SUBOPT_0x3
; 0000 0193             DAC_reset=1;
	SBI  0x5,2
; 0000 0194             delay_ms(100);
	RCALL SUBOPT_0x3
; 0000 0195 
; 0000 0196             if(!_4493)
	SBIC 0x9,4
	RJMP _0x2A
; 0000 0197             {
; 0000 0198                 // 4493 mode
; 0000 0199                 char i=0;
; 0000 019A                 for(i=0;i<22;i++)
	RCALL SUBOPT_0x4
;	i -> Y+0
_0x2C:
	LD   R26,Y
	CPI  R26,LOW(0x16)
	BRSH _0x2D
; 0000 019B                 {
; 0000 019C                     // write default values to dac
; 0000 019D                     dac_reg[i]=_4493_def_values[i];
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-__4493_def_values*2)
	SBCI R31,HIGH(-__4493_def_values*2)
	RCALL SUBOPT_0x6
; 0000 019E                     Write_To_DAC(i2c_address,i,dac_reg[i]);
	RCALL _Write_To_DAC
; 0000 019F                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x2C
_0x2D:
; 0000 01A0             }
	RJMP _0x6B
; 0000 01A1             else
_0x2A:
; 0000 01A2             {
; 0000 01A3                 // 4490 mode
; 0000 01A4                 char i=0;
; 0000 01A5                 for(i=0;i<10;i++)
	RCALL SUBOPT_0x4
;	i -> Y+0
_0x30:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRSH _0x31
; 0000 01A6                 {
; 0000 01A7                     // write default values to dac
; 0000 01A8                     dac_reg[i]=_4490_def_values[i];
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-__4490_def_values*2)
	SBCI R31,HIGH(-__4490_def_values*2)
	RCALL SUBOPT_0x6
; 0000 01A9                     Write_To_DAC(i2c_address,i,dac_reg[i]);
	RCALL _Write_To_DAC
; 0000 01AA                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x30
_0x31:
; 0000 01AB             }
_0x6B:
	ADIW R28,1
; 0000 01AC 
; 0000 01AD             delay_ms(100);
	RCALL SUBOPT_0x3
; 0000 01AE             StartUp=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 01AF             ResetChip();
	RCALL _ResetChip
; 0000 01B0             Mute=0;
	CBI  0x3,6
; 0000 01B1         }
; 0000 01B2         else
	RJMP _0x34
_0x25:
; 0000 01B3         {
; 0000 01B4             // normal work
; 0000 01B5             unsigned char _SR=1*F0+2*F1+4*F2+8*F3; //calculate current mode
; 0000 01B6             unsigned char _DF=SSLOW*1+SD*2+SLOW*4;
; 0000 01B7 
; 0000 01B8             // Samplerate check
; 0000 01B9             if(_SR!=last_SR)
	SBIW R28,2
;	_SR -> Y+1
;	_DF -> Y+0
	LDI  R26,0
	SBIC 0x9,3
	LDI  R26,1
	LDI  R30,0
	SBIC 0x9,2
	LDI  R30,1
	LSL  R30
	ADD  R26,R30
	LDI  R30,0
	SBIC 0x6,3
	LDI  R30,1
	LSL  R30
	LSL  R30
	ADD  R26,R30
	LDI  R30,0
	SBIC 0x6,2
	LDI  R30,1
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R30,R26
	STD  Y+1,R30
	LDI  R26,0
	SBIC 0x9,7
	LDI  R26,1
	LDI  R30,LOW(1)
	MUL  R30,R26
	MOV  R22,R0
	LDI  R26,0
	SBIC 0x3,0
	LDI  R26,1
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R22,R30
	LDI  R26,0
	SBIC 0x3,1
	LDI  R26,1
	LDI  R30,LOW(4)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R22
	ST   Y,R30
	LDD  R26,Y+1
	CP   R6,R26
	BREQ _0x35
; 0000 01BA             {
; 0000 01BB                 Mute=1;
	SBI  0x3,6
; 0000 01BC                 SampleRateCheck(_SR);
	RCALL _SampleRateCheck
; 0000 01BD                 last_SR=_SR;
	LDD  R6,Y+1
; 0000 01BE                 if(!_4493)
	SBIC 0x9,4
	RJMP _0x38
; 0000 01BF                 {
; 0000 01C0                     // strong check unsupported mode:
; 0000 01C1                     // AK4490 does not support DSD512 mode
; 0000 01C2                     if(_SR>11)
	LDD  R26,Y+1
	CPI  R26,LOW(0xC)
	BRLO _0x39
; 0000 01C3                     {
; 0000 01C4                         Mute=1;
	SBI  0x3,6
; 0000 01C5                     }
; 0000 01C6                     else
	RJMP _0x3C
_0x39:
; 0000 01C7                     {
; 0000 01C8                         Mute=0;
	CBI  0x3,6
; 0000 01C9                     }
_0x3C:
; 0000 01CA                 }
; 0000 01CB                 else
	RJMP _0x3F
_0x38:
; 0000 01CC                 {
; 0000 01CD                     Mute=0;
	CBI  0x3,6
; 0000 01CE                 }
_0x3F:
; 0000 01CF                 printf("Current mode: %i\n", _SR);
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x7
	LDD  R30,Y+3
	RCALL SUBOPT_0x8
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 01D0             };
_0x35:
; 0000 01D1 
; 0000 01D2 
; 0000 01D3             if(_DF!=last_DF)
	LD   R26,Y
	CP   R5,R26
	BREQ _0x42
; 0000 01D4             {
; 0000 01D5                 Mute=1;
	SBI  0x3,6
; 0000 01D6                 DF_Check();
	RCALL _DF_Check
; 0000 01D7                 ResetChip();
	RCALL _ResetChip
; 0000 01D8                 Mute=0;
	CBI  0x3,6
; 0000 01D9                 last_DF=_DF;
	LDD  R5,Y+0
; 0000 01DA                 printf("Digital Filter: SLOW=%i, SD=%i, SSLOW=%i\n",SLOW,SD,SSLOW);
	__POINTW1FN _0x0,18
	RCALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x3,1
	LDI  R30,1
	RCALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x3,0
	LDI  R30,1
	RCALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x9,7
	LDI  R30,1
	RCALL SUBOPT_0x8
	LDI  R24,12
	RCALL _printf
	ADIW R28,14
; 0000 01DB             }
; 0000 01DC         }
_0x42:
	ADIW R28,2
_0x34:
; 0000 01DD       }
	RJMP _0x22
; 0000 01DE }
_0x47:
	RJMP _0x47
; .FEND
;
;void Write_To_DAC(unsigned char chip_address, unsigned char address, unsigned char data)
; 0000 01E1 {
_Write_To_DAC:
; .FSTART _Write_To_DAC
; 0000 01E2     struct _data
; 0000 01E3     {
; 0000 01E4         unsigned char msb;
; 0000 01E5         unsigned char lsb;
; 0000 01E6         unsigned char data;
; 0000 01E7     } DAC_REG;
; 0000 01E8     DAC_REG.msb=0x0;
	ST   -Y,R26
	SBIW R28,3
;	chip_address -> Y+5
;	address -> Y+4
;	data -> Y+3
;	_data -> Y+3
;	DAC_REG -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 01E9     DAC_REG.lsb=address;
	LDD  R30,Y+4
	STD  Y+1,R30
; 0000 01EA     DAC_REG.data=data;
	LDD  R30,Y+3
	STD  Y+2,R30
; 0000 01EB     twi_master_trans(chip_address,(unsigned char*)&DAC_REG,3,0,0);
	LDD  R30,Y+5
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,1
	RCALL SUBOPT_0x7
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x7
	LDI  R26,LOW(0)
	RCALL _twi_master_trans
; 0000 01EC     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01ED }
	ADIW R28,6
	RET
; .FEND
;
;void SampleRateCheck(unsigned char mode)
; 0000 01F0 {
_SampleRateCheck:
; .FSTART _SampleRateCheck
; 0000 01F1     if(mode<9)
	ST   -Y,R26
;	mode -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x48
; 0000 01F2     {
; 0000 01F3         // clear DP bit
; 0000 01F4         _clrbit(dac_reg[2],7);
	RCALL SUBOPT_0x9
	RCALL __clrbit
; 0000 01F5         Write_To_DAC(i2c_address,2,dac_reg[2]);
	RCALL SUBOPT_0xA
; 0000 01F6         //pcm mode
; 0000 01F7         if(F0==1)
	SBIS 0x9,3
	RJMP _0x49
; 0000 01F8         {
; 0000 01F9             // 44.1 kHz MCLK mode
; 0000 01FA             Scale_44=0;
	CBI  0x8,0
; 0000 01FB             Scale_48=1;
	SBI  0x8,1
; 0000 01FC         }
; 0000 01FD         else
	RJMP _0x4E
_0x49:
; 0000 01FE         {
; 0000 01FF             // 48 kHz MCLK Mode
; 0000 0200             Scale_44=1;
	SBI  0x8,0
; 0000 0201             Scale_48=0;
	CBI  0x8,1
; 0000 0202         };
_0x4E:
; 0000 0203         ResetChip();
	RJMP _0x6C
; 0000 0204     }
; 0000 0205     else
_0x48:
; 0000 0206     {
; 0000 0207         // dsd mode
; 0000 0208         if(Scale)
	SBIS 0x9,3
	RJMP _0x54
; 0000 0209         {
; 0000 020A             // 44.1 kHz MCLK mode
; 0000 020B             Scale_44=0;
	CBI  0x8,0
; 0000 020C             Scale_48=1;
	SBI  0x8,1
; 0000 020D         }
; 0000 020E         else
	RJMP _0x59
_0x54:
; 0000 020F         {
; 0000 0210             // 48 kHz MCLK Mode
; 0000 0211             Scale_44=1;
	SBI  0x8,0
; 0000 0212             Scale_48=0;
	CBI  0x8,1
; 0000 0213         };
_0x59:
; 0000 0214 
; 0000 0215         // set DP bit
; 0000 0216         _setbit(dac_reg[2],7);
	RCALL SUBOPT_0x9
	RCALL __setbit
; 0000 0217 
; 0000 0218         switch(mode)
	LD   R30,Y
	LDI  R31,0
; 0000 0219         {
; 0000 021A             case 9:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x61
; 0000 021B             {
; 0000 021C                 //DSD64 Mode
; 0000 021D                 // set DSD mode
; 0000 021E                 // DSDSEL0
; 0000 021F                 _clrbit(dac_reg[6],0);
	RCALL SUBOPT_0xB
	RCALL __clrbit
; 0000 0220                 // DSDSEL1
; 0000 0221                 _clrbit(dac_reg[9],0);
	RCALL SUBOPT_0xC
; 0000 0222                 // write to DAC
; 0000 0223             }
; 0000 0224             break;
	RJMP _0x60
; 0000 0225             case 10:
_0x61:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x62
; 0000 0226             {
; 0000 0227                 //DSD128 Mode
; 0000 0228                 // set DSD mode
; 0000 0229                 // DSDSEL0
; 0000 022A                 _setbit(dac_reg[6],0);
	RCALL SUBOPT_0xB
	RCALL __setbit
; 0000 022B                 // DSDSEL1
; 0000 022C                 _clrbit(dac_reg[9],0);
	RCALL SUBOPT_0xC
; 0000 022D                 // write to DAC
; 0000 022E             }
; 0000 022F             break;
	RJMP _0x60
; 0000 0230             case 11:
_0x62:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x63
; 0000 0231             {
; 0000 0232                 //DSD256 Mode
; 0000 0233                 // set DP bit
; 0000 0234                 _setbit(dac_reg[2],7);
	RCALL SUBOPT_0x9
	RCALL __setbit
; 0000 0235                 // set DSD mode
; 0000 0236                 // DSDSEL0
; 0000 0237                 _clrbit(dac_reg[6],0);
	RCALL SUBOPT_0xB
	RCALL __clrbit
; 0000 0238                 // DSDSEL1
; 0000 0239                 _setbit(dac_reg[9],0);
	RJMP _0x6D
; 0000 023A                 // write to DAC
; 0000 023B             }
; 0000 023C             break;
; 0000 023D             case 12:
_0x63:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x60
; 0000 023E             {
; 0000 023F                 //DSD512 Mode
; 0000 0240                 // set DSD mode
; 0000 0241                 // DSDSEL0
; 0000 0242                 _setbit(dac_reg[6],0);
	RCALL SUBOPT_0xB
	RCALL __setbit
; 0000 0243                 // DSDSEL1
; 0000 0244                 _setbit(dac_reg[9],0);
_0x6D:
	__GETB1MN _dac_reg,9
	RCALL SUBOPT_0xD
	RCALL __setbit
; 0000 0245                 // write to DAC
; 0000 0246             }
; 0000 0247             break;
; 0000 0248 
; 0000 0249         };
_0x60:
; 0000 024A         Write_To_DAC(i2c_address,2,dac_reg[2]);
	RCALL SUBOPT_0xA
; 0000 024B         Write_To_DAC(i2c_address,6,dac_reg[6]);
	ST   -Y,R3
	LDI  R30,LOW(6)
	ST   -Y,R30
	__GETB2MN _dac_reg,6
	RCALL _Write_To_DAC
; 0000 024C         Write_To_DAC(i2c_address,9,dac_reg[9]);
	ST   -Y,R3
	LDI  R30,LOW(9)
	ST   -Y,R30
	__GETB2MN _dac_reg,9
	RCALL _Write_To_DAC
; 0000 024D         ResetChip();
_0x6C:
	RCALL _ResetChip
; 0000 024E     }
; 0000 024F }
_0x2080004:
	ADIW R28,1
	RET
; .FEND
;
;void ResetChip()
; 0000 0252 {
_ResetChip:
; .FSTART _ResetChip
; 0000 0253     //reset chip
; 0000 0254     _clrbit(dac_reg[0],0);
	LDS  R30,_dac_reg
	RCALL SUBOPT_0xD
	RCALL __clrbit
; 0000 0255     Write_To_DAC(i2c_address,0,dac_reg[0]);
	RCALL SUBOPT_0xE
; 0000 0256     delay_ms(10);
; 0000 0257     _setbit(dac_reg[0],0);
	LDS  R30,_dac_reg
	RCALL SUBOPT_0xD
	RCALL __setbit
; 0000 0258     Write_To_DAC(i2c_address,0,dac_reg[0]);
	RCALL SUBOPT_0xE
; 0000 0259     delay_ms(10);
; 0000 025A }
	RET
; .FEND
;
;void DF_Check()
; 0000 025D {
_DF_Check:
; .FSTART _DF_Check
; 0000 025E     if(SSLOW)
	SBIS 0x9,7
	RJMP _0x65
; 0000 025F     {
; 0000 0260         _setbit(dac_reg[5],0);
	__GETB1MN _dac_reg,5
	RCALL SUBOPT_0xD
	RCALL __setbit
; 0000 0261     }
; 0000 0262     else
	RJMP _0x66
_0x65:
; 0000 0263     {
; 0000 0264         _clrbit(dac_reg[5],0);
	__GETB1MN _dac_reg,5
	RCALL SUBOPT_0xD
	RCALL __clrbit
; 0000 0265     }
_0x66:
; 0000 0266 
; 0000 0267     if(SD)
	SBIS 0x3,0
	RJMP _0x67
; 0000 0268     {
; 0000 0269         _setbit(dac_reg[1],5);
	RCALL SUBOPT_0xF
	RCALL __setbit
; 0000 026A     }
; 0000 026B     else
	RJMP _0x68
_0x67:
; 0000 026C     {
; 0000 026D         _clrbit(dac_reg[1],5);
	RCALL SUBOPT_0xF
	RCALL __clrbit
; 0000 026E     }
_0x68:
; 0000 026F     if(SLOW)
	SBIS 0x3,1
	RJMP _0x69
; 0000 0270     {
; 0000 0271         _setbit(dac_reg[2],0);
	__GETB1MN _dac_reg,2
	RCALL SUBOPT_0xD
	RCALL __setbit
; 0000 0272     }
; 0000 0273     else
	RJMP _0x6A
_0x69:
; 0000 0274     {
; 0000 0275         _clrbit(dac_reg[2],0);
	__GETB1MN _dac_reg,2
	RCALL SUBOPT_0xD
	RCALL __clrbit
; 0000 0276     }
_0x6A:
; 0000 0277     Write_To_DAC(i2c_address,1,dac_reg[1]);
	ST   -Y,R3
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETB2MN _dac_reg,1
	RCALL _Write_To_DAC
; 0000 0278     Write_To_DAC(i2c_address,2,dac_reg[2]);
	RCALL SUBOPT_0xA
; 0000 0279     Write_To_DAC(i2c_address,5,dac_reg[5]);
	ST   -Y,R3
	LDI  R30,LOW(5)
	ST   -Y,R30
	__GETB2MN _dac_reg,5
	RCALL _Write_To_DAC
; 0000 027A     ResetChip();
	RCALL _ResetChip
; 0000 027B }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_usart_G100:
; .FSTART _put_usart_G100
	RCALL SUBOPT_0x10
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x2080003
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x10
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x11
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x11
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x12
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x14
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x17
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x17
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x18
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x18
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x11
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x17
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x17
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x14
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x7
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
_twi_master_init:
; .FSTART _twi_master_init
	RCALL SUBOPT_0x10
	ST   -Y,R17
	SBI  0x1E,2
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDI  R30,LOW(0)
	STS  _twi_slave_rx_handler_G101,R30
	STS  _twi_slave_rx_handler_G101+1,R30
	STS  _twi_slave_tx_handler_G101,R30
	STS  _twi_slave_tx_handler_G101+1,R30
	SBI  0x8,4
	SBI  0x8,5
	STS  188,R30
	LDS  R30,185
	ANDI R30,LOW(0xFC)
	STS  185,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL __DIVW21U
	MOV  R17,R30
	CPI  R17,8
	BRLO _0x2020006
	SUBI R17,LOW(8)
_0x2020006:
	STS  184,R17
	LDS  R30,188
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	STS  188,R30
	LDD  R17,Y+0
_0x2080003:
	ADIW R28,3
	RET
; .FEND
_twi_master_trans:
; .FSTART _twi_master_trans
	ST   -Y,R26
	SBIW R28,4
	SBIS 0x1E,2
	RJMP _0x2020007
	LDD  R30,Y+10
	LSL  R30
	STS  _slave_address_G101,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STS  _twi_tx_buffer_G101,R30
	STS  _twi_tx_buffer_G101+1,R31
	LDI  R30,LOW(0)
	STS  _twi_tx_index,R30
	LDD  R30,Y+7
	STS  _bytes_to_tx_G101,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	STS  _twi_rx_buffer_G101,R30
	STS  _twi_rx_buffer_G101+1,R31
	LDI  R30,LOW(0)
	STS  _twi_rx_index,R30
	LDD  R30,Y+4
	STS  _bytes_to_rx_G101,R30
	LDI  R30,LOW(6)
	STS  _twi_result,R30
	sei
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x2020008
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x2080002
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x202000B
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,0
	BREQ _0x202000C
_0x202000B:
	RJMP _0x202000A
_0x202000C:
	RJMP _0x2080002
_0x202000A:
	SBI  0x1E,1
	RJMP _0x202000F
_0x2020008:
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x2020010
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SBIW R30,0
	BREQ _0x2080002
	LDS  R30,_slave_address_G101
	ORI  R30,1
	STS  _slave_address_G101,R30
	CBI  0x1E,1
_0x202000F:
	CBI  0x1E,2
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	__GETD1N 0x7A120
	RCALL SUBOPT_0x19
_0x2020016:
	SBIC 0x1E,2
	RJMP _0x2020018
	RCALL __GETD1S0
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	RCALL SUBOPT_0x19
	BRNE _0x2020019
	LDI  R30,LOW(5)
	STS  _twi_result,R30
	SBI  0x1E,2
	RJMP _0x2080002
_0x2020019:
	RJMP _0x2020016
_0x2020018:
_0x2020010:
	LDS  R26,_twi_result
	LDI  R30,LOW(0)
	RCALL __EQB12
	RJMP _0x2080001
_0x2020007:
_0x2080002:
	LDI  R30,LOW(0)
_0x2080001:
	ADIW R28,11
	RET
; .FEND
_twi_int_handler:
; .FSTART _twi_int_handler
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RCALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G101
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G101
	LDS  R27,_twi_rx_buffer_G101+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2020023
	LDI  R18,LOW(0)
	RJMP _0x2020024
_0x2020023:
	CPI  R30,LOW(0x10)
	BRNE _0x2020025
_0x2020024:
	LDS  R30,_slave_address_G101
	RJMP _0x2020080
_0x2020025:
	CPI  R30,LOW(0x18)
	BREQ _0x2020029
	CPI  R30,LOW(0x28)
	BRNE _0x202002A
_0x2020029:
	CP   R16,R19
	BRSH _0x202002B
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G101
	LDS  R27,_twi_tx_buffer_G101+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2020080:
	STS  187,R30
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x202002C
_0x202002B:
	LDS  R30,_bytes_to_rx_G101
	CP   R17,R30
	BRSH _0x202002D
	LDS  R30,_slave_address_G101
	ORI  R30,1
	STS  _slave_address_G101,R30
	CBI  0x1E,1
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	RJMP _0x2020022
_0x202002D:
	RJMP _0x2020030
_0x202002C:
	RJMP _0x2020022
_0x202002A:
	CPI  R30,LOW(0x50)
	BRNE _0x2020031
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2020032
_0x2020031:
	CPI  R30,LOW(0x40)
	BRNE _0x2020033
_0x2020032:
	LDS  R30,_bytes_to_rx_G101
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2020034
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2020081
_0x2020034:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2020081:
	STS  188,R30
	RJMP _0x2020022
_0x2020033:
	CPI  R30,LOW(0x58)
	BRNE _0x2020036
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2020037
_0x2020036:
	CPI  R30,LOW(0x20)
	BRNE _0x2020038
_0x2020037:
	RJMP _0x2020039
_0x2020038:
	CPI  R30,LOW(0x30)
	BRNE _0x202003A
_0x2020039:
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x48)
	BRNE _0x202003C
_0x202003B:
	CPI  R18,0
	BRNE _0x202003D
	SBIS 0x1E,1
	RJMP _0x202003E
	CP   R16,R19
	BRLO _0x2020040
	RJMP _0x2020041
_0x202003E:
	LDS  R30,_bytes_to_rx_G101
	CP   R17,R30
	BRSH _0x2020042
_0x2020040:
	LDI  R18,LOW(4)
_0x2020042:
_0x2020041:
_0x202003D:
_0x2020030:
	RJMP _0x2020082
_0x202003C:
	CPI  R30,LOW(0x38)
	BRNE _0x2020045
	LDI  R18,LOW(2)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2020083
_0x2020045:
	CPI  R30,LOW(0x68)
	BREQ _0x2020048
	CPI  R30,LOW(0x78)
	BRNE _0x2020049
_0x2020048:
	LDI  R18,LOW(2)
	RJMP _0x202004A
_0x2020049:
	CPI  R30,LOW(0x60)
	BREQ _0x202004D
	CPI  R30,LOW(0x70)
	BRNE _0x202004E
_0x202004D:
	LDI  R18,LOW(0)
_0x202004A:
	LDI  R17,LOW(0)
	CBI  0x1E,1
	LDS  R30,_twi_rx_buffer_size_G101
	CPI  R30,0
	BRNE _0x2020051
	LDI  R18,LOW(1)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2020084
_0x2020051:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2020084:
	STS  188,R30
	RJMP _0x2020022
_0x202004E:
	CPI  R30,LOW(0x80)
	BREQ _0x2020054
	CPI  R30,LOW(0x90)
	BRNE _0x2020055
_0x2020054:
	SBIS 0x1E,1
	RJMP _0x2020056
	LDI  R18,LOW(1)
	RJMP _0x2020057
_0x2020056:
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G101
	CP   R17,R30
	BRSH _0x2020058
	LDS  R30,_twi_slave_rx_handler_G101
	LDS  R31,_twi_slave_rx_handler_G101+1
	SBIW R30,0
	BRNE _0x2020059
	LDI  R18,LOW(6)
	RJMP _0x2020057
_0x2020059:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G101,0
	CPI  R30,0
	BREQ _0x202005A
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	RJMP _0x2020022
_0x202005A:
	RJMP _0x202005B
_0x2020058:
	SBI  0x1E,1
_0x202005B:
	RJMP _0x202005E
_0x2020055:
	CPI  R30,LOW(0x88)
	BRNE _0x202005F
_0x202005E:
	RJMP _0x2020060
_0x202005F:
	CPI  R30,LOW(0x98)
	BRNE _0x2020061
_0x2020060:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2020022
_0x2020061:
	CPI  R30,LOW(0xA0)
	BRNE _0x2020062
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	SBI  0x1E,2
	LDS  R30,_twi_slave_rx_handler_G101
	LDS  R31,_twi_slave_rx_handler_G101+1
	SBIW R30,0
	BREQ _0x2020065
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G101,0
	RJMP _0x2020066
_0x2020065:
	LDI  R18,LOW(6)
_0x2020066:
	RJMP _0x2020022
_0x2020062:
	CPI  R30,LOW(0xB0)
	BRNE _0x2020067
	LDI  R18,LOW(2)
	RJMP _0x2020068
_0x2020067:
	CPI  R30,LOW(0xA8)
	BRNE _0x2020069
_0x2020068:
	LDS  R30,_twi_slave_tx_handler_G101
	LDS  R31,_twi_slave_tx_handler_G101+1
	SBIW R30,0
	BREQ _0x202006A
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G101,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x202006C
	LDI  R18,LOW(0)
	RJMP _0x202006D
_0x202006A:
_0x202006C:
	LDI  R18,LOW(6)
	RJMP _0x2020057
_0x202006D:
	LDI  R16,LOW(0)
	CBI  0x1E,1
	RJMP _0x2020070
_0x2020069:
	CPI  R30,LOW(0xB8)
	BRNE _0x2020071
_0x2020070:
	SBIS 0x1E,1
	RJMP _0x2020072
	LDI  R18,LOW(1)
	RJMP _0x2020057
_0x2020072:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G101
	LDS  R27,_twi_tx_buffer_G101+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  187,R30
	CP   R16,R19
	BRSH _0x2020073
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x2020085
_0x2020073:
	SBI  0x1E,1
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x2020085:
	STS  188,R30
	RJMP _0x2020022
_0x2020071:
	CPI  R30,LOW(0xC0)
	BREQ _0x2020078
	CPI  R30,LOW(0xC8)
	BRNE _0x2020079
_0x2020078:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	LDS  R30,_twi_slave_tx_handler_G101
	LDS  R31,_twi_slave_tx_handler_G101+1
	SBIW R30,0
	BREQ _0x202007A
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G101,0
_0x202007A:
	RJMP _0x2020043
_0x2020079:
	CPI  R30,0
	BRNE _0x2020022
	LDI  R18,LOW(3)
_0x2020057:
_0x2020082:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x2020083:
	STS  188,R30
_0x2020043:
	SBI  0x1E,2
_0x2020022:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G101,R19
	RCALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x10
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x10
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_dac_reg:
	.BYTE 0x16
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
_slave_address_G101:
	.BYTE 0x1
_twi_tx_buffer_G101:
	.BYTE 0x2
_bytes_to_tx_G101:
	.BYTE 0x1
_twi_rx_buffer_G101:
	.BYTE 0x2
_bytes_to_rx_G101:
	.BYTE 0x1
_twi_rx_buffer_size_G101:
	.BYTE 0x1
_twi_slave_rx_handler_G101:
	.BYTE 0x2
_twi_slave_tx_handler_G101:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	LD   R30,Y
	LDI  R26,LOW(1)
	RCALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	__GETB1MN _rx_buffer0,1
	LDI  R31,0
	SUBI R30,LOW(-_dac_reg)
	SBCI R31,HIGH(-_dac_reg)
	__GETB2MN _rx_buffer0,2
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R31,0
	SUBI R30,LOW(-_dac_reg)
	SBCI R31,HIGH(-_dac_reg)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(100)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_dac_reg)
	SBCI R27,HIGH(-_dac_reg)
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LPM  R30,Z
	ST   X,R30
	ST   -Y,R3
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+2
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	__GETB1MN _dac_reg,2
	ST   -Y,R30
	LDI  R26,LOW(7)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	ST   -Y,R3
	LDI  R30,LOW(2)
	ST   -Y,R30
	__GETB2MN _dac_reg,2
	RJMP _Write_To_DAC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	__GETB1MN _dac_reg,6
	ST   -Y,R30
	LDI  R26,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	__GETB1MN _dac_reg,9
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP __clrbit

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	ST   -Y,R3
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,_dac_reg
	RCALL _Write_To_DAC
	LDI  R26,LOW(10)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__GETB1MN _dac_reg,1
	ST   -Y,R30
	LDI  R26,LOW(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x11:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x12
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	RCALL __PUTD1S0
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
