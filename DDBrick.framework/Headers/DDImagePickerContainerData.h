//
//  DDImagePickerContainerData.h
//  Bee
//
//  Created by amoblin on 16/8/31.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "DDCollectionContainerData.h"
@class DDImageData;

@interface DDImagePickerContainerData : DDCollectionContainerData

@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, strong) NSString *contentPath;

@property (nonatomic, copy) void (^detailPhotoAction)(DDImageData *data);

@end
