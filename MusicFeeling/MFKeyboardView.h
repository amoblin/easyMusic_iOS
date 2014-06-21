//
//  MFKeyboardView.h
//  MusicFeeling
//
//  Created by amoblin on 14/6/19.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MFKeyboardDelegate <NSObject>

@optional
- (void)tonePressed:(NSString *)tone;
- (void)deleteButtonPressed;
- (void)returnButtonPressed;
@end

@interface MFKeyboardView : UIView

@property (nonatomic) UIInterfaceOrientation interfaceOrientation;
@property (strong, nonatomic) id<MFKeyboardDelegate> delegate;
@end
