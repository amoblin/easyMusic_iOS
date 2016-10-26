//
//  DDBaseAnnotation.h
//  Bee
//
//  Created by amoblin on 16/8/16.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "DDBaseData.h"
#import <MapKit/MapKit.h>

@interface DDBaseAnnotation : DDBaseData <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
