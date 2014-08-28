//
//  Database.m
//  FXLiveApp
//
//  Created by iapp on 1/17/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "Database.h"

@implementation Database
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static Database *db = nil;
+(Database *)sharedDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[Database alloc] init];
    });
    
    return db;
}

#pragma mark - Database Intialization
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    }
    
    return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // It will create sqlite file
    if (_persistentStoreCoordinator == nil)
    {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSURL *fileURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
        fileURL = [fileURL URLByAppendingPathComponent:@"Playdate.sqlite"];
        
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:fileURL options:nil error:&error])
        {
            abort();
            NSLog(@"%@", error.localizedDescription);
        }
    }
    
    return _persistentStoreCoordinator;
}


-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil)
    {
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Database" ofType:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    }
    
    return _managedObjectModel;
}

#pragma mark - Queries
-(NSArray *)readAllRecords
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SaveEntity" inManagedObjectContext:[self managedObjectContext]];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *favs = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    if (error)
    {
        return nil;
    }
    else
    {
        return favs;
    }
}

-(void)saveFavroiteForTeam:(NSString *)eventID
{
    SaveEntity *save =[NSEntityDescription insertNewObjectForEntityForName:@"SaveEntity" inManagedObjectContext:[self managedObjectContext]];
    [save setEventid:eventID];
    
   NSError *error = nil;
    [[self managedObjectContext] save:&error];
    if (error)
    {
        
        NSLog(@"Unable to save");
    }
    else
    {
        NSLog(@"Save successfully");
    }
}

//-(void)saveUserId:(NSString *)Userid name:(NSString *)name phoneno:(NSString *)phonenosave ImageUrl:(NSString *)imgUrl startdateTime:(NSString *)Startime  endTime:(NSString *)EndTime
//{
//    SaveEntity *save =[NSEntityDescription insertNewObjectForEntityForName:@"SaveEntity" inManagedObjectContext:[self managedObjectContext]];
//    [save setUserid:Userid];
//    [save setNamesave:name];
//    [save setPhonenosave:phonenosave];
//    [save setImageurlsave:imgUrl];
//    [save setStartTime:Startime];
//    [save setEndTime:EndTime];
//
//    
//    NSError *error = nil;
//    [[self managedObjectContext] save:&error];
//    if (error)
//    {
//        
//        NSLog(@"Unable to save");
//    }
//    else {
//        NSLog(@"Save successfully");
//    }
//
//}

//-(void)updateUserProfile:(NSString *)UserId startdate:(NSString *)startdatetime DatabaseClass :(SaveUserId *)classObj;
//
//{
//    
////    SaveUserId *Update =[NSEntityDescription insertNewObjectForEntityForName:@"SaveUserId" inManagedObjectContext:[self managedObjectContext]];
//   
//    
//    SaveUserId *Update = classObj;
//
//    
//    if (Update)
//    {
//        
//        [Update setStartTime:startdatetime];
//        
//
//        
//         NSError *error;
//        if (![[self managedObjectContext] save:&error])
//        {
//            NSLog(@"Error: %@", error);
//        }
//        else
//        {
//            NSLog(@"Record has been updated!");
//        }
//    }
//}



                       
                       
                       
                       
//-(void)deleteFavroiteForTeam:(NSString *)teamID Category:(NSString *)category
//{
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favroite" inManagedObjectContext:[self managedObjectContext]];
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamID = %@ && category = %@", teamID,category];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entity];
//    [request setPredicate:predicate];
//    
//    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:nil];
//    if ([array count] > 0){
//        
//       // Favroite *favroite = array[0];
//        //[[self managedObjectContext] deleteObject:favroite];
//        [[self managedObjectContext] save:nil];
//        
//        NSLog(@"Deleted team where teamID was = %@", teamID);
//    }
//}


//-(void)DeleteUserId:(NSString *)Userid
//{
//    NSEntityDescription *entity =[NSEntityDescription entityForName:@"SaveUserId" inManagedObjectContext:[self managedObjectContext]];
//    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"Userid = %@",Userid];
//    NSFetchRequest * request =[[NSFetchRequest alloc] init];
//    [request setEntity:entity];
//    [request setPredicate:predicate];
//    NSArray * array =[[self managedObjectContext] executeFetchRequest:request error:nil];
//
//    if ([array count]>0) {
//        
//              [[self managedObjectContext] save:nil];
//        NSLog(@"Deleted User Where UserID was = %@",Userid);
//    }
//}
//-(void)deleteAllRecord
//{
//    NSEntityDescription *entity =[NSEntityDescription entityForName:@"SaveUserId" inManagedObjectContext:[self managedObjectContext]];
//    //NSPredicate *predicate =[NSPredicate predicateWithFormat:@"Userid = %@",Userid];
//    NSFetchRequest * request =[[NSFetchRequest alloc] init];
//    [request setEntity:entity];
// //   [request setPredicate:predicate];
//    NSArray * array =[[self managedObjectContext] executeFetchRequest:request error:nil];
//    for (SaveUserId *obj  in array)
//    {
//        
//          [[self managedObjectContext] deleteObject:obj];
//        
//    }
// [[self managedObjectContext] save:nil];
//}

@end
