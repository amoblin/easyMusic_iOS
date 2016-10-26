//
//  SLSelectionData.h
//  iMarboo
//
//  Created by amoblin on 15/12/1.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "SLBaseData.h"

@interface SLSelectionData : SLBaseData

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *options;

- (instancetype)initWithName:(NSString *)name options:(NSArray *)options;

@end

@interface SLSelectionTableViewCell : DDBaseTableViewCell

@end
