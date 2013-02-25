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
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end


@implementation SpotlightViewController


#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupButtons];
    [self setupSegmentedControl];

    // Initialize MDCFocusView and customize its background color
    self.focusView = [MDCFocusView new];
    self.focusView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];

    // Register a MDCFocalPointView subclass to "wrap" focal points
    self.focusView.focalPointViewClass = [MDCSpotlightView class];

    // Add any number of custom views to MDCFocusView
    [self.focusView addSubview:[self buildLabel]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.focusView focus:self.button, self.bottomButton, self.segmentedControl, nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.focusView.isFocused) {
        [self.focusView dismiss:nil];
    }
}


#pragma mark - Internal Methods

- (void)setupButtons {
    self.button = [self buildButton:0];
    [self.view addSubview:self.button];

    [self.view addSubview:[self buildButton:1]];

    self.bottomButton = [self buildButton:2];
    [self.view addSubview:self.bottomButton];
}

- (void)setupSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ @"Hello", @"Focus" ]];
    self.segmentedControl.frame = CGRectMake(self.bottomButton.frame.origin.x - 25.0f,
                                             self.bottomButton.frame.origin.y + self.bottomButton.frame.size.height + 200,
                                             200.0f, 50.0f);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmentedControl];
}

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

- (UILabel *)buildLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 300)];
    label.numberOfLines = 10;
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = @"Press one of the buttons. All controls outside of the highlighted "
                 @"buttons cannot be tapped.";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];

    return label;
}

- (void)onButtonTapped:(UIButton *)sender {
    if (self.focusView.isFocused) {
        [self.focusView dismiss:nil];
    }
}

@end
