//
//  Database.h
//  FXLiveApp
//
//  Created by iapp on 1/17/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SaveEntity.h"
#import "NotificationMessage.h"
@interface Database : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(Database *)sharedDatabase;
-(NSArray *)readAllRecords;
//-(void)saveFavroiteForTeam:(NSString *)teamID teamName:(NSString *)name andCategory:(NSString *)category;
//-(void)deleteFavroiteForTeam:(NSString *)teamID Category:(NSString *)category;

-(void)saveFavroiteForTeam:(NSString *)eventID;
-(NSArray *)readAllRecords_Notification;
-(void)saveFavroite_NotificationMessage:(NSString *)message;
//-(void)saveUserId:(NSString *)Userid name:(NSString *)name phoneno:(NSString *)phonenosave ImageUrl:(NSString *)imgUrl startdateTime:(NSString *)Startime  endTime:(NSString *)EndTime;
////-(void)DeleteUserId:(NSString *)Userid;
//
//-(void)updateUserProfile:(NSString *)UserId startdate:(NSString *)startdatetime DatabaseClass :(SaveEntity *)classObj;
//
//-(void)deleteAllRecord;
@end
