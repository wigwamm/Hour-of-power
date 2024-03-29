//
//  ToCallViewController.h
//  Hour of power
//
//  Created by Simone Ferrini on 10/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <UIKit/UIKit.h>

//BLUR VIEW
#import "JWBlurView.h"

@interface ToCallViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *addressTableView;

@property (strong, nonatomic) IBOutlet JWBlurView *blurView;

@end
