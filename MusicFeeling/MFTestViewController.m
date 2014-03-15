//
//  MFTestViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFTestViewController.h"
#import "IDZOggVorbisFileDecoder.h"
#import <SVProgressHUD.h>

@interface MFTestViewController ()

@property (nonatomic, strong) id<IDZAudioPlayer> player;
@property (nonatomic) NSInteger randomIndex;
@property (nonatomic) BOOL isDone;
@end

@implementation MFTestViewController

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
    self.inputField.delegate = self;
    [self replayTone:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
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

- (IBAction)replayTone:(id)sender {
    //IDZTrace();
    [self.player stop];
    NSError *error;
    NSString *name = [self.tonesArray[self.randomIndex] stringByDeletingPathExtension];
    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@".ogg"];
    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:oggUrl error:&error];
    NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);
    self.player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
    //self.player.delegate = self;
    [self.player prepareToPlay];

    //[self startTimer];
    [self.player play];
}

- (IBAction)getNextRandomIndex {
    self.inputField.text = @"";
    self.randomIndex = arc4random() % self.tonesArray.count;
    [self replayTone:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( ! self.isDone) {
        return;
    }
    self.isDone = NO;
    NSLog(@"%@", textField.text);
    if ([textField.text isEqualToString:[self.tonesArray[self.randomIndex] stringByDeletingPathExtension]]) {
        [SVProgressHUD showSuccessWithStatus:@"Bingo!"];
        [self getNextRandomIndex];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Try again"];
        [self replayTone:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.isDone = YES;
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
@end
