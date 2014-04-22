//
//  DetailToCallViewController.h
//  Hour of power
//
//  Created by Simone Ferrini on 11/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailToCallViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSIndexPath *index;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *classificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastCallLabel;
@property (strong, nonatomic) IBOutlet UILabel *logLabel;

@end
