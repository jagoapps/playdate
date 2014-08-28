//
//  PDInviteViewController.m
//  PlayDate
//
//  Created by Simpy on 12/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDInviteViewController.h"
#import "PDMainViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "PDCalenderViewController.h"
#import "PDRequestArrangeViewController.h"

@interface PDInviteViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIScrollView *scrollView;
    
}

@end

@implementation PDInviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViewContents];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
        
        
    }];
}

#pragma mark - Social Button Actions

-(IBAction)faceBookAction:(id)sender
{
    SLComposeViewController *controllerSLC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controllerSLC setInitialText:@"I’ve started using Playdate by JAGO, an awesome app to arrange & manage my kids social lives.  Check it out and get your download here\n"];
    [controllerSLC addURL:[NSURL URLWithString:@"http://www.jago.nu"]];
    [controllerSLC addImage:[UIImage imageNamed:@"AppIcon40x40.png"]];
    [self presentViewController:controllerSLC animated:YES completion:Nil];

}
-(IBAction)twitterAction:(id)sender
{
    SLComposeViewController *controllerSLC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controllerSLC setInitialText:@"I’ve started using Playdate by JAGO, an awesome app to arrange & manage my kids’ lives. Check it here \n"];
    [controllerSLC addURL:[NSURL URLWithString:@"http://www.jago.nu"]];
    [controllerSLC addImage:[UIImage imageNamed:@"AppIcon40x40.png"]];
    [self presentViewController:controllerSLC animated:YES completion:Nil];

}
-(IBAction)emailAction:(id)sender
{
    NSMutableString *htmlString = [[NSMutableString alloc] init];
    [htmlString appendString:@"<html>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:@"I’ve started using Playdate by JAGO, an awesome app to arrange & manage my kids social lives.  Check it out and get your download here <a href='http://www.jago.nu'>www.jago.nu</a>"];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];

    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Playdate Feedback"];
        [mailer setToRecipients:@[@"abc@gmail.com"]];
        
        
//        NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
//        [mailer setToRecipients:toRecipients];
        
      // UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
      //  NSData *imageData = UIImagePNGRepresentation(myImage);
     //   [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        
        [mailer setMessageBody:htmlString isHTML:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}
-(IBAction)smsAction:(id)sender
{
//    PDSMSViewController *pdSMSViewController = [[PDSMSViewController alloc]initWithNibName:@"PDSMSViewController" bundle:nil];
//    [self.navigationController pushViewController:pdSMSViewController animated:YES];
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposer =
        [[MFMessageComposeViewController alloc] init];
        NSString *message = @"I’ve started using Playdate by JAGO, an awesome app to arrange & manage my kids lives.  Check it out here www.jago.nu";
        [messageComposer setBody:message];
        messageComposer.messageComposeDelegate = self;
        [self presentViewController:messageComposer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the Message sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}


#pragma mark- MFMailComposeViewController Delegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark - MFMessageComposeController Methods

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Methods
-(void)setUpViewContents
{
    CGRect rect;
    
    CGFloat totalHeight = [UIScreen mainScreen].bounds.size.height;
    if (![[PDHelper sharedHelper] isIOS7])
    {
        totalHeight -= 20.0;
    }
    else
    {
        for (UIView *subView in self.view.subviews)
        {
            if ([subView isKindOfClass:[UIView class]])
            {
                rect = subView.frame;
                rect.origin.y += 20.0;
                subView.frame = rect;
            }
        }
    }
}

-(IBAction)menuArrange:(id)sender
{
    PDRequestArrangeViewController *arrangeViewController = [[PDRequestArrangeViewController alloc]initWithNibName:@"PDRequestArrangeViewController" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:arrangeViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
}
-(IBAction)menuCalender:(id)sender
{
    PDCalenderViewController *calendarViewController = [[PDCalenderViewController alloc]initWithNibName:@"PDCalenderViewController" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:calendarViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}
-(IBAction)menuHome:(id)sender
{
    PDMainViewController *mainViewController = [[PDMainViewController alloc] initWithNibName:@"PDMainViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:mainViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}
@end
