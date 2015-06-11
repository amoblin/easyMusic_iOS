//
//  WAViewModel.h
//  marboo.io
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

- (void)addArray:(NSArray *)info atSection:(NSInteger)section;

- (id)itemForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSDictionary *)itemForRowAtSection:(NSInteger)section;

- (NSString *)titleForSection:(NSInteger)section;

- (NSArray *)titleArray;

- (void)setOnlySection:(NSInteger)section;

- (NSDictionary *)itemFiltByKey:(NSString *)key andValue:(NSString *)value;

- (void)removeObjectFromPointerArrayAtIndexPath:(NSIndexPath *)indexPath;

@end
