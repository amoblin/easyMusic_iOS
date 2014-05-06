//
//  MFArrayDataSource.m
//  MusicFeeling
//
//  Created by amoblin on 14-4-26.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFArrayDataSource.h"

@interface MFArrayDataSource()
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@end

@implementation MFArrayDataSource
- (id)initWithItems:(NSMutableArray *)items cellIdentifier:(NSString *)cellId configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock {
    self = [super init];
    if (self) {
        self.items = items;
        self.cellIdentifier = cellId;
        self.configureCellBlock = [configureCellBlock copy];
    }
    return self;
}

- (void)setEditCellBlock:(TableViewCellEditBlock)editCellBlock {
    _editCellBlock = [editCellBlock copy];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.items[indexPath.section] removeObjectAtIndex:indexPath.row];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[indexPath.section][indexPath.row];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items[section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    if (self.configureCellBlock != nil) {
        self.configureCellBlock(cell,item, indexPath);
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section < self.sectionHeaderArray.count) {
        return self.sectionHeaderArray[section];
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editCellBlock != nil) {
        id item = [self itemAtIndexPath:indexPath];
        self.editCellBlock(item, indexPath);
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self removeItemAtIndexPath:indexPath];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.items[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    if (self.configureCellBlock != nil) {
        self.configureCellBlock(cell,item, indexPath);
    }
    return cell;
}

@end
