//
//  DDImageViewController.h
//  Bee
//
//  Created by amoblin on 16/8/31.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "DDBaseCollectionViewController.h"

@interface DDImageViewController : DDBaseCollectionViewController

@property (nonatomic, strong) NSArray *imageArray;

- (instancetype)initWithImageArray:(NSArray *)imageArray;

@end
