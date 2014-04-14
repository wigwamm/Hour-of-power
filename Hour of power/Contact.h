//
//  Contact.h
//  Hour of power
//
//  Created by Simone Ferrini on 14/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSNumber * classification;
@property (nonatomic, retain) NSNumber * unanswered;
@property (nonatomic, retain) NSDate * lastCall;
@property (nonatomic, retain) NSString * log;

@end
