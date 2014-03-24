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

#define TOP @350
#define WHITE_WIDTH @44
#define WHITE_BUTTON_WIDTH @43
#define BLACK_WIDTH @27
#define LEFT_BLACK_WIDTH @16
#define WHITE_HEIGHT @144
#define BLACK_HEIGHT @90

@interface MFTestViewController ()

@property (nonatomic, strong) id<IDZAudioPlayer> player;
@property (nonatomic) NSInteger randomIndex;
@property (nonatomic) NSInteger randomDegree;
@property (nonatomic) NSString *toneName;
@property (nonatomic) BOOL isDone;
@property (nonatomic) BOOL shouldGetNextRandom;
@property (nonatomic) BOOL shouldRandomDegree;
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
    self.view.backgroundColor = [UIColor colorWithRed:238.0f/255 green:238.0f/255 blue:238.0f/255 alpha:1.0];
    //self.view.backgroundColor = [UIColor blueColor];
    [self.replayButton setImage:[UIImage imageNamed:@"music"] forState:UIControlStateNormal];
    [self.replayButton setImage:nil forState:UIControlStateSelected];
    [self.replayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    // test button
    /*
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
    [button setTitle:@"?" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button addTarget:self action:@selector(replayTone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(44)]-(160)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(button)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[button(44)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(button)]];

    self.toneButton = button;
    [self addDynamicEffect];
    */
    //button.transform = CGAffineTransformRotate(button.transform, 45);
    /*
    [UIView animateWithDuration:10 animations:^(void) {
        button.transform = CGAffineTransformMakeTranslation(-320, 0);
    }];
     */

    NSInteger leading = 8;
    NSArray *titleArray = @[@"C", @"D", @"E", @"F", @"G", @"A", @"B"];
    for (NSInteger i=0; i < 7; i++) {
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        button.tag = i;
        [button addTarget:self action:@selector(toneButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(button);
        NSDictionary *matrics = @{@"leading":[NSNumber numberWithInteger:leading],
                                  @"height":WHITE_HEIGHT,
                                  @"width": WHITE_BUTTON_WIDTH,
                                  @"top": TOP};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leading-[button(width)]"
                                                                          options:0
                                                                          metrics:matrics
                                                                            views:viewsDict]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[button(height)]"
                                                                          options:0
                                                                          metrics:matrics
                                                                            views:viewsDict]];
        leading += [WHITE_WIDTH integerValue];
    }

    leading = 31;
    for (NSInteger i=0; i<5;i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor blackColor];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        button.tag = 7 + i;
        [button addTarget:self action:@selector(toneButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(button);
        NSDictionary *matrics = @{@"leading":[NSNumber numberWithInteger:leading],
                                  @"height":BLACK_HEIGHT,
                                  @"width": BLACK_WIDTH,
                                  @"top": TOP};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leading-[button(width)]"
                                                                          options:0
                                                                          metrics:matrics
                                                                            views:viewsDict]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[button(height)]"
                                                                          options:0
                                                                          metrics:matrics
                                                                            views:viewsDict]];
        leading += 45;
        if (i==1) {
            leading += 45;
        }
    }
    [self getNextRandomIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.shouldRandomDegree = [[NSUserDefaults standardUserDefaults] boolForKey:@"randomDegree"];
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

- (void)addDynamicEffect {
    UIButton *button = self.replayButton;
    //UIButton *button = self.toneButton;
    UIDynamicAnimator* animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior* gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[button]];
    gravityBeahvior.magnitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"speed"];
    [animator addBehavior:gravityBeahvior];

    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[button]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [animator addBehavior:collisionBehavior];

    self.animator = animator;
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
    if (self.shouldGetNextRandom) {
        [self getNextRandomIndex];
    }
    [self playTone:self.toneName];
}

- (void) playTone:(NSString *)toneName {
    IDZTrace();
    if (self.shouldGetNextRandom) {
        [self getNextRandomIndex];
    }
    [self.player stop];
    NSError *error;
    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:toneName withExtension:@".ogg"];
    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:oggUrl error:&error];
    if (error != nil) {
        NSLog(@"%@", error);
        return;
    }
    NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);
    self.player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];

    //[self startTimer];
    [self.player play];
}

- (IBAction)getNextRandomIndex {
    UIButton *button = self.replayButton;
    CGRect frame = button.frame;
    frame.origin.y = 50;
    button.frame = frame;
    [self addDynamicEffect];

    [self.replayButton setSelected:NO];
    [self.toneButton setTitle:@"聆听" forState:UIControlStateNormal];
    self.shouldGetNextRandom = NO;
    if (self.shouldRandomDegree) {
        self.randomDegree = arc4random() % self.tonesArray.count;
    } else {
        self.randomDegree = 4;
    }

    /*
    do {
        self.randomIndex = arc4random() % [self.tonesArray[self.randomDegree] count];
        self.randomIndex = arc4random() % [self.tonesArray[self.randomDegree] count];
        self.toneName = [self.tonesArray[self.randomDegree][self.randomIndex] stringByDeletingPathExtension];
    } while( [self.toneName hasSuffix:@"m"]);
    */
    NSArray *tonesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"exerciseTones"];
    if (tonesArray == nil) {
        tonesArray = @[@"c%@", @"d%@", @"e%@", @"f%@", @"g%@", @"a%@", @"b%@"];
    }
    self.randomIndex = arc4random() % [tonesArray count];
    self.toneName = [NSString stringWithFormat:tonesArray[self.randomIndex], [NSNumber numberWithInteger:self.randomDegree]];

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
    NSArray *array = @[@"c%@", @"d%@", @"e%@", @"f%@", @"g%@", @"a%@", @"b%@", @"c%@m", @"d%@m", @"f%@m", @"g%@m", @"a%@m", @"b%@m"];
    NSString *toneName = [NSString stringWithFormat:array[sender.tag], [NSNumber numberWithInteger:self.randomDegree]];
    [self playTone:toneName];
    [self test:toneName];
}

- (void) test:(NSString *)text {
    NSString *currentTone = self.toneName;
    NSLog(@"current tone: %@", currentTone);
    NSLog(@"text: %@", text);
    if ([text isEqualToString:currentTone]) {
        [self.replayButton setTitle:currentTone forState:UIControlStateSelected];
        [self.replayButton setSelected:YES];
        [self.toneButton setTitle:currentTone forState:UIControlStateNormal];
        //NSString *msg = [NSString stringWithFormat:@"Bingo! %@", currentTone];
        //[SVProgressHUD showSuccessWithStatus:msg];
        [UIView animateWithDuration:0.5 animations:^(void) {
            self.replayButton.transform = CGAffineTransformScale(self.replayButton.transform, 3.0, 3.0);
        }completion:^(BOOL isFinished) {
            [self getNextRandomIndex];
        }];
        self.shouldGetNextRandom = YES;
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
}

#pragma mark - IDZAQPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(id<IDZAudioPlayer>)player successfully:(BOOL)flag {
    if (self.shouldGetNextRandom) {
        [self getNextRandomIndex];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(id<IDZAudioPlayer>)player error:(NSError *)error {
}

@end
