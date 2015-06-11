//
//  WAProfileTableViewCell.m
//  goClimb
//
//  Created by amoblin on 15/6/9.
//  Copyright (c) 2015年 marboo. All rights reserved.
//

#import "WAProfileTableViewCell.h"

@implementation WAProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // Value1: Left Right
    // Value1: small Left Right
    // Subtitle: Top Bottom
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.mImageView = [UIImageView new];
        [self waAddSubview:self.mImageView];
    }
    return self;
}

- (void)config:(NSDictionary *)item atIndexPath:(NSIndexPath *)indexPath {
    self.textLabel.text = item[@"title"];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@", item[@"value"]];
}

@end
