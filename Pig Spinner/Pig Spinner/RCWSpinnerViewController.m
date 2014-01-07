//
//  RCWSpinnerViewController.m
//  Pig Spinner
//
//  Created by Jonathan on 1/1/14.
//  Copyright (c) 2014 Rubber City Wizards. All rights reserved.
//

#import "RCWSpinnerViewController.h"
#import "RCWQuickDragRecognizer.h"

@interface RCWSpinnerViewController ()
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *spinner;
@property (nonatomic, strong) UIDynamicItemBehavior *spinnerBehavior;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) RCWQuickDragRecognizer *drag;
@property (nonatomic, strong) UILabel *what;
@end

@implementation RCWSpinnerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.988 green:0.953 blue:0.910 alpha:1.000];

    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.background.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.background];

    self.spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spinner"]];
    self.spinner.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.spinner];

    self.what = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 70)];
    self.what.font = [UIFont boldSystemFontOfSize:20];
    self.what.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.what];

    self.drag = [[RCWQuickDragRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self.view addGestureRecognizer:self.drag];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self positionViewsInSize:self.view.bounds.size];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    CGSize nextSize = CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width);
    [UIView animateWithDuration:duration animations:^{
        [self positionViewsInSize:nextSize];
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self positionViewsInSize:self.view.bounds.size];
}

- (void)positionViewsInSize:(CGSize)size
{
    CGFloat side = MIN(size.width, size.height);
    self.background.bounds = CGRectMake(0, 0, side, side);
    self.background.center = CGPointMake(size.width/2, size.height/2);

    self.spinner.bounds = CGRectMake(0, 0, side/2, side/2);
    self.spinner.center = self.background.center;

    [self.animator removeBehavior:self.spinnerBehavior];
    self.spinnerBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.spinner]];
    self.spinnerBehavior.angularResistance = 1;

    __weak typeof(self) weakSelf = self;
    self.spinnerBehavior.action = ^{
        CGAffineTransform transform = [(UIView *)weakSelf.spinnerBehavior.items.firstObject transform];
        CGFloat angle = atan2(transform.b, transform.a);
        [weakSelf highlightSegmentAtAngle:angle];
    };

    [self.animator addBehavior:self.spinnerBehavior];

    self.what.center = CGPointMake(self.background.center.x, self.background.center.y + side/2.4);
}

- (void)highlightSegmentAtAngle:(CGFloat)angle
{
    if (angle > 0 && angle <= 1.230600) {
        self.what.text = @"2 FENCES";
    } else if ((angle > 1.230600 && angle <= 1.932000) || (angle >= -1.890200 && angle < -1.206000)) {
        self.what.text = @"RUNAWAY PIG";
    } else if ((angle >= -1.20600 && angle <= 0) || (angle < -1.890200 || angle > 1.932000)) {
        self.what.text = @"1 FENCE";
    }
}

- (void)dragged:(RCWQuickDragRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged: {
            CGPoint velocity = [recognizer velocityInView:self.background];
            CGFloat angle = atan2(velocity.x, velocity.y);
            CGFloat amount = 0.3;
            if (angle > 0) amount *= -1;
            [self.spinnerBehavior addAngularVelocity:amount forItem:self.spinner];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGPoint velocity = [recognizer velocityInView:self.background];
            CGFloat angle = 0;
            if (fabs(velocity.x) > fabs(velocity.y)) {
                angle = velocity.x;
            } else {
                angle = velocity.y;
            }
            [self.spinnerBehavior addAngularVelocity:0-angle forItem:self.spinner];
            break;
        }

        default:
            break;
    }
}

@end
