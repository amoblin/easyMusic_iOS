//
//  MFButton.m
//  MusicFeeling
//
//  Created by amoblin on 14/6/20.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFButton.h"
#import "UIImage+Color.h"

@implementation MFButton

- (id)initWithTitle:(NSString *)title size:(NSInteger)size tag:(NSInteger)tagIndex andType:(NSInteger) type
{
    self = [super init];
    if (self) {
        // Initialization code
        UIButton *button = self;
        button.tag = tagIndex;
        //        [button.layer setBorderColor:[UIColorFromRGB(180, 180, 180) CGColor]];
        //        [button.layer setBorderColor:[UIColorFromRGB(194, 194, 194) CGColor]];
//        [button.layer setBorderColor:[UIColorFromRGB(171, 211, 255) CGColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        //        [button.layer setBorderColor:[UIColorFromRGB(117, 192, 255) CGColor]];

        if (type) {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:title forState:UIControlStateNormal];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:50];
//            [button setTitle:self.router[title.lowercaseString] forState:UIControlStateNormal];
            button.layer.borderWidth = 0;
            button.layer.cornerRadius = 4;
        }

        [button setTitleColor:UIColorFromRGB(1, 1, 1) forState:UIControlStateNormal];
        //        [button setTitleColor:UIColorFromRGB(41, 140, 255) forState:UIControlStateNormal];

        //            button.backgroundColor = [UIColor blueColor];
        button.translatesAutoresizingMaskIntoConstraints = NO;

//        [button setBackgroundImage:[UIImage  forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(117, 192, 255)] forState:UIControlStateSelected];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
