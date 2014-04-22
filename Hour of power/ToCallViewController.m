//
//  ToCallViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 10/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "ToCallViewController.h"

#import "DetailToCallViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

#import "TTCounterLabel.h"
#import "ODRefreshControl.h"

#import "Contact.h"

#import "AKPickerView.h"

@interface ToCallViewController () <TTCounterLabelDelegate, AKPickerViewDelegate>
{
    IBOutlet TTCounterLabel *_counterLabel;
}

@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ToCallViewController
{
    //Get CurrentContactDetail in "for statement"
    NSString *firstName;
    NSString *lastName;
    NSString *phoneNumber;
    
    //FullName-Phone Contact selected
    NSString *fullName;
    NSString *phoneNumberSelected;
    
    //
    NSMutableArray *contacts;
    
    //StartStop Call
    NSDate* start;
    NSDate* stop;
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
    
    //NotificationFromAppDelegate
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(foreground)
                                                 name: @"ForegroundNotification"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(background)
                                                 name: @"BackgroundNotification"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(becomeActive)
                                                 name: @"BecomeActiveNotification"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(resignActive)
                                                 name: @"ResignActiveNotification"
                                               object: nil];
    
    //Customize popup
    [self customizePopUp];
    
    //SetUp RefreshControl
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.addressTableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor blackColor];
    
    self.fetchedResultsController = [Contact fetchAllSortedBy:@"fullName"
                                                  ascending:YES
                                              withPredicate:nil
                                                    groupBy:nil
                                                   delegate:self
                                                  inContext:[NSManagedObjectContext contextForCurrentThread]];
    
    //PickerView
    //self.pickerView = [[AKPickerView alloc] initWithFrame:self.view.bounds];
    self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 470, self.view.frame.size.width, 40)];
	self.pickerView.delegate = self;
	[self.view addSubview:self.pickerView];
    
	self.titles = @[@"Daily",
					@"Weekly",
					@"Monthly",
					@"Quarterly",
					@"Yearly"];
    
	[self.pickerView reloadData];
    
    //AddressBook
    
    [self getAddressBookAuthorization];
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookSwitch"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addressBookSwitch"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self getAddressBookAuthorization];
//    } else {
//        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"addressBookSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//            [self getAddressBookAuthorization];
//        } else {
//            NSLog(@"Address book sync disabled");
//        }
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"addressBookSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
//        [self getAddressBookAuthorization];
//    } else {
//        NSLog(@"Address book sync disabled");
//        [[self addressTableView] reloadData];
//    }
    
    //CountDown
    [self initCountDown];
    
    [self setEditing:NO animated:NO];
    
    [self fetchContacts];
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
//	NSIndexPath *tableSelection = [self.addressTableView indexPathForSelectedRow];
//	[self.addressTableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (void)fetchContacts
{
    // 3. Fetch entities with MagicalRecord
    contacts = [[Contact findAllSortedBy:@"fullName" ascending:YES] mutableCopy];
}

- (void)getAddressBookAuthorization
{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self getContact];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self getContact];
    } else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}

- (void)getContact
{
    
    // Setup App with prefilled contact.
    //if (![[NSUserDefaults standardUserDefaults] objectForKey:@"HasPrefilledContacts"]) {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"HasPrefilledContacts"]) {
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            }
            
            if ((firstName == (id)[NSNull null] || firstName.length == 0) &&  (lastName == (id)[NSNull null] || lastName.length == 0 )) {
                
                NSLog(@"All null");
                
            } else {
                
                NSString *fullContact = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                
                if (firstName == (id)[NSNull null] || firstName.length == 0 ) {
                    fullContact = [NSString stringWithFormat:@"%@", lastName];
                }
                
                if (lastName == (id)[NSNull null] || lastName.length == 0 ) {
                    fullContact = [NSString stringWithFormat:@"%@", firstName];
                }
                
                
                // Get the local context
                NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                // Create a new contact in context
                Contact *contact = [Contact createEntityInContext:localContext];
                contact.fullName = fullContact;
                contact.phoneNumber = phoneNumber;
                contact.classification = @1;
                contact.unanswered = @NO;
                NSDate *currDate = [NSDate date];
                contact.lastCall = currDate;
                contact.log = @"log";
                // Save the modification in the local context
                NSError *error = nil;
                [localContext save:&error];
                
            }
            
        }
        
        // Set User Default to prevent another preload of data on startup.
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasPrefilledContacts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //[[self addressTableView] reloadData];
}

#pragma mark - TableView
#pragma mark -

#pragma mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Contact *selectedContact = [fetchedResultsController objectAtIndexPath:indexPath];
        
        // Remove the Contact
        [selectedContact deleteEntityInContext:[NSManagedObjectContext contextForCurrentThread]];
        
        NSError *error = nil;
        [[NSManagedObjectContext contextForCurrentThread] save:&error];
    }
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    
	return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Contact *currentContact = [fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", currentContact.fullName];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", currentContact.phoneNumber];
    
    cell.imageView.image = [UIImage imageNamed:@"call.png"];
}

- (void)btnCommentClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:senderButton.tag inSection:0];

    Contact *currentContact = [fetchedResultsController objectAtIndexPath:path];
    NSString *number = [NSString stringWithFormat:@"%@", currentContact.phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",[number stringByReplacingOccurrencesOfString:@" " withString:@""]]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"]; //UITableViewCellStyleSubtitle
    }
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
//    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
//    //Button call
//    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [callBtn setFrame:CGRectMake(10,10,20,20)];
//    callBtn.tag = indexPath.row;
//    [callBtn addTarget:self action:@selector(btnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //newBtn.backgroundColor = [UIColor greenColor];
//    
//    [callBtn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
//    [callBtn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateHighlighted];
//    
//    [cell addSubview:callBtn];
//    //-------------
//    
    
//    //Button weekly
//    UIButton *weeklyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [weeklyBtn setFrame:CGRectMake(190,10,20,20)];
//    weeklyBtn.tag = indexPath.row;
//    [weeklyBtn addTarget:self action:@selector(btnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    weeklyBtn.layer.cornerRadius = 5;
//    weeklyBtn.backgroundColor = [UIColor greenColor];
//    [weeklyBtn setTitle:@"W" forState:UIControlStateNormal];
//    [weeklyBtn setTitle:@"W" forState:UIControlStateHighlighted];
//    
////    [weeklyBtn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
////    [weeklyBtn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateHighlighted];
//    
//    [cell addSubview:weeklyBtn];
//    //-------------
//    
//    
//    //Button monthly
//    UIButton *monthlyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [monthlyBtn setFrame:CGRectMake(220,10,20,20)];
//    monthlyBtn.tag = indexPath.row;
//    
//    [monthlyBtn addTarget:self action:@selector(btnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    monthlyBtn.layer.cornerRadius = 5;
//    monthlyBtn.backgroundColor = [UIColor blueColor];
//    [monthlyBtn setTitle:@"M" forState:UIControlStateNormal];
//    [monthlyBtn setTitle:@"M" forState:UIControlStateHighlighted];
//    
////    [monthlyBtn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
////    [monthlyBtn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateHighlighted];
//    
//    [cell addSubview:monthlyBtn];
//    //-------------
//    
//    
//    
//    //Button yearly
//    UIButton *yearlyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [yearlyBtn setFrame:CGRectMake(250,10,20,20)];
//    yearlyBtn.tag = indexPath.row;
//    [yearlyBtn addTarget:self action:@selector(btnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    yearlyBtn.layer.cornerRadius = 5;
//    yearlyBtn.backgroundColor = [UIColor redColor];
//    [yearlyBtn setTitle:@"Y" forState:UIControlStateNormal];
//    [yearlyBtn setTitle:@"Y" forState:UIControlStateHighlighted];
//    
////    [yearlyBtn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
////    [yearlyBtn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateHighlighted];
//    
//    [cell addSubview:yearlyBtn];
//    //-------------
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Contact *currentContact = [fetchedResultsController objectAtIndexPath:indexPath];

    fullName = [NSString stringWithFormat:@"%@", currentContact.fullName];
    phoneNumberSelected = [NSString stringWithFormat:@"%@", currentContact.phoneNumber];
    
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"segue" source:self destination:[[DetailToCallViewController alloc] init]];
    
    [self prepareForSegue:segue sender:self];
}

#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.addressTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.addressTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.addressTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.addressTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.addressTableView endUpdates];
}

#pragma mark - CountDown

- (void)initCountDown
{
    _counterLabel.countDirection = kCountDirectionDown;
    
    [_counterLabel setStartValue:600000*6];
    
    _counterLabel.countdownDelegate = self;
    
    
    [_counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:30]];
    [_counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]];
    [_counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
    
//    _counterLabel.textColor = [UIColor darkGrayColor];
    
    [_counterLabel updateApperance];
    
    [_counterLabel start];
    
//    [_counterLabel reset];
}

#pragma mark - TTCounterLabelDelegate

- (void)countdownDidEndForSource:(TTCounterLabel *)source
{
    NSLog(@"You have run out of time!");
}

#pragma mark - ODRefreshControl

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
        [self.addressTableView reloadData];
    });
}

#pragma mark - PopUp
#pragma mark -
- (void)customizePopUp
{
    //Hidden All
    self.callResultView.hidden = YES;
    self.nextCallView.hidden = YES;
    self.contactNewView.hidden = YES;
    self.callNoteView.hidden = YES;
    
    //CallResultView
    self.callResultView.layer.cornerRadius = 5;
    self.busyButton.layer.cornerRadius = 5;
    self.notAnsweredButton.layer.cornerRadius = 5;
    self.answeredButton.layer.cornerRadius = 5;
    
    //NextCallView
    self.nextCallView.layer.cornerRadius = 5;
    self.dailyButton.layer.cornerRadius = 5;
    self.weeklyButton.layer.cornerRadius = 5;
    self.monthlyButton.layer.cornerRadius = 5;
    self.quarterlyButton.layer.cornerRadius = 5;
    self.yearlyButton.layer.cornerRadius = 5;
    
    //NewContact
    self.contactNewView.layer.cornerRadius = 5;
    self.contactNewDailyButton.layer.cornerRadius = 5;
    self.contactNewWeeklyButton.layer.cornerRadius = 5;
    self.contactNewMonthlyButton.layer.cornerRadius = 5;
    self.contactNewQuarterlyButton.layer.cornerRadius = 5;
    self.contactNewYearlyButton.layer.cornerRadius = 5;
    
    //CallNote
    self.callNoteView.layer.cornerRadius = 5;
    self.callNoteTextView.layer.cornerRadius = 5;
    self.callNoteSaveButton.layer.cornerRadius = 5;
}

#pragma mark CallResult
- (IBAction)busyButton:(id)sender
{
    self.callResultView.hidden = YES;
}

- (IBAction)notAnsweredButton:(id)sender
{
    self.callResultView.hidden = YES;
}

- (IBAction)answeredButton:(id)sender
{
    self.callResultView.hidden = YES;
}

#pragma mark NextCall
- (IBAction)dailyButton:(id)sender
{
    self.nextCallView.hidden = YES;
}

- (IBAction)weeklyButton:(id)sender
{
    self.nextCallView.hidden = YES;
}

- (IBAction)monthlyButton:(id)sender
{
    self.nextCallView.hidden = YES;
}

- (IBAction)quarterlyButton:(id)sender
{
    self.nextCallView.hidden = YES;
}

- (IBAction)yearlyButton:(id)sender
{
    self.nextCallView.hidden = YES;
}

#pragma mark NewContact
- (IBAction)contactNewDailyButton:(id)sender
{
    self.contactNewView.hidden = YES;
}

- (IBAction)contactNewWeeklyButton:(id)sender
{
    self.contactNewView.hidden = YES;
}

- (IBAction)contactNewMonthlyButton:(id)sender
{
    self.contactNewView.hidden = YES;
}

- (IBAction)contactNewQuarterlyButton:(id)sender
{
    self.contactNewView.hidden = YES;
}

- (IBAction)contactNewYearlyButton:(id)sender
{
    self.contactNewView.hidden = YES;
}

#pragma mark CallNote
- (IBAction)callNoteSaveButton:(id)sender
{
    self.callNoteView.hidden = YES;
}

#pragma mark - TextFields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.fullNameTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    
    [self.callNoteTextView resignFirstResponder];
}

#pragma mark - PointStuff
- (void)foreground
{
    NSLog(@"Foreground");
    
    stop = [NSDate date];
    NSTimeInterval distanceBetweenDates = [stop timeIntervalSinceDate:start];
    NSLog(@"Interval: %f", distanceBetweenDates);
    
    [self calculatePointWithTime:distanceBetweenDates];
}

- (void)background
{
    NSLog(@"Background");
    
    start = [NSDate date];
    
    //Show All PopUp
    self.callResultView.hidden = NO;
    self.nextCallView.hidden = NO;
    self.contactNewView.hidden = NO;
    self.callNoteView.hidden = NO;
}

- (void)becomeActive
{
    NSLog(@"becomeActive");
}

- (void)resignActive
{
    NSLog(@"resignActive");
}

- (void)calculatePointWithTime:(NSTimeInterval)time
{
    if (time < 10) {
        NSLog(@"0 point");
    } else {
        if (time > 6*60) {
            NSLog(@"0 point");
        } else {
            NSLog(@"%i point", (int)time*10);
        }
    }
}

//PickerView
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
	return [self.titles count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
	return self.titles[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
	NSLog(@"%@", self.titles[item]);
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"segue"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        DetailToCallViewController *yourViewController = (DetailToCallViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailToCallViewController"];
        
        yourViewController.fullName = fullName;
        yourViewController.phoneNumber = [NSString stringWithFormat:@"%@", phoneNumberSelected];
        
        [self.navigationController pushViewController:yourViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
