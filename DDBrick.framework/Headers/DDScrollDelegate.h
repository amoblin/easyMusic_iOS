//
//  DDScrollDelegate.h
//  DDBrickDemo
//
//  Created by amoblin on 16/4/28.
//  Copyright © 2016年 marboo. All rights reserved.
//

#ifndef DDScrollDelegate_h
#define DDScrollDelegate_h

@protocol DDScrollDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

#endif /* DDScrollDelegate_h */
