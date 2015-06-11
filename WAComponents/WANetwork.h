//
//  WANetwork.h
//  marboo.io
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
- (void)requestWithPath:(NSString *)url method:(NSString *)method
                          params:(NSDictionary *)params
                         success:(void (^)(id result))success
                  failure:(void (^)(NSError *error))failure;


- (void)uploadWithPath:(NSString *)path
                params:(NSDictionary *)params
                  data:(NSData *)data
               success:(void (^)(id result))success
               failure:(void (^)(NSError * error))failure;

@property (strong, nonatomic) NSString *apiRoot;
@end
