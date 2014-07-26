//
//  MFPlayViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFPlayViewController.h"
#import "MFAppDelegate.h"
#import "SLNavigationItem.h"
#import "MFKeyboardView.h"
#import "MFButton.h"

#import "NSArray+K2K.h"

#import "UIImage+Color.h"
#import "UIView+AutoLayout.h"


#import "PXAlertView.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <NSData+Base64.h>
#import <QuartzCore/QuartzCore.h>

#import <AVOSCloud/AVOSCloud.h>

#define XOFFSET 10
#define YOFFSET 50
#define BUTTON_SIZE 65
#define BUTTON_PADDING_H -7
#define BUTTON_PADDING_V 15
#define BUTTON_WRAP_LINE_V -7

// (0,122,255)
@interface MFPlayViewController () <MFKeyboardDelegate>

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSMutableArray *tonesArray;
@property (strong, nonatomic) NSNumber *toneCount;
@property (strong, nonatomic) NSMutableArray *buttonPool;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) MFKeyboardView *keyboardView;
@property (strong, nonatomic) NSNumber *keyboardViewHeight;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) NSArray *vConstraints;
@property (strong, nonatomic) NSArray *hConstraints;

@property (strong, nonatomic) NSMutableArray *toneButtonsArray;
@property (strong, nonatomic) UIButton *prevButton;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) NSInteger currentLine;
@property (nonatomic) BOOL isFirst;
@property (nonatomic) CGFloat currentX;
@property (nonatomic) CGFloat lastX;
@property (nonatomic) CGFloat currentY;

@property (nonatomic) NSInteger currentLine_H;
@property (nonatomic) BOOL isFirst_H;
@property (nonatomic) CGFloat currentX_H;
@property (nonatomic) CGFloat lastX_H;
@property (nonatomic) CGFloat currentY_H;

@property (nonatomic) NSInteger toneStyle;
@end

@implementation MFPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)toneButtonsArray {
    if (_toneButtonsArray == nil) {
        _toneButtonsArray = [[NSMutableArray alloc] init];
    }
    return _toneButtonsArray;
}

- (NSMutableArray *)buttonPool {
    if (_buttonPool == nil) {
        _buttonPool = [[NSMutableArray alloc] init];
    }
    return _buttonPool;
}

- (NSString *)content {
    if (_content == nil) {
        if (self.isNew) {
            _content = @"";
        }
    }
    return _content;
}

- (NSMutableArray *)tonesArray {
    if (_tonesArray == nil) {
        _tonesArray = [NSMutableArray arrayWithArray:[NSArray arrayWithK2KString:self.content]];
    }
    return _tonesArray;
}

- (NSNumber *)toneCount {
    if (_toneCount == nil) {
        NSUInteger count = 0;
        for (NSArray *item in self.tonesArray) {
            count += item.count;
        }
        _toneCount = [NSNumber numberWithInteger:count];
    }
    return _toneCount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isNew) {
        self.UMPageName = @"创作曲目";
        self.keyboardViewHeight = @152;
    } else if ([self.songInfo[@"isComposed"] boolValue]) {
        self.UMPageName = @"修改详情";
        self.keyboardViewHeight = @152;
    } else {
        self.UMPageName = @"曲目详情";
        self.keyboardViewHeight = @0;
    }

    self.isFirst = YES;
    self.currentIndex = 0;
    self.currentY = YOFFSET;
    self.currentX = XOFFSET;

    self.toneStyle = 0;
    self.view.backgroundColor = [UIColor whiteColor];

    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;

    self.scrollView = [UIScrollView autolayoutView];
//    self.scrollView.backgroundColor = [UIColor grayColor];

    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.autoresizesSubviews = YES;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    self.keyboardView = [MFKeyboardView autolayoutView];
    self.keyboardView.tag = 1;
    self.keyboardView.interfaceOrientation = self.interfaceOrientation;
    self.keyboardView.delegate = self;
    [self.view addSubview:self.keyboardView];

    if (self.isNew) {
        self.infoLabel = [UILabel autolayoutView];
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.text = @"使用底部的键盘或连接蓝牙键盘，\n按键来谱曲";
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:self.infoLabel];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.infoLabel attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_infoLabel(==300)]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(_infoLabel)]];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_infoLabel(==50)]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(_infoLabel)]];
    } else {
        NSArray *items = @[@"音符", @"键盘"];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:segmentedControl];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:segmentedControl attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[segmentedControl(==300)]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(segmentedControl)]];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[segmentedControl(==30)]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(segmentedControl)]];

    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeFirstResponder) name:@"textFieldDidEndEditingNotification" object:nil];
    if ([self.songInfo[@"isComposed"] boolValue]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(releaseButtonPressed:)];
    }
}

- (void)viewWillLayoutSubviews {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_scrollView, _keyboardView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_keyboardView]-0-|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]-0-[_keyboardView(==height)]-0-|"
                                                                      options:0
                                                                      metrics:@{@"height": self.keyboardViewHeight}
                                                                        views:viewsDictionary]];
    [super viewWillLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ( ! self.isNew) {
        [self getContent];
    }

//    CGFloat height = MAX(self.scrollView.frame.size.height, self.currentY  + BUTTON_SIZE + BUTTON_PADDING_V);
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.textField.delegate = self;
    self.scrollView.delegate = self;
}

- (NSString *)findFinalPath:(NSString *)path {
    NSInteger i = 2;
    NSString *temp = [path stringByAppendingPathExtension:@"k2k.txt"];
    while ([[NSFileManager defaultManager] fileExistsAtPath:temp]) {
        temp = [NSString stringWithFormat:@"%@-%d.k2k.txt", path, i];
        i++;
    }
    return temp;
}

- (void)viewWillDisappear:(BOOL)animated {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path;
    [SVProgressHUD dismiss];
    BOOL shouldSave = NO;
    if (self.isNew) {
        NSString *name = self.textField.text;
        if ([name isEqualToString:@""]) {
            name = @"新曲目";
        }
        path = [delegate.composedDir stringByAppendingPathComponent:name];
        path = [self findFinalPath:path];
        if ( ! [self.content isEqualToString:@""]) {
            shouldSave = YES;
        }
    } else if ([self.songInfo[@"isComposed"] boolValue]) {
        path = [self fetchPath];
        shouldSave = YES;
    }
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if (shouldSave) {
            [self saveContent:self.content atPath:path];
        }
    }
    self.textField.delegate = nil;
    self.scrollView.delegate = nil;
}

- (NSString *)fetchPath {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path = [delegate.composedDir stringByAppendingPathComponent:self.songInfo[@"path"]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    NSString *name = self.textField.text;
    if ( ! [name isEqualToString:@""] &&  ! [name isEqualToString:self.songInfo[@"name"]]) {
        path = [delegate.composedDir stringByAppendingPathComponent:name];
        path = [self findFinalPath:path];
    }
    return path;
}

- (MFButton *)createButtonWithTitle:(NSString *)title andType:(NSInteger)type {
    self.currentIndex++;
    if (self.buttonPool.count > 0) {
        MFButton *button = self.buttonPool[0];
        [self.buttonPool removeObjectAtIndex:0];
        return button;
    } else {
        MFButton *button = [[MFButton alloc] initWithTitle:title size:BUTTON_SIZE tag:self.currentIndex andType:type];
        [button addTarget:self action:@selector(toneButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        /*
        [button addTarget:self action:@selector(toneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(toneButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(toneButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];

        // repeat method
        [button addTarget:self action:@selector(toneButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self action:@selector(toneButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
         */
        return button;
    }
}

- (NSArray *)layoutButton:(UIButton *)button forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    CGFloat width, currentX, currentY;
    BOOL isFirst;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            width = [UIScreen mainScreen].bounds.size.width;
            // 测试添加后是否越界
            if (self.currentX + BUTTON_SIZE + BUTTON_PADDING_H > width) {
                self.lastX = self.currentX;
                self.currentX = XOFFSET;
                self.currentY += BUTTON_SIZE + BUTTON_WRAP_LINE_V;
                self.isFirst = YES;
            }
            currentX = self.currentX;
            currentY = self.currentY;
            isFirst = self.isFirst;

            // 为添加下一个做准备
            self.currentX += BUTTON_SIZE + BUTTON_PADDING_H;
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            width = [UIScreen mainScreen].bounds.size.height;
            // 测试添加后是否越界
            if (self.currentX_H + BUTTON_SIZE + BUTTON_PADDING_H > width) {
                self.lastX_H = self.currentX_H;
                self.currentX_H = XOFFSET;
                self.currentY_H += BUTTON_SIZE + BUTTON_WRAP_LINE_V;
                self.isFirst_H = YES;
            }
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
    if (isFirst) {
        self.isFirst = NO;
        self.isFirst_H = NO;
        NSDictionary *matrics = @{@"x":[NSNumber numberWithFloat:currentX],
                                  @"y": [NSNumber numberWithFloat:currentY],
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
    self.prevButton = button;
    return array;
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
        UIButton *button;
        for (NSString *item in items) {
            if ([item isEqualToString:@""]) {
                continue;
            }
            NSLog(@"layout item: %@", item);
            button = (UIButton *)[self.scrollView viewWithTag:self.currentIndex+1];
            if (button == nil) {
                NSLog(@"create new button");
                button = [self createButtonWithTitle:item andType:self.toneStyle];
                [self.scrollView addSubview:button];
            } else {
                self.currentIndex++;
            }
            NSLog(@"button is: %@\n%@", button.titleLabel.text, button);
            if ( ! [button.titleLabel.text isEqualToString:item]) {
                NSLog(@"current item is: %@", item);
                NSLog(@"but the button is: %@", button.titleLabel.text);
                break;
            }
            [array addObjectsFromArray:[self layoutButton:button forInterfaceOrientation:interfaceOrientation]];
        }
    }
    return array;
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

- (void)layoutButtonsWithContent:(NSString *)content {
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [self.scrollView addConstraints:self.vConstraints];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [self.scrollView addConstraints:self.hConstraints];
            break;
        default:
            break;
    }
//    CGFloat height = MAX(self.scrollView.frame.size.height, self.currentY + BUTTON_SIZE + BUTTON_PADDING_V);
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
}

- (NSString *)stringByReplacingString:(NSString *)str {
    NSMutableString *string = [NSMutableString stringWithString:str];
    for (NSString *target in self.router) {
        NSString *t = [NSString stringWithFormat:@"%@ ", target];
        [string replaceOccurrencesOfString:t
                                withString:[NSString stringWithFormat:@"%@ ",[self.router objectForKey:target]]
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(0, [string length])];

        t = [NSString stringWithFormat:@"%@\n", target];
        [string replaceOccurrencesOfString:t
                                withString:[NSString stringWithFormat:@"%@\n",[self.router objectForKey:target]]
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(0, [string length])];

        t = [NSString stringWithFormat:@"%@-", target];
        [string replaceOccurrencesOfString:t
                                withString:[NSString stringWithFormat:@"%@-",[self.router objectForKey:target]]
                                   options:NSCaseInsensitiveSearch
                                     range:NSMakeRange(0, [string length])];
    }
    return string;
}

- (void)getContent {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path;
    if ([self.songInfo[@"isComposed"] boolValue]) {
        path = [delegate.composedDir stringByAppendingPathComponent:self.songInfo[@"path"]];
    } else {
        path = [delegate.localDir stringByAppendingPathComponent:self.songInfo[@"path"]];
    }
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
        self.content = content;
        if (self.toneStyle == 0) {
            [self layoutButtonsWithContent:self.content];
        } else {
            // show computer keyboard
        }
    }

    if ( ! [self.songInfo[@"isComposed"] boolValue]) {
        if (self.content == nil) {
            [SVProgressHUD show];
        }
        AVFile *file = self.songInfo[@"contentFile"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            [SVProgressHUD dismiss];
            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (self.content == nil) {
                self.content = content;
                if (self.toneStyle == 0) {
                    [self layoutButtonsWithContent:self.content];
                } else {
                }
            }
            [self saveContent:content atPath:path];
        } progressBlock:nil];
    }
}

/*
- (void)getContent {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path;
    if ([self.songInfo[@"isComposed"] boolValue]) {
        path = [delegate.composedDir stringByAppendingPathComponent:self.songInfo[@"path"]];
    } else {
        path = [delegate.localDir stringByAppendingPathComponent:self.songInfo[@"path"]];
    }
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
        self.content = content;
        if (self.isToneShow) {
            [self layoutButtonsWithContent:self.content];
        } else {
            // show computer keyboard
        }
    }

    if ( ! [self.songInfo[@"isComposed"] boolValue]) {
        if (self.content == nil) {
            [SVProgressHUD show];
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSString *url = [NSString stringWithFormat:@"http://apion.github.io/k2k/%@", self.songInfo[@"path"]];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [SVProgressHUD dismiss];
//            NSData *data = [NSData dataFromBase64String:responseObject[@"content"]];
//            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            [self saveContent:content atPath:path];
//            if (self.content == nil) {
//                self.content = content;
//                if (self.isToneShow) {
//                    [self layoutButtonsWithContent:self.content];
//                } else {
//                }
//            }
            [SVProgressHUD dismiss];
            [self saveContent:operation.responseString atPath:path];
            if (self.content == nil) {
                self.content = operation.responseString;
                if (self.isToneShow) {
                    [self layoutButtonsWithContent:self.content];
                } else {
                }
            }
        }];
    }
}
 */

- (void)saveContent:(NSString *)content atPath:(NSString *)path {
    NSError *error = nil;
    [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) {
        NSLog(@"%@", error);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addToContent:(NSString *)toneName {
    self.content = [NSString stringWithFormat:@"%@ %@", self.content, toneName];
//    self.tonesArray[self.currentLine]
}

- (void) adjustOffsetWithFlag:(BOOL)flag {
    CGFloat height;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        height = MAX(self.scrollView.frame.size.height, self.currentY + BUTTON_SIZE + BUTTON_PADDING_V);
    } else {
        height = MAX(self.scrollView.frame.size.height, self.currentY_H + BUTTON_SIZE + BUTTON_PADDING_V);
    }
    if (flag) {
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,  height);
    }

    CGFloat offset = height - self.scrollView.bounds.size.height;
    CGPoint bottomOffset = CGPointMake(0, offset);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
}

- (void)addTone:(NSString *)toneName {
    [self addToContent:toneName];
    UIButton *button = [self createButtonWithTitle:toneName andType:self.toneStyle];
    [self.scrollView addSubview:button];
    [self.scrollView addConstraints:[self layoutButton:button forInterfaceOrientation:self.interfaceOrientation]];

    [self adjustOffsetWithFlag:YES];
}

- (void)keyPressed:(UIKeyCommand *)keyCommand {
    [super keyPressed:keyCommand];
    NSLog(@"keyCommand input is: %@", keyCommand.input);
    if ([keyCommand.input isEqualToString:@" "]) {
        CGFloat offset;
        if (keyCommand.modifierFlags == UIKeyModifierShift) {
            offset = self.scrollView.contentOffset.y - self.scrollView.frame.size.height * 0.8;
            if ( offset <= 0) {
                offset = 0;
            }
        } else {
            offset = self.scrollView.contentOffset.y + self.scrollView.frame.size.height * 0.8;
            if (offset + self.scrollView.bounds.size.height > self.scrollView.contentSize.height) {
                offset = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
            }
        }
        self.scrollView.contentOffset = CGPointMake(0, offset);
        return;
    }
    if (self.isNew || [self.songInfo[@"isComposed"] boolValue]) {
        [self.infoLabel setHidden:YES];
        if ([keyCommand.input isEqualToString:@"\r"]) {
            [self addReturnTone];
            return;
        } else if ([keyCommand.input isEqualToString:@"\b"]) {
            [self deleteLastTone];
            return;
        }
    }

    NSString *toneName = [self.mapper objectForKey:keyCommand.input];
    if (self.isNew || [self.songInfo[@"isComposed"] boolValue]) {
        [self addTone:toneName];
    }
}

- (void)addReturnTone {
    self.content = [NSString stringWithFormat:@"%@\n", self.content];

    self.isFirst = YES;
    self.lastX = self.currentX;
    self.currentX = XOFFSET;
    self.currentY += BUTTON_SIZE + BUTTON_PADDING_V;

    self.isFirst_H = YES;
    self.lastX_H = self.currentX_H;
    self.currentX_H = XOFFSET;
    self.currentY_H += BUTTON_SIZE + BUTTON_PADDING_V;

    [self adjustOffsetWithFlag:YES];
}

- (void)deleteLastTone {
    NSString *str = self.content;
    if ([self.content hasSuffix:@"\n"]) {
//        [SVProgressHUD show]
        self.content = [str substringToIndex:[str length]-1];
        self.isFirst = NO;
        self.currentX = self.prevButton.frame.origin.x + BUTTON_SIZE + BUTTON_PADDING_H;
        self.currentY -= BUTTON_SIZE + BUTTON_PADDING_V;

        self.isFirst_H = NO;
        self.currentX_H = self.prevButton.frame.origin.x + BUTTON_SIZE + BUTTON_PADDING_H;
        self.currentY_H -= BUTTON_SIZE + BUTTON_PADDING_V;
    } else {
        self.currentX -= BUTTON_SIZE + BUTTON_PADDING_H;
        if (self.currentX == XOFFSET) {
            self.isFirst = YES;
        } else if (self.currentX < XOFFSET) {
            self.currentX = self.lastX - BUTTON_SIZE - BUTTON_PADDING_H;
            self.currentY -= BUTTON_SIZE + BUTTON_WRAP_LINE_V;
            self.isFirst = NO;
        }

        self.currentX_H -= BUTTON_SIZE + BUTTON_PADDING_H;
        if (self.currentX_H == XOFFSET) {
            self.isFirst_H = YES;
        } else if (self.currentX_H < XOFFSET) {
            self.currentX_H = self.lastX_H - BUTTON_SIZE - BUTTON_PADDING_H;
            self.currentY_H -= BUTTON_SIZE + BUTTON_WRAP_LINE_V;
            self.isFirst_H = NO;
        }

        NSRange range = [str rangeOfString:@" " options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            self.content = [str substringToIndex:range.location];
        }
        //    [self.buttonPool addObject:self.prevButton];
        [self.prevButton removeFromSuperview];
        if (self.currentIndex <= 1) {
            self.currentIndex = 0;

            self.isFirst = YES;
            self.currentY = YOFFSET;
            self.currentX = XOFFSET;

            self.isFirst_H = YES;
            self.currentX_H = XOFFSET;
            self.currentY_H = YOFFSET;
            return;
        }
        self.currentIndex--;
        self.prevButton = (UIButton *)[self.scrollView viewWithTag:self.currentIndex];
    }
    [self adjustOffsetWithFlag:NO];
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
    if ( self.toneStyle == 1) {
        [PXAlertView showAlertWithTitle:@"需要连接蓝牙键盘" message:@"接入蓝牙键盘，然后按照内容键入"];
        return;
    }
    sender.backgroundColor =  UIColorFromRGB(117, 192, 255);
    [UIView animateWithDuration:0.3 animations:^(void) {
        sender.backgroundColor = [UIColor clearColor];
    }];
}

- (void)toneButtonTouchDown:(UIButton *)sender {
//    [self becomeFirstResponder];
    if ( self.toneStyle == 1) {
        return;
    }

    NSString *toneName = sender.titleLabel.text;
//    NSLog(@"%@, tag: %ll", toneName, sender.tag);
    if (toneName.length > 0) {
        [self playTone:toneName];
        self.playCount++;
        if (sender.tag >= self.toneCount.integerValue && self.playCount >= self.toneCount.integerValue) {
            [SVProgressHUD showSuccessWithStatus:@"Perfect!"];
//            [SVProgressHUD showImage:[UIImage imageNamed:@"star"] status:nil];
            self.playCount = 0;
        }
    }
}

/*
- (NSString *)getTappedContent:(UITextView *)textView {
    UITextView *subtitleView = (UITextView *)tap.view;
    subtitleView.selectedTextRange = 0;

    UITextPosition *tapPos = [subtitleView closestPositionToPoint:[tap locationInView:subtitleView]];
    UITextRange * wr = [subtitleView.tokenizer rangeEnclosingPosition:tapPos withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    NSString *toneName = [subtitleView textInRange:wr];
}
 */

- (void)tone2computer {
    NSLog(@"%@", self.scrollView.subviews);
    for (id item in self.scrollView.subviews) {
        if ([[item class] isSubclassOfClass:[UIButton class]]) {
            UIButton *button = item;
            NSString *toneName = button.titleLabel.text;
            button.titleLabel.font = [UIFont systemFontOfSize:50];
            [button setTitle:self.router[toneName.lowercaseString] forState:UIControlStateNormal];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }
        //
    }
}

- (void)computer2tone {
    NSLog(@"%@", self.scrollView.subviews);
    for (id item in self.scrollView.subviews) {
        if ([[item class] isSubclassOfClass:[UIButton class]]) {
            UIButton *button = item;
            NSString *computerKey = button.titleLabel.text;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:self.mapper[computerKey] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)releaseButtonPressed:(UIButton *)sender {
    if (self.content == nil) {
        [PXAlertView showAlertWithTitle:@"获取内容失败" message:@"请联网，重试一次"];
        return;
    }

    NSString *path = [self fetchPath];
    [self saveContent:self.content atPath:path];

    NSData *data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    AVFile *file = [AVFile fileWithName:self.songInfo[@"name"] data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            AVQuery *query = [AVQuery queryWithClassName:@"Config"];
            AVObject *config = [query getFirstObject];
//            [song setObject:@"amoblin" forKey:@"author"];
//            [song setObject:@"0" forKey:@"isPublic"];
//            [song setObject:[NSDate date] forKey:@"createdAt"];
//            [song setObject:@"123" forKey:@"mtime"];
            [(AVObject *)self.songInfo setObject:@NO forKey:@"isComposed"];
            [(AVObject *)self.songInfo setObject:file forKey:@"contentFile"];
            [(AVObject *)self.songInfo setObject:config[@"isDefaultHidden"] forKey:@"isHidden"];
            [(AVObject *)self.songInfo setObject:self.uuid forKey:@"userUUID"];
            [(AVObject *)self.songInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [PXAlertView showAlertWithTitle:@"发布成功！" message:@"返回刷新即可看到"];
            }];
        }
    }];
}

#pragma mark - Rotate Deleagate

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [self.scrollView removeConstraints:self.scrollView.constraints];
            [self.scrollView addConstraints:self.vConstraints];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [self.scrollView removeConstraints:self.scrollView.constraints];
            [self.scrollView addConstraints:self.hConstraints];
            break;
        default:
            break;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGFloat height;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        height = MAX(self.scrollView.frame.size.height, self.currentY + BUTTON_SIZE + BUTTON_PADDING_V);
    } else {
        height = MAX(self.scrollView.frame.size.height, self.currentY_H + BUTTON_SIZE + BUTTON_PADDING_V);
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,  height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"contentsize: %f, offset: %f", scrollView.contentSize.height, scrollView.contentOffset.y);
    if (scrollView.contentSize.height == 0) {
        CGFloat height;
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            height = MAX(self.scrollView.frame.size.height, self.currentY + BUTTON_SIZE + BUTTON_PADDING_V);
        } else {
            height = MAX(self.scrollView.frame.size.height, self.currentY_H + BUTTON_SIZE + BUTTON_PADDING_V);
        }
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    }
}

#pragma mark - MFKeyboard View Delegate

- (void)tonePressed:(NSString *)toneName {
    [self playTone:toneName];
    if (self.isNew || [self.songInfo[@"isComposed"] boolValue]) {
        [self.infoLabel setHidden:YES];
        [self addTone:toneName];
    }
}

- (void)deleteButtonPressed {
    [self deleteLastTone];
}

- (void)returnButtonPressed {
    [self addReturnTone];
}

- (void)valueChangedAction:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self computer2tone];
            break;
        case 1:
            [self tone2computer];
            break;
        case 2:
            break;
        default:
            break;
    }
}

@end
