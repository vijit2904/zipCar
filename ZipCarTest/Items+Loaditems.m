//
//  Items+Loaditems.m
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import "Items+Loaditems.h"

@implementation Items (Loaditems)

// this function returns an array of item from data base
+(NSArray *)fetchFromItemsWithPredicate :(NSPredicate *)predicate usingManagedObjectContext : (NSManagedObjectContext *)contex{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Items"];
    request.predicate = predicate;
    NSError *error;
    NSArray *itemsArray = [contex executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    return itemsArray;
}

// this fuction check and enter items into data base
+(void)loadItemsIntoVendingMachine: (NSArray *)items inManagedObjectContext : (NSManagedObjectContext *)contex{
    
    Items *item = nil;
    NSError *error;
    NSArray *itemsArray = [self fetchFromItemsWithPredicate:nil usingManagedObjectContext:contex];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    if (![itemsArray count]) {
        
        for (NSDictionary *vendingitem in items) {
            item = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:contex];
            item.itemname = [vendingitem objectForKey:@"name"];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            item.itemprice = [formatter numberFromString:[vendingitem objectForKey:@"price"]];
            item.itemqty = [vendingitem objectForKey:@"Qty"];
            if (![contex save:&error]) {
                NSLog(@"%@",error.localizedDescription);
            }
            
        }
        
    }
//    else{
//        for (Items *vendingitem in itemsArray) {
//        
//            NSLog(@"%@",vendingitem.itemname);
//        }
 //   }
}

// this reduce the Qty of the selected item by 1
+(void)adjustQtyForItem:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)contex{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemname = %@", name];
    
    NSArray *itemsArray = [self fetchFromItemsWithPredicate:predicate usingManagedObjectContext:contex];
    
    Items *itemToEdit = [itemsArray lastObject];
    
    int qty = [itemToEdit.itemqty intValue];
    
    if (qty != 0) {
        
        itemToEdit.itemqty = [NSString stringWithFormat:@"%i", (qty - 1)];
        NSError *error;
        if (![contex save:&error]) {
            NSLog(@"%@",error.localizedDescription);
        }
        
    }
    
}

// this fuction will refill all the items back to 10, if the Qty has reached 0
+(void)restockItems : (NSManagedObjectContext *)contex{
    
    NSArray *itemsArray = [self fetchFromItemsWithPredicate:nil usingManagedObjectContext:contex];
    
    for (Items *itemToRefill in itemsArray) {
        
        int qty = [itemToRefill.itemqty intValue];
        
        if (qty == 0) {
            
            itemToRefill.itemqty = @"10";
            
            NSError *error;
            if (![contex save:&error]) {
                NSLog(@"%@",error.localizedDescription);
            }
            
        }
        
    }
}


@end
