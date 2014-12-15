//
//  PDContactlistVC.m
//  PlayDate
//
//  Created by iapp on 30/10/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDContactlistVC.h"
#import "PDHelper.h"
#import "PDCalenderViewController.h"
#import "PDRequestArrangeViewController.h"
#import "PDMainViewController.h"
#import "ContactsData.h"
#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#import <MessageUI/MFMessageComposeViewController.h>
#import "UIImageView+WebCache.h"

@interface PDContactlistVC ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView *tble;
    

    NSMutableArray *arrFilterAllContactData;
   
    
    NSMutableArray *arrAllContactData;
    
    ContactsData *objContactsData;
    NSArray *arrTableData;

     NSMutableArray *contactsForPost;
    
    
    NSArray *arrServerfriendDetail;
}
-(IBAction)btnActionSegmentcontrol:(id)sender;
@end

@implementation PDContactlistVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(fetchContacts) withObject:nil afterDelay:0.1];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    arrFilterAllContactData=[[NSMutableArray alloc]init];
    [self setUpViewContents];
    tble.backgroundColor = [UIColor  clearColor];
    tble.backgroundView = nil;
    tble.separatorStyle = UITableViewCellSeparatorStyleNone;
   
  
    
    segment.selectedSegmentIndex=1;
       // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==1)
 
      return 44.0;
    else
      return  70.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (segment.selectedSegmentIndex==1)
    {
    if ([[arrFilterAllContactData objectAtIndex:section]count])
    
        return  [self firstLetter:section];
    }
    return @"";

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (segment.selectedSegmentIndex==1)
        return [[arrFilterAllContactData objectAtIndex:section]count];
    
    return  [arrServerfriendDetail count];


    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (segment.selectedSegmentIndex==1)
    {
        return [arrFilterAllContactData count];

    }
    return 1;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (segment.selectedSegmentIndex==1)
    {
     NSMutableArray *indices = [NSMutableArray array];
     for (int i = 0; i < arrFilterAllContactData.count; i++)
     {
        if ([[arrFilterAllContactData objectAtIndex:i]count])
             [indices addObject:[self firstLetter:i]];
        else
             [indices addObject:@""];
     }
      return indices;
    }
 return nil;
}
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//  
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       if (segment.selectedSegmentIndex==1)
    {
      
        UIButton *btn;
        

        if (cell == nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(0, 43, 320, 1)];
            vw.backgroundColor=[UIColor colorWithRed:170.0/255 green:170.0/255 blue:170./255.0 alpha:0.36];
            [cell.contentView addSubview:vw];
            
            
            
            
            
        }

        for (UIView *subView in [cell.contentView subviews])
            [subView removeFromSuperview];

    
  
    objContactsData=[[ContactsData alloc]init];
    objContactsData=[[arrFilterAllContactData objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
 
    cell.textLabel.text=objContactsData.firstNames;
    
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(230, 7, 80,30);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag=(indexPath.section)*10000+(indexPath.row);
    
   
  
    if (objContactsData.hasFriend)
    {
         [btn setTitle:@"Playdate" forState:UIControlStateNormal];
          btn.backgroundColor=[UIColor greenColor];
          btn.userInteractionEnabled=FALSE;
    }
    else
    {
         [btn setTitle:@"Invite" forState:UIControlStateNormal];
         btn.backgroundColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
         btn.userInteractionEnabled=TRUE;

    }
    [cell.contentView addSubview:btn];
    }
    
    if (segment.selectedSegmentIndex==0)
    {

    
     
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        for (UIView *subView in [cell.contentView subviews])
            [subView removeFromSuperview];
        
        
        cell.textLabel.text=@"";
        UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 200, 60)];
        lblName.text = [[NSString stringWithFormat:@"%@", [[[arrServerfriendDetail objectAtIndex:indexPath.row] valueForKey:@"friendinfo"]valueForKey:@"name"]] uppercaseString];
        lblName.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        lblName.font =[[PDHelper sharedHelper] applicationFontWithSize:14.0];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 5.0, 60.0,60.0)];
        NSURL *url = [[[arrServerfriendDetail objectAtIndex:indexPath.row] valueForKey:@"friendinfo"]valueForKey:@"profile_image"];
        NSLog(@"%@",url);
        

        [imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_img"]];
        imgView.contentMode=UIViewContentModeScaleAspectFit;
        
        
        [cell.contentView addSubview:lblName];
        [cell.contentView addSubview:imgView];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(0, 69.0, 320, 1)];
        vw.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255 blue:170.0/255 alpha:0.36];
        [cell.contentView addSubview:vw];
        
       
     
    }
    
    return cell;
 

}
#pragma mark iboutlets
-(IBAction)btnActionSegmentcontrol:(id)sender
{
 if (segment.selectedSegmentIndex==1)
  {
    if ([arrFilterAllContactData count]==0)
    {
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
        [self performSelector:@selector(fetchContacts) withObject:nil afterDelay:0.1];
    }
  }
else
{
   if ([arrServerfriendDetail count]==0)
   {
       [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];

        [self performSelector:@selector(callWebServices_Serverfriend) withObject:nil afterDelay:0.1];
   }
}
    [tble reloadData];
    
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
-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
        
        
    }];
}


#pragma mark self methods
- (NSString *)firstLetter:(NSInteger)section
{
    unichar str=[ALPHA characterAtIndex:section];
    return [NSString stringWithFormat:@"%c",str];
;
}
- (NSArray *) itemsInSection_League: (NSInteger) section
{
    NSString *predicateString = [self firstLetter:section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.firstNames beginswith[c] %@)", predicateString];
    NSLog(@"%@",[arrAllContactData filteredArrayUsingPredicate:predicate]);
    return [arrAllContactData filteredArrayUsingPredicate:predicate];
}
-(void)fetchContacts
{
[[PDHelper sharedHelper]getAllContacts:^(NSArray *arrContact) {
    
    arrAllContactData=[[NSMutableArray alloc]init];
    arrAllContactData=[arrContact mutableCopy];
          [self callWebServices];
    
   
    
}];
}
-(void)sendSMS:(UIButton *)btn
{
    
    long num = btn.tag;
    long section=num/10000;
    long row=(num%10000);

    
  

    

    
    
    
    NSLog(@"\nSection---%ld",section);
    NSLog(@"Row---%ld\n",row);
   ContactsData   *objContactsDataTemp=[[arrFilterAllContactData objectAtIndex:section]objectAtIndex:row];

    
    NSMutableArray *arrTempNumbers=[[NSMutableArray alloc]init];
    for (int i=0; i<[objContactsDataTemp.Numbers count];i++)
    
      [arrTempNumbers addObject:[objContactsDataTemp.Numbers objectAtIndex:i]];
    

    NSLog(@"%@",[arrTempNumbers copy]);
    [self sendSMS:@"I m using a new app 'Playdate' to plan the kids schedule, join me by downloading at http://www.playdateapp.co it makes it easier & fun !!" recipientList:[arrTempNumbers copy]];
}
-(void)setUpViewContents
{
    CGRect rect;
    
    CGFloat totalHeight = [UIScreen mainScreen].bounds.size.height;
    if (![[PDHelper sharedHelper] isIOS7])
        totalHeight -= 20.0;
    else
    {
        for (UIView *subView in self.view.subviews) {
            if ([subView isKindOfClass:[UIView class]]) {
                rect = subView.frame;
                rect.origin.y += 20.0;
                subView.frame = rect;
            }
        }
        
        rect = tble.frame;
        rect.size.height -= 20.0;
        tble.frame = rect;
        
    }
    
}
-(void)callWebServices
{
    NSString *strurl= [NSString stringWithFormat:@"https://graph.facebook.com/v2.0/me/friends?fields=id,name,picture.type(large)&access_token=%@" ,[FBSession activeSession].accessTokenData.accessToken];
    
    
    NSURL *url = [NSURL URLWithString:strurl];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    id friends_result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray  *friends_fb_ids = [[friends_result objectForKey:FBData] valueForKey:FBId];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    [friends_fb_ids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [str appendFormat:@"'%@'", obj];
        [str appendString:@","];
        
    }];
    
    NSLog(@"friends_fb_ids String: \n%@", str);
    if (str.length > 0){
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    }
    
    
    NSLog(@"%@",str);
    NSDictionary *params = @{@"friend_fbids": str};
    
    
    [[PDWebHandler sharedWebHandler]allreadyFriendFromContactlist_ListParams:params];
    
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
       //  id result = response;

         if ([[response valueForKey:PDWebData] isKindOfClass:[NSNull class]])
         {
             NSLog(@"%@",error.description);
         }
         else
         {
             NSLog(@"%@",[response valueForKey:PDWebData]);
             NSArray *friendDetailArray = [response valueForKey:PDWebData];
             for (int j=0; j<[friendDetailArray count]; j++)
             {
             
               for (int i=0; i<[arrAllContactData count]; i++)
                {
                  ContactsData *obj= [arrAllContactData objectAtIndex:i];

                    NSString *phoneNumberIos;
                   if ([obj.Numbers count]==0)
                    phoneNumberIos=@"aaaa";
                   else
                       phoneNumberIos=[obj.Numbers objectAtIndex:0];
                    
                    phoneNumberIos = [phoneNumberIos stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    phoneNumberIos = [phoneNumberIos stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSString *EmailIos;
                    if ([obj.Emails count]==0)
                        EmailIos=@"aaaa";
                    else
                        EmailIos=[obj.Emails objectAtIndex:0];
                    
                   EmailIos = [EmailIos stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSString *phoneNumberServer;
                    if ([[[friendDetailArray objectAtIndex:j]valueForKey:@"phone"]length]==0)
                        phoneNumberServer=@"aaaa";
                    else
                        phoneNumberServer=[[friendDetailArray objectAtIndex:j]valueForKey:@"phone"];                    NSString *EmailServer;
                    
                    phoneNumberServer = [phoneNumberServer stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    phoneNumberServer = [phoneNumberServer stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    if ([[[friendDetailArray objectAtIndex:j]valueForKey:@"email"]length]==0)
                        EmailServer=@"aaaa";
                    else
                        EmailServer=[[friendDetailArray objectAtIndex:j]valueForKey:@"email"];

                    EmailServer = [EmailServer stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    
//                    
//                    NSLog(@"------------------------------");
//                                         NSLog(@"\n SERVER email-   %@",EmailServer);
//                                         NSLog(@"\n IOS email-    %@",EmailIos);
//                    
//                    
//                    
//                                        NSLog(@"\nSERVER mobile-   %@ ",phoneNumberServer);
//                                        NSLog(@"\nIOS mobile-       %@ ",phoneNumberIos);
                    
                    
                    //@"9855334159"
                    
//                                 NSLog(@"IOS phone-   %@ ",phoneNumberIos);
//                    if ([phoneNumberIos isEqualToString:phoneNumberServer])
                    
                 if(([phoneNumberIos isEqualToString:phoneNumberServer])||([EmailIos isEqualToString:EmailServer]))
                 {
                     [arrAllContactData removeObjectAtIndex:i];
                     [arrAllContactData insertObject:obj atIndex:i];
                     obj.hasFriend=1;
                     
                 }
                   
                }
             }
             arrFilterAllContactData=[[NSMutableArray alloc]init];
  
             for (int i=0; i<26; i++)
                 [arrFilterAllContactData addObject:[self itemsInSection_League:i]];
            [tble reloadData];
           }
         
         [[PDAppDelegate sharedDelegate]hideActivity];
     }];
}
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
    {
        NSLog(@"Message cancelled");
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not sent" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
        
    }
        else if (result == MessageComposeResultSent)
        {
            NSString *str=@"";
            [[[UIAlertView alloc]initWithTitle:@"Sent " message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];

            NSLog(@"Message sent");
        }
            else
              [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not sent" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
}
-(void)callWebServices_Serverfriend
{
    NSString *strurl= [NSString stringWithFormat:@"https://graph.facebook.com/v2.0/me/friends?fields=id,name,picture.type(large)&access_token=%@" ,[FBSession activeSession].accessTokenData.accessToken];
    
    
    NSURL *url = [NSURL URLWithString:strurl];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    id friends_result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray  *friends_fb_ids = [[friends_result objectForKey:FBData] valueForKey:FBId];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    [friends_fb_ids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [str appendFormat:@"'%@'", obj];
        [str appendString:@","];
        
    }];
    
    NSLog(@"friends_fb_ids String: \n%@", str);
    if (str.length > 0){
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    }
    
    
    NSLog(@"%@",str);
    NSDictionary *params = @{PDWebFriendFBId: str};
    
    
    [[PDWebHandler sharedWebHandler]getFriend_Detail:params];
    
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         id result = response;
         NSString *strval = [NSString stringWithString: [result valueForKey:@"msg"]];
         NSLog(@"%@",strval);
         if ([[response valueForKey:PDWebData] isKindOfClass:[NSNull class]])
         {
             NSLog(@"%@",error.description);
         }
         else
         {
             NSLog(@"%@",[response valueForKey:PDWebData]);
             arrServerfriendDetail = [response valueForKey:PDWebData];
             [tble reloadData];
         }
         
         [[PDAppDelegate sharedDelegate]hideActivity];
     }];
}
@end
