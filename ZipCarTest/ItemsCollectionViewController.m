//
//  ItemsCollectionViewController.m
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import "ItemsCollectionViewController.h"
#import  "ItemCollectionViewCell.h"

@interface ItemsCollectionViewController ()

@end

@implementation ItemsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// lazy load the image array with image names
-(NSArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [[NSArray alloc]init];
    
    _imageArray = @[@"kitKat",@"singleWelchs",@"ExcelWinterfreshMints",
                    @"fiji",@"arizonaIcedTea",@"mtnDew",
                    @"doritos",@"laysClassic",@"strongMint"];
    }
    return _imageArray;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Fetching
// get items from the data base
-(void)performFetch{
    if (self.fetchedResultsController) {
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
            
        }
        [self.collectionView reloadData];
        
    }
}
// set the Fetched Results Controller
- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if (newfrc) {
            [self performFetch];
        } else {
            [self.collectionView reloadData];
        }
    }
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.imageArray.count;
}


#pragma mark <UICollectionViewDelegate>

// Notifies if fetched object has been changed due to an add, remove, move, or update.
#pragma mark - NSFetchedResultsControllerDelegate

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
            
            // only care about update
        case NSFetchedResultsChangeUpdate:
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            break;
            
        default:
            break;
    }
}



@end
