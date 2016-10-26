//
//  DDBaseContainerView.h
//  Pods
//
//  Created by amoblin on 16/7/6.
//
//

#import <DDUIKit/DDBaseView.h>
#import "DDViewModel.h"

@interface DDBaseContainerView : DDBaseView

@property (nonatomic, strong) DDViewModel *viewModel;
@property (nonatomic, strong) NSArray     *dataArray;

- (instancetype)initWithDataArray:(NSArray *)dataArray;

- (void)reloadData;

@end
