//
//  ItemsCollectionViewController.h
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ItemsCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *imageArray;

// This will also automatically be called if you change the fetchedResultsController
- (void)performFetch;

@end
