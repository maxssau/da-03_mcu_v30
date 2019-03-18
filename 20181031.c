
void Write_To_DAC (unsigned char,unsigned char,unsigned char);
void SampleRateCheck(unsigned char);
void ResetChip(unsigned char);
void DF_Check();
char getchar(void);
void putchar(char);
void SW_Mute(unsigned char mute);

#include <mega48pa.h>
#include <delay.h>

// Declare your global variables here

unsigned char dac_reg[22];
char buff[10];
int j=0;
char c=0;
//unsigned char _4490_dac_reg[10];
//unsigned char _4493_dac_reg[22];

//flash unsigned char _4490_def_values[]={0x87,0xA,0,128,128,0,130,0,0,0,0,0,0,0,0};
flash unsigned char _4490_def_values[]={0x8F,0xA,0,0xff,0xff,0x80,130,0,0,0,0};
flash unsigned char _4493_def_values[]={143,2,0,255,255,64,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};     

_Bool StartUp=0;
unsigned char i2c_address=16;

// logic vars 
unsigned char last_SR=255;
unsigned char last_DF=255;
unsigned char last_mute=255;

// GPIO Defines
#define F0 PIND.3
#define F1 PIND.2
#define F2 PINC.3
#define F3 PINC.2
#define DSD PIND.6
#define Scale PIND.3
#define _4493 PIND.4
#define DAC_reset PORTB.2
#define Mute PINB.6
#define SSLOW PIND.7
#define SD PINB.0
#define SLOW PINB.1
#define Scale_44 PORTC.0
#define Scale_48 PORTC.1

_Bool _getbit(unsigned char data,unsigned char pos)
{
    if((1<<pos)&data)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

unsigned char _setbit(unsigned char data, unsigned char pos)
{
    return (data | (1<<pos));
}

unsigned char _clrbit(unsigned char data, unsigned char pos)
{
    return (data & ~(1<<pos));    
}


#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)

// USART Receiver buffer
#define RX_BUFFER_SIZE0 8
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0=0,rx_rd_index0=0;
#else
unsigned int rx_wr_index0=0,rx_rd_index0=0;
#endif

#if RX_BUFFER_SIZE0 < 256
unsigned char rx_counter0=0;
#else
unsigned int rx_counter0=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow0;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
#endif


    if(rx_counter0==2)
    {
        //receive 3 bytes
        switch(rx_buffer0[0])
        {
            case 1:
            {
                //write to reg
                if(_4493)
                {
                    if(rx_buffer0[1]<22) //check overflow
                    {
                        dac_reg[rx_buffer0[1]]=rx_buffer0[2];                        
                    }
                }
                else
                {
                    if(rx_buffer0[1]<10) //check overflow
                    {
                        dac_reg[rx_buffer0[1]]=rx_buffer0[2];                        
                    }
                }
                
            }
            break;
            case 2:
            {   
                putchar('@');
                putchar(dac_reg[rx_buffer0[1]]);
            }
            break;
            
        }
        rx_counter0=0; //flush buffer
    }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE0 8
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0=0,tx_rd_index0=0;
#else
unsigned int tx_wr_index0=0,tx_rd_index0=0;
#endif

#if TX_BUFFER_SIZE0 < 256
unsigned char tx_counter0=0;
#else
unsigned int tx_counter0=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0++];
#if TX_BUFFER_SIZE0 != 256
   if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0++]=c;
#if TX_BUFFER_SIZE0 != 256
   if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
#endif
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// TWI functions
#include <twi.h>

void main(void)
{
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=P Bit0=P 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=P Bit6=T Bit5=T Bit4=P Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x0C;

ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
ADCSRB=(0<<ACME);
DIDR1=(0<<AIN0D) | (0<<AIN1D);

ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// Mode: TWI Master
// Bit Rate: 62 kHz
twi_master_init(62);

// Global enable interrupts
#asm("sei")

while (1)
      {
        if(!StartUp)
        {
            // first start up                
            int j=0;
            int i=0;
            delay_ms(200);
            j=0;
            DAC_reset=0;
            delay_ms(100);
            DAC_reset=1;
            ResetChip(0);
            delay_ms(100);
            SW_Mute(1);    
            if(_4493)
            {
                // 4493 mode
                char i=0;
                for(i=0;i<22;i++)
                {
                    // write default values to dac
                    dac_reg[i]=_4493_def_values[i];
                }
            }
            else
            {
                // 4490 mode
                char i=0;
                
                printf("4490 mode\n\r");
                for(i=0;i<10;i++)
                {
                    dac_reg[i]=_4490_def_values[i];
                    Write_To_DAC(i2c_address,i,dac_reg[i]);                   
                }
            }
                
            delay_ms(50);
            StartUp=1;
            ResetChip(1);
            SW_Mute(0);
        }
        else
        {
            // normal work
            unsigned char _SR=1*F1+2*F2; //calculate current mode 
            
            unsigned char _DF=SSLOW*1+SD*2+SLOW*4;
            
            if(last_mute!=Mute)
            {
                last_mute=Mute;
                SW_Mute(Mute);
            }
            
            // Samplerate check
            if((_SR+F0)!=last_SR)
            {
                ResetChip(0);
                SW_Mute(1);
                SampleRateCheck(_SR);
                last_SR=_SR+F0;
                if(!_4493)
                {
                    // strong check unsupported mode:
                    // AK4490 does not support DSD512 mode
                    if(_SR>11)
                    {
                        SW_Mute(1);
                    }
                    else
                    {
                        SW_Mute(0);
                    }    
                }
                else
                {
                    SW_Mute(0);
                }
                printf("Current mode: %i\n\r", _SR);
                ResetChip(1);
            };
            
            
            if(_DF!=last_DF)
            {   
                ResetChip(0);
                SW_Mute(1);
                DF_Check();                
                last_DF=_DF;
                printf("Digital Filter: SLOW=%i, SD=%i, SSLOW=%i\n\r",SLOW,SD,SSLOW);
                ResetChip(1);
                SW_Mute(0);
            }
        }
      }
}

void Write_To_DAC(unsigned char chip_address, unsigned char address, unsigned char data)
{
    char i=0;
    struct _data
    {
        unsigned char lsb;
        unsigned char data;
    } DAC_REG;
    DAC_REG.lsb=address;
    DAC_REG.data=data;
    if(!twi_master_trans(chip_address,(unsigned char*)&DAC_REG,2,0,0))
    {
        printf("write error!\n\r");
    }
    delay_ms(200);
    if(!twi_master_trans(chip_address,(unsigned char*)&DAC_REG,1,&c,1))
    {
        printf("error control\n\r");
    }       
}

void SampleRateCheck(unsigned char mode)
{
    if(DSD)
    {
        printf("DSD\n\r");    
        dac_reg[2]=_setbit(dac_reg[2],7);
    }
    else
    {
        printf("PCM\n\r");
        dac_reg[2]=_clrbit(dac_reg[2],7);
        
    };
    switch(mode)
        {
            case 0:
            {
                //DSD64 Mode 
                // DSDSEL0
                
                dac_reg[6]=_clrbit(dac_reg[6],0);
                dac_reg[9]=_clrbit(dac_reg[9],0);                
                dac_reg[1]=_clrbit(dac_reg[1],3);
                dac_reg[1]=_clrbit(dac_reg[1],4);
                dac_reg[5]=_clrbit(dac_reg[5],1);
                  
            }
            break;
            case 1:
            {
                dac_reg[6]=_setbit(dac_reg[6],0);
                dac_reg[9]=_clrbit(dac_reg[9],0);
                dac_reg[1]=_setbit(dac_reg[1],3);
                dac_reg[1]=_clrbit(dac_reg[1],4);
                dac_reg[5]=_clrbit(dac_reg[5],1);       
            }
            break;
            case 2:
            {
                dac_reg[6]=_clrbit(dac_reg[6],0);
                dac_reg[9]=_setbit(dac_reg[9],0);        
                dac_reg[1]=_clrbit(dac_reg[1],3);
                dac_reg[1]=_setbit(dac_reg[1],4);
                dac_reg[5]=_clrbit(dac_reg[5],1);
                
            }
            break;
            case 3:
            {
                dac_reg[6]=_setbit(dac_reg[6],0);
                dac_reg[9]=_setbit(dac_reg[9],0);
                dac_reg[1]=_clrbit(dac_reg[1],3);
                dac_reg[1]=_clrbit(dac_reg[1],4);
                dac_reg[5]=_setbit(dac_reg[5],1);
            }
            break;
            
        };
        if(F0)
        {
            // 44.1 kHz MCLK mode    
            Scale_44=1;
            Scale_48=0;
            printf("44.1 kHz\n\r");                  
        }
        else
        {               
            // 48 kHz MCLK Mode
            Scale_44=0;
            Scale_48=1;
            printf("48 kHz\n\r");
        };
 
    Write_To_DAC(i2c_address,1,dac_reg[1]);
    Write_To_DAC(i2c_address,2,dac_reg[2]);
    Write_To_DAC(i2c_address,5,dac_reg[5]);
    Write_To_DAC(i2c_address,6,dac_reg[6]);
    Write_To_DAC(i2c_address,9,dac_reg[9]);
    ResetChip(1);            
}

void ResetChip(unsigned char mode)
{   
    //printf("Reset\n\r");
    if(!mode)
    {  
        Write_To_DAC(i2c_address,0,dac_reg[0]&0xFE);
    }
    else
    {
        Write_To_DAC(i2c_address,0,dac_reg[0]|0x1);
    }
}

void DF_Check()
{
    if(SSLOW)
    {
        dac_reg[5]=_setbit(dac_reg[5],0);
    }
    else
    {   
        dac_reg[5]=_clrbit(dac_reg[5],0);
    }
    
    if(SD)
    {
        dac_reg[1]=_setbit(dac_reg[1],5);
    }
    else
    {
        dac_reg[1]=_clrbit(dac_reg[1],5);
    }                                 
    if(SLOW)
    {   
        dac_reg[2]=_setbit(dac_reg[2],0);
    }
    else
    {
        dac_reg[2]=_clrbit(dac_reg[2],0);    
    }
    Write_To_DAC(i2c_address,1,dac_reg[1]);
    Write_To_DAC(i2c_address,2,dac_reg[2]);
    Write_To_DAC(i2c_address,5,dac_reg[5]);
    
}

void SW_Mute(unsigned char mute)
{
    if(mute)
    {
        dac_reg[1]=_setbit(dac_reg[1],0);
        //printf("Mute\n\r");
    }
    else
    {
        dac_reg[1]=_clrbit(dac_reg[1],0);
        //printf("UnMute\r\n");
    };
    Write_To_DAC(i2c_address,1,dac_reg[1]);    
}