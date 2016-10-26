//
//  DDBaseCollectionContainerView.h
//  DDBrickDemo
//
//  Created by amoblin on 16/4/28.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import "DDBaseContainerView.h"
#import "DDScrollDelegate.h"

@interface DDCollectionContainerView : DDBaseContainerView

@property (nonatomic, weak) id<DDScrollDelegate> delegate;

@property (nonatomic, strong) UICollectionView              *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout    *collectionViewFlowLayout;

@property (nonatomic, assign) CGSize itemSize;

@end
