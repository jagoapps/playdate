//
//  PDChatListVC.m
//  PlayDate
//
//  Created by iApp on 25/08/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDChatListVC.h"
#import "PDRequestArrangeViewController.h"
#import "PDCalenderViewController.h"
#import "PDMainViewController.h"
#import "UIImageView+WebCache.h"
#import "PDChatData.h"

@interface PDChatListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet  UITableView *tableVw;
    NSArray *arrTableData;
    NSArray *allFriendDetailArray;
    NSMutableArray *recentFriendDetailArray;
    NSMutableArray *arrJabberId;
}
-(IBAction)menuArrange:(id)sender;
-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;
-(IBAction)menuAction:(id)sender;
-(IBAction)SegmentAction:(id)sender;
@end

@implementation PDChatListVC

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
    [self setUpViewContents];
    tableVw.backgroundColor = [UIColor  clearColor];
    tableVw.backgroundView = nil;
    tableVw.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
   [self performSelector:@selector(allFriends_WebServices) withObject:nil afterDelay:0.1];
    segmentControl.selectedSegmentIndex = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark self methods
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
        
        //        rect = tblVwEventRequstList.frame;
        //        rect.size.height -= 20.0;
        //        tblVwEventRequstList.frame = rect;
        
    }
    
}
-(void)allFriends_WebServices
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
    if (str.length > 0)
    {
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
             allFriendDetailArray = [response valueForKey:PDWebData];
           //  [tableVw reloadData];
             [self SegmentAction:0];
         }
         
         [[PDAppDelegate sharedDelegate]hideActivity];
     }];
}
#pragma mark - Table View Datasources & Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recentFriendDetailArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    lblName.text = [[NSString stringWithFormat:@"%@", [[[recentFriendDetailArray objectAtIndex:indexPath.row] valueForKey:@"friendinfo"]valueForKey:@"name"]] uppercaseString];
    lblName.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    lblName.font =[[PDHelper sharedHelper] applicationFontWithSize:14.0];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 5.0, 60.0,60.0)];
    NSURL *url = [[[recentFriendDetailArray objectAtIndex:indexPath.row] valueForKey:@"friendinfo"]valueForKey:@"profile_image"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDChatData *objPDChatData=[[PDChatData alloc]initWithNibName:@"PDChatData" bundle:nil];
    objPDChatData.jabber_id = [[[recentFriendDetailArray objectAtIndex:indexPath.row] valueForKey:@"friendinfo"]valueForKey:@"ejabber_user"];
    objPDChatData.receiverName=[[[recentFriendDetailArray objectAtIndex:indexPath.row] valueForKey:@"friendinfo"]valueForKey:@"name"];
    // jabber id send
    
    

    [self.navigationController pushViewController:objPDChatData animated:YES];
}

#pragma mark iboutlets
-(IBAction)SegmentAction:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        recentFriendDetailArray = nil;
        recentFriendDetailArray = [[NSMutableArray alloc]init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults objectForKey:@"g_id"];
        for (int i  = 0; i<[allFriendDetailArray count]; i++) {
            id obj = [[[allFriendDetailArray objectAtIndex:i] valueForKey:@"friendinfo"]valueForKey:@"g_id"];
            if ([array containsObject:obj]) {
                [recentFriendDetailArray addObject:[allFriendDetailArray objectAtIndex:i]];
            }
        }
        [tableVw reloadData];
    }
    else
    {
        recentFriendDetailArray = nil;
        recentFriendDetailArray = [[[NSMutableArray alloc]initWithArray:allFriendDetailArray] mutableCopy];
        [tableVw reloadData];
 
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
-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

@end
