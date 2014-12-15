//
//  PDDatabase.h
//  PlayDate
//
//  Created by iApp on 05/09/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ChatTable.h"

NSString *strTempIdentifySender;
NSString *strTempIdentifyReciver;
@interface PDDatabase : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(PDDatabase *)sharedChat;


//-(NSArray *)fetchChatBetweenSender:(NSString *)sender
//                                        andReceiver:(NSString *)receiver
//                                            fromIndex:(int)index
//                                                        limit:(int)limit;

-(void)saveChat_Sender:(NSString *)Sender
            andReceiver:(NSString *)receiver
            messageId:(NSString*)id
            messageType:(NSNumber *)type
            Content:(NSString *)content
            DateandTime:(NSDate *)datetime;

-(void)deleteBetweenSender:(NSString *)Sender
               andReceiver:(NSString *)receiver;
-(NSArray *)fetchChatBetweenSender:(NSString *)sender
                       andReceiver:(NSString *)receiver
                     TotalChatLoad:(int)maxNumber;
@end
