//
//  ViewController.m
//  ZipCarTest
//
//  Created by Vijit Munjal on 9/2/15.
//  Copyright (c) 2015 Vijit Munjal. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Items+Loaditems.h"



@interface ViewController () <UITextFieldDelegate>
@property(strong, nonatomic) NSManagedObjectContext *context;
@property(getter=isCredited, readwrite) BOOL hasCredit;
@property (weak, nonatomic) IBOutlet UITextField *amttxtfield;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setHasCredit:NO];
    self.amttxtfield.delegate = self;
    self.changeLabel.text = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// init NSManagedObjectContext
-(NSManagedObjectContext*)context{
    if (!_context) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        _context = [appDelegate managedObjectContext];
        
    }
    
    return _context;
}

// refill's the empty items
- (IBAction)restockEmptyItems:(UIButton *)sender {
    
    [Items restockItems:self.context];
    
}
// this will get the amt from textfiled and subtract the item price from it and return the change amount
-(void)updateChangeLabel:(double)amtToSubtract{
    
    NSDecimalNumber *change = [(NSDecimalNumber *)[NSDecimalNumber decimalNumberWithString:self.amttxtfield.text] decimalNumberBySubtracting:(NSDecimalNumber *)[NSDecimalNumber numberWithDouble:amtToSubtract] ];
    // this will set the changLable to display the change amt
    self.changeLabel.text = [self giveChangeInCoins:change];
    
    self.amttxtfield.text = @"";
    self.amttxtfield.userInteractionEnabled = YES;
    [self setHasCredit:NO]; // set the has credit to NO  from YES
    
    
}
// this caluclate the change in $1, ¢25, ¢10, ¢5 and ¢1
-(NSString*)giveChangeInCoins : (NSDecimalNumber*)leftOver{
    
    NSString *changeToReturn = [[NSString alloc]init];
    
    NSDecimalNumber *dollar = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:1];
    NSDecimalNumber *noChangeLeft = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:0];
    NSDecimalNumber *quater = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:0.25];
    NSDecimalNumber *dime = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:0.10];
    NSDecimalNumber *nickle = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:0.05];
    NSDecimalNumber *penney = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:0.01];
    NSDecimalNumber *change = leftOver;
    
    if ([change compare:noChangeLeft] == NSOrderedSame) {
       return changeToReturn = @"You have no change";
    }
    changeToReturn = @"Plase Collect: ";
    
    while ([change compare:noChangeLeft] != NSOrderedSame) {
        if (([change compare:dollar] == NSOrderedDescending || [change compare:dollar] == NSOrderedSame )&& [change compare:noChangeLeft] != NSOrderedSame) {
            NSDecimalNumber *amtLeft = [change decimalNumberByDividingBy:dollar];
            double amtToLess = 1 * amtLeft.intValue;
            change = [change decimalNumberBySubtracting:(NSDecimalNumber*)[NSDecimalNumber numberWithDouble:amtToLess]];
            changeToReturn = [changeToReturn stringByAppendingString:[NSString stringWithFormat:@"$1x%d", amtLeft.intValue]];
            
        }
        
        if (([change compare:quater] == NSOrderedDescending || [change compare:quater] == NSOrderedSame )&& change != 0) {
            
            NSDecimalNumber *amtLeft = [change decimalNumberByDividingBy:quater];
            double amtToLess = .25 * amtLeft.intValue;
            change = [change decimalNumberBySubtracting:(NSDecimalNumber*)[NSDecimalNumber numberWithDouble:amtToLess]];
           changeToReturn = [changeToReturn stringByAppendingString:[NSString stringWithFormat:@", ¢25x%d", amtLeft.intValue]];
            
        }
        if (([change compare:dime] == NSOrderedDescending || [change compare:dime] == NSOrderedSame )&& [change compare:noChangeLeft] != NSOrderedSame) {
            
            NSDecimalNumber *amtLeft = [change decimalNumberByDividingBy:dime];
            double amtToLess = .10 * amtLeft.intValue;
            change = [change decimalNumberBySubtracting:(NSDecimalNumber*)[NSDecimalNumber numberWithDouble:amtToLess]];
            changeToReturn = [changeToReturn stringByAppendingString:[NSString stringWithFormat:@", ¢10x%d", amtLeft.intValue]];
            
        }
        if (([change compare:nickle] == NSOrderedDescending || [change compare:nickle] == NSOrderedSame )&& [change compare:noChangeLeft] != NSOrderedSame) {
            
            NSDecimalNumber *amtLeft = [change decimalNumberByDividingBy:nickle];
            double amtToLess = .05 * amtLeft.intValue;
            change = [change decimalNumberBySubtracting:(NSDecimalNumber*)[NSDecimalNumber numberWithDouble:amtToLess]];
            changeToReturn = [changeToReturn stringByAppendingString:[NSString stringWithFormat:@", ¢5x%d", amtLeft.intValue]];
            
        }
        if (([change compare:penney] == NSOrderedDescending || [change compare:penney] == NSOrderedSame )&& [change compare:noChangeLeft] != NSOrderedSame) {
            
            NSDecimalNumber *amtLeft = [change decimalNumberByDividingBy:penney];
            change = 0;
            changeToReturn = [changeToReturn stringByAppendingString:[NSString stringWithFormat:@", ¢1x%d.", amtLeft.intValue]];
            
        }
    }
    
    
    return changeToReturn;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length == 2 && string.length !=0) {
        // add dot(.), to the entred amt
        textField.text = [NSString stringWithFormat:@"%@.",textField.text];
        return YES;
    }
    // stop the user from entering more then 4 char
    if (textField.text.length > 4 && range.location > 4) {
        
        return NO;
        
    }
    else{
        return YES;
    }
}
// it check's if the entred amt is less than $10 and more than $1
-(BOOL)validateEntredAmt: (NSString *)amt {
    
    NSNumberFormatter *amtFormatter = [[NSNumberFormatter alloc]init];
    [amtFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [amtFormatter setPositiveFormat:@"0.##"];
    double amtEnterd = [amtFormatter numberFromString:amt].doubleValue;
    
    if ((amtEnterd > 10.0) || (amtEnterd < 1.0)) {
        return NO;
    }
    return YES;
}

// show's alert when validate enter amt returs NO
-(void)showAlertwithMessage : (NSString *)msg andTitle :(NSString *)title{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    __weak ViewController *weakSelf = self;
    UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        weakSelf.amttxtfield.text = @"";
        ;
    }];
    [alertController addAction:alertActionOk];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (IBAction)amountEntred:(UIButton *)sender {
    
    [self.amttxtfield resignFirstResponder];
    if ([self validateEntredAmt:self.amttxtfield.text]) {
        
        [self setHasCredit:YES];
        self.amttxtfield.userInteractionEnabled = NO;
    }else{
        [self showAlertwithMessage:@"You have entered Invalid Amount" andTitle:@"Invalid"];
    }
    

}


@end
