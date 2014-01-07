#import "RCWDynamicLayout.h"

@interface RCWDynamicLayout ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSArray *originalItems;
@property (nonatomic) BOOL itemSizesChanged;
@end

CGFloat const kSpringDamping = 0.9;

@implementation RCWDynamicLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
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

- (void)dynamicallyResizeItems:(CGSize)newSize
{
    self.itemSize = newSize;
    self.itemSizesChanged = YES;
    [self invalidateLayout];
}

- (void)prepareLayout
{
    [super prepareLayout];

    if (!self.originalItems) {
        CGSize contentSize = [self collectionViewContentSize];
        self.originalItems = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];

        [self.originalItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:item snapToPoint:item.center];
            snap.damping = kSpringDamping;
            [self.animator addBehavior:snap];
        }];
    } else if (self.itemSizesChanged) {
        self.itemSizesChanged = NO;

        [self.animator removeAllBehaviors];

        CGSize contentSize = [self collectionViewContentSize];
        NSArray *newItems = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];

        [self.originalItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
            UICollectionViewLayoutAttributes *newItem = [newItems objectAtIndex:item.indexPath.row];

            CGPoint newCenter = newItem.center;
            newItem.center = item.center;

            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:newItem snapToPoint:newCenter];
            snap.damping = kSpringDamping;
            [self.animator addBehavior:snap];
        }];

        self.originalItems = newItems;
    }
}

@end
