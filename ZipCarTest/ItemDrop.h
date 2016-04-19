//
//  ItemDrop.h
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDrop : UIDynamicBehavior

-(void)addItem:(id<UIDynamicItem>)item;
-(void)removeItem:(id<UIDynamicItem>)item;

@end
