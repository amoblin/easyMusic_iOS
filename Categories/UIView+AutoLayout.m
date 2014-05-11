//
//  UIView+AutoLayout.m
//  mofunshow
//
//  Created by amoblin on 14-4-26.
//  Copyright (c) 2014年 mofunsky. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)
+(id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}
@end
