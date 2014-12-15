//
//  ContentManager.m
//  SOSimpleChatDemo
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//

#import "ContentManager.h"
#import "Message.h"
#import "SOMessageType.h"
#import "PDDatabase.h"

@implementation ContentManager

+ (ContentManager *)sharedManager
{
    static ContentManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (NSArray *)generateConversation
{
    
    
//       NSMutableArray *result = [NSMutableArray new];
//    
//  //  fetch chat from database at intialization time
//    
// NSArray *arrChatTemp=[[PDDatabase sharedChat]fetchChatBetweenSender:strTempIdentifySender andReceiver:strTempIdentifyReciver TotalChatLoad:50];
//    
//
//    for (ChatTable *chat in arrChatTemp)
//    {
//        
//        
//        Message *message = [[Message alloc] init];
//        if ([chat.sender  isEqualToString:strTempIdentifySender])
//        {
//            message.fromMe = YES;
//        }
//        else
//        {
//            message.fromMe = NO;
//        }
//     
////        message.text = chat.content;
//        message.type =[self messageTypeFromString:chat.type];
//
//        message.date = chat.dateTime;
//        
////        int index = (int)[data indexOfObject:msg];
////        if (index > 0) {
////            Message *prevMesage = result.lastObject;
////            message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
////        }
//        
//        if (message.type == SOMessageTypePhoto) {
//            
//            NSString *str = chat.content;
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentsDirectory = [paths objectAtIndex:0];
//            NSString *fullImgNm=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
//            message.thumbnail =[UIImage imageWithContentsOfFile:fullImgNm];            
//        } else if (message.type == SOMessageTypeVideo) {
////            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
////            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
//        }
//        else
//            message.text = chat.content;
//        
//        [result addObject:message];
//
//    }
//    
//
////    NSArray *data = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Conversation" ofType:@"plist"]]];
////    for (NSDictionary *msg in data)
////    {
////        Message *message = [[Message alloc] init];
////        message.fromMe = [msg[@"fromMe"] boolValue];
////        message.text = msg[@"message"];
////        message.type =  [self messageTypeFromString:msg[@"type"]];
////        message.date = [NSDate date];
////        
////        int index = (int)[data indexOfObject:msg];
////        if (index > 0) {
////            Message *prevMesage = result.lastObject;
////            message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
////        }
////        
////        if (message.type == SOMessageTypePhoto) {
////            message.media = UIImageJPEGRepresentation([UIImage imageNamed:msg[@"image"]], 1);
////        } else if (message.type == SOMessageTypeVideo) {
////            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
////            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
////        }
////
////        [result addObject:message];
////    }
//    
//    return result;

    return [[PDMessage sharedMessage]readPreviousMesages];    // read from data base
}

//- (SOMessageType)messageTypeFromString:(NSString *)string
//{
//    if ([string isEqualToString:@"SOMessageTypeText"]) {
//        return SOMessageTypeText;
//    } else if ([string isEqualToString:@"SOMessageTypePhoto"]) {
//        return SOMessageTypePhoto;
//    } else if ([string isEqualToString:@"SOMessageTypeVideo"]) {
//        return SOMessageTypeVideo;
//    }
//
//    return SOMessageTypeOther;
//}
- (SOMessageType)messageTypeFromString:(NSNumber *)num
{
    if (num == [NSNumber numberWithInt:0]) {
        return SOMessageTypeText;
    } else if (num ==[NSNumber numberWithInt:1])  {
        return SOMessageTypePhoto;
    } else if (num == [NSNumber numberWithInt:2])  {
        return SOMessageTypeVideo;
    }
    
    return SOMessageTypeOther;
}

@end
