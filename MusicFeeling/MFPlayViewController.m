//
//  MFPlayViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFPlayViewController.h"
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
    //self.textView.text = [self stringByReplacingStringsFromDictionary:self.router];
    //self.songInfo[@"content"];
    [self getContent];
}

- (NSString *)stringByReplacingStringsFromDictionary:(NSDictionary *)dict {
    NSMutableString *string = [NSMutableString stringWithString:self.songInfo[@"content"]];
    for (NSString *target in dict) {
        [string replaceOccurrencesOfString:target withString:[dict objectForKey:target]
                                   options:0 range:NSMakeRange(0, [string length])];
    }
    return string;
}

- (void)getContent {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = self.songInfo[@"git_url"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSData dataFromBase64String:responseObject[@"content"]];
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.textView.text = content;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"%@", operation.responseObject);
    }];
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
