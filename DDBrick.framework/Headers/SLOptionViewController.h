//
//  SLOptionViewController.h
//  iMarboo
//
//  Created by amoblin on 15/12/1.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "DDBaseTableViewController.h"
#import "SLSelectionData.h"
#import "SLCateModel.h"

@interface SLOptionViewController : DDBaseTableViewController

@property (nonatomic, copy) void (^selectItemBlock)();
@property (nonatomic, strong) SLCateModel *cateModel;

- (instancetype)initWithCateModel:(SLCateModel *)cateModel;

@end
