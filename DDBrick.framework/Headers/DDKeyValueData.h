//
//  DDKeyValueData.h
//  DDBrickDemo
//
//  Created by amoblin on 16/5/1.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import "DDBaseData.h"

@interface DDKeyValueData : DDBaseData

@property (nonatomic, strong) NSString *keyName;
@property (nonatomic, strong) NSString *valueName;

- (instancetype)initWithKeyName:(NSString *)keyName valueName:(NSString *)valueName;

@end

