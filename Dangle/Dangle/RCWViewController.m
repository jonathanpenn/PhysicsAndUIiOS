#import "RCWViewController.h"

@interface RCWViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@end

@implementation RCWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ball.center = CGPointMake(self.view.center.x + 150, 70);
    ball.backgroundColor = [UIColor redColor];
    ball.layer.masksToBounds = YES;
    ball.layer.cornerRadius = 20;
    [self.view addSubview:ball];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[ball]];
    [self.animator addBehavior:self.gravity];

    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ball]];
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];

    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ball]];
    itemBehavior.elasticity = 0.8;
    itemBehavior.density = 5;
    [self.animator addBehavior:itemBehavior];

    UIView *anchor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    anchor.center = CGPointMake(self.view.center.x, 200);
    anchor.backgroundColor = [UIColor blueColor];
    [self.view addSubview:anchor];

    UIView *joint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    joint.center = CGPointMake(self.view.center.x, 350);
    joint.backgroundColor = [UIColor blueColor];
    [self.view addSubview:joint];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 400, 60)];
    textField.center = CGPointMake(self.view.center.x, 500);
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont boldSystemFontOfSize:35];
    textField.backgroundColor = [UIColor lightGrayColor];
    [textField becomeFirstResponder];
    [self.view addSubview:textField];

    [collisionBehavior addItem:joint];
    [collisionBehavior addItem:textField];

    UIAttachmentBehavior *jointAttachment = [[UIAttachmentBehavior alloc] initWithItem:textField attachedToItem:joint];
    [self.animator addBehavior:jointAttachment];
    UIAttachmentBehavior *anchorAttacment = [[UIAttachmentBehavior alloc] initWithItem:joint attachedToAnchor:anchor.center];
    [self.animator addBehavior:anchorAttacment];

    [self.gravity addItem:joint];
    [self.gravity addItem:textField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.gravity.angle *= -1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    CGRect keyboardFrame = [(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:self.view.window];
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= keyboardFrame.size.height;
    self.view.frame = viewFrame;
}

- (void)keyboardWillHide:(NSNotification *)note
{
    CGRect keyboardFrame = [(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += keyboardFrame.size.height;
    self.view.frame = viewFrame;
}

@end
