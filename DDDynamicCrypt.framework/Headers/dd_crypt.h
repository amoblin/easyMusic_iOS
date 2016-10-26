//
//  DDCrypt.h
//  DiDynamicKey
//
//  Created by hujin on 15/9/17.
//  Copyright (c) 2015年 DiDi. All rights reserved.
//

#ifndef __DiDynamicKey__DDCrypt__
#define __DiDynamicKey__DDCrypt__

#include <stdio.h>

int dd_aes_encrypt(char *plaintext, char * key, char **ciphertext);
int dd_aes_decrypt(char *ciphertext, char * key, char **plaintext);

#endif /* defined(__DiDynamicKey__DDCrypt__) */
