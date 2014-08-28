//
//  PDMainViewController.m
//  PlayDate
//
//  Created by Vakul on 01/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDMainViewController.h"
#import "UIImageView+WebCache.h"
#import "DetailOfEventVC.h"
#import "PDRequestArrangeViewController.h"
#import "PDCalenderViewController.h"

#import "GAI.h"
@interface PDMainViewController ()
{
    NSArray *arrTableData;
    id<GAITracker> tracker;
}

@property (strong, nonatomic) IBOutlet UIView *topMenuView;

-(void)setUpViewContents;

-(IBAction)menuAction:(id)sender;
-(IBAction)menuArrange:(id)sender;
-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;

@end

@implementation PDMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"PDMainViewController";
}
-(void)viewDidAppear:(BOOL)animated
{
    
       if ([[PDUser currentUser] hasDetail])
    {
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
        [self performSelector:@selector(callWebServices) withObject:nil afterDelay:0.1];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
 tracker = [[GAI sharedInstance] defaultTracker];
    
    
    [tracker setAllowIDFACollection:YES];
    
    // Do any additional setup after loading the view.
    
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    
      // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];
    
    
    tblVwEventRequstList.backgroundColor = [UIColor  clearColor];
    tblVwEventRequstList.backgroundView = nil;
    tblVwEventRequstList.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(void)callWebServices
{
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];

   NSDictionary *params = @{PDWebGID: strGid};
  //   NSDictionary *params = @{PDWebGID: @"46"};

[[PDWebHandler sharedWebHandler]getEventRequestListParams:params];

[[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
 {
     
     id result =response;
     NSString *strval=[NSString stringWithString: [result valueForKey:PDWebMessage]];
     
     if ([strval isEqualToString:@"success"])
     {
       if ([[response valueForKey:@"data"] isKindOfClass:[NSNull class]])
        {}
           else
          {
           arrTableData=[response valueForKey:@"data"];
           [tblVwEventRequstList reloadData];
          }
     }
        else
     {
         NSLog(@"%@",error.description);
     }
     
     [[PDAppDelegate sharedDelegate]hideActivity];
     
 }];
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
       
        rect = tblVwEventRequstList.frame;
        rect.size.height -= 20.0;
        tblVwEventRequstList.frame = rect;
        
    }
    
}
#pragma  mark -TableView  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return  [arrTableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailOfEventVC  *objDetailOfEventVC=[[DetailOfEventVC alloc]initWithNibName:@"DetailOfEventVC" bundle:nil];
    objDetailOfEventVC.dictSlected_EventInfo=[arrTableData objectAtIndex:indexPath.row];
    objDetailOfEventVC.fromCalendar=NO;
    [self.navigationController pushViewController:objDetailOfEventVC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellStr=@"Cell";
    CustomCellProfilePage *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil)
    {
        NSArray *top = [[NSBundle mainBundle] loadNibNamed:@"CustomCellProfilePage" owner:self options:nil];
        for (id t in top)
        {
            if ([t isKindOfClass:[UITableViewCell class]])
            {
                cell =(CustomCellProfilePage*)t;
                break;
            }
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    cell.lblNameChild.text=[[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"child_name"] uppercaseString];
    cell.lblNameFriend.text=[[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"friendname"] uppercaseString];
    cell.lblNameParent.text=[[NSString stringWithFormat:@"%@", [[arrTableData objectAtIndex:indexPath.row]valueForKey:@"name"]] uppercaseString];
    cell.lblNameChild.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
    cell.lblNameFriend.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
    cell.lblNameParent.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];

    
    cell.lblTime.text=[[NSString stringWithFormat:@"%@-%@", [[arrTableData objectAtIndex:indexPath.row]valueForKey:@"Starttime"],[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"endtime"] ]uppercaseString];
    cell.lblTime.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"date"]];
    [df setDateFormat:@"dd-MM-YYY"];
    NSString *strDate= [df stringFromDate:date];
    
    
    
    
    cell.lblDate.text=strDate;
    [cell.imgVwChild setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"profile_image"]];
    [cell.imgVwFriend setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"friend_profile_image"]];
    [cell.imgVwParent setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"parent_profile_image"]];

    NSString *strStatus=[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"status"];

          if ([strStatus isEqualToString:@"accepted"]||[strStatus isEqualToString:@"now"]) {
        cell.lblStatus.textColor=[UIColor colorWithRed:127.0/255.0 green:206.0/255.0 blue:49.0/255.0 alpha:1.0];
    }
    else  if ([strStatus isEqualToString:@"pending"]) {
        cell.lblStatus.textColor=[UIColor colorWithRed:145.0/255.0 green:49.0/255.0 blue:206.0/255.0 alpha:1.0];

    }
    else
    {   cell.lblStatus.textColor=[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];

    }
    cell.lblStatus.text=[strStatus uppercaseString];

    
    
    return cell;

}
#pragma mark - Button Actions
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

@end
