//
//  MFSettingViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-22.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFSettingViewController.h"
#import "MFArrayDataSource.h"

#import <QuartzCore/QuartzCore.h>
#import <UMFeedback.h>

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

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_tableView];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_tableView]-0-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
    }
    return _tableView;
}

- (MFArrayDataSource *)arrayDataSource {
    if (_arrayDataSource == nil) {
        NSArray *dataArray;
        static NSString *cellId;
        void (^block)(id, id, NSIndexPath*);

        dataArray = @[@[@"帮助", @"反馈", @"去评分", @"版本更新", @"关于",]];
        cellId = @"cellId";
        block = ^(UITableViewCell *cell, NSString *item, NSIndexPath *indexPath) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = item;
            if (indexPath.row == 3) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            }
        };
        _arrayDataSource = [[MFArrayDataSource alloc] initWithItems:dataArray cellIdentifier:cellId configureCellBlock:block];
    }
    return _arrayDataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *view = [[UIView alloc] init];
    CGRect frame = [view frame];
    frame.size.height = 150;
    view.frame = frame;

    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"傻瓜演奏家";
    [view addSubview:titleLabel];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"treble_clef"]];
    logoImageView.layer.cornerRadius = 10.0;
    logoImageView.layer.masksToBounds = YES;
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:logoImageView];

    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:logoImageView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[logoImageView(==60)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(logoImageView)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(titleLabel)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[logoImageView(==60)]-10-[titleLabel]-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(logoImageView, titleLabel)]];
    self.tableView.tableHeaderView = view;
    [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(view)]];
    [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view(==100)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(view)]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.arrayDataSource;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];

    [self.toggleRandomSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"randomDegree"]];
    [self.toggleRandomSwitch addTarget:self action:@selector(toggleRandomDegree:) forControlEvents:UIControlEventTouchUpInside];
    [self.toggleMapperSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"mapper"]];

    //[self initPianoKeyboard];
}

- (void)initPianoKeyboard {
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

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) goAppStore
{
    NSString *url = @"https://itunes.apple.com/us/app/sha-gua-yan-zou-jia/id848880040?ls=1&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            [UMFeedback showFeedback:self withAppkey:UMENG_KEY];
            break;
        case 2:
            [self goAppStore];
            break;
        default:
            break;
    }
}
@end
