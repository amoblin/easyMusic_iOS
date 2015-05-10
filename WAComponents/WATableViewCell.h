//
//  WATableViewCell.h
//  ShuDongPo
//
//  Created by amoblin on 15/3/12.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WATableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *mImageView;

- (void)waAddSubview:(UIView *)view;
@end
