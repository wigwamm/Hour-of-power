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
#import "CallDate.h"

#import "AKPickerView.h"

#define N_CLASSIFICATIONS 5

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
    NSIndexPath *indexToSend;
    
    //Contacts
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
    
    self.navigationItem.title = @"Hour Of Power";
    
    //BlurView
    [self.blurView setBlurAlpha:0.01];
    
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
    
    contacts = [NSMutableArray array];
    
    self.fetchedResultsController = [Contact fetchAllSortedBy:@"fullName"
                                                  ascending:YES
                                              withPredicate:nil
                                                    groupBy:nil
                                                   delegate:self
                                                  inContext:[NSManagedObjectContext contextForCurrentThread]];
    
    [self rankingUsers];
    
    //PickerView
    //self.pickerView = [[AKPickerView alloc] initWithFrame:self.view.bounds];
    //self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 470, self.view.frame.size.width, 40)];
    self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 480, self.view.frame.size.width, 40)];
	self.pickerView.delegate = self;
	[self.view addSubview:self.pickerView];
    
	self.titles = @[@"Today",
					@"Tomorrow",
					@"Next week",
					@"Next month",
					@"Next year"];
    
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

- (void)rankingUsers
{
    NSArray *datess = [CallDate findAll];
    NSDate *newDate;
    
    for (int s = 100; s < datess.count; s ++) {
        
        CallDate *ggggg = datess[s];
        
        NSDate *now = [NSDate date];
        
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        newDate = [theCalendar dateByAddingComponents:dayComponent toDate:now options:0];
        
        ggggg.nextCall = newDate;
        
        // Save the modification in the local context
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"Updated answer");
        }];
    }
    
    NSDate *dateNormalized = [self normalizedDateWithDate:newDate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(nextCall >= %@) AND (nextCall <= %@)", dateNormalized, newDate];
    
    NSArray * callDateFiltred = [CallDate findAllSortedBy:@"nextCall"
                                              ascending:YES
                                          withPredicate:predicate];
    NSLog(@"CallDateFiltred: %@", callDateFiltred);
    
    
    for (int classification = 0; classification < N_CLASSIFICATIONS; classification ++) {
        
//        NSArray * people = [Contact findAllSortedBy:@"fullName"
//                                          ascending:YES
//                                      withPredicate:[NSPredicate predicateWithFormat:@"classification = %i", classification]];
        
        
        NSArray * people = [Contact findAllSortedBy:@"fullName"
                                          ascending:YES
                                      withPredicate:[NSPredicate predicateWithFormat:@"classification = %i", classification]];
        

        NSArray * dates = [CallDate findAll];
        CallDate *ddddd = dates[2];
        
        NSString *nsx = ddddd.nextCall;
        
//        if (people.count > 0) {
//            
//            for (int i = 0; i < people.count; i++) {
//                Contact *myUser = people[i];
//                NSString *na = myUser.fullName;
//                
//                NSLog(@"%@ classification: %i", na, classification);
//                
//            }
//        }
    }
}

-(NSDate*)normalizedDateWithDate:(NSDate*)date
{
    NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: date];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (void)viewWillAppear:(BOOL)animated
{
    //CountDown
    [self initCountDown];
    
    [self setEditing:NO animated:NO];
}


#pragma mark - AddressBook Sync
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
                
                // Create a new Photo in the current thread context
                Contact *contact = [Contact createEntityInContext:localContext];
                contact.fullName = fullContact;
                contact.phoneNumber = phoneNumber;
                contact.classification = @1;
                contact.answered = @NO;
                
                NSDate *currDate = [NSDate date];
                contact.lastCall = currDate;
                contact.log = @"log";
                
                CallDate *callDate = [CallDate createEntityInContext:localContext];
                callDate.contact = [NSSet setWithObject:contact];
                callDate.nextCall = currDate;
                
                // Save the modification in the local context
                [localContext saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    NSLog(@"Imported contact");
                }];
            }
        }
        
        // Set User Default to prevent another preload of data on startup.
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasPrefilledContacts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - - TableView
#pragma mark -
#pragma mark UITableViewDelegate

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.addressTableView deselectRowAtIndexPath:indexPath animated:YES];

    Contact *currentContact = [fetchedResultsController objectAtIndexPath:indexPath];

    fullName = [NSString stringWithFormat:@"%@", currentContact.fullName];
    phoneNumberSelected = [NSString stringWithFormat:@"%@", currentContact.phoneNumber];
    indexToSend = indexPath;
    
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"detail" source:self destination:[[DetailToCallViewController alloc] init]];

    [self prepareForSegue:segue sender:self];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Contact *selectedContact = [fetchedResultsController objectAtIndexPath:indexPath];
        
        // Remove the photo
        [selectedContact deleteEntityInContext:[NSManagedObjectContext contextForCurrentThread]];
        
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"delated");
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        return @"Today";
    }
    
    return @"Never";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.510 green:0.874 blue:1.000 alpha:1.000]];
    
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Futura" size:18];
    label.text = [NSString stringWithFormat:@" %@", sectionTitle];
//    label.textAlignment = UITextAlignmentCenter;
    
    [headerView addSubview:label];
    
    return headerView;

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
    cell.imageView.image = [UIImage imageNamed:@"call_Orange.png"];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TableCell"];
	}
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    //Button call
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
    //-------------

    //Button weekly
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
    //-------------
    
	return cell;
}

//- (void)btnCommentClick:(id)sender
//{
//    UIButton *senderButton = (UIButton *)sender;
//    NSIndexPath *path = [NSIndexPath indexPathForRow:senderButton.tag inSection:0];
//
//    Contact *currentContact = [fetchedResultsController objectAtIndexPath:path];
//    NSString *number = [NSString stringWithFormat:@"%@", currentContact.phoneNumber];
//
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",[number stringByReplacingOccurrencesOfString:@" " withString:@""]]]];
//}

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
    
    [_counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10]];
    [_counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:10]];
    [_counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:6]];
    
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

#pragma mark - - PopUp
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
    self.nextCallView.hidden = YES;
    self.contactNewView.hidden = YES;
    self.callNoteView.hidden = YES;
    
    [self updateAnsweredWithAnswer:@YES];
}

- (IBAction)notAnsweredButton:(id)sender
{
    self.callResultView.hidden = YES;
    self.nextCallView.hidden = YES;
    self.contactNewView.hidden = YES;
    self.callNoteView.hidden = YES;
    
    [self updateAnsweredWithAnswer:@YES];
}

- (IBAction)answeredButton:(id)sender
{
    self.callResultView.hidden = YES;
    
    [self updateAnsweredWithAnswer:@NO];
}

- (void)updateAnsweredWithAnswer:(NSNumber *)answer
{
    // Create a new Contact in the current thread context
    Contact *currentContact = [fetchedResultsController objectAtIndexPath:indexToSend];
    currentContact.answered = answer;
    
    NSDate *currDate = [NSDate date];
    currentContact.lastCall = currDate;
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Updated answer");
    }];
}

#pragma mark NextCall
- (IBAction)dailyButton:(id)sender
{
    self.nextCallView.hidden = YES;
    
    [self updateContactWithClassification:@0];
}

- (IBAction)weeklyButton:(id)sender
{
    self.nextCallView.hidden = YES;
    
    [self updateContactWithClassification:@1];
}

- (IBAction)monthlyButton:(id)sender
{
    self.nextCallView.hidden = YES;
    
    [self updateContactWithClassification:@2];
}

- (IBAction)quarterlyButton:(id)sender
{
    self.nextCallView.hidden = YES;
    
    [self updateContactWithClassification:@3];
}

- (IBAction)yearlyButton:(id)sender
{
    self.nextCallView.hidden = YES;
    
    [self updateContactWithClassification:@4];
}

- (void)updateContactWithClassification:(NSNumber *)classification
{
    Contact *currentContact = [fetchedResultsController objectAtIndexPath:indexToSend];
    currentContact.classification = classification;
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Updated classification");
    }];
}

#pragma mark NewContact
- (IBAction)contactNewDailyButton:(id)sender
{
    self.contactNewView.hidden = YES;
    
    [self createNewContactWithClassification:@0];
}

- (IBAction)contactNewWeeklyButton:(id)sender
{
    self.contactNewView.hidden = YES;
    
    [self createNewContactWithClassification:@1];
}

- (IBAction)contactNewMonthlyButton:(id)sender
{
    self.contactNewView.hidden = YES;
    
    [self createNewContactWithClassification:@2];
}

- (IBAction)contactNewQuarterlyButton:(id)sender
{
    self.contactNewView.hidden = YES;
    
    [self createNewContactWithClassification:@3];
}

- (IBAction)contactNewYearlyButton:(id)sender
{
    self.contactNewView.hidden = YES;
    
    [self createNewContactWithClassification:@4];
}

- (void)createNewContactWithClassification:(NSNumber *)classification
{
    // Create a new Photo in the current thread context
    Contact *contact = [Contact createEntityInContext:[NSManagedObjectContext contextForCurrentThread]];
    
    contact.fullName = self.fullNameTextField.text;
    contact.phoneNumber = self.phoneNumberTextField.text;
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

#pragma mark CallNote
- (IBAction)callNoteSaveButton:(id)sender
{
    self.callNoteView.hidden = YES;
    
    // Create a new Contact in the current thread context
    Contact *currentContact = [fetchedResultsController objectAtIndexPath:indexToSend];
    currentContact.log = self.callNoteTextView.text;
    
    // Save the modification in the local context
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Updated call desctiption");
    }];
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

#pragma mark - PickerView
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
	NSLog(@"PikerSelected: %@", self.titles[item]);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:0];
    
    [self.addressTableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"detail"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        DetailToCallViewController *yourViewController = (DetailToCallViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailToCallViewController"];
        
        yourViewController.index = indexToSend;
        
        [self.navigationController pushViewController:yourViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
