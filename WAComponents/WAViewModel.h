//
//  WAViewModel.h
//  ShuDongPo
//
//  Created by amoblin on 15/3/11.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import "RVMViewModel.h"

@interface WAViewModel : RVMViewModel


@property (strong, nonatomic) NSMutableArray *indexPathDataList;
@property (strong, nonatomic) NSMutableArray *sectionTitleList;
@property (strong, nonatomic) NSMutableArray *pointerArray;
@property (strong, nonatomic) NSArray *sectionArray;

-(NSInteger)numberOfSections;

-(NSInteger)numberOfRowsInSection:(NSInteger)section;

- (id)initWithArray:(NSArray *)info;

- (id)itemForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)sortByBlock:(void (^)(id a, id b))block;

- (NSDictionary *)itemForRowAtSection:(NSInteger)section;

- (NSString *)titleForSection:(NSInteger)section;

- (NSArray *)titleArray;

- (void)setOnlySection:(NSInteger)section;

- (NSDictionary *)itemFiltByKey:(NSString *)key andValue:(NSString *)value;

- (void)removeObjectFromPointerArrayAtIndexPath:(NSIndexPath *)indexPath;

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
@end
