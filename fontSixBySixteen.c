#include <avr/io.h>
#include <avr/pgmspace.h> 
 
#ifndef FONT6X16_H
#define FONT6X16_H

/*******************************************************************************************
  Font name: Bodoni MT Poster Compressed
  Font width: varialbe (proportional font)
  Font height: 16
  Data length: 8 bits
  Data format: Big Endian, Column based, Row preferred, Unpacked

  Create time: 15:02 10-03-2011  by BitFontCreator (e-mail: support@iseatech.com)
 *******************************************************************************************/

static unsigned char  fontSixBySixteen[] PROGMEM = {
/* character 0x30 ('0'): (width=6, offset=0) */
0x3F, 0xFF, 0x80, 0xFF, 0x3F, 0x00, 0xFC, 0xFF, 
0x01, 0xFF, 0xFC, 0x00, 

/* character 0x31 ('1'): (width=6, offset=12) */
0x00, 0x80, 0xFF, 0xFF, 0x80, 0x00, 0x00, 0x02, 
0xFF, 0xFF, 0x00, 0x00, 

/* character 0x32 ('2'): (width=6, offset=24) */
0xF0, 0xCC, 0xC2, 0xC1, 0xF8, 0x00, 0x3E, 0x31, 
0x01, 0xFF, 0xFE, 0x00, 

/* character 0x33 ('3'): (width=6, offset=36) */
0x7C, 0x9C, 0x80, 0xFF, 0x3E, 0x00, 0x1E, 0x9D, 
0x81, 0x7F, 0x3E, 0x00, 

/* character 0x34 ('4'): (width=6, offset=48) */
0x0E, 0x09, 0x88, 0xFF, 0xFF, 0x88, 0x00, 0xC0, 
0x3C, 0xFF, 0xFF, 0x00, 

/* character 0x35 ('5'): (width=6, offset=60) */
0x79, 0xB8, 0x80, 0xFF, 0x7F, 0x00, 0xFF, 0x43, 
0x23, 0xE3, 0xC3, 0x00, 

/* character 0x36 ('6'): (width=6, offset=72) */
0x3F, 0xFF, 0x80, 0xFF, 0x3F, 0x00, 0xFC, 0xFF, 
0x41, 0xCF, 0x8E, 0x00, 

/* character 0x37 ('7'): (width=6, offset=84) */
0xF8, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x03, 
0xC3, 0x23, 0x1B, 0x07, 

/* character 0x38 ('8'): (width=6, offset=96) */
0x7E, 0xC1, 0x83, 0x8F, 0x7C, 0x00, 0x1E, 0xF9, 
0xE1, 0x21, 0x1E, 0x00, 

/* character 0x39 ('9'): (width=6, offset=108) */
0x71, 0xF3, 0x82, 0xFF, 0x3F, 0x00, 0xFC, 0xFF, 
0x01, 0xFF, 0xFC, 0x00, 

/* character 0x3A (':'): (width=6, offset=120) */
0x00, 0x3C, 0x3C, 0x3C, 0x3C, 0x00, 0x00, 0x1E, 
0x1E, 0x1E, 0x1E, 0x00, 


/* roate char */
0x80, 0x00, 0x00, 0x00, 0x00, 0xC0, 0x07, 0x04, 
0x00, 0x00, 0x01, 0x03, 

};

#endif
