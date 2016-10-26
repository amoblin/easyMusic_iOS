//
//  DDMediaPlayerData.h
//  iMarboo
//
//  Created by amoblin on 16/1/31.
//  Copyright © 2016年 amoblin. All rights reserved.
//

#import "DDBaseData.h"

@interface DDMediaPlayerData : DDBaseData

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *media;

@end

@interface DDMediaPlayerTableViewCell : DDBaseTableViewCell

@property (nonatomic, strong) UIImageView   *mImageView;

@end