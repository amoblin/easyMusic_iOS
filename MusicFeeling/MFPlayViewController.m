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

#import "PXAlertView.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <NSData+Base64.h>

@interface MFPlayViewController ()

@property (strong, nonatomic) NSString *content;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isToneShow = YES;
    for (UIGestureRecognizer *recognizer in self.textView.gestureRecognizers) {
        //[self.textView removeGestureRecognizer:recognizer];
        if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
            recognizer.enabled = NO;
        } else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [(UITapGestureRecognizer *)recognizer setNumberOfTapsRequired:1];
        }
    }
    [self.textView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPlay:)]];
    [self getContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeFirstResponder) name:@"textFieldDidEndEditingNotification" object:nil];
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
        self.content = [NSString stringWithFormat:@"%@\n", self.textView.text];
        [self saveContent:self.content atPath:path];
    }
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
            self.textView.text = self.content;
        } else {
            self.textView.text = [self stringByReplacingString:self.content];
        }
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
                self.textView.text = content;
            } else {
                self.textView.text = [self stringByReplacingString:content];
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
        return;
    }
    if ( self.isNew ) {
        if ([keyCommand.input isEqualToString:@"\r"]) {
            self.textView.text = [NSString stringWithFormat:@"%@\n", self.textView.text];
            return;
        } else if ([keyCommand.input isEqualToString:@"\b"]) {
            [self deleteLastTone];
            return;
        }
    }

    NSString *toneName = [self.mapper objectForKey:keyCommand.input];

    if (self.isNew) {
        self.content = [NSString stringWithFormat:@"%@ %@", self.textView.text, toneName];
        self.textView.text = self.content;
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
    NSString *str = self.textView.text;
    NSRange range = [str rangeOfString:@" " options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        self.textView.text = [str substringToIndex:range.location];
    }
}

- (void)tapToPlay:(UITapGestureRecognizer *)tap {
    [self becomeFirstResponder];
    if ( ! [tap.view isKindOfClass:[UITextView class]]) {
        return;
    }
    if ( ! self.isToneShow) {
        [PXAlertView showAlertWithTitle:@"需要连接蓝牙键盘" message:@"接入蓝牙键盘，然后按照内容键入"];
    }

    UITextView *subtitleView = (UITextView *)tap.view;
    subtitleView.selectedTextRange = 0;

    UITextPosition *tapPos = [subtitleView closestPositionToPoint:[tap locationInView:subtitleView]];
    UITextRange * wr = [subtitleView.tokenizer rangeEnclosingPosition:tapPos withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    NSString *toneName = [subtitleView textInRange:wr];
    NSLog(@"%@", toneName);
    if (toneName.length > 0) {
        [self playTone:toneName];
    }
}

- (IBAction)k2kButtonPressed:(UIButton *)sender {
    if (self.content == nil) {
        [PXAlertView showAlertWithTitle:@"获取内容失败" message:@"请联网，重试一次"];
        return;
    }
    self.isToneShow = ! self.isToneShow;
    if (self.isToneShow) {
        self.textView.text = self.content;
    } else {
        self.textView.text = [self stringByReplacingString:[self.content stringByAppendingString:@"\n"]];
    }
}
@end
