//
//  DDNetwork.h
//  marboo.io
//
//  Created by amoblin on 14/12/21.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WARequestConfigModel.h"
#import "DDBaseRequest.h"

@interface DDNetworking : NSObject

@property (strong, nonatomic) NSString *apiRoot;
@property (nonatomic, strong) Class requestClass;

+ (DDNetworking *)sharedInstance;

- (DDBaseRequest *)requestWithString:(NSString *)url
                              method:(NSString *)method
                              params:(NSDictionary *)params
                             success:(void (^)(id result))success
                             failure:(void (^)(id response, NSError *error))failure;

- (DDBaseRequest *)requestWithPath:(NSString *)url
                            method:(NSString *)method
                            params:(NSDictionary *)params
                           success:(void (^)(id result))success
                           failure:(void (^)(id response, NSError *error))failure;

- (void)uploadWithPath:(NSString *)path
                params:(NSDictionary *)params
                  data:(NSData *)data
               success:(void (^)(id result))success
               failure:(void (^)(NSError * error))failure;

@end
