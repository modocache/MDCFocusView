//  MDCFocusViewSpec.m
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


#import <Kiwi/Kiwi.h>
#import "MDCFocusView.h"

#import "MDCFocalPointView.h"


SPEC_BEGIN(MDCFocusViewSpec)

describe(@"MDCFocusView", ^{
    __block MDCFocusView *focusView = nil;
    beforeEach(^{
        focusView = [MDCFocusView new];
    });

    describe(@"-init", ^{
        it(@"is hidden", ^{
            [[theValue(focusView.alpha) should] equal:theValue(0.0f)];
        });

        it(@"does not swallow touches", ^{
            [[theValue(focusView.userInteractionEnabled) should] beNo];
        });
    });

    describe(@"-focusDuration", ^{
        it(@"determines the duration of animation used in -focus:", ^{
            focusView.focusDuration = 10.0;

            [[UIView should] receive:@selector(animateWithDuration:animations:completion:)
                       withArguments:theValue(10.0), [KWAny any], [KWAny any]];

            [focusView focusOnViews:@[]];
        });
    });

    describe(@"-focus:", ^{
        it(@"applies a focus to the views in the list", ^{
            UIView *view = [UIView new];
            UIButton *button = [UIButton new];

            [[focusView should] receive:@selector(focusOnViews:) withArguments:@[view, button]];

            [focusView focus:view, button, nil];
        });
    });

    describe(@"-focusOnViews:", ^{
        context(@"views is nil", ^{
            it(@"raises", ^{
                [[theBlock(^{
                    [focusView focusOnViews:nil];
                }) should] raiseWithName:NSInternalInconsistencyException
                                  reason:@"Invalid parameter not satisfying: views != nil"];
            });
        });

        context(@"views is not nil", ^{
            __block NSMutableArray *views = nil;
            beforeEach(^{
                views = [NSMutableArray new];
            });

            it(@"becomes focused", ^{
                [focusView focusOnViews:views];
                [[theValue(focusView.isFocused) should] beYes];
            });

            it(@"requests to be redrawn", ^{
                [[focusView should] receive:@selector(setNeedsDisplay)];
                [focusView focusOnViews:views];
            });

            it(@"triggers an animation", ^{
                [[UIView should] receive:@selector(animateWithDuration:animations:completion:)];
                [focusView focusOnViews:views];
            });

            it(@"begins to swallow touches", ^{
                [[focusView shouldEventually] receive:@selector(setUserInteractionEnabled:)
                                        withArguments:theValue(YES)];
                [focusView focusOnViews:views];
            });
        });
    });

    describe(@"-dismiss", ^{
        context(@"when not focused in the first place", ^{
            it(@"raises", ^{
                [[theBlock(^{
                    [focusView dismiss:nil];
                }) should] raiseWithName:NSInternalInconsistencyException
                                  reason:@"Cannot dismiss when focus is not applied "
                                         @"in the first place."];
            });
        });

        context(@"when in a focused state", ^{
            beforeEach(^{
                [focusView focusOnViews:@[]];
            });

            it(@"stops swallowing touches", ^{
                [[focusView shouldEventually] receive:@selector(setUserInteractionEnabled:)
                                        withArguments:theValue(NO)];
                [focusView dismiss:nil];
            });

            it(@"loses focus", ^{
                [[focusView shouldEventually] receive:@selector(setFocused:)
                                        withArguments:theValue(NO)];
                [focusView dismiss:nil];
            });
        });
    });
});

SPEC_END
