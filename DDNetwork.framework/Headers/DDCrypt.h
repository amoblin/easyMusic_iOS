//
//  DDCrypt.h
//  CryptDemo
//
//  Created by 巩鹏军 on 15/9/18.
//  Copyright (c) 2015年 巩鹏军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCrypt : NSObject

+ (NSString *)encryptString:(NSString *)plainString withEncryptKey:(NSString *)encryptKey;
+ (NSString *)decryptString:(NSString *)encryptedAndBase64EncodedString withEncryptKey:(NSString *)encryptKey;

+ (NSData *)encryptData:(NSData *)plainData withEncryptKey:(NSString *)encryptKey;
+ (NSData *)decryptData:(NSData *)encryptedAndBase64EncodedData withEncryptKey:(NSString *)encryptKey;

+ (void)testCrypt;

@end
