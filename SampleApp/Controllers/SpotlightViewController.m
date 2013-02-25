//  SpotlightViewController.m
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


#import "SpotlightViewController.h"

#import "MDCFocusView.h"
#import "MDCSpotlightView.h"


static CGFloat const kSpotlightViewControllerButtonMargin = 70.0f;
static CGFloat const kSpotlightViewControllerButtonHeight = 50.0f;
static CGFloat const kSpotlightViewControllerButtonWidth = 150.0f;


@interface SpotlightViewController ()
@property (nonatomic, strong) MDCFocusView *focusView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@end


@implementation SpotlightViewController


#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];

    self.button = [self buildButton:0];
    [self.view addSubview:self.button];

    [self.view addSubview:[self buildButton:1]];

    self.bottomButton = [self buildButton:2];
    [self.view addSubview:self.bottomButton];

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.focusView = [[MDCFocusView alloc] initWithFrame:keyWindow.frame];
    self.focusView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7f];
    self.focusView.focalPointViewClass = [MDCSpotlightView class];
    [keyWindow addSubview:self.focusView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.focusView focus:self.button, self.bottomButton, self.doneButton, nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.focusView.isFocused) {
        [self.focusView dismiss];
    }
}


#pragma mark - Internal Methods

- (UIButton *)buildButton:(NSUInteger)buttonIndex {
    CGFloat buttonOriginY = kSpotlightViewControllerButtonMargin +
                            (buttonIndex * (kSpotlightViewControllerButtonHeight + kSpotlightViewControllerButtonMargin));

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(floorf((self.view.frame.size.width - kSpotlightViewControllerButtonWidth)/2),
                              buttonOriginY,
                              kSpotlightViewControllerButtonWidth,
                              kSpotlightViewControllerButtonHeight);

    [button setTitle:@"Press Me!" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(onButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (void)onButtonTapped:(UIButton *)sender {
    if (self.focusView.isFocused) {
        [self.focusView dismiss];
    }
}

@end
