//
//  DDVideoPlayerData.h
//  iMarboo
//
//  Created by amoblin on 16/1/31.
//  Copyright © 2016年 amoblin. All rights reserved.
//

#import "DDMediaPlayerData.h"
@class AVPlayer;

@interface DDVideoPlayerData : DDMediaPlayerData

@property (nonatomic, copy) void (^tapImageViewAction)(UIImageView *imageView);

@property (nonatomic, strong) AVPlayer *avPlayer;

@end

@interface DDVideoPlayerTableViewCell : DDMediaPlayerTableViewCell

@end