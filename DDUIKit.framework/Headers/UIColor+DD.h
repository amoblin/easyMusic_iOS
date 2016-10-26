//
//  UIColor+DD.h
//  iMarboo
//
//  Created by amoblin on 15/12/9.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DD)

+ (UIColor *)randomColor;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHex:(uint)hex;

@end
