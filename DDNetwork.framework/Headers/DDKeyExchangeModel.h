//
//  DDKeyExchangeModel.h
//  Pods
//
//  Created by 巩鹏军 on 15/12/16.
//
//

#import <DDUIKit/DDBaseModel.h>

@protocol DDKeyExchangeModel <NSObject>
@end

@interface DDKeyExchangeModel : DDBaseModel

@property (nonatomic, assign) BOOL      encrypt;
@property (nonatomic, strong) NSString *pubKey;
@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, assign) NSInteger expireAt;

@end
