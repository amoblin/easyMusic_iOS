//
//  DDMutliCollectionViewController.h
//  Bee
//
//  Created by amoblin on 16/8/17.
//  Copyright © 2016年 didi. All rights reserved.
//

#import <DDUIKit/DDBaseViewController.h>
#import "DDCollectionContainerView.h"

@interface DDMultiCollectionViewController : DDBaseViewController

@property (nonatomic, strong) DDCollectionContainerView *topCollectionContainerView;
@property (nonatomic, strong) DDCollectionContainerView *mainCollectionContainerView;

@end
