//
//  ChatTable.h
//  PlayDate
//
//  Created by iApp on 05/09/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ChatTable : NSManagedObject

@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSString * messageId;

@end
