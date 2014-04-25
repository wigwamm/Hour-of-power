//
//  CallNoteViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 25/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "CallNoteViewController.h"

#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"

#import "Contact.h"

@interface CallNoteViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CallNoteViewController
{
    NSIndexPath *index;
    
    Contact *currentContact;
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
    self.navigationItem.title = @"Call Note";
    
    NSNumber *indexRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"IndexPathRow"];
    NSNumber *indexSection = [[NSUserDefaults standardUserDefaults] objectForKey:@"IndexPathSection"];
    
    index = [NSIndexPath indexPathForItem:[indexRow intValue] inSection:[indexSection intValue]];
    
    self.fetchedResultsController = [Contact fetchAllSortedBy:@"fullName"
                                                    ascending:YES
                                                withPredicate:nil
                                                      groupBy:nil
                                                     delegate:self
                                                    inContext:[NSManagedObjectContext contextForCurrentThread]];
    
    currentContact = [self.fetchedResultsController objectAtIndexPath:index];
    
    [self fillScreen];
}

- (void)fillScreen
{
    switch ([currentContact.classification intValue]) {
        case 0:
            self.classificationSegmentedControl.selectedSegmentIndex = 0;
            break;
            
        case 1:
            self.classificationSegmentedControl.selectedSegmentIndex = 1;
            break;
            
        case 2:
            self.classificationSegmentedControl.selectedSegmentIndex = 2;
            break;
            
        case 3:
            self.classificationSegmentedControl.selectedSegmentIndex = 3;
            break;
            
        case 4:
            self.classificationSegmentedControl.selectedSegmentIndex = 4;
            break;
            
        default:
            self.classificationSegmentedControl.selectedSegmentIndex = 0;
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CallNote
- (IBAction)callNoteSaveButton:(id)sender
{
    // Create a new Contact in the current thread context
    currentContact.log = self.callNoteTextView.text;
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Updated call desctiption");
        
        //Dismiss PopUp
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {}];
        
    }];
}

- (IBAction)classificationAction:(id)sender
{
    NSInteger selectedSegmentIndex = [self.classificationSegmentedControl selectedSegmentIndex];
    NSString *selectedSegmentTitle = [self.classificationSegmentedControl titleForSegmentAtIndex: selectedSegmentIndex];
    
    NSLog(@"%li %@", (long)selectedSegmentIndex, selectedSegmentTitle);
    
    currentContact.classification = [NSNumber numberWithLong:selectedSegmentIndex];
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Updated classification");
    }];
}

- (IBAction)newContact:(id)sender
{
    currentContact.log = self.callNoteTextView.text;
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Updated call desctiption");
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.callNoteTextView resignFirstResponder];
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
