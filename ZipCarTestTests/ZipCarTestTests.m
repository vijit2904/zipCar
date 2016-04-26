//
//  ZipCarTestTests.m
//  ZipCarTestTests
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "ICVCViewController.h"

@interface ZipCarTestTests : XCTestCase
@property (nonatomic, strong)ICVCViewController *collection;
@end

@implementation ZipCarTestTests

-(ICVCViewController*)collection{
    if (!_collection) {
        _collection = [[ICVCViewController alloc]init];
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        _collection.managedContext = [appDelegate managedObjectContext];
        
    }
    return _collection;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCollectionViewHasItems {
    // This is an example of a functional test case.
    XCTAssert([self.collection.fetchedResultsController.fetchedObjects count] > 0, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
