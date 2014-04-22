//
//  DetailToCallViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 11/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "DetailToCallViewController.h"

#import "Contact.h"

@interface DetailToCallViewController ()

@end

@implementation DetailToCallViewController
{
    Contact *currentContact;
}

@synthesize fetchedResultsController;

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
    
    self.fetchedResultsController = [Contact fetchAllSortedBy:@"fullName"
                                                    ascending:YES
                                                withPredicate:nil
                                                      groupBy:nil
                                                     delegate:self
                                                    inContext:[NSManagedObjectContext contextForCurrentThread]];
    
    currentContact = [fetchedResultsController objectAtIndexPath:self.index];
    
    [self fillScreen];

}

- (void)fillScreen
{
    self.fullNameLabel.text = currentContact.fullName;
    self.phoneNumberLabel.text = currentContact.phoneNumber;
    self.classificationLabel.text = [NSString stringWithFormat:@"%@", currentContact.classification];
    self.unansweredLabel.text = [NSString stringWithFormat:@"%@", currentContact.unanswered];
    self.lastCallLabel.text = [NSString stringWithFormat:@"%@", currentContact.lastCall];
    self.logLabel.text = [NSString stringWithFormat:@"%@", currentContact.log];
}

- (IBAction)callNumber:(id)sender
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:444"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",[currentContact.phoneNumber
                                                                                                                stringByReplacingOccurrencesOfString:@" "
                                                                                                                withString:@""]]]];
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
