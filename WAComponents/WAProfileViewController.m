//
//  WAProfileViewController.m
//  goClimb
//
//  Created by amoblin on 15/6/2.
//  Copyright (c) 2015年 marboo. All rights reserved.
//

#import "WAProfileViewController.h"
#import "WAHeadView.h"
#import "WATableViewCell.h"
#import "WAEditViewController.h"
#import "WAProfileTableViewCell.h"
#import "WANetwork.h"
#import <AFNetworking.h>

@interface WAProfileViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) WAHeadView *headerView;
@property (strong, nonatomic) NSMutableDictionary *info;
@property (nonatomic) BOOL isClickIcon;

@end

@implementation WAProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"info" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%@", object);
    [self refreshData];
}

- (void)loadView {
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [super loadView];
    
    self.headerView = [[WAHeadView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self.headerView.rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    NSString *url = [self.info[@"cover"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    [self.mTableView setTableHeaderView:self.headerView];
    self.cellId = @"cellId1";
    [self.mTableView registerClass:[WAProfileTableViewCell class] forCellReuseIdentifier:self.cellId];
    
//    navController.navigationItem.leftBarButtonItem =
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(leftMenuPressed:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
}

- (void)refreshData {
    [[WANetwork sharedInstace] requestWithPath:@"/user/info" method:@"GET" params:nil success:^(id result) {
        NSLog(@"%@", result);
        [self.refreshControl endRefreshing];
        NSDictionary *info = [result valueForKeyPath:@"data.user"];
        self.info = [info mutableCopy];
        NSArray *arr = @[@[@{@"title": @"昵称", @"key_string": @"nickname", @"value": info[@"nickname"]},
                           @{@"title": @"性别", @"key_string": @"gender", @"value": [info[@"gender"] integerValue] == 1 ? @"男" : @"女"},
                           @{@"title": @"常住地", @"key_string": @"address", @"value": info[@"address"]},
                           @{@"title": @"签名", @"key_string": @"sign", @"value": info[@"sign"]},
//                           @{@"title": @"修改密码", @"value": @""},
                           ]];
        self.mViewModel = [[WAViewModel alloc] initWithArray:arr];
        
        [self.mTableView reloadData];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 1) {
        self.isClickIcon = NO;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择性别"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"男", @"女", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
        return;
    }
    WAEditViewController *controller = [WAEditViewController new];
    NSDictionary *item = [self.mViewModel itemForRowAtIndexPath:indexPath];
    controller.info = item;
    controller.title = item[@"title"];
    controller.userInfo = self.info;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonPressed:(UIButton *)sender {
    self.isClickIcon = YES;
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:@"选择一张图片作为头像"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"立即拍照上传", @"从手机相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.isClickIcon) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        
        switch (buttonIndex) {
            case 0:
                [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [imgPicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
                [self presentViewController:imgPicker animated:YES completion:nil];
                break;
            case 1:
                [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [self presentViewController:imgPicker animated:YES completion:nil];
                break;
            default:
                break;
        }
    } else {
        if (buttonIndex == 0) {
//            self.genderLabel.text = @"汉子";
        } else if (buttonIndex == 1) {
//            self.genderLabel.text = @"妹子";
        } else {
            return;
        }
        NSDictionary *payload = @{@"gender": @(buttonIndex + 1)};
        [[WANetwork sharedInstace] requestWithPath:@"/user/info" method:@"POST" params:payload success:^(id result) {
            NSLog(@"%@", result);
            //        NSDictionary *info = [result valueForKeyPath:@"data.user"];
            self.info[@"gender"] = @(buttonIndex+1);
            [[NSUserDefaults standardUserDefaults] setValue:self.info forKeyPath:@"info"];
        } failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.0);
//    [self saveImage:image withName:@"currentImage.jpg"];
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.jpg"];
//    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
//    [self.imageView setImage:savedImage];
//    self.imageView.tag = 100;
    [self uploadAvatar:data];
}

- (void)uploadAvatar:(NSData *)data {
    NSData *avatarData = data;
    NSDictionary *params = @{@"filetype":@"jpg", @"is_temp":@1, @"file": @"test.jpg"};
    [[WANetwork sharedInstace] uploadWithPath:@"/user/pic" params:params data:data success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        NSString *filename = [responseObject objectForKey:@"filename"];
//        [self.userIconButton setImageWithURL:[NSURL URLWithString:responseObject[@"url"]]];
//        self.isUploadImageSuccess = YES;
//        self.iconName = filename;
//        MFUser *user = [MFUser sharedInstance];
//        NSDictionary *params = @{@"id":user.identity,
//                                 @"token":user.token,
//                                 @"name":user.name,
//                                 @"photo":filename,
//                                 @"v":APP_INFO};
//        [self updateUserInfoWithDictionary:params];
        
    } failure:^(NSError * error) {
        NSLog(@"%@", error);
    }];
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"info"];
}

@end
