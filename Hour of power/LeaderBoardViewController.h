//
//  LeaderBoardViewController.h
//  Hour of power
//
//  Created by Simone Ferrini on 11/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface LeaderBoardViewController : UIViewController <GKGameCenterControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *pointsTextField;

@end
