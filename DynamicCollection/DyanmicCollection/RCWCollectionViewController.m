#import "RCWCollectionViewController.h"
#import "RCWCollectionViewCell.h"
#import "RCWSpringLayout.h"
#import "RCWDynamicLayout.h"

@interface RCWCollectionViewController ()
@end

@implementation RCWCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self springTapped:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    cell.label.text = [NSString stringWithFormat:@"Cell #%d", indexPath.row];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = 2.0;
    return cell;
}

- (IBAction)springTapped:(id)sender
{
    RCWSpringLayout *layout = [[RCWSpringLayout alloc] init];
    layout.minimumLineSpacing = 4;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, 50);
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

- (IBAction)listTapped:(id)sender
{
    [self switchToTheDynamicLayout];
    RCWDynamicLayout *layout = (id)self.collectionView.collectionViewLayout;
    [layout dynamicallyResizeItems:CGSizeMake(self.view.bounds.size.width, 50)];
}

- (IBAction)gridTapped:(id)sender
{
    [self switchToTheDynamicLayout];
    RCWDynamicLayout *layout = (id)self.collectionView.collectionViewLayout;
    [layout dynamicallyResizeItems:CGSizeMake(154, 100)];
}

- (void)switchToTheDynamicLayout
{
    NSObject *layoutCheck = self.collectionView.collectionViewLayout;
    if ([layoutCheck isKindOfClass:[RCWSpringLayout class]]) {
        RCWDynamicLayout *layout = [[RCWDynamicLayout alloc] init];
        layout.minimumLineSpacing = 4;
        layout.itemSize = CGSizeMake(self.view.bounds.size.width, 50);
        [self.collectionView setCollectionViewLayout:layout animated:YES];
    }
}

@end
