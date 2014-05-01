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

#import "UIImage+Color.h"

#import "PXAlertView.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <NSData+Base64.h>
#import <QuartzCore/QuartzCore.h>

#define XOFFSET 15
#define YOFFSET 20
#define BUTTON_SIZE 65
#define BUTTON_PADDING_H -7
#define BUTTON_PADDING_V 10
#define BUTTON_WRAP_LINE_V 2

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// (0,122,255)
@interface MFPlayViewController ()

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *tonesArray;
@property (strong, nonatomic) NSMutableArray *buttonPool;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) BOOL isToneShow;
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

- (NSMutableArray *)buttonPool {
    if (_buttonPool == nil) {
        _buttonPool = [[NSMutableArray alloc] init];
    }
    return _buttonPool;
}

- (NSArray *)tonesArray {
    if (_tonesArray == nil) {
        NSString *content = self.content;
        NSRange currentRange;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        unsigned length = [content length];
        unsigned paraStart = 0, paraEnd = 0, contentsEnd = 0;
        //    NSMutableArray *array = [NSMutableArray array];
        while (paraEnd < length)
        {
            [content getParagraphStart:&paraStart end:&paraEnd
                           contentsEnd:&contentsEnd forRange:NSMakeRange(paraEnd, 0)];
            currentRange = NSMakeRange(paraStart, contentsEnd - paraStart);
            NSString *line = [content substringWithRange:currentRange];
            NSLog(@"%@", line);
            NSArray *items = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -"]];
            NSLog(@"%@", items);
            [array addObject:items];
        }
        _tonesArray = [NSArray arrayWithArray:array];
    }
    return _tonesArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isToneShow = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] init];
//    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
//    self.scrollView.contentSize = CGSizeMake(320, 480);
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.autoresizesSubviews = YES;
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_scrollView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]-0-|" options:0 metrics: 0 views:viewsDictionary]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeFirstResponder) name:@"textFieldDidEndEditingNotification" object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"k2k" style:UIBarButtonItemStylePlain target:self action:@selector(k2kButtonPressed:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path;
    [SVProgressHUD dismiss];
    if (self.isNew) {
        SLNavigationItem *item = (SLNavigationItem *)self.navigationItem;
        path = [delegate.composedDir stringByAppendingPathComponent:item.textField.text];
    } else if ([self.songInfo[@"isComposed"] boolValue]) {
        path = [delegate.composedDir stringByAppendingPathComponent:self.songInfo[@"name"]];
    } else {
        path = [delegate.localDir stringByAppendingPathComponent:self.songInfo[@"name"]];
    }
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
//        self.content = [NSString stringWithFormat:@"%@\n", self.textView.text];
        [self saveContent:self.content atPath:path];
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title andType:(NSInteger)type {
    if (self.buttonPool.count > 0) {
        UIButton *button = self.buttonPool[0];
        [self.buttonPool removeObjectAtIndex:0];
        return button;
    } else {
        UIButton *button = [UIButton new];
        [button addTarget:self action:@selector(toneButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(toneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(toneButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(toneButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(toneButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self action:@selector(toneButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [button.layer setBorderColor:[UIColorFromRGB(180, 180, 180) CGColor]];

        if (type) {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:title forState:UIControlStateNormal];
            button.layer.borderWidth = 1.0f;
            button.layer.cornerRadius = BUTTON_SIZE/2;
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:50];
            [button setTitle:self.router[title.lowercaseString] forState:UIControlStateNormal];
            button.layer.borderWidth = 0;
            button.layer.cornerRadius = 4;
        }

        button.layer.masksToBounds = YES;
        [button setTitleColor:UIColorFromRGB(1, 1, 1) forState:UIControlStateNormal];

        //            button.backgroundColor = [UIColor blueColor];
        button.translatesAutoresizingMaskIntoConstraints = NO;

        [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(117, 192, 255)] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(117, 192, 255)] forState:UIControlStateSelected];
        return button;
    }
}

- (void)layoutButtonsWithContent:(NSString *)content {
    NSInteger index = 0;
    for (UIView *view in self.scrollView.subviews) {
        if ([[view class] isSubclassOfClass:[UIButton class]]) {
            break;
            //[view removeFromSuperview];
            //[self.buttonPool addObject:view];
        }
        index++;
    }

    CGFloat x, y;
    y = YOFFSET;
    for (NSArray *items in self.tonesArray) {
        x = XOFFSET;
        BOOL isFirst = YES;
        UIButton *preButton, *button;
        for (NSString *item in items) {
            if ([item isEqualToString:@""]) {
                continue;
            }
            if (index < self.scrollView.subviews.count) {
                button = self.scrollView.subviews[index];
            } else {
                button = [self createButtonWithTitle:item andType:self.isToneShow];
                [self.scrollView addSubview:button];
            }
            [button removeConstraints:button.constraints];

            if (x+50 > self.scrollView.frame.size.width) {
                x = XOFFSET;
                y += BUTTON_SIZE + BUTTON_WRAP_LINE_V;
                isFirst = YES;
            }

            if (isFirst) {
                isFirst = NO;
            NSDictionary *matrics = @{@"x":[NSNumber numberWithFloat:x],
                                      @"y": [NSNumber numberWithFloat:y],
                                      @"size": [NSNumber numberWithFloat:BUTTON_SIZE]};
            NSLog(@"%@", matrics);
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-x-[button(==size)]"
                                                                             options:0
                                                                             metrics:matrics
                                                                               views:NSDictionaryOfVariableBindings(button)]];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-y-[button(==size)]"
                                                                                    options:0
                                                                                    metrics:matrics
                                                                                      views:NSDictionaryOfVariableBindings(button)]];
            } else {
            NSDictionary *matrics = @{@"padding_h":[NSNumber numberWithFloat:BUTTON_PADDING_H],
                                      @"size": [NSNumber numberWithFloat:BUTTON_SIZE]};
                [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[preButton]-padding_h-[button(==size)]" options:0 metrics:matrics views:NSDictionaryOfVariableBindings(preButton, button)]];
                [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==size)]" options:0 metrics:matrics views:NSDictionaryOfVariableBindings(button)]];
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:preButton attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0]];
            }
            preButton = button;
            x += BUTTON_SIZE + BUTTON_PADDING_H;
            index++;
        }
        index++;
        y += BUTTON_SIZE + BUTTON_PADDING_V;
    }
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, y + 20);
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
        path = [delegate.composedDir stringByAppendingPathComponent:self.songInfo[@"name"]];
    } else {
        path = [delegate.localDir stringByAppendingPathComponent:self.songInfo[@"name"]];
    }
    NSError *error;
    self.content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (self.content != nil) {
        if (self.isToneShow) {
            [self layoutButtonsWithContent:self.content];
        } else {
            // show computer keyboard
        }
        return;
    }

    if (self.songInfo[@"git_url"] != nil) {
        [SVProgressHUD show];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = self.songInfo[@"git_url"];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            NSData *data = [NSData dataFromBase64String:responseObject[@"content"]];
            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *path = [delegate.localDir stringByAppendingPathComponent:self.songInfo[@"name"]];
            [self saveContent:content atPath:path];
            self.content = content;
            if (self.isToneShow) {
                [self layoutButtonsWithContent:self.content];
//                self.textView.text = content;
            } else {
//                self.textView.text = [self stringByReplacingString:content];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"%@", error);
        }];
    }
}

- (void)saveContent:(NSString *)content atPath:(NSString *)path {
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths[0] stringByAppendingPathComponent:path];
     */
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)keyPressed:(UIKeyCommand *)keyCommand {
    if ([keyCommand.input isEqualToString:UIKeyInputEscape]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSLog(@"keyCommand input is: %@", keyCommand.input);
    if ([keyCommand.input isEqualToString:@" "]) {
        /*
        CGRect frame = self.textView.frame;
        frame.origin.x = 0;
        if (keyCommand.modifierFlags == UIKeyModifierShift) {
            frame.origin.y -= frame.size.height * 0.9;
            if (frame.origin.y < 0) {
                frame.origin.y = 0;
            }
        } else {
            frame.origin.y += frame.size.height * 0.9;
        }
        [self.textView scrollRectToVisible:frame animated:YES];
         */
        return;
    }
    if ( self.isNew ) {
        if ([keyCommand.input isEqualToString:@"\r"]) {
//            self.textView.text = [NSString stringWithFormat:@"%@\n", self.textView.text];
            return;
        } else if ([keyCommand.input isEqualToString:@"\b"]) {
            [self deleteLastTone];
            return;
        }
    }

    NSString *toneName = [self.mapper objectForKey:keyCommand.input];

    if (self.isNew) {
//        self.content = [NSString stringWithFormat:@"%@ %@", self.textView.text, toneName];
//        self.textView.text = self.content;
    }
    if (toneName == nil) {
        return;
    }
    switch (keyCommand.modifierFlags) {
        case UIKeyModifierAlternate:
            // b
            toneName = [self getPreviousHalfTone:toneName];
            break;
        case UIKeyModifierShift:
            // #
            toneName = [NSString stringWithFormat:@"%@m", toneName];
            break;
        default:
            break;
    }
    [self playTone:toneName];
}

- (void)deleteLastTone {
//    NSString *str = self.textView.text;
//    NSRange range = [str rangeOfString:@" " options:NSBackwardsSearch];
//    if (range.location != NSNotFound) {
//        self.textView.text = [str substringToIndex:range.location];
//    }
}

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
    if ( ! self.isToneShow) {
        [PXAlertView showAlertWithTitle:@"需要连接蓝牙键盘" message:@"接入蓝牙键盘，然后按照内容键入"];
        return;
    }

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
    if ( ! self.isToneShow) {
        return;
    }

    NSString *toneName = sender.titleLabel.text;
    NSLog(@"%@", toneName);
    if (toneName.length > 0) {
        [self playTone:toneName];
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
            button.layer.borderWidth = 0;
            button.layer.cornerRadius = 4;
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
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = BUTTON_SIZE / 2;
        }
        //
    }
}

- (IBAction)k2kButtonPressed:(UIButton *)sender {
    if (self.content == nil) {
        [PXAlertView showAlertWithTitle:@"获取内容失败" message:@"请联网，重试一次"];
        return;
    }
    self.isToneShow = ! self.isToneShow;
    if (self.isToneShow) {
//        self.textView.text = self.content;
        [self computer2tone];
    } else {
        [self tone2computer];
//        self.textView.text = [self stringByReplacingString:[self.content stringByAppendingString:@"\n"]];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self layoutButtonsWithContent:self.content];
}
@end
