//
//  DDJSONResponseSerializer.h
//  Bee
//
//  Created by amoblin on 16/7/28.
//  Copyright © 2016年 didi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface DDJSONResponseSerializer : AFJSONResponseSerializer

@property (nonatomic, copy) NSString *encryptKey;

@end
