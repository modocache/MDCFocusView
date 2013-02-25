## MDCFocusView

Apply a "tutorial screen" overlay to your application window.
`MDCFocusView` can apply a focus on an arbitrary number of views,
and prevents users from tapping views not currently focused on.

<iframe src="http://player.vimeo.com/video/60418239" width="500" height="508" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe> <p><a href="http://vimeo.com/60418239">MDCFocusView</a> from <a href="http://vimeo.com/user11771478">modocache</a> on <a href="http://vimeo.com">Vimeo</a>.</p>

### How to Use

You can install the project using Cocoapods, by placing `pod MDCFocusView`
in your `Podfile`. After installing:

```objc
// Initialize MDCFocusView and customize its background color
MDCFocusView *focusView = [MDCFocusView new];
focusView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];

// Register a MDCFocalPointView subclass to "wrap" focal points
focusView.focalPointViewClass = [MDCSpotlightView class];

// Add any number of custom views to MDCFocusView
[focusView addSubview:[self buildLabel]];

// Present the focus view
[self.focusView focus:someView, anotherView, nil];
```

Please see the sample app for an example.

### Features

- Because `MDCFocusView` uses `MDCFocalPointView` to wrap focal points,
  it is highly extensible--to create your own focus effect, simply subclass
  `MDCFocalPointView` and implement any custom drawing behavior in `drawRect:`.
  Please see `MDCSpotlightView` for an example.

### Limitations (or Ways to Contribute to this Project)

- Currently `MDCFocusView` can only be applied to the entire application
  window. Ideally, any arbirary view should be able to add `MDCFocusView` as
  a subview.
- Currently only `MDCFocalPointView` and `MDCSpotlightView` are available,
  although I would like to make more. It would be nice, for example, if
  a Gaussian blur could be applied everywhere but the focal points.
- See the GitHub issues for more bugs/feature requests you can help with.

