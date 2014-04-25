//
//  NewContactViewController.h
//  Hour of power
//
//  Created by Simone Ferrini on 25/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewContactViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *classificationSegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end
