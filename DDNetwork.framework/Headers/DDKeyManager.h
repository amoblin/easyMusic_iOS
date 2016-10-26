//
//  DDKeyManager.h
//  DiBus
//
//  Created by 巩鹏军 on 15/9/14.
//  Copyright (c) 2015年 DiDi. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DDBlocks.h"
#import "DDRequestError.h"

#define ARC_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SS_CLASSNAME)	\
+ (SS_CLASSNAME *)sharedInstance;

typedef void (^DDKeyExchangeBlock)(NSString *requestId, NSString *encryptKey, DDRequestError *error);

@class DDBaseEncryptRequest;

@interface DDKeyManager : NSObject

ARC_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(DDKeyManager)

@property (nonatomic, strong) NSString *rootUrl;
@property (nonatomic, strong) NSString *pathName;

- (void)forceKeyExpired:(NSString *)expiredKey;
- (void)loadEncryptKey;
- (void)requestEncryptKeyWithCompletion:(DDKeyExchangeBlock)completion;
- (void)cancelRequest:(DDBaseEncryptRequest *)request;

@end
