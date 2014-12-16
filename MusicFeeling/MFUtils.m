//
//  MFUtils.m
//  MusicFeeling
//
//  Created by amoblin on 14/10/11.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFUtils.h"

@interface MFUtils()

@property (strong, nonatomic) NSDictionary *mapper;
@property (strong, nonatomic) NSDictionary *router;
@property (strong, nonatomic) NSDictionary *numberDict;
@property (strong, nonatomic) NSDictionary *revertNumberDict;

@end
@implementation MFUtils

+ (MFUtils*)sharedInstance {
    static MFUtils *_instance = nil;

    @synchronized (self) {
        _instance = [MFUtils new];
    }
    return _instance;
}

- (NSDictionary *)mapper {
    if (_mapper == nil) {
        _mapper = @{@"1": @"C6", @"2": @"D6", @"3": @"E6", @"4": @"F6", @"7": @"G6", @"8": @"A6", @"9": @"B6",
                    @"0": @"C7", @"-": @"D7", @"=": @"E7",

                    @"q": @"C5", @"w": @"D5", @"e": @"E5", @"r": @"F5", @"u": @"G5", @"i": @"A5", @"o": @"B5",
                    @"p": @"C6", @"[": @"D6", @"]": @"E6", @"\\": @"F6",

                    @"a": @"C4", @"s": @"D4", @"d": @"E4", @"f": @"F4", @"j": @"G4", @"k": @"A4", @"l": @"B4",
                    @";": @"C5", @"'": @"D5",

                    @"z": @"C3", @"x": @"D3", @"c": @"E3", @"v": @"F3", @"m": @"G3", @",": @"A3", @".": @"B3",
                    @"/": @"C4",

                    @"g": @"D4m", @"h": @"F4m",
                    @"t": @"D5m", @"y": @"F5m",
                    @"b": @"D3m", @"n": @"F3m",

                    // b
                    @"∑": @"C5m", @"´": @"D5m", @"¨": @"F5m", @"ˆ": @"G5m", @"ø": @"A5m",
                    @"ß": @"C4m", @"∂": @"D4m", @"∆": @"F4m", @"˚": @"G4m", @"¬": @"A4m",
                    @"≈": @"C3m", @"ç": @"D3m", @"µ": @"F3m", @"≤": @"G3m", @"≥": @"A3m",

                    // #
                    @"Q": @"C5m", @"W": @"D5m", @"R": @"F5m", @"U": @"G5m", @"I": @"A5m",
                    @"A": @"C4m", @"S": @"D4m", @"F": @"F4m", @"J": @"G4m", @"K": @"A4m",
                    @"Z": @"C3m", @"X": @"D3m", @"V": @"F3m", @"M": @"G3m", @"<": @"A3m"
                    };
    }
    return _mapper;
}

- (NSDictionary *)numberDict {
    if (_numberDict == nil) {
        _numberDict = @{
                        @"C3": @"•1",
                        @"C3m": @"•1#",
                        @"D3": @"•2",
                        @"D3m": @"•2#",
                        @"E3": @"•3",
                        @"F3": @"•4",
                        @"F3m": @"•4#",
                        @"G3": @"•5",
                        @"G3m": @"•5#",
                        @"A3": @"•6",
                        @"A3m": @"•6#",
                        @"B3": @"•7",

                        @"C4": @"1",
                        @"C4m": @"1#",
                        @"D4": @"2",
                        @"D4m": @"2#",
                        @"E4": @"3",
                        @"F4": @"4",
                        @"F4m": @"4#",
                        @"G4": @"5",
                        @"G4m": @"5#",
                        @"A4": @"6",
                        @"A4m": @"6#",
                        @"B4": @"7",

                        @"C5": @"1•",
                        @"C5m": @"1#•",
                        @"D5": @"2•",
                        @"D5m": @"2#•",
                        @"E5": @"3•",
                        @"F5": @"4•",
                        @"F5m": @"4#•",
                        @"G5": @"5•",
                        @"G5m": @"5#•",
                        @"A5": @"6•",
                        @"A5m": @"6#•",
                        @"B5": @"7•",

                        @"C6": @"1••",
                        @"C6m": @"1#••",
                        @"D6": @"2••",
                        @"D6m": @"2#••",
                        @"E6": @"3••",
                        @"F6": @"4••",
                        @"F6m": @"4#••",
                        @"G6": @"5••",
                        @"G6m": @"5#••",
                        @"A6": @"6••",
                        @"A6m": @"6#••",
                        @"B6": @"7••",

                        @"C7": @"1•••",
                        @"C7m": @"1#•••",
                        @"D7": @"2•••",
                        @"D7m": @"2#•••",
                        @"E7": @"3•••",
                        @"F7": @"4•••",
                        @"F7m": @"4#•••",
                        @"G7": @"5•••",
                        @"G7m": @"5#•••",
                        @"A7": @"6•••",
                        @"A7m": @"6#•••",
                        @"B7": @"7•••",

                        };
    }
    return _numberDict;
}

- (NSDictionary *)revertNumberDict {
    if (_revertNumberDict == nil) {
        _revertNumberDict = [self reverseDict:self.numberDict];
    }
    return _revertNumberDict;
}
- (NSDictionary *)router {
    if (_router == nil) {
        NSString *filter = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789,.-=";
        NSDictionary *dic = [self getFilteredDict:self.mapper withFilter:filter];
        _router = [self reverseDict:dic];
    }
    return _router;
}

- (NSDictionary *)getFilteredDict:(NSDictionary *)dict withFilter:(NSString *)filter {
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:filter] invertedSet];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    for (NSString *key in dict.allKeys) {
        if ([key rangeOfCharacterFromSet:set].location != NSNotFound) {
            //NSLog(@"This string contains illegal characters");
            [dic removeObjectForKey:key];
            continue;
        }
    }
    return dic;
}

- (NSDictionary *)reverseDict:(NSDictionary *)dict {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:50];
    for (NSString *key in dict.allKeys) {
        dic[dict[key]] = key;
    }
    return dic;
}

+ (NSString *)staffToNumber:(NSString *)staffString {
    return [MFUtils sharedInstance].numberDict[staffString];
}

+ (NSString *)numberToStaff:(NSString *)numberString {
    return [MFUtils sharedInstance].revertNumberDict[numberString];
}

+ (NSString *)keyboardToStaff:(NSString *)keyboardString {
    return [MFUtils sharedInstance].mapper[keyboardString];
}

+ (NSString *)staffToKeyboard:(NSString *)staffString {
    return [MFUtils sharedInstance].router[staffString];
}

@end
