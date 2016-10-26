//
//  DDBaseListViewController.h
//  Pods
//
//  Created by amoblin on 16/7/6.
//
//

#import <DDUIKit/DDBaseViewController.h>
#import "DDViewModel.h"

@interface DDBaseListViewController : DDBaseViewController

@property (nonatomic, strong) DDViewModel *viewModel;
@property (nonatomic, strong) NSArray *dataArray;

- (void)reloadData;

@end
