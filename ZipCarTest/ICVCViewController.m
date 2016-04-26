//
//  ICVCViewController.m
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import "ICVCViewController.h"
#import "ViewController.h"
#import "ItemCollectionViewCell.h"
#import "Items.h"
#include "Items+Loaditems.h"
#import "AppDelegate.h"
#import "ItemDrop.h"


@interface ICVCViewController ()<UIDynamicAnimatorDelegate>

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) ItemDrop *dropitBehavior;
@property (strong, nonatomic) UIImageView *itemDropView;
@property (strong, nonatomic) ViewController *pvc;

@end

@implementation ICVCViewController

static NSString * const reuseIdentifier = @"snackCell";

-(void)awakeFromNib{
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedContext = [appDelegate managedObjectContext];
}
// set Managed object Context
-(void)setManagedContext:(NSManagedObjectContext *)managedContext{
    
    _managedContext = managedContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Items"];
    request.predicate = nil;
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"itemname"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                       managedObjectContext:managedContext
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
    
}
// lazy load parent View Controller
-(ViewController*)pvc{
    if (!_pvc) {
        
        if ([self.parentViewController isKindOfClass:[ViewController class]]) {
            _pvc = (ViewController*)self.parentViewController;
            
        }
    }
    return _pvc;
}

// Asks the data source for the cell that corresponds to the specified item in the collection view
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.itemImage.image = [UIImage imageNamed:self.imageArray[indexPath.item]];
    Items * vedingItems = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.itemPrice.text = [NSString stringWithFormat:@"$ %@", vedingItems.itemprice];
    cell.itemQty.text = [NSString stringWithFormat:@"Qty: %@", vedingItems.itemqty];
    cell.imageRefill.image = ([(vedingItems.itemqty) intValue] == 0) ? [UIImage imageNamed:@"redglow"]:[UIImage imageNamed:@"greenglow"];
    if ([(vedingItems.itemqty) intValue] == 0) cell.userInteractionEnabled = NO;
    return cell;
}



// Tells the delegate that the item at the specified index path was selected.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Items *itemName = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([itemName.itemqty intValue] != 0 && self.pvc.isCredited) {
        
        [ Items adjustQtyForItem:[NSString stringWithFormat:@"%@" ,itemName.itemname] inManagedObjectContext:self.managedContext];
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CGRect selectedCellFrame = [cell.superview convertRect:cell.frame toView:self.collectionView];
        
        [self dropFromPoint:selectedCellFrame withImageName:self.imageArray[indexPath.item]];
        
        
        [self.pvc.changeLabel setText:@"Vending...."];
        [self.pvc.vendingActivityIndicator startAnimating];
        [self.pvc updateChangeLabel:itemName.itemprice.doubleValue];
        
    }
    
}




#pragma mark - Drop Animation

// lazy load ItemDrop
- (ItemDrop *)dropitBehavior
{
    if (!_dropitBehavior) {
        _dropitBehavior = [[ItemDrop alloc] init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

// lazy load DynamicAnimator
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.collectionView];
        _animator.delegate = self;
    }
    return _animator;
}

// is called when Dynamic Animator is done animating.
// remove the droped item from the view and from ItemDrop
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.itemDropView removeFromSuperview];
    [self.dropitBehavior removeItem:self.itemDropView];
    self.itemDropView = nil;
    self.collectionView.userInteractionEnabled = YES;
    [self.pvc.vendingActivityIndicator stopAnimating];
}
// set item for ItemDrop
- (void)dropFromPoint: (CGRect)frame withImageName:(NSString *)imageName{
    
    UIImageView *dropImageView = [[UIImageView alloc]initWithFrame:frame];
    [dropImageView setContentMode:UIViewContentModeScaleAspectFit];
    dropImageView.image = [UIImage imageNamed:imageName];
    
    self.itemDropView = dropImageView;
    [self.collectionView addSubview:self.itemDropView];
    
    [self.dropitBehavior addItem:self.itemDropView];
    self.collectionView.userInteractionEnabled = NO;
}

-(UIImageView*)itemDropView{
    if (!_itemDropView) {
        _itemDropView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _itemDropView;
}


@end
