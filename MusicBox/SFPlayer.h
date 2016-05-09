//
//  SFPlayer.h
//  easyMusic
//
//  Created by amoblin on 16/5/9.
//  Copyright © 2016年 amoblin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFPlayer : NSObject

@property (nonatomic, strong) NSArray *soundFontArray;

- (void)noteOn:(NSNumber *)noteNumber velocity:(NSNumber *)velocityNumber;
- (void)loadSamplerAtIndex:(NSInteger)index;

@end
