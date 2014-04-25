//
//  DetailToCallViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 11/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "DetailToCallViewController.h"

#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"

#import "Contact.h"

@interface DetailToCallViewController () <MZFormSheetBackgroundWindowDelegate>

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
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    
    self.noteNewTextView.layer.borderWidth = 1.0f;
    self.noteNewTextView.layer.borderColor = [[UIColor colorWithWhite:0.500 alpha:0.680] CGColor];
    
    self.noteNewTextView.delegate = self;
    
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
    self.navigationItem.title = currentContact.fullName;
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"Phone n°: %@", currentContact.phoneNumber];
    self.lastCallLabel.text = [NSString stringWithFormat:@"Last call: %@", currentContact.lastCall];
    self.logLabel.text = [NSString stringWithFormat:@"Note: %@", currentContact.log];
    
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

- (IBAction)callNumber:(id)sender
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:444"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",[currentContact.phoneNumber
                                                                                                                stringByReplacingOccurrencesOfString:@" "
                                                                                                                withString:@""]]]];
}

- (IBAction)classificationSegmentedAction:(id)sender
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.noteNewTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{self.containerScrollView.contentOffset = CGPointMake(0, 80);}];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{self.containerScrollView.contentOffset = CGPointMake(0, 0);}];
}



- (IBAction)testAction:(id)sende
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"popup"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 298);
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    //    formSheet.landscapeTopInset = 50;
    //    formSheet.portraitTopInset = 100;
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        //        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        //        navController.topViewController.title = @"PASSING DATA";
    };
    
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {}];
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
