//  MDCSpotlightView.m
//
//  Copyright (c) 2013 modocache
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "MDCSpotlightView.h"


@implementation MDCSpotlightView


#pragma mark - MDCFocalPointView Overrides

- (id)initWithFocalView:(UIView *)focalView {
    self = [super initWithFocalView:focalView];
    if (self) {
        CGRect focalRect = focalView.frame;

        CGFloat margin = MAX(focalRect.size.width, focalRect.size.height);
        self.frame = CGRectMake(focalRect.origin.x - margin/2,
                                focalRect.origin.y - margin/2,
                                focalRect.size.width + margin,
                                focalRect.size.height + margin);
    }
    return self;
}


#pragma mark - UIView Overrides

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat locations[3] = { 0.0f, 0.5f, 1.0f };
    CFArrayRef colors = (__bridge CFArrayRef)@[
        (__bridge id)[UIColor clearColor].CGColor,
        (__bridge id)[UIColor clearColor].CGColor,
        (__bridge id)self.superview.backgroundColor.CGColor
    ];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);

    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(rect.size.width/2, rect.size.height/2);
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
