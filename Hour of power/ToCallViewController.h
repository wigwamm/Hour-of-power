//
//  ToCallViewController.h
//  Hour of power
//
//  Created by Simone Ferrini on 10/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToCallViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *addressTableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

#pragma mark - PopUps

//CallResult
@property (strong, nonatomic) IBOutlet UIView *callResultView;
@property (strong, nonatomic) IBOutlet UIButton *busyButton;
@property (strong, nonatomic) IBOutlet UIButton *notAnsweredButton;
@property (strong, nonatomic) IBOutlet UIButton *answeredButton;

//NextCall
@property (strong, nonatomic) IBOutlet UIView *nextCallView;
@property (strong, nonatomic) IBOutlet UIButton *dailyButton;
@property (strong, nonatomic) IBOutlet UIButton *weeklyButton;
@property (strong, nonatomic) IBOutlet UIButton *monthlyButton;
@property (strong, nonatomic) IBOutlet UIButton *quarterlyButton;
@property (strong, nonatomic) IBOutlet UIButton *yearlyButton;

//NewContact
@property (strong, nonatomic) IBOutlet UIView *contactNewView;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *contactNewDailyButton;
@property (strong, nonatomic) IBOutlet UIButton *contactNewWeeklyButton;
@property (strong, nonatomic) IBOutlet UIButton *contactNewMonthlyButton;
@property (strong, nonatomic) IBOutlet UIButton *contactNewQuarterlyButton;
@property (strong, nonatomic) IBOutlet UIButton *contactNewYearlyButton;

//CallNote
@property (strong, nonatomic) IBOutlet UIView *callNoteView;
@property (strong, nonatomic) IBOutlet UITextView *callNoteTextView;
@property (strong, nonatomic) IBOutlet UIButton *callNoteSaveButton;

@end
