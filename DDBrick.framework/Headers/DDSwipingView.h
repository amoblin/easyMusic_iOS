//
//  DDSwipingView.h
//  DDBrickDemo
//
//  Created by amoblin on 16/7/21.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import <DDUIKit/DDBaseView.h>

@class DDSwipingView;

typedef NS_ENUM(NSInteger, PageVisibleState) {
    PageVisibleStateTop,
    PageVisibleStateCenter,
    PageVisibleStateBottom
};

@protocol DDSwipingViewDelegate <NSObject>

- (void)pagingScrollView:(DDSwipingView *)pagingView changeVisibleState:(PageVisibleState)state;

@end

@interface DDSwipingView : DDBaseView

@property (nonatomic, assign, readonly) PageVisibleState currentVS; // 当前内容显示的位置

// 当 |forwardHitTestView| 不为nil的时候，点击显示区域上面的透明区域，会把事件传递给 |forwardHitTestView|
@property (nonatomic, weak) UIView *forwardHitTestView;

//center状态时，地图区域遮盖层
@property (nonatomic, strong) UIView *upMapCoverView;

@property (nonatomic, weak) id<DDSwipingViewDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

//@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *scrollPan;

@property (nonatomic, assign) BOOL scrollEnabled;

- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToCenterAnimated:(BOOL)animated;

- (void)setupSubviews;
@end
