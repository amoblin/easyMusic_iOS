//
//  MFSettingViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-22.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFSettingViewController.h"

#define TOP @350
#define WHITE_WIDTH @44
#define WHITE_BUTTON_WIDTH @43
#define BLACK_WIDTH @27
#define LEFT_BLACK_WIDTH @16
#define WHITE_HEIGHT @144
#define BLACK_HEIGHT @90

@interface MFSettingViewController ()

@end

@implementation MFSettingViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:238.0f/255 green:238.0f/255 blue:238.0f/255 alpha:1.0];

    [self.toggleRandomSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"randomDegree"]];
    [self.toggleRandomSwitch addTarget:self action:@selector(toggleRandomDegree:) forControlEvents:UIControlEventTouchUpInside];
    [self.toggleMapperSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"mapper"]];

    NSInteger leading = 8;
    NSArray *titleArray = @[@"C", @"D", @"E", @"F", @"G", @"A", @"B"];
    NSArray *tonesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"exerciseTones"];
    for (NSInteger i=0; i < 7; i++) {
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        button.tag = i;
        if ([tonesArray containsObject:[NSString stringWithFormat:@"%@%%@", [titleArray[i] lowercaseString]]]) {
            [button setSelected:YES];
        }
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

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"speed"];
}

- (IBAction) toggleRandomDegree:(UISwitch *)toggleSwitch {
    [[NSUserDefaults standardUserDefaults] setBool:toggleSwitch.isOn forKey:@"randomDegree"];
}

- (IBAction)toggleMapper:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"mapper"];
}

- (void)toneButtonPressed:(UIButton *)sender {
    [sender setSelected: ! sender.isSelected];
    NSArray *array = @[@"c%@", @"d%@", @"e%@", @"f%@", @"g%@", @"a%@", @"b%@", @"c%@m", @"d%@m", @"f%@m", @"g%@m", @"a%@m", @"b%@m"];
    NSString *tone = array[sender.tag];
    NSMutableArray *tones = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"exerciseTones"]];
    if ([tones containsObject:tone]) {
        [tones removeObject:tone];
    } else {
        [tones addObject:tone];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tones forKey:@"exerciseTones"];
}

- (IBAction)segmentedValueChanged:(UISegmentedControl *)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"toneType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
