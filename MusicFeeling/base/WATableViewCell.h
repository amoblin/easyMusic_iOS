//
//  WATableViewCell.h
//  marboo.io
//
//  Created by amoblin on 15/3/12.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface WATableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *mImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *introLabel;

- (void)waAddSubview:(UIView *)view;
- (void)config:(NSDictionary *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)testWithIndexPath:(NSIndexPath *)indexPath;
@end
