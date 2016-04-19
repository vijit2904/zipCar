//
//  Items.h
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Items : NSManagedObject

@property (nonatomic, retain) NSString * itemname;
@property (nonatomic, retain) NSString * itemqty;
@property (nonatomic, retain) NSNumber * itemprice;

@end
