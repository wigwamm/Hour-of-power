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

@property (strong, nonatomic) NSMutableArray *contactList;


@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
