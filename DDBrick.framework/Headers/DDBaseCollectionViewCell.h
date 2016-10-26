//
//  DDBaseCollectionViewCell.h
//  DDBrickDemo
//
//  Created by amoblin on 16/4/28.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import "Masonry.h"
#import <DDUIKit/UILabel+DD.h>
#import "DDColors.h"
#import <DDUIKit/DDFonts.h>
#import <DDUIKit/DDCollectionViewCell.h>

@class DDBaseData;

@interface DDBaseCollectionViewCell : DDCollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) DDBaseData *data; // cell data

+ (NSString *)DDReuseIdentifier;
+ (CGFloat)defaultHeight;

@end
