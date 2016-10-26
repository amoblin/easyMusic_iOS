//
//  HJTimerBridge.h
//
//  Created by hujin on 14-2-13.
//  Copyright (c) 2014年 HJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJTimerBridge : NSObject


+ (HJTimerBridge *)timerBridgeWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector withObject:(id)object repeats:(BOOL)repeat;

- (void)invalidate;
 
- (BOOL)isValid;
@end
