//
//  DDAudioPlayerData.h
//  iMarboo
//
//  Created by amoblin on 16/1/31.
//  Copyright © 2016年 amoblin. All rights reserved.
//

#import "DDMediaPlayerData.h"

@interface DDAudioPlayerData : DDMediaPlayerData

@property (nonatomic, copy) void (^playButtonPressed)();

@end

@interface DDAudioPlayerTableViewCell : DDMediaPlayerTableViewCell

@end