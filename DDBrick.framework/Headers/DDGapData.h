//
//  DDGapData.h
//  Pods
//
//  Created by amoblin on 16/5/4.
//
//

#import "DDBaseData.h"

@interface DDGapData : DDBaseData

- (instancetype)initWithCellHeight:(CGFloat)cellHeight;

#if TARGET_OS_IPHONE
- (instancetype)initWithItemSize:(CGSize)itemSize;
#else
- (instancetype)initWithItemSize:(NSSize)itemSize;
#endif

@end

