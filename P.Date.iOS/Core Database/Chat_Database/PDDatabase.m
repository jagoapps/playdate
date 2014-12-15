//
//  PDDatabase.m
//  PlayDate
//
//  Created by iApp on 05/09/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDDatabase.h"

@implementation PDDatabase

static PDDatabase *db = nil;
+(PDDatabase *)sharedChat
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[PDDatabase alloc] init];
      }
    );
    
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
        fileURL = [fileURL URLByAppendingPathComponent:@"PDChat.sqlite"];
        
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
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"ChatDatabase" ofType:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    }
    
    return _managedObjectModel;
}
#pragma selfMethods
//-(NSArray *)fetchChatBetweenSender:(NSString *)sender andReceiver:(NSString *)receiver fromIndex:(int)index limit:(int)limit
-(NSArray *)fetchChatBetweenSender:(NSString *)sender
                       andReceiver:(NSString *)receiver
                         TotalChatLoad:(int)maxNumber
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatTable" inManagedObjectContext:[self managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(receiver = %@ && sender = %@) || (receiver = %@ && sender = %@)", receiver,sender,sender,receiver];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    [request setFetchOffset:maxNumber-50];
    [request setFetchLimit:maxNumber];
    
    NSError *error = nil;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (error)
    {
        return nil;
    }
    else
    {
        return array;
    }
}

-(void)saveChat_Sender:(NSString *)Sender
           andReceiver:(NSString *)Receiver
             messageId:(NSString*)idMessage
messageType:(NSNumber *)type
Content:(NSString *)content
DateandTime:(NSDate *)datetime
{
    ChatTable *save =[NSEntityDescription insertNewObjectForEntityForName:@"ChatTable" inManagedObjectContext:[self managedObjectContext]];
    [save setSender:Sender];
    [save setReceiver:Receiver];
    [save setMessageId:idMessage];
    [save setType:type];
    [save setContent:content];
    [save setDateTime:datetime];
    
    
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

-(void)deleteBetweenSender:(NSString *)sender
               andReceiver:(NSString *)receiver
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatTable" inManagedObjectContext:[self managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"receiver = %@ && sender = %@", receiver,sender];
    NSFetchRequest * request =[[NSFetchRequest alloc] init];
      [request setEntity:entity];
      [request setPredicate:predicate];
    NSArray * array =[[self managedObjectContext] executeFetchRequest:request error:nil];
  
     for (ChatTable *obj  in array)
              [[self managedObjectContext] deleteObject:obj];
                    
     [[self managedObjectContext] save:nil];
            
            
            
}

@end
