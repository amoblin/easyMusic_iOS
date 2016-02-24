//
//  MFSongListTableViewCell.m
//  MusicFeeling
//
//  Created by amoblin on 14/7/26.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFSongListTableViewCell.h"

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
        self.titleLabel = [UILabel labelWithFont:WASystemFontSize18 textColor:nil];
        [self.contentView addSubview:self.titleLabel];

        self.authorLabel = [UILabel labelWithFont:WASystemFontSize13 textColor:WAHexColorB4B4B4];
        [self.contentView addSubview:self.authorLabel];

//        self.viewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green"]];
//        self.viewImageView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:self.viewImageView];

        self.viewLabel = [UILabel labelWithFont:WASystemFontSize11 textColor:WAHexColor646464];
        self.viewLabel.text = @"浏览";
        [self.contentView addSubview:self.viewLabel];

        self.viewCountLabel = [UILabel labelWithFont:WASystemFontSize11 textColor:WAHexColor7EC821];
        [self.contentView addSubview:self.viewCountLabel];

//        self.finishImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue"]];
//        self.finishImageView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:self.finishImageView];

        self.finishLabel = [UILabel labelWithFont:WASystemFontSize11 textColor:WAHexColor646464];
        self.finishLabel.text = @"演奏";
        [self.contentView addSubview:self.finishLabel];

        self.finishCountLabel = [UILabel labelWithFont:WASystemFontSize11 textColor:WAHexColor39AAFF];
        [self.contentView addSubview:self.finishCountLabel];

        self.dateLabel = [UILabel labelWithFont:WASystemFontSize10 textColor:WAHexColorB4B4B4];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
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
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_dateLabel(==70)]-10-|"
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
            info = [NSString stringWithFormat:@"%@分钟前", @((NSInteger)delta)];
        } else {
            delta = delta / 60;
            if (delta < 24) {
                // n小时前
                info = [NSString stringWithFormat:@"%@小时前", @((NSInteger)delta)];
            } else {
                delta = delta / 24;
                if ((NSInteger)delta == 1) {
                    //昨天
                    info = @"昨天";
                } else if ((NSInteger)delta == 2) {
                    info = @"前天";
                } else {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    info = [dateFormatter stringFromDate:theDate];
//                    info = [NSString stringWithFormat:@"%d天前", (NSUInteger)delta];
                }
            }
        }
    }
    return info;
}

@end
