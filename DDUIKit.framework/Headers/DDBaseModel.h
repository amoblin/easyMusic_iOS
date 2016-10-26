//
//  DDBaseModel.h
//  iMarboo
//
//  Created by amoblin on 15/11/25.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDBaseModel : JSONModel

@property (nonatomic, assign) NSInteger errCode;

- (NSString *)errMessage;

- (void)updateWithDictionary:(NSDictionary *)dict;
- (void)updateWithModel:(DDBaseModel *)model;

- (BOOL)isValid;

+ (NSDictionary *)customKeyMapper;
@end
