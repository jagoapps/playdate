//
//  PDFriendListViewController.m
//  PlayDate
//
//  Created by Simpy on 18/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDFriendListViewController.h"
#import "UIImageView+WebCache.h"
#import "PDProfileViewController.h"
#import "PDCalenderViewController.h"
#import "PDMainViewController.h"
#import "PDRequestArrangeViewController.h"
#import "UIImageView+WebCache.h"
@interface PDFriendListViewController ()
{
    IBOutlet UITableView *tblView;
    IBOutlet UIImageView *imgVwTop;
    IBOutlet UIButton *btnArrange;
    IBOutlet UIButton *btnCalender;

    IBOutlet UIButton *btnMenu;
    IBOutlet UIButton *btnHome;
    IBOutlet UIView *topMenuView;
    
}
-(IBAction)menuArrange:(id)sender;
-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;
@end

@implementation PDFriendListViewController


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
    
    
    
    tblView.backgroundColor=[UIColor clearColor];
    tblView.backgroundView=nil;
    tblView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self setUpViewContents];
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    
    if (self.fromSet)
    {
    imgVwTop.image=[UIImage imageNamed:@"navigation_blank"];
    btnArrange.hidden=YES;
    btnCalender.hidden=YES;
    btnMenu.hidden=YES;
    btnHome.hidden=YES;
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(5, 6, 31, 31);
    [btnBack setImage:[UIImage imageNamed:@"back_blank"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [topMenuView addSubview:btnBack];
    }

    if ([self.strSet_Id length]==0)
       [self performSelector:@selector(callWebServices) withObject:nil afterDelay:0.1];
    
   else
  [self performSelector:@selector(callWebServices_detailSet) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- TablView DataSource Delegate Methods

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ friendDetailArray count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    for (UIView *subView in [cell.contentView subviews])
         [subView removeFromSuperview];
    
   

    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 200, 60)];
    lblName.text = [[NSString stringWithFormat:@"%@", [[[friendDetailArray objectAtIndex:indexPath.row] valueForKey:@"friendinfo"]valueForKey:@"name"]] uppercaseString];
    lblName.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    lblName.font =[[PDHelper sharedHelper] applicationFontWithSize:14.0];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 5.0, 60.0,60.0)];
    NSURL *url = [[[friendDetailArray objectAtIndex:indexPath.row] valueForKey:@"friendinfo"]valueForKey:@"profile_image"];
    NSLog(@"%@",url);
    
    if (url == nil)
        [imgView setImage:[UIImage imageNamed:@"user_img"]];
    
    else
        [imgView setImageWithURL:url];
    
    
   
    [cell.contentView addSubview:lblName];
    [cell.contentView addSubview:imgView];
     cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(0, 69.0, 320, 1)];
    vw.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255 blue:170.0/255 alpha:0.36];
    [cell.contentView addSubview:vw];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   PDProfileViewController *profileViewController = [[PDProfileViewController alloc]initWithNibName:@"PDProfileViewController" bundle:nil];
    profileViewController.friendProfileArray = [friendDetailArray objectAtIndex:indexPath.row];
    profileViewController.str_Parent_gid=[[[friendDetailArray objectAtIndex:indexPath.row]objectForKey:@"friendinfo"]objectForKey:@"g_id"];
    profileViewController.isFromSets = YES;
    [self.navigationController pushViewController:profileViewController animated:YES];
    
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

#pragma mark - Button Actions
-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
        
        
    }];
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
#pragma marks method
-(void)callWebServices_detailSet
{
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];

    NSDictionary *params = @{PDWebSetID: self.strSet_Id,@"friend_fbid":self.strFacebook_Ids,@"guardian_id":strGid};
    

    [[PDWebHandler sharedWebHandler]slectedSet_ViewListParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
      {
          id result = response;
          
          if (result==nil) {
              
              [[PDAppDelegate sharedDelegate]hideActivity];
 
              return;
          }
          NSString *strval = [NSString stringWithString: [result valueForKey:@"msg"]];
          NSLog(@"%@",strval);
          if ([[response valueForKey:PDWebData] isKindOfClass:[NSNull class]])
          {
              NSLog(@"%@",error.description);
          }
          else
          {
              NSLog(@"%@",[response valueForKey:PDWebData]);
              friendDetailArray = [response valueForKey:PDWebData];
              [tblView reloadData];
          }
          
          [[PDAppDelegate sharedDelegate]hideActivity];
      }];
     

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
              friendDetailArray = [response valueForKey:PDWebData];
             [tblView reloadData];
            }
         
         [[PDAppDelegate sharedDelegate]hideActivity];
     }];
}

@end
