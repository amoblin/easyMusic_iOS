//
//  NSArray+K2K.m
//  MusicFeeling
//
//  Created by amoblin on 14/6/20.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "NSArray+K2K.h"

@implementation NSArray (K2K)

+ (id)arrayWithK2KString:(NSString *)content {
    NSRange currentRange;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger length = [content length];
    NSUInteger paraStart = 0, paraEnd = 0, contentsEnd = 0;
    //    NSMutableArray *array = [NSMutableArray array];
    while (paraEnd < length)
    {
        [content getParagraphStart:&paraStart end:&paraEnd
                       contentsEnd:&contentsEnd forRange:NSMakeRange(paraEnd, 0)];
        currentRange = NSMakeRange(paraStart, contentsEnd - paraStart);
        NSString *line = [content substringWithRange:currentRange];
        NSLog(@"%@", line);
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSString *item in [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -"]]) {
            if ([item isEqualToString:@""]) {
                continue;
            }
            [items addObject:item];
        }

        NSLog(@"%@", items);
        [array addObject:items];
    }
    return [NSArray arrayWithArray:array];
}

@end
