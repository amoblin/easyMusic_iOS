//
//  NSString+K2K.m
//  MusicFeeling
//
//  Created by amoblin on 14/6/20.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "NSString+K2K.h"
#import "MFUtils.h"

@implementation NSString (K2K)

- (NSString *)numberString {
    return [MFUtils staffToNumber:self];
}

- (NSString *)keyboardString {
    return [MFUtils staffToKeyboard:self];
}

@end
