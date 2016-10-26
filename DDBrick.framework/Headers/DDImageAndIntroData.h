//
//  DDImageAndIntroData.h
//  iMarboo
//
//  Created by amoblin on 15/12/9.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "DDBaseData.h"

@interface DDImageAndIntroData : DDBaseData

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *left;
@property (nonatomic, strong) NSString *center;
@property (nonatomic, strong) NSString *right;

- (instancetype)initWithLeft:(NSString *)left center:(NSString *)center right:(NSString *)right;
@end

