//
//  DDTableContainerView.h
//  iMarboo
//
//  Created by amoblin on 15/11/24.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "DDBaseContainerView.h"

@interface DDTableContainerView : DDBaseContainerView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end
