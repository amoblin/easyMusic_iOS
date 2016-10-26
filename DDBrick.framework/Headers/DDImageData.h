//
//  DDImageData.h
//  iMarboo
//
//  Created by amoblin on 15/12/5.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "DDBaseData.h"

@interface DDImageData : DDBaseData

@property (nonatomic, strong) NSString *imageString;

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImageString:(NSString *)imageString;


- (instancetype)initWithImage:(UIImage *)image;

@end

