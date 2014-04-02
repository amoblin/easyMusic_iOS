//
//  MFPlayViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFPlayViewController.h"
#import "MFAppDelegate.h"
#import <AFNetworking.h>
#import <NSData+Base64.h>

@interface MFPlayViewController ()

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
    // Do any additional setup after loading the view.
    //self.textView.text = [self stringByReplacingString:self.songInfo[@"content"]];
    [self getContent];
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
    MFAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *path = [delegate.songsDir stringByAppendingPathComponent:self.songInfo[@"name"]];
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (content != nil) {
        self.textView.text = [self stringByReplacingString:content];
    }

    if (self.songInfo[@"git_url"] != nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = self.songInfo[@"git_url"];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *data = [NSData dataFromBase64String:responseObject[@"content"]];
            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self save:content];
            self.textView.text = [self stringByReplacingString:content];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)save:(NSString *)content {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:self.songInfo[@"name"]];
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

@end
