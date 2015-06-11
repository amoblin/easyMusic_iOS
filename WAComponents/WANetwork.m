//
//  WANetwork.m
//  marboo.io
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
    
    if (p[@"token"] == nil && user[@"token"] != nil) {
        p[@"token"] = user[@"token"];
    }
    
    if (p[@"id"] == nil && user[@"id"] != nil) {
        p[@"id"] = user[@"id"];
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
    } else if ([method isEqualToString:@"POST"]) {
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
    } else if ([method isEqualToString:@"DELETE"]) {
        [manager DELETE:url parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if (responseObject == nil) {
                NSLog(@"%@", operation);
                [PXAlertView showAlertWithTitle:@"数据错误" message:@"请稍后重试"];
            } else {
                success(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"%@", error.localizedDescription);
            failure(error);
        }];
    }
}

- (void)requestWithPath:(NSString *)url method:(NSString *)method params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self requestWithString:url method:method params:params success:success failure:failure];
}


- (void)uploadWithPath:(NSString *)path params:(NSDictionary *)params data:(NSData *)data success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDictionary *user = [USER_DEFAULT objectForKey:@"user"];
    
    if (p[@"token"] == nil && user[@"token"] != nil) {
        p[@"token"] = user[@"token"];
    }
    
    if (p[@"id"] == nil && user[@"id"] != nil) {
        p[@"id"] = user[@"id"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@", self.apiRoot, path];
    [manager POST:url  parameters:p constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/JPEG"];
        /*
         <form action="/test/tttt" method="post" enctype="multipart/form-data">
         <label for="file">Filename:</label>
         <input type="file" name="file" id="file" />
         <br />
         <input type="submit" name="submit" value="Submit" />
         </form>
         
         array (size=1)
         'file' =>
         array (size=5)
         'name' => string 'test.jpg' (length=5)
         'type' => string 'image/JPEG' (length=9)
         'tmp_name' => string 'D:\wamp\tmp\phpDE85.tmp' (length=23)
         'error' => int 0
         'size' => int 11400
         */
    }success:^(AFHTTPRequestOperation *op, id responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject == nil) {
            NSLog(@"%@", op);
            [PXAlertView showAlertWithTitle:@"数据错误" message:@"请稍后重试"];
        } else {
            success(responseObject);
        }
    }failure:^(AFHTTPRequestOperation *op, NSError *error) {
        NSLog(@"%@", op.responseObject);
        [SVProgressHUD dismiss];
        failure(error);
//        NSLog(@"upload mp3 failed: %@", error);
//        [PXAlertView showAlertWithTitle:error.localizedDescription];
    }];
}

@end
