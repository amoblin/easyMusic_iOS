//
//  MFButton.m
//  MusicFeeling
//
//  Created by amoblin on 14/6/20.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFButton.h"
#import "UIImage+Color.h"
#import "NSString+K2K.h"

@interface MFButton()

@end

@implementation MFButton

- (id)initWithTitle:(NSString *)title size:(NSInteger)size tag:(NSInteger)tagIndex andType:(NSInteger) type
{
    self = [super init];
    if (self) {
        // Initialization code
        self.tone = title;
        UIButton *button = self;
        button.tag = tagIndex;
        //        [button.layer setBorderColor:[UIColorFromRGB(180, 180, 180) CGColor]];
        //        [button.layer setBorderColor:[UIColorFromRGB(194, 194, 194) CGColor]];
//        [button.layer setBorderColor:[UIColorFromRGB(171, 211, 255) CGColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        //        [button.layer setBorderColor:[UIColorFromRGB(117, 192, 255) CGColor]];

        if (type == 0) {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:title forState:UIControlStateNormal];
        } else if (type == 1) {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:title.numberString forState:UIControlStateNormal];
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

        [button setBackgroundImage:[UIImage imageNamed:@"circle_hit"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"circle_hit"] forState:UIControlStateSelected];
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

- (void)setStyle:(NSInteger)style {
    switch (style) {
        case 0:
            self.titleLabel.font = [UIFont systemFontOfSize:14];
            [self setTitle:self.tone forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"circle"]
                            forState:UIControlStateNormal];
            break;
        case 1:
            self.titleLabel.font = [UIFont systemFontOfSize:14];
            [self setTitle:self.tone.numberString forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"circle"]
                            forState:UIControlStateNormal];
            break;
        case 2:
            self.titleLabel.font = [UIFont systemFontOfSize:50];
            [self setTitle:self.tone.keyboardString forState:UIControlStateNormal];
            [self setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        case 3:
            self.titleLabel.font = [UIFont systemFontOfSize:20];
            [self setTitle:self.tone forState:UIControlStateNormal];
            [self setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        default:
            break;
    }
//            NSString *toneName = self.titleLabel.text;
}

- (void)setCurrent:(BOOL)current {
    if (current) {
        [self setBackgroundImage:[UIImage imageNamed:@"circle_hit"] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    }
}

@end
