//
//  DGCBasePickerView.h
//  Pods
//
//  Created by amoblin on 16/5/9.
//
//

#import <DDUIKit/DDBaseView.h>

@interface DDPickerContainerView : DDBaseView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^confirmButtonPressedBlock)(NSInteger index);

- (void)show;

@end
