//
//  WAHeadView.m
//  goClimb
//
//  Created by amoblin on 15/6/2.
//  Copyright (c) 2015年 marboo. All rights reserved.
//

#import "WAHeadView.h"

@interface WAHeadView()

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *avatarImageView;

@end
@implementation WAHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImageView = [UIImageView new];
        [self addSubview:self.bgImageView];
        
        self.avatarImageView = [UIImageView new];
        [self.avatarImageView setImage:[UIImage imageNamed:@"avatar"]];
        [self addSubview:self.avatarImageView];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftButton setImage:[UIImage imageNamed:@"changeAvatarButton"] forState:UIControlStateNormal];
        [self addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.rightButton setImage:[UIImage imageNamed:@"changeAvatarButton"] forState:UIControlStateNormal];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WS(ws);
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top);
        make.left.equalTo(ws.mas_left);
        make.right.equalTo(ws.mas_right);
        make.bottom.equalTo(ws.mas_bottom);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mas_centerX);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(72);
        make.top.mas_equalTo(20);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(23);
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(-10);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(23);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-10);
    }];
}

@end
