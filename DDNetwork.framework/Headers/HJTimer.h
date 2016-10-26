//
//  HJTimer.h
//
//  Created by hujin on 14-2-13.
//  Copyright (c) 2014年 HJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJTimer : NSObject
+ (HJTimer*)timeWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector withObject:(id)object repeats:(BOOL)repeat;

@end
