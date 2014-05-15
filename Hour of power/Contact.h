//
//  Contact.h
//  Hour of power
//
//  Created by Simone Ferrini on 01/05/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSNumber * answered;
@property (nonatomic, retain) NSNumber * classification;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSDate * lastCall;
@property (nonatomic, retain) NSString * log;
@property (nonatomic, retain) NSDate * nextCall;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSNumber * speakTime;
@property (nonatomic, retain) NSNumber * nCalls;
@property (nonatomic, retain) NSNumber * nIntroductions;

@end
