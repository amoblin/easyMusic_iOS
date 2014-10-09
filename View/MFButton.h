//
//  MFButton.h
//  MusicFeeling
//
//  Created by amoblin on 14/6/20.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFButton : UIButton

@property (strong, nonatomic) NSString *tone;

- (id)initWithTitle:(NSString *)title size:(NSInteger)size tag:(NSInteger)tag andType:(NSInteger) type;

- (void)setStyle:(NSInteger)style;
@end
