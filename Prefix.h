//
//  Prefix.h
//  marboo.io
//
//  Created by amoblin on 14/10/31.
//
//

#ifndef Macros_h
#define Macros_h

#define Local(key) NSLocalizedString(key, nil)

#define UIColorFromRGBA(r,g,b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

// for Masonry
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#import <Masonry.h>
//#import <SVProgressHUD.h>

//#import "WANetwork.h"
//#import "WATableViewController.h"
//#import "WATableViewCell.h"

//#define API_ROOT @"http://api.zhanguide.com"
#define API_ROOT @"http://shop.10000km.cn"

//#define AMAP_KEY @"918a8be56cc8f8abf4eee239d987b511"
#define AMAP_KEY @"8a82b9cd4e124fe657653dea9a47f26f"

#endif