//
//  KeyManager.h
//  DDDh
//
//  Created by hujin on 15/9/9.
//  Copyright (c) 2015年 DiDi. All rights reserved.
//

#ifndef __DDDh__KeyManager__
#define __DDDh__KeyManager__

#include <stdio.h>

char * dd_create_pub_key(char ** priv_key_str);
char * dd_create_key(char * priv_key_str, char * peer_pub_key_str);

#endif /* defined(__DDDh__KeyManager__) */
