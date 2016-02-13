//
//  MFSettingViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-22.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFSettingViewController.h"
#import "MFArrayDataSource.h"
#import "MFSettingsTableViewCell.h"

#import <QuartzCore/QuartzCore.h>
#import <UMFeedback.h>
#import <SVProgressHUD.h>
#import <Masonry.h>

#define TOP @350
#define WHITE_WIDTH @44
#define WHITE_BUTTON_WIDTH @43
#define BLACK_WIDTH @27
#define LEFT_BLACK_WIDTH @16
#define WHITE_HEIGHT @144
#define BLACK_HEIGHT @90

@interface MFSettingViewController () <UINavigationBarDelegate>

@property (nonatomic) CGFloat barHeight;
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

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (MFArrayDataSource *)arrayDataSource {
    if (_arrayDataSource == nil) {
        NSArray *dataArray;
        static NSString *cellId;
        void (^block)(id, id, NSIndexPath*);

        dataArray = @[@[@"键盘布局", @"和我沟通", @"去评分", @"QQ群： 253107875"]];
        cellId = @"cellId";
        block = ^(UITableViewCell *cell, NSString *item, NSIndexPath *indexPath) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = item;
            if (indexPath.row == 0) {
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"keyboardType"] == 0) {
                    cell.detailTextLabel.text = @"音符";
                } else {
                    cell.detailTextLabel.text = @"简谱";
                }
            } else if (indexPath.row == 3) {
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
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
    self.title = Local(@"Settings");
    self.UMPageName = Local(@"Settings");
    self.view.backgroundColor = [UIColor whiteColor];

    UINavigationBar *bar = [[UINavigationBar alloc] init];
    bar.delegate = self;
    bar.translatesAutoresizingMaskIntoConstraints = NO;
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:Local(@"Settings")];
    [bar setItems:@[item]];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Local(@"Close")
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(close:)];
    self.bar = bar;
    [self.view addSubview:bar];
    self.barHeight = 64;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:bar];

    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGRect frame = [view frame];
    frame.size.height = 150;
    view.frame = frame;

    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"傻瓜演奏家%@(%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    [view addSubview:titleLabel];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"treble_clef"]];
    logoImageView.layer.cornerRadius = 10.0;
    logoImageView.layer.masksToBounds = YES;
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:logoImageView];

    WS(ws);
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
//        make.bottom.equalTo(view);
        
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.left.equalTo(view);
        make.top.equalTo(logoImageView.mas_bottom).with.offset(0);
        make.bottom.equalTo(view).with.offset(-10);
    }];

    self.tableView.tableHeaderView = view;

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.tableView);
        make.left.equalTo(ws.tableView);
        make.height.mas_equalTo(150);
        make.top.equalTo(ws.tableView);
    }];

    self.tableView.delegate = self;
    self.tableView.dataSource = self.arrayDataSource;
    [self.tableView registerClass:[MFSettingsTableViewCell class] forCellReuseIdentifier:@"cellId"];

    [self.toggleRandomSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"randomDegree"]];
    [self.toggleRandomSwitch addTarget:self
                                action:@selector(toggleRandomDegree:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.toggleMapperSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"mapper"]];

    //[self initPianoKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateLayoutWithOrientation:self.interfaceOrientation];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutWithOrientation:toInterfaceOrientation];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    WS(ws);
    [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.top.equalTo(ws.view);
        make.height.mas_equalTo(ws.barHeight);
        make.bottom.equalTo(ws.tableView.mas_top);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.top.equalTo(ws.bar.mas_bottom);
        make.bottom.equalTo(ws.view);
    }];
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

- (void)checkNewVersion
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
//    [iVersion sharedInstance].applicationBundleID = @"biz.marboo.k2k";

    //configure iVersion. These paths are optional - if you don't set
    //them, iVersion will just get the release notes from iTunes directly (if your app is on the store)

//    [[iVersion sharedInstance] setDelegate:self];
//    [[iVersion sharedInstance] checkForNewVersion];
}

#pragma mark - iVersion Delegate
- (void)iVersionDidNotDetectNewVersion {
//    [[iVersion sharedInstance] setDelegate:nil];
    [SVProgressHUD showSuccessWithStatus:@"目前已是最新版本"];
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
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"keyboardType"] == 0) {
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"keyboardType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"keyboardType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case 1:
            [UMFeedback showFeedback:self withAppkey:UMENG_KEY];
            break;
        case 2:
            [self goAppStore];
            break;
        case 3:
            [self checkNewVersion];
            break;
        case 4:
            [self copyToClipboard];
            break;
        default:
            break;
    }
}

- (void)copyToClipboard {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"253107875";
    [SVProgressHUD showSuccessWithStatus:@"QQ号码已复制！"];
}

- (void)updateLayoutWithOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            CGFloat viewWidth, viewHeight;
            viewWidth = [UIScreen mainScreen].bounds.size.width;
            viewHeight= [UIScreen mainScreen].bounds.size.height;

            self.barHeight = 64;
            self.bar.frame = CGRectMake(0, 20, viewWidth, 44);
            self.tableView.frame = CGRectMake(0, 64, viewWidth, viewHeight - 44 - 64);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            CGFloat viewWidth, viewHeight, originY;
            if (IS_IOS_8_OR_LATER) {
                originY = 0;
                viewWidth = [UIScreen mainScreen].bounds.size.width;
                viewHeight= [UIScreen mainScreen].bounds.size.height;
            } else {
                originY = 20;
                viewWidth = [UIScreen mainScreen].bounds.size.height;
                viewHeight = [UIScreen mainScreen].bounds.size.width;
            }
            self.bar.frame = CGRectMake(0, originY, viewWidth, 32);
            self.barHeight = 32;

            if (IS_IOS_8_OR_LATER) {
                self.tableView.frame = CGRectMake(0, 32, viewWidth, viewHeight - 44 - 32);
            } else {
                self.tableView.frame = CGRectMake(0, 52, viewWidth, viewHeight - 44 - 52);
            }
            break;
        }
        default:
            break;
    }
}

@end
