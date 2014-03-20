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
#import <PXAlertView.h>

@interface MFTestViewController ()

@property (nonatomic, strong) id<IDZAudioPlayer> player;
@property (nonatomic) NSInteger randomIndex;
@property (nonatomic) NSInteger randomDegree;
@property (nonatomic) NSString *toneName;
@property (nonatomic) NSString *baseToneName;
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    self.inputField.delegate = self;

    NSInteger leading = 2;
    NSArray *titleArray = @[@"C", @"D", @"E", @"F", @"G", @"A", @"B"];
    for (NSInteger i=0; i < 7; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button addTarget:self action:@selector(toneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(button);
        NSDictionary *matrics = @{@"leading":[NSNumber numberWithInteger:leading]};
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leading-[button(44)]" options:0 metrics:matrics views:viewsDict];
        NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-300-[button(80)]" options:0 metrics:nil views:viewsDict];
        [self.view addConstraints:constraints];
        [self.view addConstraints:constraints2];
        leading += 45;
    }
    [self getNextRandomIndex];
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
    [self playTone:self.toneName];
}

- (IBAction)playBaseTone:(id)sender {
    [self playTone:self.baseToneName];
}

- (void) playTone:(NSString *)toneName {
    //IDZTrace();
    [self.player stop];
    NSError *error;
    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:toneName withExtension:@".ogg"];
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
    self.randomDegree = arc4random() % self.tonesArray.count;
    self.randomIndex = arc4random() % [self.tonesArray[self.randomDegree] count];

    self.toneName = [self.tonesArray[self.randomDegree][self.randomIndex] stringByDeletingPathExtension];
    self.baseToneName = [NSString stringWithFormat:@"c%@", [self.toneName substringWithRange:NSMakeRange(1, 1)]];
    [self replayTone:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( ! self.isDone) {
        return;
    }
    self.isDone = NO;
    [self test:[textField.text lowercaseString]];
}

- (IBAction)toneButtonPressed:(UIButton *)sender {
    [self test:[sender.titleLabel.text lowercaseString]];
}

- (void) test:(NSString *)text {
    NSString *currentTone = [self.tonesArray[self.randomDegree][self.randomIndex] stringByDeletingPathExtension];
    NSLog(@"current tone: %@", currentTone);
    NSLog(@"text: %@", text);
    if ([currentTone hasPrefix:text]) {
        NSString *msg = [NSString stringWithFormat:@"Bingo! %@", currentTone];
        if ([text isEqualToString:currentTone]) {
            [SVProgressHUD showSuccessWithStatus:msg];
            [self getNextRandomIndex];
        } else {
            [SVProgressHUD showSuccessWithStatus:msg];
            [self getNextRandomIndex];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"Try again"];
        [self replayTone:nil];
    }
}

- (IBAction)showTip:(id)sender {
    NSLog(@"%@", self.toneName);
    [PXAlertView showAlertWithTitle:@"Tip" message:self.toneName];
    //[SVProgressHUD showWith:self.toneName];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.isDone = YES;
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)tapViewAction {
    [self.inputField endEditing:YES];
}
@end
