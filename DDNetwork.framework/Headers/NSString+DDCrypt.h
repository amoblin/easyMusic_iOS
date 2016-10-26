//
//  NSString+DDCrypt.h
//  CryptDemo
//
//  Created by 巩鹏军 on 15/9/18.
//  Copyright (c) 2015年 巩鹏军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DDCrypt)

- (NSString *)DD_AES256EncryptWithKey:(NSString *)key;
- (NSString *)DD_AES256DecryptWithKey:(NSString *)key;

@end
