//
//  DetailToCallViewController.h
//  Hour of power
//
//  Created by Simone Ferrini on 11/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailToCallViewController : UIViewController <NSFetchedResultsControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSIndexPath *index;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastCallLabel;
@property (strong, nonatomic) IBOutlet UILabel *logLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *classificationSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *nextCallDateLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *containerScrollView;

@property (strong, nonatomic) IBOutlet UITextView *noteNewTextView;

@end
