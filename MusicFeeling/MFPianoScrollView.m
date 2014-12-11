//
//  MFPianoScrollView.m
//  MusicFeeling
//
//  Created by amoblin on 14/12/11.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFPianoScrollView.h"
#import "MFButton.h"

@interface MFPianoScrollView()

@property (strong, nonatomic) MFButton *previousKey;
@property (strong, nonatomic) MFButton *currentKey;

@end

@implementation MFPianoScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches)
    {
        CGPoint location = [touch locationInView:self];

        //Go through black keys first
        for ( MFButton* key in [self subviews]) {
            if ([key isKindOfClass:[MFButton class]])
            {
                if (CGRectContainsPoint(key.frame, location))
                {
                    self.previousKey = key;
                    self.currentKey = key;
                    [self.delegate toneButtonTouchDown:key];
                    /*
                     [key pressAnimation];
                     [self playPitch:key.pitch];
                     [self showPitch:key.pitch];
                     */
                }

            }

        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches)
    {
        CGPoint location = [touch locationInView:self];
        NSUInteger flag = 0;
        for ( MFButton* key in [self subviews]) {
            if ([key isKindOfClass:[MFButton class]]){
                if (CGRectContainsPoint(key.frame, location)) {
                    flag++;
                    if (self.previousKey == key) {
                        continue;
                    } else {

                    }
                    if (self.currentKey != key) {
                        self.currentKey = key;
                        [self.delegate toneButtonTouchDown:key];
                    /*
                    [key pressAnimation];
                    [self changePitch:key.pitch];
                     */
                    }
                    if (flag == 1) {
                        self.currentKey = key;
                        self.previousKey = key;
                    }
                } else {
//                    [key releaseAnimation];
                }
            }
        }
    }
}
@end
