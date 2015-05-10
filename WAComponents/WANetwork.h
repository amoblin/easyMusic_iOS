//
//  WANetwork.h
//  ShuDongPo
//
//  Created by amoblin on 14/12/21.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WANetwork : NSObject

+ (WANetwork *)sharedInstace;
- (void)requestWithString:(NSString *)url method:(NSString *)method
                          params:(NSDictionary *)params
                         success:(void (^)(id result))success
                  failure:(void (^)(NSError *error))failure;

@property (strong, nonatomic) NSString *apiRoot;
@end
