//
//  DDBaseCollectionViewController.h
//  DDBrickDemo
//
//  Created by amoblin on 16/4/28.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import "DDBaseListViewController.h"
#import "DDViewModel+CollectionView.h"

@interface DDBaseCollectionViewController : DDBaseListViewController

@property (nonatomic, strong) UICollectionView              *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout    *collectionViewFlowLayout;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
