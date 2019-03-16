
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
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
	.DEF _j=R3
	.DEF _j_msb=R4
	.DEF _c=R6
	.DEF _StartUp=R5
	.DEF _i2c_address=R8
	.DEF _last_SR=R7
	.DEF _last_DF=R10
	.DEF _last_mute=R9
	.DEF _rx_wr_index0=R12
	.DEF _rx_rd_index0=R11
	.DEF _rx_counter0=R14
	.DEF _tx_wr_index0=R13

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
	.DB  0x8F,0xA,0x0,0xFF,0xFF,0x80,0x82,0x0
	.DB  0x0,0x0,0x0
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
	.DB  0xFF,0x10,0xFF,0xFF
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x34,0x34,0x39,0x30,0x20,0x6D,0x6F,0x64
	.DB  0x65,0xA,0xD,0x0,0x43,0x75,0x72,0x72
	.DB  0x65,0x6E,0x74,0x20,0x6D,0x6F,0x64,0x65
	.DB  0x3A,0x20,0x25,0x69,0xA,0xD,0x0,0x44
	.DB  0x69,0x67,0x69,0x74,0x61,0x6C,0x20,0x46
	.DB  0x69,0x6C,0x74,0x65,0x72,0x3A,0x20,0x53
	.DB  0x4C,0x4F,0x57,0x3D,0x25,0x69,0x2C,0x20
	.DB  0x53,0x44,0x3D,0x25,0x69,0x2C,0x20,0x53
	.DB  0x53,0x4C,0x4F,0x57,0x3D,0x25,0x69,0xA
	.DB  0xD,0x0,0x77,0x72,0x69,0x74,0x65,0x20
	.DB  0x65,0x72,0x72,0x6F,0x72,0x21,0xA,0xD
	.DB  0x0,0x65,0x72,0x72,0x6F,0x72,0x20,0x63
	.DB  0x6F,0x6E,0x74,0x72,0x6F,0x6C,0xA,0xD
	.DB  0x0,0x44,0x53,0x44,0xA,0xD,0x0,0x50
	.DB  0x43,0x4D,0xA,0xD,0x0,0x34,0x34,0x2E
	.DB  0x31,0x20,0x6B,0x48,0x7A,0xA,0xD,0x0
	.DB  0x34,0x38,0x20,0x6B,0x48,0x7A,0xA,0xD
	.DB  0x0,0x36,0x3D,0x25,0x58,0x2C,0x39,0x3D
	.DB  0x25,0x58,0xD,0xA,0x0
_0x2020003:
	.DB  0x7

__GLOBAL_INI_TBL:
	.DW  0x0C
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
;
;void Write_To_DAC (unsigned char,unsigned char,unsigned char);
;void SampleRateCheck(unsigned char);
;void ResetChip();
;void DF_Check();
;char getchar(void);
;void putchar(char);
;void SW_Mute(unsigned char mute);
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
;char buff[10];
;int j=0;
;char c=0;
;//unsigned char _4490_dac_reg[10];
;//unsigned char _4493_dac_reg[22];
;
;//flash unsigned char _4490_def_values[]={0x87,0xA,0,128,128,0,130,0,0,0,0,0,0,0,0};
;flash unsigned char _4490_def_values[]={0x8F,0xA,0,0xff,0xff,0x80,130,0,0,0,0};
;flash unsigned char _4493_def_values[]={143,2,0,255,255,64,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
;
;_Bool StartUp=0;
;unsigned char i2c_address=16;
;
;// logic vars
;unsigned char last_SR=255;
;unsigned char last_DF=255;
;unsigned char last_mute=255;
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
; 0000 0033 {

	.CSEG
; 0000 0034     if((1<<pos)&data)
;	data -> Y+1
;	pos -> Y+0
; 0000 0035     {
; 0000 0036         return 1;
; 0000 0037     }
; 0000 0038     else
; 0000 0039     {
; 0000 003A         return 0;
; 0000 003B     }
; 0000 003C }
;
;unsigned char _setbit(unsigned char data, unsigned char pos)
; 0000 003F {
__setbit:
; .FSTART __setbit
; 0000 0040     return (data | (1<<pos));
	RCALL SUBOPT_0x0
;	data -> Y+1
;	pos -> Y+0
	LDD  R26,Y+1
	OR   R30,R26
	RJMP _0x2080005
; 0000 0041 }
; .FEND
;
;unsigned char _clrbit(unsigned char data, unsigned char pos)
; 0000 0044 {
__clrbit:
; .FSTART __clrbit
; 0000 0045     return (data & ~(1<<pos));
	RCALL SUBOPT_0x0
;	data -> Y+1
;	pos -> Y+0
	COM  R30
	LDD  R26,Y+1
	AND  R30,R26
_0x2080005:
	ADIW R28,2
	RET
; 0000 0046 }
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
; 0000 0064 {
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
; 0000 0065 char status,data;
; 0000 0066 status=UCSR0A;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0067 data=UDR0;
	LDS  R16,198
; 0000 0068 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x5
; 0000 0069    {
; 0000 006A    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 006B #if RX_BUFFER_SIZE0 == 256
; 0000 006C    // special case for receiver buffer size=256
; 0000 006D    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 006E #else
; 0000 006F    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x6
	CLR  R12
; 0000 0070    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x6:
	INC  R14
	LDI  R30,LOW(8)
	CP   R30,R14
	BRNE _0x7
; 0000 0071       {
; 0000 0072       rx_counter0=0;
	CLR  R14
; 0000 0073       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 0074       }
; 0000 0075 #endif
; 0000 0076 
; 0000 0077 
; 0000 0078     if(rx_counter0==2)
_0x7:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0xA
; 0000 0079     {
; 0000 007A         //receive 3 bytes
; 0000 007B         switch(rx_buffer0[0])
	LDS  R30,_rx_buffer0
	LDI  R31,0
; 0000 007C         {
; 0000 007D             case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE
; 0000 007E             {
; 0000 007F                 //write to reg
; 0000 0080                 if(_4493)
	SBIS 0x9,4
	RJMP _0xF
; 0000 0081                 {
; 0000 0082                     if(rx_buffer0[1]<22) //check overflow
	__GETB2MN _rx_buffer0,1
	CPI  R26,LOW(0x16)
	BRSH _0x10
; 0000 0083                     {
; 0000 0084                         dac_reg[rx_buffer0[1]]=rx_buffer0[2];
	RCALL SUBOPT_0x1
; 0000 0085                     }
; 0000 0086                 }
_0x10:
; 0000 0087                 else
	RJMP _0x11
_0xF:
; 0000 0088                 {
; 0000 0089                     if(rx_buffer0[1]<10) //check overflow
	__GETB2MN _rx_buffer0,1
	CPI  R26,LOW(0xA)
	BRSH _0x12
; 0000 008A                     {
; 0000 008B                         dac_reg[rx_buffer0[1]]=rx_buffer0[2];
	RCALL SUBOPT_0x1
; 0000 008C                     }
; 0000 008D                 }
_0x12:
_0x11:
; 0000 008E 
; 0000 008F             }
; 0000 0090             break;
	RJMP _0xD
; 0000 0091             case 2:
_0xE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD
; 0000 0092             {
; 0000 0093                 putchar('@');
	LDI  R26,LOW(64)
	RCALL _putchar
; 0000 0094                 putchar(dac_reg[rx_buffer0[1]]);
	__GETB1MN _rx_buffer0,1
	RCALL SUBOPT_0x2
	RCALL _putchar
; 0000 0095             }
; 0000 0096             break;
; 0000 0097 
; 0000 0098         }
_0xD:
; 0000 0099         rx_counter0=0; //flush buffer
	CLR  R14
; 0000 009A     }
; 0000 009B    }
_0xA:
; 0000 009C }
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
; 0000 00A3 {
; 0000 00A4 char data;
; 0000 00A5 while (rx_counter0==0);
;	data -> R17
; 0000 00A6 data=rx_buffer0[rx_rd_index0++];
; 0000 00A7 #if RX_BUFFER_SIZE0 != 256
; 0000 00A8 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 00A9 #endif
; 0000 00AA #asm("cli")
; 0000 00AB --rx_counter0;
; 0000 00AC #asm("sei")
; 0000 00AD return data;
; 0000 00AE }
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
; 0000 00C4 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C5 if (tx_counter0)
	RCALL SUBOPT_0x3
	CPI  R30,0
	BREQ _0x18
; 0000 00C6    {
; 0000 00C7    --tx_counter0;
	RCALL SUBOPT_0x3
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 00C8    UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	STS  198,R30
; 0000 00C9 #if TX_BUFFER_SIZE0 != 256
; 0000 00CA    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x8)
	BRNE _0x19
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 00CB #endif
; 0000 00CC    }
_0x19:
; 0000 00CD }
_0x18:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00D4 {
_putchar:
; .FSTART _putchar
; 0000 00D5 while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0x1A:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x8)
	BREQ _0x1A
; 0000 00D6 #asm("cli")
	cli
; 0000 00D7 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	RCALL SUBOPT_0x3
	CPI  R30,0
	BRNE _0x1E
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BRNE _0x1D
_0x1E:
; 0000 00D8    {
; 0000 00D9    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00DA #if TX_BUFFER_SIZE0 != 256
; 0000 00DB    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x20
	CLR  R13
; 0000 00DC #endif
; 0000 00DD    ++tx_counter0;
_0x20:
	RCALL SUBOPT_0x3
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00DE    }
; 0000 00DF else
	RJMP _0x21
_0x1D:
; 0000 00E0    UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 00E1 #asm("sei")
_0x21:
	sei
; 0000 00E2 }
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
; 0000 00ED {
_main:
; .FSTART _main
; 0000 00EE #pragma optsize-
; 0000 00EF CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00F0 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00F1 #ifdef _OPTIMIZE_SIZE_
; 0000 00F2 #pragma optsize+
; 0000 00F3 #endif
; 0000 00F4 
; 0000 00F5 // Port B initialization
; 0000 00F6 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00F7 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(4)
	OUT  0x4,R30
; 0000 00F8 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=P Bit0=P
; 0000 00F9 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(3)
	OUT  0x5,R30
; 0000 00FA 
; 0000 00FB // Port C initialization
; 0000 00FC // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00FD DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
	OUT  0x7,R30
; 0000 00FE // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00FF PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0100 
; 0000 0101 // Port D initialization
; 0000 0102 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0103 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0xA,R30
; 0000 0104 // State: Bit7=P Bit6=T Bit5=T Bit4=P Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0105 PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(144)
	OUT  0xB,R30
; 0000 0106 
; 0000 0107 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0108 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 0109 TCNT0=0x00;
	OUT  0x26,R30
; 0000 010A OCR0A=0x00;
	OUT  0x27,R30
; 0000 010B OCR0B=0x00;
	OUT  0x28,R30
; 0000 010C 
; 0000 010D TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 010E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 010F TCNT1H=0x00;
	STS  133,R30
; 0000 0110 TCNT1L=0x00;
	STS  132,R30
; 0000 0111 ICR1H=0x00;
	STS  135,R30
; 0000 0112 ICR1L=0x00;
	STS  134,R30
; 0000 0113 OCR1AH=0x00;
	STS  137,R30
; 0000 0114 OCR1AL=0x00;
	STS  136,R30
; 0000 0115 OCR1BH=0x00;
	STS  139,R30
; 0000 0116 OCR1BL=0x00;
	STS  138,R30
; 0000 0117 
; 0000 0118 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0119 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 011A TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 011B TCNT2=0x00;
	STS  178,R30
; 0000 011C OCR2A=0x00;
	STS  179,R30
; 0000 011D OCR2B=0x00;
	STS  180,R30
; 0000 011E 
; 0000 011F // Timer/Counter 0 Interrupt(s) initialization
; 0000 0120 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 0121 
; 0000 0122 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0123 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 0124 
; 0000 0125 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0126 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 0127 
; 0000 0128 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0129 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 012A PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 012B 
; 0000 012C UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	STS  192,R30
; 0000 012D UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	STS  193,R30
; 0000 012E UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 012F UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 0130 UBRR0L=0x0C;
	LDI  R30,LOW(12)
	STS  196,R30
; 0000 0131 
; 0000 0132 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0133 ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0134 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 0135 
; 0000 0136 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 0137 
; 0000 0138 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0139 
; 0000 013A // TWI initialization
; 0000 013B // Mode: TWI Master
; 0000 013C // Bit Rate: 62 kHz
; 0000 013D twi_master_init(62);
	LDI  R26,LOW(62)
	LDI  R27,0
	RCALL _twi_master_init
; 0000 013E 
; 0000 013F // Global enable interrupts
; 0000 0140 #asm("sei")
	sei
; 0000 0141 
; 0000 0142 while (1)
_0x22:
; 0000 0143       {
; 0000 0144         if(!StartUp)
	TST  R5
	BREQ PC+2
	RJMP _0x25
; 0000 0145         {
; 0000 0146             // first start up
; 0000 0147             int j=0;
; 0000 0148             int i=0;
; 0000 0149             delay_ms(200);
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	j -> Y+2
;	i -> Y+0
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x4
; 0000 014A             j=0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 014B             DAC_reset=0;
	CBI  0x5,2
; 0000 014C             delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x4
; 0000 014D             DAC_reset=1;
	SBI  0x5,2
; 0000 014E             delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x4
; 0000 014F             SW_Mute(1);
	LDI  R26,LOW(1)
	RCALL _SW_Mute
; 0000 0150             if(_4493)
	SBIS 0x9,4
	RJMP _0x2A
; 0000 0151             {
; 0000 0152                 // 4493 mode
; 0000 0153                 char i=0;
; 0000 0154                 for(i=0;i<22;i++)
	SBIW R28,1
	RCALL SUBOPT_0x5
;	j -> Y+3
;	i -> Y+1
;	i -> Y+0
	RCALL SUBOPT_0x5
_0x2C:
	LD   R26,Y
	CPI  R26,LOW(0x16)
	BRSH _0x2D
; 0000 0155                 {
; 0000 0156                     // write default values to dac
; 0000 0157                     dac_reg[i]=_4493_def_values[i];
	RCALL SUBOPT_0x6
	SUBI R30,LOW(-__4493_def_values*2)
	SBCI R31,HIGH(-__4493_def_values*2)
	LPM  R30,Z
	ST   X,R30
; 0000 0158                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x2C
_0x2D:
; 0000 0159             }
	RJMP _0x58
; 0000 015A             else
_0x2A:
; 0000 015B             {
; 0000 015C                 // 4490 mode
; 0000 015D                 char i=0;
; 0000 015E 
; 0000 015F                 printf("4490 mode\n\r");
	SBIW R28,1
	RCALL SUBOPT_0x5
;	j -> Y+3
;	i -> Y+1
;	i -> Y+0
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 0160                 for(i=0;i<10;i++)
	RCALL SUBOPT_0x5
_0x30:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRSH _0x31
; 0000 0161                 {
; 0000 0162                     dac_reg[i]=_4490_def_values[i];
	RCALL SUBOPT_0x6
	SUBI R30,LOW(-__4490_def_values*2)
	SBCI R31,HIGH(-__4490_def_values*2)
	LPM  R30,Z
	ST   X,R30
; 0000 0163                     Write_To_DAC(i2c_address,i,dac_reg[i]);
	ST   -Y,R8
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+2
	RCALL SUBOPT_0x2
	RCALL _Write_To_DAC
; 0000 0164                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x30
_0x31:
; 0000 0165             }
_0x58:
	ADIW R28,1
; 0000 0166 
; 0000 0167             delay_ms(50);
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x4
; 0000 0168             StartUp=1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0169             ResetChip();
	RCALL _ResetChip
; 0000 016A             SW_Mute(0);
	LDI  R26,LOW(0)
	RCALL _SW_Mute
; 0000 016B         }
	ADIW R28,4
; 0000 016C         else
	RJMP _0x32
_0x25:
; 0000 016D         {
; 0000 016E             // normal work
; 0000 016F             unsigned char _SR=1*F1+2*F2; //calculate current mode
; 0000 0170 
; 0000 0171             unsigned char _DF=SSLOW*1+SD*2+SLOW*4;
; 0000 0172 
; 0000 0173             if(last_mute!=Mute)
	SBIW R28,2
;	_SR -> Y+1
;	_DF -> Y+0
	LDI  R26,0
	SBIC 0x9,2
	LDI  R26,1
	LDI  R30,0
	SBIC 0x6,3
	LDI  R30,1
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
	LDI  R30,0
	SBIC 0x3,6
	LDI  R30,1
	MOV  R26,R9
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x33
; 0000 0174             {
; 0000 0175                 last_mute=Mute;
	LDI  R30,0
	SBIC 0x3,6
	LDI  R30,1
	MOV  R9,R30
; 0000 0176                 SW_Mute(Mute);
	LDI  R26,0
	SBIC 0x3,6
	LDI  R26,1
	RCALL _SW_Mute
; 0000 0177             }
; 0000 0178 
; 0000 0179             // Samplerate check
; 0000 017A             if((_SR+F0)!=last_SR)
_0x33:
	LDD  R26,Y+1
	CLR  R27
	LDI  R30,0
	SBIC 0x9,3
	LDI  R30,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R7
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x34
; 0000 017B             {
; 0000 017C                 SW_Mute(1);
	LDI  R26,LOW(1)
	RCALL _SW_Mute
; 0000 017D                 SampleRateCheck(_SR);
	LDD  R26,Y+1
	RCALL _SampleRateCheck
; 0000 017E                 last_SR=_SR+F0;
	LDI  R30,0
	SBIC 0x9,3
	LDI  R30,1
	LDD  R26,Y+1
	ADD  R30,R26
	MOV  R7,R30
; 0000 017F                 if(!_4493)
	SBIC 0x9,4
	RJMP _0x35
; 0000 0180                 {
; 0000 0181                     // strong check unsupported mode:
; 0000 0182                     // AK4490 does not support DSD512 mode
; 0000 0183                     if(_SR>11)
	LDD  R26,Y+1
	CPI  R26,LOW(0xC)
	BRLO _0x36
; 0000 0184                     {
; 0000 0185                         SW_Mute(1);
	LDI  R26,LOW(1)
	RJMP _0x59
; 0000 0186                     }
; 0000 0187                     else
_0x36:
; 0000 0188                     {
; 0000 0189                         SW_Mute(0);
	LDI  R26,LOW(0)
_0x59:
	RCALL _SW_Mute
; 0000 018A                     }
; 0000 018B                 }
; 0000 018C                 else
	RJMP _0x38
_0x35:
; 0000 018D                 {
; 0000 018E                     SW_Mute(0);
	LDI  R26,LOW(0)
	RCALL _SW_Mute
; 0000 018F                 }
_0x38:
; 0000 0190                 printf("Current mode: %i\n\r", _SR);
	__POINTW1FN _0x0,12
	RCALL SUBOPT_0x7
	LDD  R30,Y+3
	RCALL SUBOPT_0x9
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 0191             };
_0x34:
; 0000 0192 
; 0000 0193 
; 0000 0194             if(_DF!=last_DF)
	LD   R26,Y
	CP   R10,R26
	BREQ _0x39
; 0000 0195             {
; 0000 0196                 SW_Mute(1);
	LDI  R26,LOW(1)
	RCALL _SW_Mute
; 0000 0197                 DF_Check();
	RCALL _DF_Check
; 0000 0198                 ResetChip();
	RCALL _ResetChip
; 0000 0199                 last_DF=_DF;
	LDD  R10,Y+0
; 0000 019A                 printf("Digital Filter: SLOW=%i, SD=%i, SSLOW=%i\n\r",SLOW,SD,SSLOW);
	__POINTW1FN _0x0,31
	RCALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x3,1
	LDI  R30,1
	RCALL SUBOPT_0x9
	LDI  R30,0
	SBIC 0x3,0
	LDI  R30,1
	RCALL SUBOPT_0x9
	LDI  R30,0
	SBIC 0x9,7
	LDI  R30,1
	RCALL SUBOPT_0x9
	LDI  R24,12
	RCALL _printf
	ADIW R28,14
; 0000 019B                 SW_Mute(0);
	LDI  R26,LOW(0)
	RCALL _SW_Mute
; 0000 019C             }
; 0000 019D         }
_0x39:
	ADIW R28,2
_0x32:
; 0000 019E       }
	RJMP _0x22
; 0000 019F }
_0x3A:
	RJMP _0x3A
; .FEND
;
;void Write_To_DAC(unsigned char chip_address, unsigned char address, unsigned char data)
; 0000 01A2 {
_Write_To_DAC:
; .FSTART _Write_To_DAC
; 0000 01A3     char i=0;
; 0000 01A4     struct _data
; 0000 01A5     {
; 0000 01A6         unsigned char lsb;
; 0000 01A7         unsigned char data;
; 0000 01A8     } DAC_REG;
; 0000 01A9     DAC_REG.lsb=address;
	ST   -Y,R26
	SBIW R28,2
	ST   -Y,R17
;	chip_address -> Y+5
;	address -> Y+4
;	data -> Y+3
;	i -> R17
;	_data -> Y+3
;	DAC_REG -> Y+1
	LDI  R17,0
	LDD  R30,Y+4
	STD  Y+1,R30
; 0000 01AA     DAC_REG.data=data;
	LDD  R30,Y+3
	STD  Y+2,R30
; 0000 01AB     if(!twi_master_trans(chip_address,(unsigned char*)&DAC_REG,2,0,0))
	RCALL SUBOPT_0xA
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x7
	LDI  R26,LOW(0)
	RCALL _twi_master_trans
	CPI  R30,0
	BRNE _0x3B
; 0000 01AC     {
; 0000 01AD         printf("write error!\n\r");
	__POINTW1FN _0x0,74
	RCALL SUBOPT_0xB
; 0000 01AE     }
; 0000 01AF     delay_ms(200);
_0x3B:
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x4
; 0000 01B0     if(!twi_master_trans(chip_address,(unsigned char*)&DAC_REG,1,&c,1))
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xC
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x7
	LDI  R26,LOW(1)
	RCALL _twi_master_trans
	CPI  R30,0
	BRNE _0x3C
; 0000 01B1     {
; 0000 01B2         printf("error control\n\r");
	__POINTW1FN _0x0,89
	RCALL SUBOPT_0xB
; 0000 01B3     }
; 0000 01B4 }
_0x3C:
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
;
;void SampleRateCheck(unsigned char mode)
; 0000 01B7 {
_SampleRateCheck:
; .FSTART _SampleRateCheck
; 0000 01B8     if(DSD)
	ST   -Y,R26
;	mode -> Y+0
	SBIS 0x9,6
	RJMP _0x3D
; 0000 01B9     {
; 0000 01BA         printf("DSD\n\r");
	__POINTW1FN _0x0,105
	RCALL SUBOPT_0xB
; 0000 01BB         dac_reg[2]=_setbit(dac_reg[2],7);
	RCALL SUBOPT_0xD
	RCALL __setbit
	RJMP _0x5A
; 0000 01BC     }
; 0000 01BD     else
_0x3D:
; 0000 01BE     {
; 0000 01BF         printf("PCM\n\r");
	__POINTW1FN _0x0,111
	RCALL SUBOPT_0xB
; 0000 01C0         dac_reg[2]=_clrbit(dac_reg[2],7);
	RCALL SUBOPT_0xD
	RCALL __clrbit
_0x5A:
	__PUTB1MN _dac_reg,2
; 0000 01C1 
; 0000 01C2     };
; 0000 01C3     switch(mode)
	LD   R30,Y
	LDI  R31,0
; 0000 01C4         {
; 0000 01C5             case 0:
	SBIW R30,0
	BRNE _0x42
; 0000 01C6             {
; 0000 01C7                 //DSD64 Mode
; 0000 01C8                 // DSDSEL0
; 0000 01C9 
; 0000 01CA                 dac_reg[6]=_clrbit(dac_reg[6],0);
	RCALL SUBOPT_0xE
	RCALL __clrbit
	RCALL SUBOPT_0xF
; 0000 01CB                 dac_reg[9]=_clrbit(dac_reg[9],0);
	RJMP _0x5B
; 0000 01CC                 //dac_reg[1]=_clrbit(dac_reg[1],3);
; 0000 01CD                 //dac_reg[1]=_clrbit(dac_reg[1],4);
; 0000 01CE                 //dac_reg[5]=_clrbit(dac_reg[5],1);
; 0000 01CF 
; 0000 01D0             }
; 0000 01D1             break;
; 0000 01D2             case 1:
_0x42:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x43
; 0000 01D3             {
; 0000 01D4                 dac_reg[6]=_setbit(dac_reg[6],0);
	RCALL SUBOPT_0xE
	RCALL __setbit
	RCALL SUBOPT_0xF
; 0000 01D5                 dac_reg[9]=_clrbit(dac_reg[9],0);
	RJMP _0x5B
; 0000 01D6                 //dac_reg[1]=_setbit(dac_reg[1],3);
; 0000 01D7                 //dac_reg[1]=_clrbit(dac_reg[1],4);
; 0000 01D8                 //dac_reg[5]=_clrbit(dac_reg[5],1);
; 0000 01D9             }
; 0000 01DA             break;
; 0000 01DB             case 2:
_0x43:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x44
; 0000 01DC             {
; 0000 01DD                 dac_reg[6]=_clrbit(dac_reg[6],0);
	RCALL SUBOPT_0xE
	RCALL __clrbit
	RJMP _0x5C
; 0000 01DE                 dac_reg[9]=_setbit(dac_reg[9],0);
; 0000 01DF                 //dac_reg[1]=_clrbit(dac_reg[1],3);
; 0000 01E0                 //dac_reg[1]=_setbit(dac_reg[1],4);
; 0000 01E1                 //dac_reg[5]=_clrbit(dac_reg[5],1);
; 0000 01E2 
; 0000 01E3             }
; 0000 01E4             break;
; 0000 01E5             case 3:
_0x44:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x41
; 0000 01E6             {
; 0000 01E7                 dac_reg[6]=_setbit(dac_reg[6],0);
	RCALL SUBOPT_0xE
	RCALL __setbit
_0x5C:
	__PUTB1MN _dac_reg,6
; 0000 01E8                 dac_reg[9]=_setbit(dac_reg[9],0);
	__GETB1MN _dac_reg,9
	RCALL SUBOPT_0x10
_0x5B:
	__PUTB1MN _dac_reg,9
; 0000 01E9                 //dac_reg[1]=_clrbit(dac_reg[1],3);
; 0000 01EA                 //dac_reg[1]=_clrbit(dac_reg[1],4);
; 0000 01EB                 //dac_reg[5]=_setbit(dac_reg[5],1);
; 0000 01EC             }
; 0000 01ED             break;
; 0000 01EE 
; 0000 01EF         };
_0x41:
; 0000 01F0         if(F0)
	SBIS 0x9,3
	RJMP _0x46
; 0000 01F1         {
; 0000 01F2             // 44.1 kHz MCLK mode
; 0000 01F3 
; 0000 01F4             Scale_44=1;
	SBI  0x8,0
; 0000 01F5             Scale_48=0;
	CBI  0x8,1
; 0000 01F6             printf("44.1 kHz\n\r");
	__POINTW1FN _0x0,117
	RJMP _0x5D
; 0000 01F7 
; 0000 01F8         }
; 0000 01F9         else
_0x46:
; 0000 01FA         {
; 0000 01FB             // 48 kHz MCLK Mode
; 0000 01FC             Scale_44=0;
	CBI  0x8,0
; 0000 01FD             Scale_48=1;
	SBI  0x8,1
; 0000 01FE             printf("48 kHz\n\r");
	__POINTW1FN _0x0,128
_0x5D:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x8
; 0000 01FF 
; 0000 0200         };
; 0000 0201 
; 0000 0202 
; 0000 0203     printf("6=%X,9=%X\r\n",dac_reg[6],dac_reg[9]);
	__POINTW1FN _0x0,137
	RCALL SUBOPT_0x7
	__GETB1MN _dac_reg,6
	RCALL SUBOPT_0x9
	__GETB1MN _dac_reg,9
	RCALL SUBOPT_0x9
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
; 0000 0204     Write_To_DAC(i2c_address,1,dac_reg[1]);
	ST   -Y,R8
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x11
; 0000 0205     Write_To_DAC(i2c_address,2,dac_reg[2]);
; 0000 0206     Write_To_DAC(i2c_address,5,dac_reg[5]);
; 0000 0207     Write_To_DAC(i2c_address,6,dac_reg[6]);
	ST   -Y,R8
	LDI  R30,LOW(6)
	ST   -Y,R30
	__GETB2MN _dac_reg,6
	RCALL _Write_To_DAC
; 0000 0208     Write_To_DAC(i2c_address,9,dac_reg[9]);
	ST   -Y,R8
	LDI  R30,LOW(9)
	ST   -Y,R30
	__GETB2MN _dac_reg,9
	RCALL _Write_To_DAC
; 0000 0209     ResetChip();
	RCALL _ResetChip
; 0000 020A }
	RJMP _0x2080004
; .FEND
;
;void ResetChip()
; 0000 020D {
_ResetChip:
; .FSTART _ResetChip
; 0000 020E     //printf("Reset\n\r");
; 0000 020F     Write_To_DAC(i2c_address,0,dac_reg[0]&0xFE);
	RCALL SUBOPT_0x12
	ANDI R30,0xFE
	RCALL SUBOPT_0x13
; 0000 0210     delay_ms(50);
; 0000 0211     Write_To_DAC(i2c_address,0,dac_reg[0]|0x1);
	RCALL SUBOPT_0x12
	ORI  R30,1
	RCALL SUBOPT_0x13
; 0000 0212     delay_ms(50);
; 0000 0213 }
	RET
; .FEND
;
;void DF_Check()
; 0000 0216 {
_DF_Check:
; .FSTART _DF_Check
; 0000 0217     if(SSLOW)
	SBIS 0x9,7
	RJMP _0x50
; 0000 0218     {
; 0000 0219         dac_reg[5]=_setbit(dac_reg[5],0);
	__GETB1MN _dac_reg,5
	RCALL SUBOPT_0x10
	RJMP _0x5E
; 0000 021A     }
; 0000 021B     else
_0x50:
; 0000 021C     {
; 0000 021D         dac_reg[5]=_clrbit(dac_reg[5],0);
	__GETB1MN _dac_reg,5
	RCALL SUBOPT_0x14
_0x5E:
	__PUTB1MN _dac_reg,5
; 0000 021E     }
; 0000 021F 
; 0000 0220     if(SD)
	SBIS 0x3,0
	RJMP _0x52
; 0000 0221     {
; 0000 0222         dac_reg[1]=_setbit(dac_reg[1],5);
	RCALL SUBOPT_0x15
	RCALL __setbit
	RJMP _0x5F
; 0000 0223     }
; 0000 0224     else
_0x52:
; 0000 0225     {
; 0000 0226         dac_reg[1]=_clrbit(dac_reg[1],5);
	RCALL SUBOPT_0x15
	RCALL __clrbit
_0x5F:
	__PUTB1MN _dac_reg,1
; 0000 0227     }
; 0000 0228     if(SLOW)
	SBIS 0x3,1
	RJMP _0x54
; 0000 0229     {
; 0000 022A         dac_reg[2]=_setbit(dac_reg[2],0);
	__GETB1MN _dac_reg,2
	RCALL SUBOPT_0x10
	RJMP _0x60
; 0000 022B     }
; 0000 022C     else
_0x54:
; 0000 022D     {
; 0000 022E         dac_reg[2]=_clrbit(dac_reg[2],0);
	__GETB1MN _dac_reg,2
	RCALL SUBOPT_0x14
_0x60:
	__PUTB1MN _dac_reg,2
; 0000 022F     }
; 0000 0230     Write_To_DAC(i2c_address,1,dac_reg[1]);
	ST   -Y,R8
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x11
; 0000 0231     Write_To_DAC(i2c_address,2,dac_reg[2]);
; 0000 0232     Write_To_DAC(i2c_address,5,dac_reg[5]);
; 0000 0233 
; 0000 0234     ResetChip();
	RCALL _ResetChip
; 0000 0235 }
	RET
; .FEND
;
;void SW_Mute(unsigned char mute)
; 0000 0238 {
_SW_Mute:
; .FSTART _SW_Mute
; 0000 0239     if(mute)
	ST   -Y,R26
;	mute -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x56
; 0000 023A     {
; 0000 023B         dac_reg[1]=_setbit(dac_reg[1],0);
	__GETB1MN _dac_reg,1
	RCALL SUBOPT_0x10
	RJMP _0x61
; 0000 023C         //printf("Mute\n\r");
; 0000 023D     }
; 0000 023E     else
_0x56:
; 0000 023F     {
; 0000 0240         dac_reg[1]=_clrbit(dac_reg[1],0);
	__GETB1MN _dac_reg,1
	RCALL SUBOPT_0x14
_0x61:
	__PUTB1MN _dac_reg,1
; 0000 0241         //printf("UnMute\r\n");
; 0000 0242     };
; 0000 0243     Write_To_DAC(i2c_address,1,dac_reg[1]);
	ST   -Y,R8
	RCALL SUBOPT_0xC
	__GETB2MN _dac_reg,1
	RCALL _Write_To_DAC
; 0000 0244 }
_0x2080004:
	ADIW R28,1
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
	RCALL SUBOPT_0x16
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
	RCALL SUBOPT_0x16
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
	RCALL SUBOPT_0x17
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x18
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1A
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
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
	RCALL SUBOPT_0x1D
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
	RCALL SUBOPT_0x1D
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1E
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
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1E
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
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x1D
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x1D
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
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x1A
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
	RCALL SUBOPT_0x16
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
	RCALL SUBOPT_0x1F
_0x2020016:
	SBIC 0x1E,2
	RJMP _0x2020018
	RCALL __GETD1S0
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	RCALL SUBOPT_0x1F
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
	RCALL SUBOPT_0x16
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
	RCALL SUBOPT_0x16
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
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x1
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R31,0
	SUBI R30,LOW(-_dac_reg)
	SBCI R31,HIGH(-_dac_reg)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDS  R30,_tx_counter0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_dac_reg)
	SBCI R27,HIGH(-_dac_reg)
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDD  R30,Y+5
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x7
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETB1MN _dac_reg,2
	ST   -Y,R30
	LDI  R26,LOW(7)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	__GETB1MN _dac_reg,6
	ST   -Y,R30
	LDI  R26,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	__PUTB1MN _dac_reg,6
	__GETB1MN _dac_reg,9
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP __clrbit

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP __setbit

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x11:
	__GETB2MN _dac_reg,1
	RCALL _Write_To_DAC
	ST   -Y,R8
	LDI  R30,LOW(2)
	ST   -Y,R30
	__GETB2MN _dac_reg,2
	RCALL _Write_To_DAC
	ST   -Y,R8
	LDI  R30,LOW(5)
	ST   -Y,R30
	__GETB2MN _dac_reg,5
	RJMP _Write_To_DAC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	ST   -Y,R8
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,_dac_reg
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	MOV  R26,R30
	RCALL _Write_To_DAC
	LDI  R26,LOW(50)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP __clrbit

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__GETB1MN _dac_reg,1
	ST   -Y,R30
	LDI  R26,LOW(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x17:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x18
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
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
SUBOPT_0x1D:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
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
