//
//  PDNotificationListVC.m
//  PlayDate
//
//  Created by iApp on 14/08/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDNotificationListVC.h"
#import "PDRequestArrangeViewController.h"
#import "PDMainViewController.h"
#import "PDCalenderViewController.h"
#import "PDSetsViewController.h"
@interface PDNotificationListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tableVwList;
    NSArray *arrTableData;
    NSArray *arrServerNotificationData;
    NSArray *arrDatebasenotificationData;
}
@end

@implementation PDNotificationListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(callWebServices) withObject:nil afterDelay:0.1];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    
    // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];
    
    
    tableVwList.backgroundColor = [UIColor  clearColor];
    tableVwList.backgroundView = nil;
    tableVwList.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        for (UIView *subView in self.view.subviews) {
            if ([subView isKindOfClass:[UIView class]])
            {
                rect = subView.frame;
                rect.origin.y += 20.0;
                subView.frame = rect;
            }
        }
        
        rect = tableVwList.frame;
        rect.size.height -= 20.0;
        tableVwList.frame = rect;
        
    }
    
}
-(void)callWebServices
{
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    
    NSDictionary *params = @{PDWebGID: strGid};
    [[PDWebHandler sharedWebHandler]Notificationlist_ListParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         id result =response;
         NSString *strval=[NSString stringWithFormat:@"%@", [result valueForKey:@"success"]];
         if ([strval integerValue])
         {
             if ([[response valueForKey:@"data"] isKindOfClass:[NSNull class]])
             {}
             else
             {
                 arrServerNotificationData=[response valueForKey:@"data"];
                 arrTableData=arrServerNotificationData;
                 [tableVwList reloadData];
             }
         }
         else
         {
             NSLog(@"%@",error.description);
         }
         
         NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
         for (id obj in   [[Database sharedDatabase]readAllRecords_Notification])  // Fetch id from data base
         {
             NotificationMessage *saveObj=obj;
             [arrTemp addObject:saveObj.messageName];
         }
         
         arrDatebasenotificationData =[arrTemp copy];
         arrTableData=arrDatebasenotificationData;
         [tableVwList reloadData];
         [[PDAppDelegate sharedDelegate]hideActivity];
         
     }];
}
#pragma mark - Table View Datasources & Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(320,CGFLOAT_MAX);
    
    CGSize expectedLabelSize = [[arrTableData objectAtIndex:indexPath.row]
                                sizeWithFont:[UIFont systemFontOfSize:15.0]
                                  constrainedToSize:maximumLabelSize
                                      lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize.height+3.0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrTableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"cellID";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
   if (cell == nil)
   {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
 
    for (UIView *vw in [cell.contentView subviews])
        [vw removeFromSuperview];
    

  cell.textLabel.font=[[PDHelper sharedHelper]applicationFontWithSize:15.0];
  cell.textLabel.numberOfLines=0;
  cell.textLabel.text=[arrTableData objectAtIndex:indexPath.row];
  CGSize maximumLabelSize = CGSizeMake(320,CGFLOAT_MAX);
    
  CGSize expectedLabelSize = [[arrTableData objectAtIndex:indexPath.row]
                                sizeWithFont:[[PDHelper sharedHelper]applicationFontWithSize:15.0]
                                constrainedToSize:maximumLabelSize
                                lineBreakMode:NSLineBreakByWordWrapping];
    
  
  [cell.textLabel sizeToFit];
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
  UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(0, expectedLabelSize.height+2.6, 320, 0.5)];
  vw.backgroundColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
  [cell addSubview:vw];
  
   return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if ([[arrTableData objectAtIndex:indexPath.row]isEqualToString:@"Playdate Requested"]||[[arrTableData objectAtIndex:indexPath.row]isEqualToString:@"Playdate Accepted"]||[[arrTableData objectAtIndex:indexPath.row]isEqualToString:@"Playdate Updated"]||[[arrTableData objectAtIndex:indexPath.row]isEqualToString:@"Playdate Rejected"])
    {
        PDMainViewController *mainViewController = [[PDMainViewController alloc] initWithNibName:@"PDMainViewController" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:mainViewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

    }
    else if ([[arrTableData objectAtIndex:indexPath.row]isEqualToString:@"Set updated"]||[[arrTableData objectAtIndex:indexPath.row]isEqualToString:@"Child added to your  profile"])
     {
         PDSetsViewController *pdSetsViewController = [[PDSetsViewController alloc]initWithNibName:@"PDSetsViewController" bundle:nil];
         UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
         NSArray *controllers = [NSArray arrayWithObject:pdSetsViewController];
         navigationController.viewControllers = controllers;
         [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

            
     }
}

#pragma mark iboutlets
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
-(IBAction)SegmentAction:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
      arrTableData=arrDatebasenotificationData;
  else
      arrTableData=arrServerNotificationData;

    
    [tableVwList reloadData];

}
@end
