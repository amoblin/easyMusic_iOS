//
//  WATableViewCell.m
//  marboo.io
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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.mImageView = [UIImageView new];
        [self waAddSubview:self.mImageView];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        [self waAddSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)introLabel {
    if (_introLabel == nil) {
        _introLabel = [UILabel new];
        [self waAddSubview:_introLabel];
    }
    return _introLabel;
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
}

- (void)config:(NSDictionary *)item atIndexPath:(NSIndexPath *)indexPath {
    [self.mImageView setImageWithURL:[NSURL URLWithString:item[@"img_url"]] placeholderImage:nil];
}

- (void)testWithIndexPath:(NSIndexPath *)indexPath {
    self.textLabel.text = [NSString stringWithFormat:@"%@-%@", @(indexPath.section+1), @(indexPath.row+1)];
}

@end
