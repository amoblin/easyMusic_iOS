//
//  SLPickerData.h
//  Pods
//
//  Created by amoblin on 16/9/6.
//
//

#import <DDBrick/DDBrick.h>
#import "DDPickerContainerView.h"
#import "SLBaseData.h"

@interface SLPickerData : SLBaseData

@end

@interface SLPickerTableViewCell : DDBaseTableViewCell

@property (nonatomic, strong) DDPickerContainerView *pickerContainerView;

@end