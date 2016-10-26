//
//  DGBBasePickerItemView.h
//  Pods
//
//  Created by amoblin on 16/5/9.
//
//

#import "DDBaseData.h"

@interface DDBasePickerItemView : UIView

@property (nonatomic, strong) id data; // cell data

+ (CGFloat)heightForData:(id)data;

@end
