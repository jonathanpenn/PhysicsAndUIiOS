#import "RCWSpringLayout.h"

@interface RCWSpringLayout ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPaths;
@property (nonatomic) CGFloat lastScrollDelta;
@end

@implementation RCWSpringLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visibleIndexPaths = [NSMutableSet set];
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.animator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
}

- (void)prepareLayout
{
    [super prepareLayout];

    CGRect visibleRect = CGRectInset(self.collectionView.bounds, -100, -100);

    NSArray *itemsVisible = [super layoutAttributesForElementsInRect:visibleRect];
    NSSet *indexPathsInRect = [NSSet setWithArray:[itemsVisible valueForKey:@"indexPath"]];

    [self.animator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *attachment, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *item = attachment.items.firstObject;
        BOOL notVisibleInRect = [indexPathsInRect member:item.indexPath] == nil;
        if (notVisibleInRect) {
            [self.animator removeBehavior:attachment];
            [self.visibleIndexPaths removeObject:item.indexPath];
        }
    }];

    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    [itemsVisible enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        BOOL currentlyVisible = [self.visibleIndexPaths member:item.indexPath] != nil;
        if (!currentlyVisible) {
            CGPoint center = item.center;
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];

            spring.length = 0;
            spring.damping = 0.8;
            spring.frequency = 1;

            [self updateItemCenter:item fromTouchLocation:touchLocation forScrollDelta:self.lastScrollDelta anchorPoint:center];

            [self.animator addBehavior:spring];
            [self.visibleIndexPaths addObject:item.indexPath];
        }
    }];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    self.lastScrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];

    [self.animator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *spring, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *item = spring.items.firstObject;
        [self updateItemCenter:item fromTouchLocation:touchLocation forScrollDelta:self.lastScrollDelta anchorPoint:spring.anchorPoint];
        [self.animator updateItemUsingCurrentState:item];
    }];
    
    return NO;
}

- (void)updateItemCenter:(UICollectionViewLayoutAttributes *)item fromTouchLocation:(CGPoint)touchLocation forScrollDelta:(CGFloat)scrollDelta anchorPoint:(CGPoint)anchorPoint
{
    CGPoint center = item.center;
    if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
        CGFloat distanceFromTouch = fabsf(touchLocation.y - anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch / 1500.0f;

        if (scrollDelta < 0) {
            center.y += MAX(scrollDelta, scrollDelta * scrollResistance);
        }
        else {
            center.y += MIN(scrollDelta, scrollDelta * scrollResistance);
        }
        item.center = center;
    }
}

@end
