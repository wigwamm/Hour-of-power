//
//  CallNoteViewController.h
//  Hour of power
//
//  Created by Simone Ferrini on 25/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallNoteViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *classificationSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextView *callNoteTextView;
@property (strong, nonatomic) IBOutlet UIButton *justSaveButton;
@property (strong, nonatomic) IBOutlet UIButton *addNewContactButton;

@end
