//
//  DDTableViewCell.h
//  Pods
//
//  Created by amoblin on 16/8/25.
//
//

#import "UILabel+DD.h"
#import "DDFonts.h"
#import <Masonry/Masonry.h>

@interface DDTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addButton;

// 添加布局组件
- (void)setupSubviews;

// 设置组件约束
- (void)configConstraints;

// 使用数据填充界面
- (void)configCell; // subclass override

@end
