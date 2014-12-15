//
//  Type4VC.m
//  SOSimpleChatDemo
//
//  Created by Artur Mkrtchyan on 7/21/14.
//  Copyright (c) 2014 SocialOjbects Software. All rights reserved.
//

#import "PDChatData.h"
#import "ContentManager.h"
#import "Message.h"
#import "PDDatabase.h"
#import "XMPPFramework.h"
#import "DDLog.h"
#import <CoreData/CoreData.h>
#import "PDHelper.h"
#import "Base64Transcoder.h"

@interface PDChatData ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UILabel *lblReciver;
}
@property (strong,nonatomic)IBOutlet  UIView *navigationBarView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;
-(IBAction)btnBack:(id)sender;

@end

@implementation PDChatData
@synthesize jabber_id = _jabber_id;

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblReciver.text=self.receiverName;
    [PDAppDelegate sharedDelegate].objChatdata=self;
    // Do any additional setup after loading the view.
    
    self.myImage      = [UIImage imageNamed:@"arturdev.jpg"];
    self.partnerImage = [UIImage imageNamed:@"jobs.jpg"];
    
    [self setUpViewContents];
    [self loadMessages];
    
}
-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadMessages
{

    strTempIdentifySender=[NSString stringWithFormat:@"%@@192.168.1.193",[[NSUserDefaults standardUserDefaults] objectForKey:@"Chat_Id"]];
    strTempIdentifyReciver=[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id];
    self.dataSource = [[[ContentManager sharedManager] generateConversation] mutableCopy];
}

-(void)setUpViewContents
{
    CGRect rect;
    CGFloat totalHeight = [UIScreen mainScreen].bounds.size.height;
    if (![[PDHelper sharedHelper] isIOS7])
        totalHeight -= 20.0;
    else
    {
        for (UIView *subView in self.view.subviews)
        {
            if ([subView isKindOfClass:[UIView class]])
            {
              
                if (subView == self.navigationBarView)
                {
                    rect = subView.frame;
                    rect.origin.y += 20.0;
                    subView.frame = rect;
                }
               
            }
        }
        //        rect = tblVwEventRequstList.frame;
        //        rect.size.height -= 20.0;
        //        tblVwEventRequstList.frame = rect;
    
    }
}
#pragma mark - SOMessaging data source
- (NSMutableArray *)messages
{
    return self.dataSource;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    // Return 0 for disableing grouping
    return 2 * 24 * 3600;
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    Message *message = self.dataSource[index];
    
    // Adjusting content for 3pt. (In this demo the width of bubble's tail is 3pt)
    if (!message.fromMe)
    {
        cell.contentInsets = UIEdgeInsetsMake(0, 3.0f, 0, 0); //Move content for 3 pt. to right
        cell.textView.textColor = [UIColor blackColor];
    }
    else
    {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0f); //Move content for 3 pt. to left
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.userImageView.layer.cornerRadius = self.userImageSize.width/2;
    
    // Fix user image position on top or bottom.
    cell.userImageView.autoresizingMask = message.fromMe ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleBottomMargin;
    
    // Setting user images
    cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
    
    [self generateUsernameLabelForCell:cell];
}

- (void)generateUsernameLabelForCell:(SOMessageCell *)cell
{
    static NSInteger labelTag = 666;

    Message *message = (Message *)cell.message;
    UILabel *label = (UILabel *)[cell.containerView viewWithTag:labelTag];
    if (!label)
    {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = [UIColor grayColor];
        label.tag = labelTag;
        //[cell.containerView addSubview:label];
    }
    label.text = message.fromMe ?@"Me":self.receiverName;
    [label sizeToFit];

    CGRect frame = label.frame;
    
    CGFloat topMargin = 2.0f;
    if (message.fromMe)
    {
        frame.origin.x = cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width/2 - frame.size.width/2;
        frame.origin.y = cell.containerView.frame.size.height + topMargin;

    } else {
        frame.origin.x = cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width/2 - frame.size.width/2;
        frame.origin.y = cell.userImageView.frame.origin.y + cell.userImageView.frame.size.height + topMargin;
    }
    label.frame = frame;
}

- (CGFloat)messageMaxWidth
{
    return 140;
}

- (CGSize)userImageSize
{
    return CGSizeMake(40, 40);
}

- (CGFloat)messageMinHeight
{
    return 0;
}

#pragma mark - SOMessaging delegate

- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    // Show selected media in fullscreen
    [super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        return;
    }
    
    // check this user is online or not
    
//    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
//     [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id]];
//    [presence addAttributeWithName:@"type" stringValue:@"subscribe"];
//    [[PDAppDelegate sharedDelegate].xmppStream sendElement:presence];
//    


    
    
    // Show message on UI
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    [self sendMessage:msg];

    // Save in data base
    [PDMessage sharedMessage].receiver=[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id];//Convert into reciver email id
    [PDMessage sharedMessage].sender=[NSString stringWithFormat:@"%@@192.168.1.193",[[NSUserDefaults standardUserDefaults] objectForKey:@"Chat_Id"]];//convert into sender email id
    [PDMessage sharedMessage].type=0;
    [PDMessage sharedMessage].content=message;
    [PDMessage sharedMessage].messageId=@"temp";
    [PDMessage sharedMessage].dateTime=[NSDate date];
    
    [[PDMessage sharedMessage]sendMessage];
    // Add  Guardian_id for adding recents
    
    [[[PDHelper sharedHelper] recentArray] addObject:[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id]];
    NSLog(@"%lu",(unsigned long)[[[PDHelper sharedHelper] recentArray]count]);
    [[NSUserDefaults standardUserDefaults] setObject:[[PDHelper sharedHelper] recentArray] forKey:@"g_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    /// xmpp Chat
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    
    NSXMLElement *message1 = [NSXMLElement elementWithName:@"message"];
    [message1 addAttributeWithName:@"type" stringValue:@"chat"];
    [message1 addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id]];
    [message1 addChild:body];
    [[[PDAppDelegate sharedDelegate] xmppStream] sendElement:message1];
}

- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

    UIImage *image = chosenImage;
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//    NSError *error = nil;
    int i=1;

    NSString *fileName=[NSString stringWithFormat:@"%d.jpg",i];
    
    while (1)
    {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[stringPath stringByAppendingPathComponent:fileName]])
     {
        i++;
        fileName=[NSString stringWithFormat:@"%d.jpg",i];
     }
     else
     {
        NSString* path = [stringPath stringByAppendingPathComponent:fileName];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [data writeToFile:path atomically:YES];
    
        break;
     }
    }
  
    // save in data base
    [PDMessage sharedMessage].receiver=[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id];//Convert into reciver email id
    [PDMessage sharedMessage].sender=[NSString stringWithFormat:@"%@@192.168.1.193",[[NSUserDefaults standardUserDefaults] objectForKey:@"Chat_Id"]];//[[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];// convert into sender email id
    [PDMessage sharedMessage].type=1;
    [PDMessage sharedMessage].content=fileName;
    [PDMessage sharedMessage].messageId=@"temp";
    [PDMessage sharedMessage].dateTime=[NSDate date];
    
    [[PDMessage sharedMessage]sendMessage];
    // Add  Guardian_id for adding recents

    
    // show on View
    Message *msg = [[Message alloc] init];
    msg.thumbnail=chosenImage;
    msg.fromMe = YES;
    msg.type=SOMessageTypePhoto;
    [self sendMessage:msg];

 
    
    
    /// xmpp Chat send image
    NSData *data = UIImageJPEGRepresentation(chosenImage, 1.0);
  NSLog(@"Size of Image(bytes):%lu",(unsigned long)[data length]);
    Base64Transcoder *base64 = [[Base64Transcoder alloc] init];
    NSString *imgStr = [base64 base64EncodedStringfromData:data];


    
//    NSData *dataF = UIImagePNGRepresentation(chosenImage);
//    NSString *imgStr=[dataF base64Encoding];
    NSXMLElement *ImgAttachement = [NSXMLElement elementWithName:@"attachement"];
    [ImgAttachement setStringValue:imgStr];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:@"image test"];

    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id]];
   
    [message addChild:ImgAttachement];
    [message addChild:body];
    [[[PDAppDelegate sharedDelegate] xmppStream] sendElement:message];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
// chat Xmpp
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Accessors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//- (iPhoneXMPPAppDelegate *)appDelegate
//{
//	return (iPhoneXMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-(void)viewDidLoad
//{
//    UIBarButtonItem *btnBar=[[UIBarButtonItem alloc]initWithTitle:@"SEND" style:UIBarButtonItemStylePlain target:self action:@selector(btnSendAction)];
//    self.navigationItem.rightBarButtonItem=btnBar;
//
//}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor darkTextColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	titleLabel.numberOfLines = 1;
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.textAlignment = NSTextAlignmentCenter;
    
	if ([[PDAppDelegate  sharedDelegate] connect])
	{
		
        titleLabel.text = [[[[PDAppDelegate  sharedDelegate] xmppStream] myJID] bare];
        
        // check user is online
            NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
            [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id]];
            [presence addAttributeWithName:@"type" stringValue:@"subscribe"];
            [[[PDAppDelegate sharedDelegate] xmppStream] sendElement:presence];
        

        
        
	} else
	{
		titleLabel.text = @"No JID";
	}
	
	[titleLabel sizeToFit];
    
	///self.navigationItem.titleView = titleLabel;
}

- (void)viewWillDisappear:(BOOL)animated
{
//	[[PDAppDelegate  sharedDelegate] disconnect];
//	[[[PDAppDelegate  sharedDelegate] xmppvCardTempModule] removeDelegate:self];
//
//	[super viewWillDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[PDAppDelegate  sharedDelegate]managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors=[NSArray arrayWithObjects:sd1,sd2,nil];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:moc
                                                                       sectionNameKeyPath:@"sectionNum"
                                                                                cacheName:nil];
		[fetchedResultsController setDelegate:self];
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			DDLogError(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	//[[self tableView] reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewCell helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	
	if (user.photo != nil)
	{
		cell.imageView.image = user.photo;
	}
	else
	{
		NSData *photoData = [[[PDAppDelegate  sharedDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			cell.imageView.image = [UIImage imageWithData:photoData];
		else
			cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
	}
}
-(void)message_receiveToMe_Message:(NSString *)mesg type:(NSString *)type
{
    Message *msg = [[Message alloc] init];
    if ([type isEqual:@"Image"])
    {
        Base64Transcoder *base64 = [[Base64Transcoder alloc] init];
        UIImage *imgTemp=[UIImage imageWithData:[base64 decodedDataFromBase64String:mesg]];
        msg.thumbnail=imgTemp;
        msg.fromMe = YES;
        msg.type=SOMessageTypePhoto;
        [self sendMessage:msg];
        
      NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];

        int i=1;
        
        NSString *fileName=[NSString stringWithFormat:@"%d.jpg",i];
        
        while (1)
        {
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[stringPath stringByAppendingPathComponent:fileName]])
            {
                i++;
                fileName=[NSString stringWithFormat:@"%d.jpg",i];
            }
            else
            {
                NSString* path = [stringPath stringByAppendingPathComponent:fileName];
                NSData *data = UIImageJPEGRepresentation(imgTemp, 1.0);
                [data writeToFile:path atomically:YES];
                
                break;
            }
        }
        
        // save in data base
        [PDMessage sharedMessage].sender=[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id];//Convert into reciver Jabber  id
        [PDMessage sharedMessage].receiver=[NSString stringWithFormat:@"%@@192.168.1.193",[[NSUserDefaults standardUserDefaults] objectForKey:@"Chat_Id"]];//convert into sender jabber_id id

        [PDMessage sharedMessage].type=1;
        [PDMessage sharedMessage].content=fileName;
        [PDMessage sharedMessage].messageId=@"temp";
        [PDMessage sharedMessage].dateTime=[NSDate date];
        [[PDMessage sharedMessage]sendMessage];
        
        
    }
    else
    {
    msg.text = mesg;
    msg.fromMe = NO;
    [self receiveMessage:msg];
    
    [PDMessage sharedMessage].sender=[NSString stringWithFormat:@"%@@192.168.1.193",self.jabber_id];//Convert into reciver Jabber  id
    [PDMessage sharedMessage].receiver=[NSString stringWithFormat:@"%@@192.168.1.193",[[NSUserDefaults standardUserDefaults] objectForKey:@"Chat_Id"]];//convert into sender jabber_id id
    [PDMessage sharedMessage].type=0;
    [PDMessage sharedMessage].content=mesg;
    [PDMessage sharedMessage].messageId=@"temp";
    [PDMessage sharedMessage].dateTime=[NSDate date];
    
    [[PDMessage sharedMessage]sendMessage];
    }
}
@end
