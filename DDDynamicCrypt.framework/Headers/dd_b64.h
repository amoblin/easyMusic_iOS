//
//  B64.c
//
//  Created by hujin on 15/9/10.
//  Copyright (c) 2015年 DiDi. All rights reserved.
//

#ifndef DDB64_H
#define DDB64_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int dd_base64_encode_len(int binlength);
int dd_base64_encode( const unsigned char * bindata, char * base64, int binlength );

int dd_base64_decode_len(const char * base64);
int dd_base64_decode( const char * base64, unsigned char * bindata );

#endif
