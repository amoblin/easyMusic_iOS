//
//  DDBaseRequest.h
//  iMarboo
//
//  Created by amoblin on 15/11/25.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDUIKit/DDBaseModel.h>
#import "DDRequestError.h"

@class DDHTTPRequestOperation;

typedef void (^DDRequestCompletionBlock)(void);

@interface DDBaseRequest : NSObject

@property (nonatomic, strong) NSString *rootUrl;
@property (nonatomic, strong) NSString *pathName;
@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) Class modelClass;

@property (nonatomic, strong) NSMutableDictionary *getParams;
@property (nonatomic, strong) NSMutableDictionary *postParams;
@property (nonatomic, strong) NSMutableDictionary *fileBodyParams;

@property (nonatomic, strong) DDBaseModel<Optional> *responseModel;
@property (nonatomic, strong) DDRequestError<Optional> *error;

@property (nonatomic, strong, readonly) DDHTTPRequestOperation *operation;

// for 3-rd server api
+ (instancetype)requestWithRootUrl:(NSString *)rootUrl
                              path:(NSString *)path
                            method:(NSString *)method
                            params:(NSDictionary *)params
                           success:(void (^)(id result))success
                           failure:(void (^)(id response, NSError *error))failure;

// for internal server api
- (instancetype)initWithRootUrl:(NSString *)rootUrl;

- (void)requestWithPath:(NSString *)path
                 method:(NSString *)method
                 params:(NSDictionary *)params
             modelClass:(Class)modelClass
                success:(void (^)(DDBaseModel *model, NSInteger statusCode))success
                failure:(void (^)(DDRequestError *error, NSInteger statusCode))failure;

- (void)requestWithCompletion:(DDRequestCompletionBlock)completion;

- (void)requestWithSuccess:(void (^)(DDBaseModel *model, id responseObject, NSInteger statusCode))success
                   failure:(void (^)(DDRequestError *error, NSInteger statusCode))failure;

- (void)cancel;

- (DDBaseModel *)responseModelWithData:(id)data;
- (NSString *)pathName;
- (NSString *)rootUrl;

@end
