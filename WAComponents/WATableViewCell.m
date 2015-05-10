//
//  WATableViewCell.m
//  ShuDongPo
//
//  Created by amoblin on 15/3/12.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import "WATableViewCell.h"

@implementation WATableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // Value1: Left Right
    // Value1: small Left Right
    // Subtitle: Top Bottom
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.mImageView = [UIImageView new];
        [self waAddSubview:self.mImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)waAddSubview:(UIView *)view {
    if (IOS_7_OR_LATER) {
        [self addSubview:view];
    } else {
        [self.contentView addSubview:view];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WS(ws);
    [self.mImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ws);
        make.centerY.equalTo(ws.mas_centerY);
    }];
}
@end
