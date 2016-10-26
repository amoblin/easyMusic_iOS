//
//  DDBaseView.h
//  DDBrickDemo
//
//  Created by amoblin on 16/4/28.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import "DDFonts.h"
#import "UILabel+DD.h"
#import "UIColor+DD.h"

@interface DDBaseView : UIView

- (void)setupSubviews;

- (void)configConstraints;

- (void)resetData;

- (void)reloadData;

@end
