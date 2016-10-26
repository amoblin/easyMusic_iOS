//
//  DDButton.h
//  DDBrickDemo
//
//  Created by amoblin on 16/4/29.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDButton : UIButton

@property (assign, nonatomic) CGFloat fixedHeight;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@property (strong, nonatomic) CGSize (^intrinsicContentSizeBlock)(CGSize recommendSize);
@property (strong, nonatomic) CGRect (^titleRectBlock)(CGRect contentRect, CGRect recommendTitleRect);
@property (strong, nonatomic) CGRect (^imageRectBlock)(CGRect contentRect, CGRect recommendImageRect);

- (CGSize)intrinsicContentSize;

@end

@interface DDButton (ConvenientAPI)

- (void)configTitleImageGap:(CGFloat)gap;
- (void)configTitleImageGap:(CGFloat)gap margin:(CGFloat)margin;
- (void)configTitleImageGap:(CGFloat)gap margin:(CGFloat)margin titleFirst:(BOOL)titleFirst;
- (void)configTitleImageGap:(CGFloat)gap leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin titleirst:(BOOL)titleFirst;

@end