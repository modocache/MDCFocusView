//  MDCFocusView.m
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


#import "MDCFocusView.h"

#import "MDCFocalPointView.h"
#import "MDCSpotlightView.h"


@interface MDCFocusView ()
@property (nonatomic, strong) NSArray *focii;
@property (nonatomic, assign, getter = isFocused) BOOL focused;
@end


@implementation MDCFocusView


#pragma mark - Object Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _focusDuration = 0.5;
        _focalPointViewClass = [MDCFocalPointView class];

        self.userInteractionEnabled = NO;
        self.opaque = NO;
        self.alpha = 0.0f;
    }
    return self;
}


#pragma mark - UIView Overrides

- (void)drawRect:(CGRect)rect {
    [[UIColor clearColor] setFill];

    for (UIView *focus in self.focii) {
        UIRectFill(CGRectIntersection(focus.frame, rect));
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (MDCFocalPointView *focus in self.focii) {
        if (CGRectContainsPoint(focus.frame, point)) {
            return focus.focalView;
        }
    }

    return self.isFocused ? self : nil;
}


#pragma mark - Public Interface

- (void)focus:(UIView *)views, ... {
    NSMutableArray *focii = [NSMutableArray new];

    va_list viewList;
    va_start(viewList, views);
    for (UIView *view = views; view != nil; view = va_arg(viewList, UIView *)) {
        [focii addObject:view];
    }
    va_end(viewList);

    [self focusOnViews:[focii copy]];
}

- (void)focusOnViews:(NSArray *)views {
    NSParameterAssert(views != nil);

    self.focused = YES;

    NSMutableArray *focii = [NSMutableArray arrayWithCapacity:[views count]];

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in views) {
        MDCFocalPointView *focalPointView = [[self.focalPointViewClass alloc] initWithFocalView:view];
        [self addSubview:focalPointView];
        focalPointView.frame = [keyWindow convertRect:focalPointView.frame fromView:focalPointView.focalView.superview];

        [focii addObject:focalPointView];
    }

    self.focii = [focii copy];
    [self setNeedsDisplay];

    [UIView animateWithDuration:self.focusDuration animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)dismiss {
    NSAssert(self.focused, @"Cannot dismiss when focus is not applied in the first place.");

    [UIView animateWithDuration:self.focusDuration animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        for (MDCFocalPointView *view in self.focii) {
            [view removeFromSuperview];
        }
        self.focii = nil;

        self.userInteractionEnabled = NO;
        self.focused = NO;
        [self setNeedsDisplay];
    }];
}

@end
