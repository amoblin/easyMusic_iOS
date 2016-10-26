//
//  SLDateData.h
//  iMarboo
//
//  Created by amoblin on 15/12/1.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "SLBaseData.h"
#import "DDTitleAndSubtitleTableViewCell.h"

@interface SLDateData : SLBaseData

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL isShowPicker;
@end

@interface SLDateTableViewCell : DDTitleAndSubtitleTableViewCell

@end
