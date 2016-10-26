//
//  DDImageAndLabelView.h
//  DDBrickDemo
//
//  Created by amoblin on 16/4/28.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import <DDUIKit/DDBaseView.h>

@interface DDImageAndLabelView : DDBaseView

@property (nonatomic, strong) UIImageView *mImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *subtitleLabel;
@property (nonatomic, strong) UILabel     *infoLabel;

@end
