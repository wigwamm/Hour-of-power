//
//  ToCallViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 10/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "ToCallViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

#import "TTCounterLabel.h"
#import "ODRefreshControl.h"

@interface ToCallViewController () <TTCounterLabelDelegate>
{
    IBOutlet TTCounterLabel *_counterLabel;
}

@end

@implementation ToCallViewController
{
    NSString *firstName;
    NSString *lastName;
    NSString *phoneNumber;
}

@synthesize contactList;

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
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.addressTableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    refreshControl.tintColor = [UIColor blackColor];
    
    //AddressBook
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookSwitch"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addressBookSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self fillTableView];
        
    } else {
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"addressBookSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            [self fillTableView];
            
        } else {
            NSLog(@"Address book sync disabled");
        }
    }
    
    //Facebook
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"facebookSwitch"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"facebookSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"facebookSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            
        } else {
            NSLog(@"Facebook sync disabled");
        }
    }
    
    //Email
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"emailSwitch"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"emailSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"emailSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            
        } else {
            NSLog(@"Address book sync disabled");
        }
    }
    
    //CountDown
    [self initCountDown];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"addressBookSwitch"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
        [self fillTableView];
        
    } else {
        
        NSLog(@"Address book sync disabled");
        [contactList removeAllObjects];
        [[self addressTableView] reloadData];
    }
}

- (void)fillTableView
{
    [self initArray];
    [self getAddressBookAuthorization];
}

- (void)initArray
{
    NSLog(@"Init array");
    
    contactList = [[NSMutableArray alloc]init];
}

- (void)clearArray
{
    [contactList removeAllObjects];
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
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
//    for(int i = 0; i < numberOfPeople; i++) {
//        
//        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
//        
//        firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
//        lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
//        NSLog(@"Name:%@ %@", firstName, lastName);
//        
//        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
//        
//        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
//            phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
//            NSLog(@"phone:%@", phoneNumber);
//        }
//        
//        //Fill array contactList
//        NSString *fullContact = [NSString stringWithFormat:@"%@ %@ : %@", firstName, lastName, phoneNumber];
//        [contactList addObject:fullContact];
//        
//        NSLog(@"=============================================");
//        
//    }
    
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        NSLog(@"Name:%@ %@", firstName, lastName);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            NSLog(@"phone:%@", phoneNumber);
        }
        
        
        //Facebook
        ABMultiValueRef profile = ABRecordCopyValue(person,  kABPersonInstantMessageProperty);
        if (ABMultiValueGetCount(profile) > 0) {
            
            // collect all emails in array
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(profile); i++) {
                NSDictionary *socialItem = (__bridge NSDictionary*)ABMultiValueCopyValueAtIndex(profile, i);
                NSString* SocialLabel =  [socialItem objectForKey:(NSString *)kABPersonInstantMessageServiceKey];
                
                if([SocialLabel isEqualToString:(NSString *)kABPersonInstantMessageServiceFacebook]) {
                    
                    NSString *facebookProfile = ([socialItem objectForKey:(NSString *)kABPersonInstantMessageUsernameKey]);
                    NSLog(@"fbName %@", facebookProfile);
                }
            }
            CFRelease(profile);
        }
        //--------
        
        
        
        
        
        //Fill array contactList
        NSString *fullContact = [NSString stringWithFormat:@"%@ %@ : %@", firstName, lastName, phoneNumber];
        [contactList addObject:fullContact];
        
        NSLog(@"=============================================");
        
    }
    
    
    
    [[self addressTableView] reloadData];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Load data");
    return [contactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.text = [contactList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    });
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
