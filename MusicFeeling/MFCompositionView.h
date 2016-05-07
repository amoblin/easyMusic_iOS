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

- (void)tonePressed:(NSString *)toneName;

@end

@interface MFCompositionView : UIScrollView <UIKeyInput>

@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) BOOL smartMode;
@property (weak, nonatomic) NSObject <MFPianoScrollViewDelegate> *pianoDelegate;
@end
