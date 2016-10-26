//
//  UILabel+DD.h
//  iMarboo
//
//  Created by amoblin on 15/11/20.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFonts.h"
#import "UIColor+DD.h"

@interface UILabel (DD)

+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;

- (void)setFont:(UIFont *)font andTextColor:(UIColor *)textColor;
@end
