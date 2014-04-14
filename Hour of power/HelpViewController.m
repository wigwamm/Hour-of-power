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
        [self setSwitchStatusWithSwitch:self.addressBookSwitch withStatus:YES];
    } else {
        [self setSwitchStatusWithSwitch:self.addressBookSwitch withStatus:NO];
    }
}

- (void)setSwitchStatusWithSwitch:(UISwitch *)theSwitch withStatus:(BOOL)status
{
    [theSwitch setOn:status];
}

- (IBAction)addressBookSwitchAction:(id)sender
{
    if ([self.addressBookSwitch isOn]) {
        [self setValueToSwitch:@"addressBookSwitch" withValue:YES];
    } else {
        [self setValueToSwitch:@"addressBookSwitch" withValue:NO];
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
