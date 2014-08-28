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
@interface PDNotificationListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tableVwList;
    NSArray *arrTableData;
}
@end

@implementation PDNotificationListVC

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
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(callWebServices) withObject:nil afterDelay:0.1];
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
            if ([subView isKindOfClass:[UIView class]]) {
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
-(void)callWebServices
{
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    
    NSDictionary *params = @{PDWebGID: strGid};
    //   NSDictionary *params = @{PDWebGID: @"46"};
    
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
                 arrTableData=[response valueForKey:@"data"];
                 [tableVwList reloadData];
              

             }
         }
         else
         {
             NSLog(@"%@",error.description);
       
         }
         
         [[PDAppDelegate sharedDelegate]hideActivity];
         
     }];
}
#pragma mark - Table View Datasources & Delegates
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
 
  cell.textLabel.font=[[PDHelper sharedHelper]applicationFontWithSize:15.0];
  cell.textLabel.text=[arrTableData objectAtIndex:indexPath.row];
  cell.textLabel.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
    UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    vw.backgroundColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
    [cell addSubview:vw];
   return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
@end
