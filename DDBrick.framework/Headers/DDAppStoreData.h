//
//  DDAppStoreData.h
//  Marboo
//
//  Created by amoblin on 15/5/13.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import "DDBaseData.h"

@interface DDAppStoreData : DDBaseData

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, copy) void (^cateButtonPressed)();

@end

