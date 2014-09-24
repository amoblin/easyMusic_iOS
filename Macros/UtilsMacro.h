//
//  UtilsMacro.h
//  MusicFeeling
//
//  Created by amoblin on 14/6/20.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#ifndef MusicFeeling_UtilsMacro_h
#define MusicFeeling_UtilsMacro_h

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#endif
