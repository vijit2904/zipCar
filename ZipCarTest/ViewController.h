//
//  ViewController.h
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// this will get the amt from textfiled and subtract the item price from it and return the change amount
-(void)updateChangeLabel: (double)amtToSubtract;

@property (getter=isCredited, readonly) BOOL hasCredit;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *vendingActivityIndicator;


@end

