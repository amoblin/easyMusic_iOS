//
//  MFPianoScrollView.h
//  MusicFeeling
//
//  Created by amoblin on 14/12/11.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFButton;

@protocol MFPianoScrollViewDelegate <NSObject>

- (void)toneButtonTouchDown:(MFButton *)sender;

@end

@interface MFPianoScrollView : UIScrollView

@property (weak, nonatomic) NSObject <MFPianoScrollViewDelegate> *delegate;
@end
