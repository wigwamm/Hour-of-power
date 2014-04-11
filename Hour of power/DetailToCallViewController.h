//
//  DetailToCallViewController.h
//  Hour of power
//
//  Created by Simone Ferrini on 11/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailToCallViewController : UIViewController

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *phoneNumber;

@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end
