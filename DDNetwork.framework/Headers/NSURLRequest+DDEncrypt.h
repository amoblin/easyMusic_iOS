//
//  NSURLRequest+DDEncrypt.h
//  DiBus
//
//  Created by 巩鹏军 on 15/9/15.
//  Copyright (c) 2015年 DiDi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (DDEncrypt)

@property (nonatomic, strong) NSString *encryptKey;

@end
