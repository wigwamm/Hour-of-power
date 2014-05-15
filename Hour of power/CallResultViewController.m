//
//  CallResultViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 25/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "CallResultViewController.h"

//DATABASE
#import "Contact.h"

//POPUP
#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"

//MANAGE TIME
#import <NSDate+Calendar.h>

@interface CallResultViewController ()

@end

@implementation CallResultViewController
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
    self.navigationItem.title = @"Call Result";
    
    NSNumber *indexRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"IndexPathRow"];
    NSNumber *indexSection = [[NSUserDefaults standardUserDefaults] objectForKey:@"IndexPathSection"];
    
    index = [NSIndexPath indexPathForItem:[indexRow intValue] inSection:[indexSection intValue]];

    if (index.section == 0) {
        
        NSArray *peoples = [Contact findAllSortedBy:@"classification" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"(nextCall == %@)", [[NSDate date] dateToday]]];
        currentContact = peoples[index.row];
        
    } else if (index.section == 1) {
        
        NSArray *peoples = [Contact findAllSortedBy:@"fullName" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"(nextCall > %@)", [[NSDate date] dateToday]]];
        currentContact = peoples[index.row];
    }
}

#pragma mark CallResult
- (IBAction)answeredButton:(id)sender
{
    [self updateAnsweredWithAnswer:@YES];
}

- (IBAction)unansweredButton:(id)sender
{
    [self updateAnsweredWithAnswer:@NO];
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {}];
}

- (IBAction)busyButton:(id)sender
{
    [self updateAnsweredWithAnswer:@NO];
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {}];
}

- (void)updateAnsweredWithAnswer:(NSNumber *)answer
{
    // Update Contact in the current thread context
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
