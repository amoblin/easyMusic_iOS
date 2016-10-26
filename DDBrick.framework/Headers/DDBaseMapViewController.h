//
//  DDBaseMapViewController.h
//  Bee
//
//  Created by amoblin on 16/8/15.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "DDBaseListViewController.h"

@import MapKit;

@interface DDBaseMapViewController : DDBaseListViewController

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, copy) void (^regionDidChangeAction)();
@property (nonatomic, copy) void (^deselectAnnotationViewAction)();

@end
