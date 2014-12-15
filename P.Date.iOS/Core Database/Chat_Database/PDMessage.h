//
//  PDMessage.h
//  PlayDate
//
//  Created by iApp on 05/09/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
     Text,
     Photo,
     Video
} TypeofMessage;


@interface PDMessage : NSObject

@property (nonatomic, strong) NSString * receiver;
@property (nonatomic, strong) NSString * sender;
@property (nonatomic) TypeofMessage  type;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSDate * dateTime;
@property (nonatomic, strong) NSString * messageId;

+(PDMessage *)sharedMessage;
-(void)sendMessage;
-(NSArray *)readPreviousMesages;
@end
//5/sep
//Project Tittle:
//.Playdate
//
//Task Assigned :
//.Playdate
//1. DataBase for Chat
//2. Save Chat
//3. Chat Check on gabber server(office server) by creating account
//4. Calender event displaying on sender side(in app calender)
//
//Activities Completed Today :
//.Playdate
//1. DataBase for Chat
//2. Save Chat
//3. Calender event displayed on sender side( on  app calender)
//

//Activities in Progress :
//
//Activities not completed :
// .office server is not configure
//Issues needing immediate
//
//
//Time taken to complete task :
//8.00 hours
//Duration of Meter Run
//6.30 hours