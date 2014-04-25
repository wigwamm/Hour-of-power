//
//  NewContactViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 25/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "NewContactViewController.h"

#import "Contact.h"

#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"

@interface NewContactViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation NewContactViewController
{
    NSIndexPath *index;
}

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
    
#warning - Set how many contact introduced
//    NSNumber *indexRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"IndexPathRow"];
//    NSNumber *indexSection = [[NSUserDefaults standardUserDefaults] objectForKey:@"IndexPathSection"];
//    
//    index = [NSIndexPath indexPathForItem:[indexRow intValue] inSection:[indexSection intValue]];
//    
//    NSLog(@"NewContact index: %@", index);
//    
//    self.fetchedResultsController = [Contact fetchAllSortedBy:@"fullName"
//                                                    ascending:YES
//                                                withPredicate:nil
//                                                      groupBy:nil
//                                                     delegate:self
//                                                    inContext:[NSManagedObjectContext contextForCurrentThread]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAction:(id)sender
{
    [self createNewContact];
}

#pragma mark NewContact
- (void)createNewContact
{
    // Create a new Photo in the current thread context
    Contact *contact = [Contact createEntityInContext:[NSManagedObjectContext contextForCurrentThread]];
    
    contact.fullName = self.fullNameTextField.text;
    contact.phoneNumber = self.phoneNumberTextField.text;
    contact.classification = [NSNumber numberWithLong:[self.classificationSegmentedControl selectedSegmentIndex]];
    contact.answered = @NO;
    
    NSDate *currDate = [NSDate date];
    contact.lastCall = currDate;
    
    contact.log = @"Description";
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Created new contact");
        
        //Dismiss PopUp
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {}];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.fullNameTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
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
