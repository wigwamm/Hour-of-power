//
//  NewContactViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 25/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "NewContactViewController.h"

#import "Contact.h"

@interface NewContactViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation NewContactViewController

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
    self.navigationItem.title = @"New Contact";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NewContact
- (void)createNewContactWithClassification:(NSNumber *)classification
{
    // Create a new Photo in the current thread context
    Contact *contact = [Contact createEntityInContext:[NSManagedObjectContext contextForCurrentThread]];
    
    contact.fullName = @"self.fullNameTextField.text";
    contact.phoneNumber = @"self.phoneNumberTextField.text";
    contact.classification = classification;
    contact.answered = @YES;
    
    NSDate *currDate = [NSDate date];
    contact.lastCall = currDate;
    
    contact.log = @"Description";
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Created new contact");
    }];
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
