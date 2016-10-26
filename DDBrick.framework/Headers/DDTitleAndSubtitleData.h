//
//  DDTitleAndSubtitleData.h
//  iMarboo
//
//  Created by amoblin on 16/1/28.
//  Copyright © 2016年 amoblin. All rights reserved.
//

#import "DDTitleData.h"

@interface DDTitleAndSubtitleData : DDTitleData

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) NSInteger type; // 0:top/bottom 1:left/right

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle andPressAction:(void (^)())pressAction;
@end

