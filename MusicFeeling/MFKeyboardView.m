//
//  MFKeyboardView.m
//  MusicFeeling
//
//  Created by amoblin on 14/6/19.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFKeyboardView.h"
#import "UIImage+Color.h"
#import <QuartzCore/QuartzCore.h>

#define XOFFSET 15
#define YOFFSET 20
#define BUTTON_SIZE 44
#define BUTTON_PADDING_H -7
#define BUTTON_PADDING_V 15
#define BUTTON_WRAP_LINE_V -7

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MFKeyboardView()

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSArray *tonesArray;
@property (nonatomic) NSInteger type;

@property (nonatomic) BOOL isFirst;
@property (nonatomic) CGFloat currentX;
@property (nonatomic) CGFloat currentY;
@property (nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSArray *vConstraints;
@property (strong, nonatomic) NSArray *hConstraints;
@property (strong, nonatomic) UIButton *prevButton;

@end

@implementation MFKeyboardView

- (id)init {
    self = [super init];

    if (self) {
        self.isFirst = YES;
        self.type = 1; // isToneShow
        self.currentIndex = 0;
        self.currentY = YOFFSET;
        self.currentX = XOFFSET;
        self.tonesArray = @[[@"C4 D4 E4 F4 G4 A4 B4" componentsSeparatedByString:@" "]];
        //        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (NSMutableArray *)buttonArray {
    if (_buttonArray == nil) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

- (void)layoutSubviews {
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [self addConstraints:self.vConstraints];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [self addConstraints:self.hConstraints];
            break;
        default:
            break;
    }
    [super layoutSubviews];
}

- (NSArray *)vConstraints {
    if (_vConstraints == nil) {
        _vConstraints = [self getConstraintsForInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
    return _vConstraints;
}

- (NSArray *)hConstraints {
    if (_hConstraints == nil) {
        _hConstraints = [self getConstraintsForInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    return _hConstraints;
}


- (NSArray *)getConstraintsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.currentY = YOFFSET;
    self.currentIndex = 0;
    for (NSArray *items in self.tonesArray) {
        self.currentX = XOFFSET;
        self.isFirst = YES;
        UIButton *button;
        for (NSString *item in items) {
            if ([item isEqualToString:@""]) {
                continue;
            }
            NSLog(@"layout item: %@", item);
            NSLog(@"create new button");
            button = [self createButtonWithTitle:item andType:self.type];
            [self addSubview:button];
            NSLog(@"button is: %@\n%@", button.titleLabel.text, button);
            if ( ! [button.titleLabel.text isEqualToString:item]) {
                NSLog(@"current item is: %@", item);
                NSLog(@"but the button is: %@", button.titleLabel.text);
                break;
            }
            [array addObjectsFromArray:[self layoutButton:button forInterfaceOrientation:interfaceOrientation]];
        }
        self.currentY += BUTTON_SIZE + BUTTON_PADDING_V;
    }
    return array;
}

- (UIButton *)createButtonWithTitle:(NSString *)title andType:(NSInteger)type {
    self.currentIndex++;
    UIButton *button = [UIButton new];
    [button addTarget:self action:@selector(toneButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(toneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(toneButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(toneButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];

    // repeat method
    [button addTarget:self action:@selector(toneButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(toneButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    //        [button.layer setBorderColor:[UIColorFromRGB(180, 180, 180) CGColor]];
    //        [button.layer setBorderColor:[UIColorFromRGB(194, 194, 194) CGColor]];
    [button.layer setBorderColor:[UIColorFromRGB(171, 211, 255) CGColor]];
    //        [button.layer setBorderColor:[UIColorFromRGB(117, 192, 255) CGColor]];

    if (type) {
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:title forState:UIControlStateNormal];
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = BUTTON_SIZE/2;
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        [button setTitle:title.lowercaseString forState:UIControlStateNormal];
        button.layer.borderWidth = 0;
        button.layer.cornerRadius = 4;
    }

    button.layer.masksToBounds = YES;
    [button setTitleColor:UIColorFromRGB(1, 1, 1) forState:UIControlStateNormal];
    //        [button setTitleColor:UIColorFromRGB(41, 140, 255) forState:UIControlStateNormal];

    //            button.backgroundColor = [UIColor blueColor];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(117, 192, 255)] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(117, 192, 255)] forState:UIControlStateSelected];
    return button;
}

- (NSArray *)layoutButton:(UIButton *)button forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    CGFloat width;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            width = [UIScreen mainScreen].bounds.size.width;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            width = [UIScreen mainScreen].bounds.size.height;
            break;
        default:
            break;
    }
    if (self.currentX + 50 > width) {
        self.currentX = XOFFSET;
        self.currentY += BUTTON_SIZE + BUTTON_WRAP_LINE_V;
        self.isFirst = YES;
    }

    if (self.isFirst) {
        self.isFirst = NO;
        NSDictionary *matrics = @{@"x":[NSNumber numberWithFloat:self.currentX],
                                  @"y": [NSNumber numberWithFloat:self.currentY],
                                  @"size": [NSNumber numberWithFloat:BUTTON_SIZE]};
        NSLog(@"%@", matrics);
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-x-[button(==size)]"
                                                                           options:0
                                                                           metrics:matrics
                                                                             views:NSDictionaryOfVariableBindings(button)]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-y-[button(==size)]"
                                                                           options:0
                                                                           metrics:matrics
                                                                             views:NSDictionaryOfVariableBindings(button)]];
    } else {
        NSDictionary *matrics = @{@"padding_h":[NSNumber numberWithFloat:BUTTON_PADDING_H],
                                  @"size": [NSNumber numberWithFloat:BUTTON_SIZE]};
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_prevButton]-padding_h-[button(==size)]" options:0 metrics:matrics views:NSDictionaryOfVariableBindings(_prevButton, button)]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==size)]" options:0 metrics:matrics views:NSDictionaryOfVariableBindings(button)]];
        [array addObject:[NSLayoutConstraint constraintWithItem:self.prevButton attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0]];
    }
    self.currentX += BUTTON_SIZE + BUTTON_PADDING_H;
    self.prevButton = button;
    return array;
}

#pragma mark - Tone Button Press Action

- (void)toneButtonTouchDragEnter:(UIButton *)sender {
    NSLog(@"%@", sender);
    NSLog(@"%s", __func__);
}
- (void)toneButtonTouchDragExit:(UIButton *)sender {
    NSLog(@"%@", sender);
    NSLog(@"%s", __func__);
}
- (void)toneButtonTouchDragInside:(UIButton *)sender {
    NSLog(@"%@", sender);
    NSLog(@"%s", __func__);
}
- (void)toneButtonTouchDragOutside:(UIButton *)sender {
    NSLog(@"%@", sender);
    NSLog(@"%s", __func__);
}

- (void)toneButtonPressed:(UIButton *)sender {
//    [self becomeFirstResponder];
    sender.backgroundColor =  UIColorFromRGB(117, 192, 255);
    [UIView animateWithDuration:0.3 animations:^(void) {
        sender.backgroundColor = [UIColor clearColor];
    }];

    /*
    NSString *toneName = sender.titleLabel.text;
    NSLog(@"%@", toneName);
    if (toneName.length > 0) {
        [self playTone:toneName];
    }
     */
}

- (void)toneButtonTouchDown:(UIButton *)sender {
//    [self becomeFirstResponder];
    NSString *toneName = sender.titleLabel.text;
    NSLog(@"%@, tag: %d", toneName, sender.tag);
    if ([self.delegate respondsToSelector:@selector(tonePressed:)]) {
        [self.delegate tonePressed:toneName];
    }
}

@end
