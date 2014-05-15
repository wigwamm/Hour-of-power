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

#import <NSDate+Calendar.h>

@interface NewContactViewController ()

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
    
    //NextCall
    self.nextCallDateLabel.text = [NSString stringWithFormat:@"Next call: %@", [self stringFromDate:[[[NSDate date] dateToday] dateByAddingDays:1]]];
    
#warning - Set how many contact introduced
//    NSNumber *indexRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"IndexPathRow"];
//    NSNumber *indexSection = [[NSUserDefaults standardUserDefaults] objectForKey:@"IndexPathSection"];
//    
//    index = [NSIndexPath indexPathForItem:[indexRow intValue] inSection:[indexSection intValue]];
//    
//    NSLog(@"NewContact index: %@", index);
//    
//    if (index.section == 0) {
//        
//        NSArray *peoples = [Contact findAllSortedBy:@"classification" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"(nextCall == %@)", [[NSDate date] dateToday]]];
//        currentContact = peoples[index.row];
//        
//    } else if (index.section == 1) {
//        
//        NSArray *peoples = [Contact findAllSortedBy:@"fullName" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"(nextCall > %@)", [[NSDate date] dateToday]]];
//        currentContact = peoples[index.row];
//    }
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

- (IBAction)classificationAction:(id)sender
{
    NSInteger selectedSegmentIndex = [self.classificationSegmentedControl selectedSegmentIndex];
    
    switch (selectedSegmentIndex) {
        case 0:
            self.nextCallDateLabel.text = [NSString stringWithFormat:@"Next call: %@", [self stringFromDate:[[[NSDate date] dateToday] dateByAddingDays:1]]];
            break;
            
        case 1:
            self.nextCallDateLabel.text = [NSString stringWithFormat:@"Next call: %@", [self stringFromDate:[[[NSDate date] dateToday] dateByAddingWeek:1]]];
            break;
            
        case 2:
            self.nextCallDateLabel.text = [NSString stringWithFormat:@"Next call: %@", [self stringFromDate:[[[NSDate date] dateToday] dateByAddingMonth:1]]];
            break;
            
        case 3:
            self.nextCallDateLabel.text = [NSString stringWithFormat:@"Next call: %@", [self stringFromDate:[[[NSDate date] dateToday] dateByAddingMonth:4]]];
            break;
            
        case 4:
            self.nextCallDateLabel.text = [NSString stringWithFormat:@"Next call: %@", [self stringFromDate:[[[NSDate date] dateToday] dateByAddingYear:1]]];
            break;
            
        default:
            self.nextCallDateLabel.text = [NSString stringWithFormat:@"Next call: %@", [self stringFromDate:[[[NSDate date] dateToday] dateByAddingDays:1]]];
            break;
    }
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy";
    NSString *strngDate = [formatter stringFromDate:date];
    
    return strngDate;
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
    contact.nextCall = currDate;
    
    contact.log = @"Description";
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Created new contact");
        
        // NUMBER NEW CONTACT TODAY
        [[NSUserDefaults standardUserDefaults] setInteger:([[[NSUserDefaults standardUserDefaults] objectForKey:@"nNewContactToday"] integerValue] + 1) forKey:@"nNewContactToday"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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
