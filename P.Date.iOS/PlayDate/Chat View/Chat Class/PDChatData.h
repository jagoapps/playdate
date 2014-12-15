//
//  Type4VC.h
//  SOSimpleChatDemo
//
//  Created by Artur Mkrtchyan on 7/21/14.
//  Copyright (c) 2014 SocialOjbects Software. All rights reserved.
//

#import "SOMessagingViewController.h"
#import "PDMessage.h"
#import <CoreData/CoreData.h>

@interface PDChatData : SOMessagingViewController<NSFetchedResultsControllerDelegate>
{
     NSFetchedResultsController *fetchedResultsController;
}

@property(nonatomic,strong) id jabber_id;
@property(nonatomic,strong) NSString* receiverName;
-(void)message_receiveToMe_Message:(NSString *)mesg type:(NSString *)type;
@end


