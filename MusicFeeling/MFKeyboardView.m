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

#define XOFFSET 15
#define YOFFSET 20
#define BUTTON_SIZE 44
#define BUTTON_PADDING_H -7
#define BUTTON_PADDING_V 0
#define BUTTON_WRAP_LINE_V -7

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

@property (strong, nonatomic) UIButton *delButton;
@property (strong, nonatomic) UIButton *returnButton;

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
        self.tonesArray = [NSArray arrayWithK2KString:@"C5 D5 E5 F5 G5 A5 B5\n C4 D4 E4 F4 G4 A4 B4\n C3 D3 E3 F3 G3 A3 B3"];

        self.returnButton = [UIButton new];
        [self.returnButton setTitle:@"换行" forState:UIControlStateNormal];
        [self.returnButton addTarget:self action:@selector(returnButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.returnButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.returnButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.returnButton];
        self.delButton = [UIButton new];
        [self.delButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.delButton addTarget:self action:@selector(delButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.delButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.delButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.delButton];
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
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_delButton(==44)]-2-|"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_delButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_returnButton(==44)]-2-|"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_returnButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_delButton(==44)]-[_returnButton(==44)]-5-|"
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
    MFButton *button = [[MFButton alloc] initWithTitle:title size:BUTTON_SIZE tag:0 andType:type];
    [button addTarget:self action:@selector(toneButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(toneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(toneButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(toneButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];

    // repeat method
    [button addTarget:self action:@selector(toneButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(toneButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
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
