//
//  PDMessage.m
//  PlayDate
//
//  Created by iApp on 05/09/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDMessage.h"
#import "PDDatabase.h"
#import "ContentManager.h"
#import "Message.h"
#import "SOMessageType.h"
#import "PDDatabase.h"
@implementation PDMessage

static PDMessage *db = nil;

+(PDMessage *)sharedMessage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[PDMessage alloc] init];
    }
                  );
    
    return db;
}
-(void)sendMessage
{
    NSLog(@"%u",(int)self.type);
       [[PDDatabase sharedChat]saveChat_Sender: self.sender andReceiver: self.receiver messageId:  self.messageId messageType:[NSNumber numberWithInt:(int)self.type] Content:self.content DateandTime: self.dateTime];
}
-(NSArray *)readPreviousMesages
{
    NSMutableArray *result = [NSMutableArray new];
    
    //  fetch chat from database at intialization time
    
    NSArray *arrChatTemp=[[PDDatabase sharedChat]fetchChatBetweenSender:strTempIdentifySender andReceiver:strTempIdentifyReciver TotalChatLoad:50];
    
    
    for (ChatTable *chat in arrChatTemp)
    {
        
        
        Message *message = [[Message alloc] init];
        if ([chat.sender  isEqualToString:strTempIdentifySender])
        {
            message.fromMe = YES;
        }
        else
        {
            message.fromMe = NO;
        }
        
        //        message.text = chat.content;
        message.type =[self messageTypeFromString:chat.type];
        
        message.date = chat.dateTime;
        
        //        int index = (int)[data indexOfObject:msg];
        //        if (index > 0) {
        //            Message *prevMesage = result.lastObject;
        //            message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
        //        }
        
        if (message.type == SOMessageTypePhoto) {
            
            NSString *str = chat.content;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fullImgNm=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
            message.thumbnail =[UIImage imageWithContentsOfFile:fullImgNm];
        } else if (message.type == SOMessageTypeVideo) {
            //            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
            //            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
        }
        else
            message.text = chat.content;
        
        [result addObject:message];
        
    }
    
    

    
    return result;
}

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
