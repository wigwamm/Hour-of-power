//
//  GCHelper.h
//  Hour of power
//
//  Created by Simone Ferrini on 15/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject {
    
    BOOL gameCenterAvailabel;
    BOOL userAuthenticated;
    
}

@property (assign, readonly) BOOL gameCentreAvailable;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

@end
