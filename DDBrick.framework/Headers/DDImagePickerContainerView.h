//
//  DDImagePickerContainerView.h
//  Bee
//
//  Created by amoblin on 16/8/31.
//  Copyright © 2016年 didi. All rights reserved.
//

#import "DDCollectionContainerView.h"
@class DDImageData;

@interface DDImagePickerContainerView : DDCollectionContainerView

@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSString *contentPath;

@property (nonatomic, copy) void (^takePhotoAction)();
@property (nonatomic, copy) void (^detailPhotoAction)(DDImageData *data);

@end
