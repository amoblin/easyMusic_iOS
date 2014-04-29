//
//  MFArrayDataSource.h
//  MusicFeeling
//
//  Created by amoblin on 14-4-26.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item, NSIndexPath *indexPath);


@interface MFArrayDataSource: NSObject <UITableViewDataSource, UICollectionViewDataSource>

- (id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellId configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end