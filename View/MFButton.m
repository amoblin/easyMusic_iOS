//
//  MFButton.m
//  MusicFeeling
//
//  Created by amoblin on 14/6/20.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFButton.h"
#import "UIImage+Color.h"

@interface MFButton()

@property (strong, nonatomic) NSDictionary *mapper;
@property (strong, nonatomic) NSDictionary *router;
@property (strong, nonatomic) NSDictionary *numberDict;
@property (strong, nonatomic) NSDictionary *revertNumberDict;

@end

@implementation MFButton

- (id)initWithTitle:(NSString *)title size:(NSInteger)size tag:(NSInteger)tagIndex andType:(NSInteger) type
{
    self = [super init];
    if (self) {
        // Initialization code
        self.tone = title;
        UIButton *button = self;
        button.tag = tagIndex;
        //        [button.layer setBorderColor:[UIColorFromRGB(180, 180, 180) CGColor]];
        //        [button.layer setBorderColor:[UIColorFromRGB(194, 194, 194) CGColor]];
//        [button.layer setBorderColor:[UIColorFromRGB(171, 211, 255) CGColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        //        [button.layer setBorderColor:[UIColorFromRGB(117, 192, 255) CGColor]];

        if (type == 0) {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:title forState:UIControlStateNormal];
        } else if (type == 1) {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:self.numberDict[title] forState:UIControlStateNormal];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:50];
//            [button setTitle:self.router[title.lowercaseString] forState:UIControlStateNormal];
            button.layer.borderWidth = 0;
            button.layer.cornerRadius = 4;
        }

        [button setTitleColor:UIColorFromRGB(1, 1, 1) forState:UIControlStateNormal];
        //        [button setTitleColor:UIColorFromRGB(41, 140, 255) forState:UIControlStateNormal];

        //            button.backgroundColor = [UIColor blueColor];
        button.translatesAutoresizingMaskIntoConstraints = NO;

        [button setBackgroundImage:[UIImage imageNamed:@"circle_hit"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"circle_hit"] forState:UIControlStateSelected];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setStyle:(NSInteger)style {
    switch (style) {
        case 0:
            self.titleLabel.font = [UIFont systemFontOfSize:14];
            [self setTitle:self.tone forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"circle"]
                            forState:UIControlStateNormal];
            break;
        case 1:
            self.titleLabel.font = [UIFont systemFontOfSize:14];
            [self setTitle:self.numberDict[self.tone] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"circle"]
                            forState:UIControlStateNormal];
            break;
        case 2:
            self.titleLabel.font = [UIFont systemFontOfSize:50];
            [self setTitle:self.router[self.tone] forState:UIControlStateNormal];
            [self setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        default:
            break;
    }
//            NSString *toneName = self.titleLabel.text;
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
                        @"D3": @"•2",
                        @"E3": @"•3",
                        @"F3": @"•4",
                        @"G3": @"•5",
                        @"A3": @"•6",
                        @"B3": @"•7",

                        @"C4": @"1",
                        @"D4": @"2",
                        @"E4": @"3",
                        @"F4": @"4",
                        @"G4": @"5",
                        @"A4": @"6",
                        @"B4": @"7",

                        @"C5": @"1•",
                        @"D5": @"2•",
                        @"E5": @"3•",
                        @"F5": @"4•",
                        @"G5": @"5•",
                        @"A5": @"6•",
                        @"B5": @"7•",

                        @"C6": @"1••",
                        @"D6": @"2••",
                        @"E6": @"3••",
                        @"F6": @"4••",
                        @"G6": @"5••",
                        @"A6": @"6••",
                        @"B6": @"7••",

                        @"C7": @"1•••",
                        @"D7": @"2•••",
                        @"E7": @"3•••",
                        @"F7": @"4•••",
                        @"G7": @"5•••",
                        @"A7": @"6•••",
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

@end
