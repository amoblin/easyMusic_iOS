//
//  WAViewModel.m
//  ShuDongPo
//
//  Created by amoblin on 15/3/11.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import "WAViewModel.h"

@interface WAViewModel()

@end

@implementation WAViewModel

- (id)initWithArray:(NSArray *)info {
    if (self == [super init]) {
    }
    
    self.indexPathDataList = [info mutableCopy];
    self.sectionTitleList = nil;
    self.sectionArray = self.indexPathDataList;
    return self;
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.sectionArray[indexPath.section] removeObjectAtIndex:indexPath.row];
}

- (NSArray *)titleArray {
    return self.sectionTitleList;
}

- (NSMutableArray *)pointerArray {
    if (_pointerArray == nil) {
        _pointerArray = self.indexPathDataList;
    }
    return _pointerArray;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [self.pointerArray[section] count];
}

- (NSInteger)numberOfSections {
    return [self.pointerArray count];
}

- (id)itemForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.pointerArray[indexPath.section] isKindOfClass:[NSArray class]]) {
        return self.pointerArray[indexPath.section][indexPath.row];
    } else {
        return [self.pointerArray[indexPath.section] allValues][indexPath.row];
    }
}

- (NSDictionary *)itemForRowAtSection:(NSInteger)section {
    return self.pointerArray[section];
}

- (NSString *)titleForSection:(NSInteger)section {
    return self.sectionTitleList[section];
}

- (void)setOnlySection:(NSInteger)section {
    self.pointerArray = [@[self.indexPathDataList[section]] mutableCopy];
    self.sectionArray = self.pointerArray;
    self.sectionTitleList = nil;
}

- (NSDictionary *)itemFiltByKey:(NSString *)key andValue:(NSString *)value {
    for (NSDictionary *item in self.pointerArray) {
        if ([[NSString stringWithFormat:@"%@", [item objectForKey:key]] isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

- (void)removeObjectFromPointerArrayAtIndexPath:(NSIndexPath *)indexPath {
    self.pointerArray[indexPath.section] = [self.pointerArray[indexPath.section] mutableCopy];
    [self.pointerArray[indexPath.section] removeObjectAtIndex:indexPath.row];
}

@end
