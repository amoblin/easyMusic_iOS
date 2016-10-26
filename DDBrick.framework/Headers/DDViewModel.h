//
//  DDViewModel.h
//  DDBrickDemo
//
//  Created by amoblin on 16/5/24.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import "DDBaseData.h"
#import "DDBaseAnnotation.h"

@interface DDViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *dataArray;

- (instancetype)initWithDataArray:(NSArray *)dataArray;
- (void)setDataArray:(NSMutableArray *)dataArray;

- (NSInteger)count;
- (DDBaseData *) dataAtIndex:(NSUInteger )index;

// protected method
- (Class) cellClassForData:(DDBaseData *)data withSuffix:(NSString *)suffix;

#if TARGET_OS_IPHONE

- (Class)tableViewCellClassForIndexPath:(NSIndexPath *)indexPath;
- (Class)annotationViewClassForAnnotation:(DDBaseAnnotation *)annotation;

#endif

- (DDBaseData *) dataForIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath withClass:(Class)class;

- (void)insertItem:(DDBaseData *)data atIndex:(NSInteger)index;

- (void)removeItemAtIndex:(NSInteger)index;

- (void)moveItemFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex;
@end
