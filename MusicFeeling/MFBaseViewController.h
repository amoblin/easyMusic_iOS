//
//  MFBaseViewController.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDZTrace.h"
#import "IDZOggVorbisFileDecoder.h"
#import "IDZAQAudioPlayer.h"

@interface MFBaseViewController : UIViewController <IDZAudioPlayerDelegate>

- (void)playTone:(NSString *)name;
@end
