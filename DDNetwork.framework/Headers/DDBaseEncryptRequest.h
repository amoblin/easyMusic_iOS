//
//  DDBaseEncryptRequest.h
//  iMarboo
//
//  Created by amoblin on 15/12/21.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "DDBaseRequest.h"
#import "DDHTTPRequestOperationManager+Encrypt.h"
#import "DDJSONResponseSerializer.h"
#import "DDKeyManager.h"

typedef NS_ENUM(NSInteger, DDParameterEncoding) {
    DDParameterEncodingFormURL,
    DDParameterEncodingJSON,
    DDParameterEncodingJSONEncrypt,
};

@interface DDBaseEncryptRequest : DDBaseRequest

@property (nonatomic, assign) DDParameterEncoding parameterEncoding;
@property (nonatomic, strong) DDKeyManager *keyManager;
@property (nonatomic, strong) NSString *encryptKey;
@property (nonatomic, copy) DDKeyExchangeBlock completion;

- (BOOL)shouldEncrypt;

@end
