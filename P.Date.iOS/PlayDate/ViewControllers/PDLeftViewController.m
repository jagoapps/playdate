//
//  PDLeftViewController.m
//  PlayDate
//
//  Created by Vakul on 01/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDLeftViewController.h"
#import "PDAddChildViewController.h"
#import "PDMainViewController.h"
#import "PDProfileViewController.h"
#import "PDRequestArrangeViewController.h"
#import "UIImageView+WebCache.h"
#import "PDInviteViewController.h"
#import "PDUpgradeViewController.h"
#import "PDCalenderViewController.h"
#import "PDSetsViewController.h"
#import "PDFriendListViewController.h"
#import <MessageUI/MessageUI.h>
#import "PDExtentedPermissions.h"
#import "PDNotificationListVC.h"
#import "RecipeProducts.h"
#import "PDChatListVC.h"
#import "PDContactlistVC.h"
#define TITLE @"title"
#define IMAGE @"image"

#define HOME        @"Home"
#define PROFILE     @"Profile"
#define ARRANGE     @"Arrange"
#define SETS        @"Sets"
#define CALENDAR    @"Calendar"
#define INVITE      @"Invite"
#define ADD_CHILD   @"Add Child"
#define NOTIFICATION   @"Notifications"
#define UPGRADE     @"Upgrade"
#define SETTING     @"Setting"
#define FEEDBACK    @"Feedback"
#define FRIENDS   @"Friends"
#define RESTORE   @"Restore"
#define CHAT   @"Chat"

@interface PDLeftViewController () <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate,RecipeProductsDelegate>

@property (strong, nonatomic) IBOutlet UIView *profileBGView;
@property (strong, nonatomic) IBOutlet UIImageView *iVBackground;


@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) NSArray *tblItems;

-(void)setUpViewContents;

@end

@implementation PDLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];

    
    self.iVProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iVProfile.layer.borderWidth = 2.0;
    self.iVProfile.layer.cornerRadius = 50.0;
    self.iVProfile.clipsToBounds = YES;
    self.iVProfile.userInteractionEnabled=YES;
    // Tap gesture
    UITapGestureRecognizer *tapGestureiVProfile=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureActioniVProfile:)];
    [self.iVProfile addGestureRecognizer:tapGestureiVProfile];
    
    
    // ADDING BOTTOM LINE
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0, CGRectGetHeight(self.profileBGView.frame)-2.0, CGRectGetWidth(self.profileBGView.frame), 2.0);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.profileBGView.layer addSublayer:bottomBorder];

    
    self.tblView.backgroundColor = [UIColor clearColor];
    self.tblView.backgroundView = nil;
    self.tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.tblItems = @[@{TITLE: HOME,     IMAGE: [UIImage imageNamed:@"home_icon"]},
                      
                      @{TITLE: PROFILE,  IMAGE: [UIImage imageNamed:@"profile_icon"]},
                      @{TITLE: NOTIFICATION,IMAGE: [UIImage imageNamed:@"notification_icon"]},
                      @{TITLE: ARRANGE,  IMAGE: [UIImage imageNamed:@"add_icon"]},
                      @{TITLE: FRIENDS,  IMAGE: [UIImage imageNamed:@"friend"]},
                      @{TITLE: SETS,     IMAGE: [UIImage imageNamed:@"sets_icon"]},
                      @{TITLE: ADD_CHILD,IMAGE: [UIImage imageNamed:@"child_icon"]},
                      @{TITLE: CALENDAR, IMAGE: [UIImage imageNamed:@"calender_icon"]},
                      
                      @{TITLE: INVITE,   IMAGE: [UIImage imageNamed:@"invite_icon"]},
                      @{TITLE: UPGRADE,  IMAGE: [UIImage imageNamed:@"upgrade_icon"]},
                      @{TITLE: FEEDBACK, IMAGE: [UIImage imageNamed:@"feedback_icon"]},
                    /*  @{TITLE: CHAT, IMAGE: [UIImage imageNamed:@"feedback_icon"]},*/

                       @{TITLE: RESTORE, IMAGE: [UIImage imageNamed:@"restore_icon"]}];
  //  @{TITLE: SETTING,  IMAGE: [UIImage imageNamed:@"settings_icon"]},

    
    // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Methods

-(void)tapGestureActioniVProfile :(UITapGestureRecognizer *)gestureView
{
    PDProfileViewController *profileViewController = [[PDProfileViewController alloc] initWithNibName:@"PDProfileViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:profileViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

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
                rect = subView.frame;
                rect.origin.y += 20.0;
                subView.frame = rect;
            }
        }
    }
    
    
    rect = self.tblView.frame;
    rect.origin.y = CGRectGetMaxY(self.profileBGView.frame);
    rect.size.height = totalHeight - CGRectGetMaxY(self.profileBGView.frame);
    self.tblView.frame = rect;
}


-(void)setUpUserProfile
{

    NSURL *imageURL = [NSURL URLWithString:[[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebProfileImage]];
 //   self.lblName.text = [[[PDUser currentUser] compositeName]uppercaseString];
     self.lblName.text = [[[[[PDUser currentUser] detail] valueForKey:@"userinfo"]valueForKey:PDWebFirstName] uppercaseString];
    
    [self.iVProfile setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_img"]];
}


#pragma mark - Table View Datasources & Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tblItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    for (id obj in cell.contentView.subviews)
        [obj removeFromSuperview];
    
    
    // ICON OF ROW
    CGSize iconSize = CGSizeMake(30.0, 30.0);
    
    UIImageView *iVIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, (44.0 - iconSize.height)/2.0, iconSize.width, iconSize.height)];
    iVIcon.image = [[self.tblItems objectAtIndex:indexPath.row] objectForKey:IMAGE];
    iVIcon.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:iVIcon];
    
    // TITLE OF ROW
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iVIcon.frame)+5.0, 0.0, CGRectGetWidth(self.tblView.frame)-CGRectGetMaxX(iVIcon.frame)+5.0, 44.0)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = [[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE];
    lblTitle.font = [UIFont systemFontOfSize:13.0];
    [cell.contentView addSubview:lblTitle];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE] isEqualToString:ADD_CHILD])
    {
        // OPEN ADD CHILD VIEW CONTROLLER
        PDAddChildViewController *addChildController = [[PDAddChildViewController alloc] initWithNibName:@"PDAddChildViewController" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:addChildController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE] isEqualToString:NOTIFICATION])
    {
        // OPEN Noticication VIEW CONTROLLER
        PDNotificationListVC *objPDNotificationListVC = [[PDNotificationListVC alloc] initWithNibName:@"PDNotificationListVC" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:objPDNotificationListVC];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }

    else if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE] isEqualToString:HOME])
    {
        // OPEN ADD CHILD VIEW CONTROLLER
        PDMainViewController *mainViewController = [[PDMainViewController alloc] initWithNibName:@"PDMainViewController" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:mainViewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE] isEqualToString:PROFILE])
    {
        // OPEN PROFILE VIEW CONTROLLER
        PDProfileViewController *profileViewController = [[PDProfileViewController alloc] initWithNibName:@"PDProfileViewController" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:profileViewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE] isEqualToString:ARRANGE])
    {
        PDRequestArrangeViewController *arrangeViewController = [[PDRequestArrangeViewController alloc]initWithNibName:@"PDRequestArrangeViewController" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:arrangeViewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row]objectForKey:TITLE]isEqualToString:INVITE])
    {
        PDInviteViewController *inviteViewController = [[PDInviteViewController alloc]initWithNibName:@"PDInviteViewController" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:inviteViewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row]objectForKey:TITLE]isEqualToString:CALENDAR])
    {
        PDCalenderViewController *calendarViewController = [[PDCalenderViewController alloc]initWithNibName:@"PDCalenderViewController" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:calendarViewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row]objectForKey:TITLE]isEqualToString:UPGRADE])
    {
        

        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"com.jagoapps.playdate.exchangechilds"])
        {
      
        
          PDExtentedPermissions *objPDExtentedPermissions=[[PDExtentedPermissions alloc]initWithNibName:@"PDExtentedPermissions" bundle:nil];
            
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:objPDExtentedPermissions];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
 
       else
       {
        PDUpgradeViewController *pdUpgradeView = [[PDUpgradeViewController alloc]initWithNibName:@"PDUpgradeViewController" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:pdUpgradeView];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
       }
    }
    
    else if ([[[self.tblItems objectAtIndex:indexPath.row]objectForKey:TITLE]isEqualToString:FEEDBACK])
    {
        NSMutableString *htmlString = [[NSMutableString alloc] init];
        [htmlString appendString:@"<html>"];
        [htmlString appendString:@"<body>"];
        [htmlString appendString:@"I’ve started using Playdate by JAGO, an awesome app to arrange & manage my kids social lives.  Check it out and get your download here <a href='http://www.jago.nu'>www.jago.nu</a>"];
        [htmlString appendString:@"</body>"];
        [htmlString appendString:@"</html>"];

        
       MFMailComposeViewController  *myMailViewController = [[MFMailComposeViewController alloc] init];
        
        if([MFMailComposeViewController canSendMail])
        {
        myMailViewController.mailComposeDelegate = self;
        [myMailViewController setMessageBody:htmlString isHTML:YES];
    
      //  [myMailViewController.navigationBar setTintColor:[UIColor whiteColor]];
        [myMailViewController setToRecipients:@[@"jagoapps@gmail.com"]];
        [myMailViewController setSubject:@"Playdate Feedback"];

        [[PDAppDelegate sharedDelegate].navigationController presentViewController:myMailViewController animated:YES completion:nil];
        }
    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE]isEqualToString:SETS])
    {
        PDSetsViewController *pdSetsViewController = [[PDSetsViewController alloc]initWithNibName:@"PDSetsViewController" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:pdSetsViewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE]isEqualToString:FRIENDS])
    {
        
        PDContactlistVC *objPDContactlistVC=[[PDContactlistVC alloc]initWithNibName:@"PDContactlistVC" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:objPDContactlistVC];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        
        
        
//        PDFriendListViewController *pdFriendListViewController = [[PDFriendListViewController alloc]initWithNibName:@"PDFriendListViewController" bundle:nil];
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        NSArray *controllers = [NSArray arrayWithObject:pdFriendListViewController];
//        navigationController.viewControllers = controllers;
//        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    else if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE]isEqualToString:CHAT])
    {
        PDChatListVC *pdPDChatListVC = [[PDChatListVC alloc]initWithNibName:@"PDChatListVC" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:pdPDChatListVC];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }

    else if ([[[self.tblItems objectAtIndex:indexPath.row] objectForKey:TITLE]isEqualToString:RESTORE])
    {
        

        
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
        [self performSelector:@selector(btnActivity_Purchase) withObject:self afterDelay:0.1];

//        PDExtentedPermissions *objPDExtentedPermissions=[[PDExtentedPermissions alloc]initWithNibName:@"PDExtentedPermissions" bundle:nil];
//        
//        
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        NSArray *controllers = [NSArray arrayWithObject:objPDExtentedPermissions];
//        navigationController.viewControllers = controllers;
//        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)btnActivity_Purchase
{
    
    //   [[PDAppDelegate sharedDelegate].recipeProducts restoreLastTrasanction];
    
    if ( [PDAppDelegate sharedDelegate].allProducts.count==0 )
    {
        
        
        [PDAppDelegate sharedDelegate].recipeProducts  = [RecipeProducts sharedInstance];
        [[PDAppDelegate sharedDelegate].recipeProducts  initialize];
        
        [[PDAppDelegate sharedDelegate].recipeProducts  setDelegate:self];
        [PDAppDelegate sharedDelegate].recipeProducts.controller = self;
        
        if ([PDAppDelegate sharedDelegate].recipeProducts.products == nil)
            [[PDAppDelegate sharedDelegate].recipeProducts  requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
             {
                 if (success)
                 {
                     [PDAppDelegate sharedDelegate].allProducts = products;
                  
                     [[PDAppDelegate sharedDelegate].recipeProducts restoreLastTrasanction];
                    
                     
                 }
                 else
                 {
                     UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Please wait While Product is loaded" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                     [[PDAppDelegate sharedDelegate]hideActivity];
                 }
             }];
    }
    
    else
    {
        [[PDAppDelegate sharedDelegate].recipeProducts restoreLastTrasanction];
    }
}
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        
        if ([@"There is no product purchased by you."isEqualToString:alertView.message]) {
            
        }
        else
        {
          [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"com.jagoapps.playdate.exchangechilds"];
        PDExtentedPermissions *objPDExtentedPermissions = [[PDExtentedPermissions alloc]initWithNibName:@"PDExtentedPermissions" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:objPDExtentedPermissions];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
            [[PDAppDelegate sharedDelegate] hideActivity];
    }
}

-(void)didFinishWithTransaction:(SKPaymentTransaction *)transaction
{
    
    [[PDAppDelegate sharedDelegate] hideActivity];
    
    PDExtentedPermissions *objPDExtentedPermissions = [[PDExtentedPermissions alloc]initWithNibName:@"PDExtentedPermissions" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:objPDExtentedPermissions];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
    
    
    //    PDExtentedPermissions *objPDExtentedPermissions=[[PDExtentedPermissions alloc]initWithNibName:@"PDExtentedPermissions" bundle:nil];
    //    [self.navigationController pushViewController:objPDExtentedPermissions animated:YES];
    
    
}
-(void)didFailWithError:(NSError *)error transaction:(SKPaymentTransaction *)transaction
{
    [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"error while purchasing please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    [[PDAppDelegate sharedDelegate] hideActivity];
}
@end
