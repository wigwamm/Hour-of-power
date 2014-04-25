//
//  CallDate.h
//  Hour of power
//
//  Created by Simone Ferrini on 23/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface CallDate : NSManagedObject

@property (nonatomic, retain) NSDate * nextCall;
@property (nonatomic, retain) NSSet *contact;
@end

@interface CallDate (CoreDataGeneratedAccessors)

- (void)addContactObject:(Contact *)value;
- (void)removeContactObject:(Contact *)value;
- (void)addContact:(NSSet *)values;
- (void)removeContact:(NSSet *)values;

@end
