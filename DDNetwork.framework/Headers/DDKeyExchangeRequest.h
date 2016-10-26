//
//  DDKeyExchangeRequest.h
//  Pods
//
//  Created by 巩鹏军 on 15/12/16.
//
//

#import "DDBaseRequest.h"
#import "DDKeyExchangeModel.h"

@interface DDKeyExchangeRequest : DDBaseRequest

+ (instancetype)requestWithClientPubKey:(NSString *)clientPubKey;

- (void)requestWithCompletion:(DDRequestCompletionBlock)completion;

@end
