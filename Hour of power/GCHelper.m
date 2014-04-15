//
//  GCHelper.m
//  Hour of power
//
//  Created by Simone Ferrini on 15/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper
@synthesize gameCentreAvailable;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;

+ (GCHelper *) sharedInstance
{
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc]init];
    }
    return sharedHelper;
}

-(BOOL)isGameCentreAvailable
{
    //Check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //Check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init
{
    if ((self = [super init])) {
        gameCentreAvailable = [self isGameCentreAvailable];
        if (gameCentreAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}


- (void)authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication Changed. User Authenticated");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication Changed. User Not Authenticated");
        userAuthenticated = FALSE;
    }
}

#pragma mark User Functions

- (void)authenticateLocalUser
{
    if (!gameCentreAvailable) return
        NSLog(@"Authenticating Local User....");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else{
        NSLog(@"Already Authenticated!");
    }
}

@end