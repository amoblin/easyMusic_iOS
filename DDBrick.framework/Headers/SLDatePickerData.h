//
//  SLDatePickerData.h
//  Pods
//
//  Created by amoblin on 16/8/29.
//
//

#import "SLBaseData.h"

@interface SLDatePickerData : SLBaseData

@property (nonatomic, strong) NSString *layout;

@end

@interface SLDatePickerTableViewCell : DDBaseTableViewCell

@property (nonatomic, strong) UIDatePicker *datePicker;

@end
