//
//  MFSongListTableViewCell.m
//  MusicFeeling
//
//  Created by amoblin on 14/7/26.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFSongListTableViewCell.h"
#import "UIView+AutoLayout.h"

#import <AVOSCloud/AVOSCloud.h>

@interface MFSongListTableViewCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UIImageView *viewImageView;
@property (strong, nonatomic) UILabel *viewLabel;
@property (strong, nonatomic) UILabel *viewCountLabel;
@property (strong, nonatomic) UIImageView *finishImageView;
@property (strong, nonatomic) UILabel *finishLabel;
@property (strong, nonatomic) UILabel *finishCountLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation MFSongListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        // Initialization code
        self.titleLabel = [UILabel autolayoutView];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLabel];

        self.authorLabel = [UILabel autolayoutView];
        self.authorLabel.font = [UIFont italicSystemFontOfSize:13];
        self.authorLabel.textColor = UIColorFromRGB(180, 180, 180);
        [self.contentView addSubview:self.authorLabel];

//        self.viewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green"]];
//        self.viewImageView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:self.viewImageView];

        self.viewLabel = [UILabel autolayoutView];
        self.viewLabel.font = [UIFont systemFontOfSize:11];
        self.viewLabel.textColor = UIColorFromRGB(100, 100, 100);
        self.viewLabel.text = @"浏览";
        [self.contentView addSubview:self.viewLabel];

        self.viewCountLabel = [UILabel autolayoutView];
        self.viewCountLabel.font = [UIFont italicSystemFontOfSize:11];
        self.viewCountLabel.textColor = UIColorFromRGB(126, 200, 33);
        [self.contentView addSubview:self.viewCountLabel];

//        self.finishImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue"]];
//        self.finishImageView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:self.finishImageView];

        self.finishLabel = [UILabel autolayoutView];
        self.finishLabel.textColor = UIColorFromRGB(100, 100, 100);
        self.finishLabel.font = [UIFont systemFontOfSize:11];
        self.finishLabel.text = @"演奏";
        [self.contentView addSubview:self.finishLabel];

        self.finishCountLabel = [UILabel autolayoutView];
        self.finishCountLabel.font = [UIFont italicSystemFontOfSize:11];
        self.finishCountLabel.textColor = UIColorFromRGB(57, 170, 255);
        [self.contentView addSubview:self.finishCountLabel];

        self.dateLabel = [UILabel autolayoutView];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = [UIFont systemFontOfSize:10];
        self.dateLabel.textColor = UIColorFromRGB(180, 180, 180);
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_titleLabel(==270)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_titleLabel, _dateLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_dateLabel(==50)]-10-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_titleLabel, _dateLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_authorLabel(==210)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_authorLabel, _viewLabel, _viewCountLabel, _finishLabel, _finishCountLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_viewLabel(==25)]-5-[_viewCountLabel(==30)]-5-[_finishLabel(==25)]-5-[_finishCountLabel(==30)]-5-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_authorLabel, _viewLabel, _viewCountLabel, _finishLabel, _finishCountLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleLabel(==20)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_titleLabel, _authorLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_authorLabel(==15)]-10-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_titleLabel, _authorLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.viewLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.authorLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.viewCountLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.authorLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-1.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.finishLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.authorLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.finishCountLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.authorLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-1.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItem:(AVObject *)item {
    self.titleLabel.text = item[@"name"];
    self.dateLabel.text = [self humanableInfoFromDate:item[@"mtime"]];
    self.authorLabel.text = item[@"author"];
    self.viewCountLabel.text = [item[@"viewCount"] stringValue];
    self.finishCountLabel.text = [item[@"finishCount"] stringValue];
}

- (void)showCount:(BOOL)flag {
    [self.viewLabel setHidden: ! flag];
    [self.viewCountLabel setHidden: ! flag];
    [self.finishLabel setHidden: ! flag];
    [self.finishCountLabel setHidden: ! flag];
}

- (NSString *)humanableInfoFromDate: (NSDate *) theDate {
    NSString *info;

    NSTimeInterval delta = - [theDate timeIntervalSinceNow];
    if (delta < 60) {
        // 1分钟之内
        info = @"刚刚";
    } else {
        delta = delta / 60;
        if (delta < 60) {
            // n分钟前
            info = [NSString stringWithFormat:@"%@分钟前", @(delta)];
        } else {
            delta = delta / 60;
            if (delta < 24) {
                // n小时前
                info = [NSString stringWithFormat:@"%@小时前", @(delta)];
            } else {
                delta = delta / 24;
                if ((NSInteger)delta == 1) {
                    //昨天
                    info = @"昨天";
                } else if ((NSInteger)delta == 2) {
                    info = @"前天";
                } else {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM-dd"];
                    info = [dateFormatter stringFromDate:theDate];
//                    info = [NSString stringWithFormat:@"%d天前", (NSUInteger)delta];
                }
            }
        }
    }
    return info;
}

@end
