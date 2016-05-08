//
//  MFKeyboardView.m
//  MusicFeeling
//
//  Created by amoblin on 14/6/19.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFKeyboardView.h"
#import "NSArray+K2K.h"
#import "MFButton.h"


#import "UIImage+Color.h"
#import <QuartzCore/QuartzCore.h>

#define XOFFSET 10
#define YOFFSET 8
#define BUTTON_SIZE 50
#define BUTTON_PADDING_H -5
#define BUTTON_PADDING_V 0
#define BUTTON_WRAP_LINE_V -7

@interface MFKeyboardView()

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSArray *tonesArray;

@property (nonatomic) BOOL isFirst;
@property (nonatomic) CGFloat currentX;
@property (nonatomic) CGFloat lastX;
@property (nonatomic) CGFloat currentY;

@property (nonatomic) BOOL isFirst_H;
@property (nonatomic) CGFloat currentX_H;
@property (nonatomic) CGFloat lastX_H;
@property (nonatomic) CGFloat currentY_H;


@property (nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSArray *vConstraints;
@property (strong, nonatomic) NSArray *hConstraints;
@property (strong, nonatomic) UIButton *prevButton;

@property (strong, nonatomic) UIButton *delButton;
@property (strong, nonatomic) UIButton *returnButton;

@end

@implementation MFKeyboardView

- (id)init {
    self = [super init];

    if (self) {
        self.isFirst = YES;
        self.keyboardType = [[NSUserDefaults standardUserDefaults] integerForKey:@"keyboardType"];
        self.currentIndex = 0;
        self.currentY = YOFFSET;
        self.currentX = XOFFSET;
        self.tonesArray = [NSArray arrayWithK2KString:@"C6 D6 E6 F6 G6 A6 B6\n\
                           C5 D5 E5 F5 G5 A5 B5\n\
                           C4 D4 E4 F4 G4 A4 B4\n\
                           C3 D3 E3 F3 G3 A3 B3"];

        self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.delButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self.delButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self.delButton addTarget:self action:@selector(delButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.delButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.delButton setBackgroundColor:[UIColor grayColor]];
        self.delButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.delButton];

        self.returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.returnButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [self.returnButton setImageEdgeInsets:UIEdgeInsetsMake(15, 10, 10, 15)];
        [self.returnButton addTarget:self action:@selector(returnButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.returnButton setTitle:@"换行" forState:UIControlStateNormal];
//        [self.returnButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.returnButton setBackgroundColor:[UIColor grayColor]];
        self.returnButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.returnButton];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
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
    /*
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_delButton(==44)]"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_delButton)]];
     */
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_delButton(==44)]-0-|"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_delButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_returnButton(==44)]-0-|"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_returnButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_delButton(==44)]-(50)-[_returnButton(==44)]"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_delButton, _returnButton)]];
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
    self.currentIndex = 0;
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.currentY = YOFFSET;
        if (self.tonesArray.count > 0) {
            self.currentY -= BUTTON_SIZE + BUTTON_PADDING_V;
        }
    } else {
        self.currentY_H = YOFFSET;
        if (self.tonesArray.count > 0) {
            self.currentY_H -= BUTTON_SIZE + BUTTON_PADDING_V;
        }
    }
    for (NSArray *items in self.tonesArray) {
        if (interfaceOrientation == UIInterfaceOrientationPortrait) {
            self.currentX = XOFFSET;
            self.currentY += BUTTON_SIZE + BUTTON_PADDING_V;
            self.isFirst = YES;
        } else {
            self.currentX_H = XOFFSET;
            self.currentY_H += BUTTON_SIZE + BUTTON_PADDING_V;
            self.isFirst_H = YES;
        }
        MFButton *button;
        NSInteger index = 1;
        for (NSString *item in items) {
            if ([item isEqualToString:@""]) {
                continue;
            }
            button = [self createButtonWithTitle:item andType:self.keyboardType];
            [self addSubview:button];
//            NSLog(@"button is: %@\n%@", button.titleLabel.text, button);
            if ( ![button.tone isEqualToString:item]) {
                break;
            }
            [array addObjectsFromArray:[self layoutButton:button isLast:(index == items.count) forInterfaceOrientation:interfaceOrientation]];
            index += 1;
        }
    }
    return array;
}

- (MFButton *)createButtonWithTitle:(NSString *)title andType:(NSInteger)type {
    self.currentIndex++;
    MFButton *button = [[MFButton alloc] initWithTitle:title size:BUTTON_SIZE tag:0 andType:type];
    [button setBackgroundImage:[UIImage imageNamed:@"circle_gray"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toneButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    /*
    [button addTarget:self action:@selector(toneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(toneButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(toneButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:self action:@selector(toneEvent:) forControlEvents:UIControlEventAllEvents];

    // repeat method
    [button addTarget:self action:@selector(toneButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(toneButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
     */
    return button;
}

- (NSArray *)layoutButton:(UIButton *)button isLast:(BOOL)isLast forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    CGFloat width, currentX=self.currentX, currentY=self.currentY;
    BOOL isFirst;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            if (IOS_8_OR_LATER &&
                (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft
                 || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
                    width = [UIScreen mainScreen].bounds.size.height;
                } else {
                    width = [UIScreen mainScreen].bounds.size.width;
                }
            /*
            // 测试添加后是否越界
            if (self.currentX + BUTTON_SIZE + BUTTON_PADDING_H > width) {
                self.lastX = self.currentX;
                self.currentX = XOFFSET;
                self.currentY += BUTTON_SIZE + BUTTON_WRAP_LINE_V;
                self.isFirst = YES;
            }
             */
            currentX = self.currentX;
            currentY = self.currentY;
            isFirst = self.isFirst;

            // 为添加下一个做准备
            self.currentX += BUTTON_SIZE + BUTTON_PADDING_H;
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            if (IOS_8_OR_LATER &&
                (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft
                 || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
                    width = [UIScreen mainScreen].bounds.size.height;
                width = [UIScreen mainScreen].bounds.size.width;
            } else {
                width = [UIScreen mainScreen].bounds.size.height;
            }
            /*
            // 测试添加后是否越界
            if (self.currentX_H + BUTTON_SIZE + BUTTON_PADDING_H > width) {
                self.lastX_H = self.currentX_H;
                self.currentX_H = XOFFSET;
                self.currentY_H += BUTTON_SIZE + BUTTON_WRAP_LINE_V;
                self.isFirst_H = YES;
            }
             */
            currentX = self.currentX_H;
            currentY = self.currentY_H;
            isFirst = self.isFirst_H;

            // 为添加下一个做准备
            self.currentX_H += BUTTON_SIZE + BUTTON_PADDING_H;
            break;
        }
        default:
            break;
    }

    /*
    // 测试添加后是否越界
    if (self.currentX + 50 > width) {
        self.currentX = XOFFSET;
        self.currentY += BUTTON_SIZE + BUTTON_WRAP_LINE_V;
        self.isFirst = YES;
    }
     */

    if (isFirst) {
        self.isFirst = NO;
        self.isFirst_H = NO;
        NSDictionary *matrics = @{@"x":[NSNumber numberWithFloat:currentX],
                                  @"y": [NSNumber numberWithFloat:currentY],
                                  @"size": [NSNumber numberWithFloat:BUTTON_SIZE]};
//        NSLog(@"%@", matrics);
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-x-[button(<=size)]"
                                                                           options:0
                                                                           metrics:matrics
                                                                             views:NSDictionaryOfVariableBindings(button)]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-y-[button(<=size)]"
                                                                           options:0
                                                                           metrics:matrics
                                                                             views:NSDictionaryOfVariableBindings(button)]];
    } else {
        NSDictionary *matrics = @{@"padding_h":[NSNumber numberWithFloat:BUTTON_PADDING_H],
                                  @"size": [NSNumber numberWithFloat:BUTTON_SIZE]};
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_prevButton]-padding_h-[button(<=size)]" options:0 metrics:matrics views:NSDictionaryOfVariableBindings(_prevButton, button)]];
        [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(<=size)]" options:0 metrics:matrics views:NSDictionaryOfVariableBindings(button)]];
        [array addObject:[NSLayoutConstraint constraintWithItem:self.prevButton attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0]];
        [array addObject:[NSLayoutConstraint constraintWithItem:self.prevButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [array addObject:[NSLayoutConstraint constraintWithItem:self.prevButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    }
    
    if (isLast) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:button.superview  attribute:NSLayoutAttributeRight multiplier:1.0 constant:-44];
        [array addObject:constraint];
    }

    [array addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];

//    self.currentX += BUTTON_SIZE + BUTTON_PADDING_H;
    self.prevButton = button;
    return array;
}

#pragma mark - Tone Button Press Action

- (void)toneButtonTouchDragEnter:(UIButton *)sender {
    NSLog(@"%s", __func__);
}
- (void)toneButtonTouchDragExit:(UIButton *)sender {
    NSLog(@"%s", __func__);
}
- (void)toneButtonTouchDragInside:(UIButton *)sender {
    NSLog(@"%s", __func__);
}
- (void)toneButtonTouchDragOutside:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

- (void)toneEvent:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

- (void)toneButtonPressed:(UIButton *)sender {
    NSLog(@"%s", __func__);
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

- (void)toneButtonTouchDown:(MFButton *)sender {
    NSLog(@"%s", __func__);
//    [self becomeFirstResponder];
    [sender setHighlighted:YES];
    NSString *toneName = sender.tone;
    NSLog(@"%@, tag: %@", toneName, @(sender.tag));
    if ([self.delegate respondsToSelector:@selector(tonePressed:)]) {
        [self.delegate tonePressed:toneName];
    }
}

- (void)delButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteButtonPressed)]) {
        [self.delegate deleteButtonPressed];
    }
}

- (void)returnButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(returnButtonPressed)]) {
        [self.delegate returnButtonPressed];
    }
}

@end
