//
//  DDViewModel+CollectionView.h
//  DDBrickDemo
//
//  Created by amoblin on 16/7/20.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import "DDViewModel.h"
#import "DDBaseData+CollectionView.h"
#import "DDBaseCollectionViewCell.h"

@interface DDViewModel (CollectionView)

#if TARGET_OS_IPHONE

- (Class)collectionViewCellClassForIndexPath:(NSIndexPath *)indexPath;

#endif

@end
