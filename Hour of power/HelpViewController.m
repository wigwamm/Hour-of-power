//
//  HelpViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 10/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStatus];
}

- (void)setStatus
{
    //AddressBook
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"addressBookSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        NSLog(@"ONNNNN");
        [self setSwitchStatusWithSwitch:self.addressBookSwitch withStatus:YES];
    } else {
        NSLog(@"OFFFFF");
        [self setSwitchStatusWithSwitch:self.addressBookSwitch withStatus:NO];
    }
    
    //Facebook
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"facebookSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        NSLog(@"ONNNNN");
        [self setSwitchStatusWithSwitch:self.facebookSwitch withStatus:YES];
    } else {
        NSLog(@"OFFFFF");
        [self setSwitchStatusWithSwitch:self.facebookSwitch withStatus:NO];
    }
    
    //Email
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"emailSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        NSLog(@"ONNNNN");
        [self setSwitchStatusWithSwitch:self.emailSwitch withStatus:YES];
    } else {
        NSLog(@"OFFFFF");
        [self setSwitchStatusWithSwitch:self.emailSwitch withStatus:NO];
    }
}

- (void)setSwitchStatusWithSwitch:(UISwitch *)theSwitch withStatus:(BOOL)status
{
    [theSwitch setOn:status];
}

- (IBAction)addressBookSwitchAction:(id)sender
{
    if ([self.addressBookSwitch isOn]) {
        NSLog(@"AddressBook sync On!");
        [self setValueToSwitch:@"addressBookSwitch" withValue:YES];
    } else {
        NSLog(@"AddressBook sync Off!");
        [self setValueToSwitch:@"addressBookSwitch" withValue:NO];
    }
}

- (IBAction)facebookSwitchAction:(id)sender
{
    if ([self.facebookSwitch isOn]) {
        NSLog(@"Facebook sync On!");
        [self setValueToSwitch:@"facebookSwitch" withValue:YES];
    } else {
        NSLog(@"Facebook sync Off!");
        [self setValueToSwitch:@"facebookSwitch" withValue:NO];
    }
}

- (IBAction)emailSwitchAction:(id)sender
{
    if ([self.emailSwitch isOn]) {
        NSLog(@"Email sync On!");
        [self setValueToSwitch:@"emailSwitch" withValue:YES];
    } else {
        NSLog(@"Eamil sync Off!");
        [self setValueToSwitch:@"emailSwitch" withValue:NO];
    }
}

- (void)setValueToSwitch:(NSString *)theSwitch withValue:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:theSwitch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
