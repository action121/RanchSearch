//
//  XHRadarPointView.m
//  XHRadarView
//
//  Created by 邱星豪 on 14/10/27.
//  Copyright (c) 2014年 邱星豪. All rights reserved.
//

#import "WWQRadarPointView.h"

@implementation WWQRadarPointView



- (void)drawRect:(CGRect)rect {
}


#pragma mark - select point
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if(touch.tapCount == 1)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemRadarPointView:)]) {
            [self.delegate didSelectItemRadarPointView:self];
        }
    }
}

@end
