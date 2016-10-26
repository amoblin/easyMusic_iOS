//
//  DDLandscapeData.h
//  iMarboo
//
//  Created by amoblin on 15/5/8.
//  Copyright (c) 2015年 marboo. All rights reserved.
//

#import "DDBaseData.h"

@interface DDLandscapeData : DDBaseData

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *imageFilePath;

@property (nonatomic, strong) NSString *left;
@property (nonatomic, strong) NSString *center;
@property (nonatomic, strong) NSString *right;

- (instancetype)initWithImage:(NSString *)image;
- (instancetype)initWithImageFilePath:(NSString *)imageFilePath;
@end

