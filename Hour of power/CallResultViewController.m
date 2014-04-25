//
//  CallResultViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 25/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "CallResultViewController.h"

#import "Contact.h"

@interface CallResultViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CallResultViewController

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
    self.navigationItem.title = @"Call Result";
}

#pragma mark CallResult
- (IBAction)answeredButton:(id)sender
{
    [self updateAnsweredWithAnswer:@YES];
}

- (IBAction)notAnsweredButton:(id)sender
{
    [self updateAnsweredWithAnswer:@NO];
}

- (IBAction)busyButton:(id)sender
{
    [self updateAnsweredWithAnswer:@NO];
}

- (void)updateAnsweredWithAnswer:(NSNumber *)answer
{
    // Update Contact in the current thread context
    Contact *currentContact = [self.fetchedResultsController objectAtIndexPath:0]; //Change index!
    currentContact.answered = answer;
    
    NSDate *currDate = [NSDate date];
    currentContact.lastCall = currDate;
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Updated answer");
    }];
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
