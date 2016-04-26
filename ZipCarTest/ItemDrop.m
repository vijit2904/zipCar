//
//  ItemDrop.m
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import "ItemDrop.h"

@interface ItemDrop()
@property(strong, nonatomic) UIGravityBehavior *gravity;
@property(strong, nonatomic) UICollisionBehavior *collider;
@property(strong, nonatomic) UIDynamicItemBehavior *animationOptions;

@end

@implementation ItemDrop


-(instancetype)init{
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collider];
        [self addChildBehavior:self.animationOptions];
    }
    
    return self;
}
// lazy Load GravityBehavior
-(UIGravityBehavior*)gravity{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc]init];
        _gravity.magnitude = 0.9;
    }
    return _gravity;
}
// lazy load Collision Behavior
-(UICollisionBehavior*)collider{
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc]init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}
// lazy load Dynamic Item Behavior
-(UIDynamicItemBehavior*)animationOptions{
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc]init];
        _animationOptions.allowsRotation = YES;
    }
    return _animationOptions;
}

-(void)addItem:(id<UIDynamicItem>)item{
    [self.gravity addItem:item];
    [self.collider addItem:item];
    [self.animationOptions addItem:item];
}
-(void)removeItem:(id<UIDynamicItem>)item{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
    [self.animationOptions removeItem:item];
    
}
@end
