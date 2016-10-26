//
//  DDTableViewCell+DD.h
//  Pods
//
//  Created by amoblin on 16/8/30.
//
//

//#import <DDTableViewCell.h>
#import "DDUIKit/DDTableViewCell.h"


@class DDBaseData;

@interface DDTableViewCell (DD)

@property (nonatomic, strong) DDBaseData *data; // cell data

+ (NSString *)DDReuseIdentifier; // cell reuse identifier, subclass use as it
+ (CGFloat)heightForData:(DDBaseData *)data; // cell height, subclass override
+ (CGFloat)defaultHeight;

@end
