#import "RCWViewController.h"

@interface RCWViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *dropZone1;
@property (weak, nonatomic) IBOutlet UIView *dropZone2;

@property (weak, nonatomic) UIView *lastDroppedInZone;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation RCWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.animator = [[UIDynamicAnimator alloc] init];
    [self snapToZone:self.dropZone1];
}

- (void)snapToZone:(UIView *)zone
{
    self.lastDroppedInZone = zone;
    [self.animator removeAllBehaviors];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView
                                                    snapToPoint:zone.center];
    snap.damping = 0.8;
    [self.animator addBehavior:snap];
}

- (IBAction)panned:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture locationInView:self.view];

    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            [self.animator removeAllBehaviors];
            self.imageView.center = point;
            break;
        case UIGestureRecognizerStateEnded:
            if ([panGesture velocityInView:self.view].y < -500) {
                [self snapToZone:self.dropZone1];
            } else if ([panGesture velocityInView:self.view].y > 500) {
                [self snapToZone:self.dropZone2];
            } else {
                if (CGRectContainsPoint(self.dropZone1.frame, point)) {
                    [self snapToZone:self.dropZone1];
                } else if (CGRectContainsPoint(self.dropZone2.frame, point)) {
                    [self snapToZone:self.dropZone2];
                } else {
                    [self snapToZone:self.lastDroppedInZone];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            [self snapToZone:self.lastDroppedInZone];
            break;
        default:
            break;
    }

}

@end
