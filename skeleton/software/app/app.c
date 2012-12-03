// app.c
// ISR coe_to_serial'ed at 0xc0000180
// inIDX will be held at 0xc1000004
// STATE will be held at 0xc1000000
// outIDX will be held at 0xc1000008
// software FIFO will be held at 0xc100000c

// 'r' 0x72
// 'R' 0x52
// 'v' 0x76
// 'V' 0x56
// 'd' 0x64
// 'e' 0x65

#include "ascii.h"
#include "uart.h"
#include "string.h"
#include "memory.h"


void fmode_cycles(char * target, char * buffer, uint32_t value, char c)
{
  int in = 0;	//index of next character in the input buffer to be copied
  int out = 0;	//index of the position in the output buffer to be copied
  char current = buffer[in];	//set the current character
  char form_char;		//temp variable for format char
  int j;
  int div;
  char temp[10];

  //copy by char into new buffer with formatting
  while (current != '\0') {
    if (current == '%') {
      in = in + 1;
      form_char = buffer[in];

      //abusing %d, should be %h
      if (form_char == 'd') {
	uint32_to_ascii_hex(value, temp, 10);
	for (j = 0; j < 8; j = j + 1) {
	  target[out] = temp[j];
	  out = out + 1;
	}
      } 
      else if (form_char == 'c') {
	target[out] = c;
	out = out + 1;
      } 
      else {
	uwrite_int8s("Error in formatting string\n\r");
      }
      in = in + 1;
    } else {
      target[out] = buffer[in];
      out = out + 1;
      in = in + 1;
    }
    current = buffer[in];
  }
  target[out] = '\0';	//null terminate string
  return;
}

void fmin_sec(char * target, char* buffer, int min, int sec) {
  int in = 0; int out = 0;
  char next_char = buffer[in];
  int arg1 = 0;
  char temp[10];
  
  while(next_char != '\0') {
    if (next_char == '%') {
      in = in + 1;
      next_char = buffer[in];
      if (next_char == 'd' && !arg1) {
	uint32_to_ascii_hex(min, temp, 10);
	target[out] = temp[6];
	target[out+1] = temp[7];
	out = out + 2;
	arg1 = 1;
      }
      else if (next_char == 'd'){
	uint32_to_ascii_hex(sec, temp, 10);
	target[out] = temp[6];
	target[out+1] = temp[7];
	out = out + 2;
      } else {
	uwrite_int8s("Unrecognized format\n\r");
      }
    }
    else
      {
	target[out] = next_char;
	out = out + 1;
      }
    in = in + 1;
    next_char = buffer[in];
  }
  target[out] = '\0';
}

//Dummy test cases




#define BUFFER_SIZE 2048
#define COUNT (*((volatile unsigned int*)0x80000010))

#define RECV_CTRL (*((volatile unsigned int*)0x80000004) & 0x01) // DataOutValid
#define RECV_DATA (*((volatile unsigned int*)0x8000000C) & 0xFF) // DataOut

#define TRAN_CTRL (*((volatile unsigned int*)0x80000000) & 0x01) // DataInReady
#define TRAN_DATA (*((volatile unsigned int*)0x80000008)) // DataIn

#define inIDX (*((volatile unsigned int*)0xc1000004))
#define outIDX (*((volatile unsigned int*)0xc1000008))
#define STATE (*((volatile char*)0xc1000000))
#define SW_RTC (*((volatile char*)0xc100000c))
#define FIFO (*((volatile char[BUFFER_SIZE]*)) 0xc1000010)

int tstart, tend, diff, min, sec;
static volatile int vol_count;

void r100m(){
	int i = 10000000;
	while(i>0){
		i -= 1;
	}
}


void v100m(){
	volatile int vol_count = 10000000;
	while(vol_count>0){
		vol_count += 1;
	}
}

void out(char * m){
	//FIFO[inIDX] = m;
	//if (TRAN_CTRL){TRAN_DATA = FIFO[inIDX];}
}

int main(void)
{
	tstart = 0;
	tend = 0;
	char s[100];
	
    while(1){
		switch(STATE){
			case 'r': 
				tstart = COUNT;
				int i = 10000000;
				while(i>0) {
					i -= 1;
				}
				tend = COUNT;
				diff = tstart-tend;
				min = diff/60;
				sec = diff % 60;
				fmin_sec("r; %d : %d", s, min, sec);
				out(s);
				break;
			case 'R':
				tstart = COUNT;
				r100m();
				tend = COUNT;
				diff = tstart-tend;
				min = diff/60;
				sec = diff % 60;
				fmin_sec("R; %d : %d", s, min, sec);
				out(s);
				break;
			case 'v':
				tstart = COUNT;
				int vol_count = 10000000;
				while(vol_count>0) {
					vol_count -= 1;
				}
				tend = COUNT;
				diff = tstart-tend;
				min = diff/60;
				sec = diff % 60;
				fmin_sec("v; %d : %d", s, min, sec);
				out(s);
				break;
			case 'V':
				tstart = COUNT;
				v100m();
				tend = COUNT;
				diff = tstart-tend;
				min = diff/60;
				sec = diff % 60;
				fmin_sec("V; %d : %d", s, min, sec);
				out(s);
				break;
			default: break;
		}
	
    }

    return 0;
}
