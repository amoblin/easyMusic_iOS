//
//  WATextField.m
//  goClimb
//
//  Created by amoblin on 15/5/22.
//  Copyright (c) 2015年 marboo. All rights reserved.
//

#import "WATextField.h"

@implementation WATextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 50 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 50 , 10 );
}

@end
