//
//  DDBaseViewModel+Promise.h
//  Bee
//
//  Created by amoblin on 16/9/7.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "DDBaseViewModel.h"
#import "CLLocationManager+Promise.h"

@interface DDBaseViewModel (Promise)

@property (nonatomic, strong) CLLocationManager *locationManager;

- (PMKPromise *)getLocation;

@end
