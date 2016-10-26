//
//  CLLocationManager+Promise.h
//  Bee
//
//  Created by amoblin on 16/9/1.
//  Copyright © 2016年 didi. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <PromiseKit/PromiseKit.h>

@interface CLLocationManager (Promise)

- (PMKPromise *)promise;

@end
