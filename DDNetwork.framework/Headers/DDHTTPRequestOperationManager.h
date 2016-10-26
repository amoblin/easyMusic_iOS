//
//  DDHTTPRequestOperationManager.h
//  iMarboo
//
//  Created by amoblin on 15/12/15.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "DDHTTPRequestOperation.h"

@interface DDHTTPRequestOperationManager : AFHTTPRequestOperationManager

@property (nonatomic, strong) NSString *encryptKey;
@property (nonatomic, assign) BOOL shouldEncrypt;

- (DDHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(DDHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(DDHTTPRequestOperation *operation, NSError *error))failure;

@end
