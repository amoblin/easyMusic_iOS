//
//  WANetwork.m
//  ShuDongPo
//
//  Created by amoblin on 14/12/21.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "WANetwork.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <PXAlertView.h>

@implementation WANetwork

+ (WANetwork *)sharedInstace {
    static WANetwork *_sharedInstace = nil;
    if (!_sharedInstace) {
        _sharedInstace = [[[self class] alloc] init];
    }
    return _sharedInstace;
}

- (void)requestWithString:(NSString *)url method:(NSString *)method
                          params:(NSDictionary *)params
                         success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure {
    url = [NSString stringWithFormat:@"%@%@", self.apiRoot, url];

    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDictionary *user = [USER_DEFAULT objectForKey:@"user"];
    
    if (p[@"id"] == nil && user[@"id"] != nil) {
        p[@"id"] = user[@"id"];
        p[@"token"] = user[@"token"];
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([method isEqualToString:@"GET"]) {
        [manager GET:url parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if (responseObject == nil) {
                NSLog(@"%@", operation);
                [PXAlertView showAlertWithTitle:@"数据错误" message:@"请稍后重试"];
            } else {
//                success([self checkKeyValueWith:responseObject]);
                success(responseObject);
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            failure(error);
        }];
    } else {
        [manager POST:url parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if (responseObject == nil) {
                NSLog(@"%@", operation);
                [PXAlertView showAlertWithTitle:@"数据错误" message:@"请稍后重试"];
            } else {
                success(responseObject);
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"%@", error.localizedDescription);
            failure(error);
        }];
    }
}

@end
