//
//  SLOptionData.h
//  iMarboo
//
//  Created by amoblin on 15/12/1.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "SLBaseData.h"

@interface SLOptionData : SLBaseData

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface SLOptionTableViewCell: DDBaseTableViewCell

@end

