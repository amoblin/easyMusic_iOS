//
//  MFSettingsTableViewCell.m
//  MusicFeeling
//
//  Created by amoblin on 14-5-1.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFSettingsTableViewCell.h"

@implementation MFSettingsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
