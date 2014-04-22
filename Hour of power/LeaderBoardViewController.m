//
//  LeaderBoardViewController.m
//  Hour of power
//
//  Created by Simone Ferrini on 11/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "AppDelegate.h"

@interface LeaderBoardViewController ()

// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;
// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;

// The player's score. Its type is int64_t so as to match the expected type by the respective method of GameKit.
@property (nonatomic) int64_t score;

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;

-(void)authenticateLocalPlayer;

-(void)reportScore;

-(void)updateAchievements;

@end

@implementation LeaderBoardViewController

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
	// Do any additional setup after loading the view, typically from a nib.
    
    [self authenticateLocalPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setPoints:(id)sender
{
    self.score = [self.pointsTextField.text intValue];
    
    [self reportScore];
    [self updateAchievements];
}

- (IBAction)showGCOptions:(id)sender
{
    [self showLeaderboardAndAchievements:YES];
    
    //    [self showLeaderboardAndAchievements:NO];
}

- (void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        } else {
            
            if ([GKLocalPlayer localPlayer].authenticated) {
                self.gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    } else {
                        self.leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            } else {
                self.gameCenterEnabled = NO;
            }
        }
    };
}

- (void)reportScore
{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardIdentifier];
    score.value = self.score;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)updateAchievements
{
    // Each achievement identifier will be assigned to this string.
    NSString *achievementIdentifier;
    // The calculated progress percentage will be assigned to the next variable.
    float progressPercentage = 0.0;
    
    // Declare a couple of GKAchievement objects to use in this method.
    GKAchievement *scoreAchievement = nil;
    
    // Calculate the progress percentage and set the identifier for each achievement regarding the score.
    if (self.score <= 50) {
        progressPercentage = self.score * 100 / 50;
        achievementIdentifier = @"Achievement_50Points";
    } else if (self.score <= 300) {
        progressPercentage = _score * 100 / 300;
        achievementIdentifier = @"Achievement_300Points";
    } else {
        progressPercentage = _score * 100 / 1000;
        achievementIdentifier = @"Achievement_1000Points";
    }
    
    // Initialize the scoreAchievement object and assign the progress.
    scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
    scoreAchievement.percentComplete = progressPercentage;
    
    // Depending on the progressInLevelAchievement flag value create a NSArray containing either both
    // or just the scores achievement.
    NSArray *achievements = @[scoreAchievement];
    
    // Report the achievements.
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


- (void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = self.leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextFields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pointsTextField resignFirstResponder];
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
