//
//  Items+Loaditems.h
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import "Items.h"

@interface Items (Loaditems)

// this fuction check and enter items into data base
+(void)loadItemsIntoVendingMachine: (NSArray *)items inManagedObjectContext : (NSManagedObjectContext *)contex;

// this reduce the Qty of the selected item by 1
+(void)adjustQtyForItem: (NSString *)name inManagedObjectContext : (NSManagedObjectContext *)contex;

// this fuction will refill all the items back to 10, if the Qty has reached 0
+(void)restockItems : (NSManagedObjectContext *)contex;

@end
