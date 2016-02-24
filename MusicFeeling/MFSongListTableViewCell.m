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

@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UILabel     *authorLabel;
@property (strong, nonatomic) UIImageView *viewImageView;
@property (strong, nonatomic) UILabel     *viewLabel;
@property (strong, nonatomic) UILabel     *viewCountLabel;
@property (strong, nonatomic) UIImageView *finishImageView;
@property (strong, nonatomic) UILabel     *finishLabel;
@property (strong, nonatomic) UILabel     *finishCountLabel;
@property (strong, nonatomic) UILabel     *dateLabel;

@end

@implementation MFSongListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel labelWithFont:WASystemFontSize18 textColor:nil];
        [self.contentView addSubview:self.titleLabel];

        self.authorLabel = [UILabel labelWithFont:WAItalicSystemFontSize13 textColor:WAHexColorB4B4B4];
        [self.contentView addSubview:self.authorLabel];

        self.viewLabel = [UILabel labelWithFont:WASystemFontSize11 textColor:WAHexColor646464];
        self.viewLabel.text = @"浏览";
        [self.contentView addSubview:self.viewLabel];

        self.viewCountLabel = [UILabel labelWithFont:WASystemFontSize11 textColor:WAHexColor7EC821];
        [self.contentView addSubview:self.viewCountLabel];

        self.finishLabel = [UILabel labelWithFont:WASystemFontSize11 textColor:WAHexColor646464];
        self.finishLabel.text = @"演奏";
        [self.contentView addSubview:self.finishLabel];

        self.finishCountLabel = [UILabel labelWithFont:WASystemFontSize11 textColor:WAHexColor39AAFF];
        [self.contentView addSubview:self.finishCountLabel];

        self.dateLabel = [UILabel labelWithFont:WASystemFontSize10 textColor:WAHexColorB4B4B4];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.dateLabel];
        [self configConstraints];
    }
    return self;
}

- (void)configConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(270, 20));
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.width.mas_equalTo(70);
        make.top.equalTo(self.titleLabel);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(210, 15));
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    [self.finishCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.bottom.equalTo(self.authorLabel);
        make.right.equalTo(self.contentView).with.offset(-5);
    }];
    [self.finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.authorLabel);
        make.right.equalTo(self.finishCountLabel.mas_left).with.offset(-5);
        make.width.mas_equalTo(25);
    }];
    [self.viewCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.bottom.equalTo(self.authorLabel);
        make.right.equalTo(self.finishLabel.mas_left).with.offset(-5);
    }];
    [self.viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(25);
        make.bottom.equalTo(self.authorLabel);
        make.right.equalTo(self.viewCountLabel.mas_left).with.offset(-5);
    }];
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
