//
//  DDNetwork+Promise.h
//  Bee
//
//  Created by amoblin on 16/9/1.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "DDNetworking.h"
#import <PromiseKit/PromiseKit.h>

@interface DDNetworking (Promise)

- (PMKPromise *)requestWithString:(NSString *)url
                              method:(NSString *)method
                              params:(NSDictionary *)params;

- (PMKPromise *)uploadWithPath:(NSString *)path
                        params:(NSDictionary *)params
                          data:(NSData *)data;
@end
