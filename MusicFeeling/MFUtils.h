//
//  MFUtils.h
//  MusicFeeling
//
//  Created by amoblin on 14/10/11.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFUtils : NSObject

+ (NSString *)staffToNumber:(NSString *)staffString;
+ (NSString *)staffToKeyboard:(NSString *)staffString;

//+ (NSString *)numberToStaff:(NSString *)numberString;
//+ (NSString *)keyboardToStaff:(NSString *)keyboardString;
@end
