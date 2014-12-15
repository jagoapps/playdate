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
#import "PDRequestEditViewController.h"
#import "GAI.h"
@interface PDMainViewController ()
{
    NSArray *arrTableData;
    id<GAITracker> tracker;
    IBOutlet UIView  *vwCustomMessage;
    IBOutlet UITextView *txtVw1CustomMessage;
    IBOutlet UITextView *txtVw2CustomMessage;
    IBOutlet UITextView *txtVw3CustomMessage;
    IBOutlet UITextView *txtVw4CustomMessage;
    IBOutlet UIScrollView *scrollVwCustomMessage;

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

    [[txtVw2CustomMessage layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[txtVw2CustomMessage layer] setBorderWidth:3.0];
    [[txtVw2CustomMessage layer] setCornerRadius:0];

   
    [[txtVw3CustomMessage layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[txtVw3CustomMessage layer] setBorderWidth:3.0];
    [[txtVw3CustomMessage layer] setCornerRadius:0];
 
    [[txtVw4CustomMessage layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[txtVw4CustomMessage layer] setBorderWidth:3.0];
    [[txtVw4CustomMessage layer] setCornerRadius:0];

    
    
   vwCustomMessage .hidden=YES;

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


[[PDWebHandler sharedWebHandler]getEventRequestListParams:params];

[[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
 {
      vwCustomMessage .hidden=NO;
     id result =response;
     NSString *strval=[NSString stringWithString: [result valueForKey:PDWebMessage]];
     
     if ([strval isEqualToString:@"success"])
     {
       if ([[response valueForKey:@"data"] isKindOfClass:[NSNull class]])
        {}
           else
          {
              
           arrTableData=[response valueForKey:@"data"];
              if ([arrTableData count]>0)
              {
                  vwCustomMessage .hidden=YES;
              
                [tblVwEventRequstList reloadData];
              }
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
-(void)tapGesture_Action :(UITapGestureRecognizer *)gesture
{
    [gesture.view removeFromSuperview];
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
       
        rect = tblVwEventRequstList.frame;
        rect.size.height -= 20.0;
        tblVwEventRequstList.frame = rect;
        
    }
    
}
#pragma  mark -TableView  delegate
#pragma  mark -TableView  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return  [arrTableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 131.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DetailOfEventVC *objDetailOfEventVC=[[DetailOfEventVC alloc]initWithNibName:@"DetailOfEventVC" bundle:nil];
    objDetailOfEventVC.dictSlected_EventInfo=[arrTableData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objDetailOfEventVC animated:YES];

//    PDRequestEditViewController  *objPDRequestEditViewController=[[PDRequestEditViewController alloc]initWithNibName:@"PDRequestEditViewController" bundle:nil];
//    
//       objPDRequestEditViewController.dictEventInfo_edit=[arrTableData objectAtIndex:indexPath.row];
// 
//    [self.navigationController pushViewController:objPDRequestEditViewController animated:YES];
    
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
    cell.vwGrayBg.layer.shadowRadius=2;
    cell.vwGrayBg.layer.borderWidth=2;
    cell.vwGrayBg.layer.borderColor=(__bridge CGColorRef)([UIColor grayColor]);
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[[PDHelper sharedHelper]applicationBackgroundColor];
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
    [df setDateFormat:@"dd"];
    NSString *strDay= [df stringFromDate:date];
    [df setDateFormat:@"MMMM"];
    NSString *strMonth= [df stringFromDate:date];
    [df setDateFormat:@"yyyy"];
    NSString *strYear= [df stringFromDate:date];
    
    
    
    
    
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
       [gregorian setFirstWeekday:1]; // Sunday == 1, Saturday == 7
        NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
    
       NSString *strWeekDay;
    
        NSLog(@"Day %lu",(unsigned long)adjustedWeekdayOrdinal);
       if (adjustedWeekdayOrdinal==1)
        strWeekDay=@"Sunday";
    
      else  if (adjustedWeekdayOrdinal==2)
          strWeekDay=@"Monday";
       else  if (adjustedWeekdayOrdinal==3)
           strWeekDay=@"Tuesday";
        else  if (adjustedWeekdayOrdinal==4)
            strWeekDay=@"Wednesday";
        else  if (adjustedWeekdayOrdinal==5)
                 strWeekDay=@"Thrusday";
        else  if (adjustedWeekdayOrdinal==6)
                 strWeekDay=@"Friday";
      else  if (adjustedWeekdayOrdinal==7)
         strWeekDay=@"Saturday";
    
      cell.lblDate.text=[NSString stringWithFormat:@"%@ %@ %@,%@",strWeekDay,strMonth,strDay,strYear];
    

    
 
    [cell.imgVwChild setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"profile_image"]];
    [cell.imgVwFriend setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"friend_profile_image"]placeholderImage:[UIImage imageNamed:@"user_img"]];
    [cell.imgVwParent setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"parent_profile_image"] placeholderImage:[UIImage imageNamed:@"user_img"]];
    
    NSString *strStatus=[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"status"];
    
    if ([strStatus isEqualToString:@"accepted"]||[strStatus isEqualToString:@"now"])
    {
        cell.lblStatus.textColor=[UIColor colorWithRed:127.0/255.0 green:206.0/255.0 blue:49.0/255.0 alpha:1.0];
        cell.vwStaus.backgroundColor=[UIColor colorWithRed:127.0/255.0 green:206.0/255.0 blue:49.0/255.0 alpha:1.0];

    }
    else  if ([strStatus isEqualToString:@"pending"]) {
        cell.lblStatus.textColor=[UIColor colorWithRed:145.0/255.0 green:49.0/255.0 blue:206.0/255.0 alpha:1.0];
        cell.vwStaus.backgroundColor=[UIColor colorWithRed:145.0/255.0 green:49.0/255.0 blue:206.0/255.0 alpha:1.0];

    }
    else
    {   cell.lblStatus.textColor=[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        
    }
    cell.vwStaus.layer.cornerRadius=10;
    cell.vwStaus.clipsToBounds=YES;
    
    cell.lblStatus.text=[strStatus uppercaseString];
    
    
    
    return cell;
    
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//
//{
//    return  [arrTableData count];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray *arrAllfriendChild_Temp=[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"finfo"];
//    
//    BOOL valueAccepted=0;
//    BOOL valuePanding=0;
//
//    for (int i=0; i<[arrAllfriendChild_Temp count]; i++)
//    {
//     
//    if([@"accepted"isEqualToString:[[arrAllfriendChild_Temp objectAtIndex:i]valueForKey:@"friend_status"]])
//        valueAccepted=1;
//    
//    if ([@"pending"isEqualToString:[[arrAllfriendChild_Temp objectAtIndex:i]valueForKey:@"friend_status"]])
//        valuePanding=1;
//    }
//
//    if (valueAccepted==1&&valuePanding==1)
//        return 258.0;
//
//    else
//        return 160+35.0;
//    
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    DetailOfEventVC  *objDetailOfEventVC=[[DetailOfEventVC alloc]initWithNibName:@"DetailOfEventVC" bundle:nil];
//    objDetailOfEventVC.dictSlected_EventInfo=[arrTableData objectAtIndex:indexPath.row];
//    objDetailOfEventVC.fromCalendar=NO;
//    [self.navigationController pushViewController:objDetailOfEventVC animated:YES];
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *cellStr=@"Cell";
//    CustomCellProfilePage *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
//    
//    if (cell == nil)
//    {
//        NSArray *top = [[NSBundle mainBundle] loadNibNamed:@"CustomCellProfilePage" owner:self options:nil];
//        for (id t in top)
//        {
//            if ([t isKindOfClass:[UITableViewCell class]])
//            {
//                cell =(CustomCellProfilePage*)t;
//                break;
//            }
//        }
//    }
//    
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.backgroundColor=[UIColor clearColor];
//    cell.lblNameChild.text=[[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"child_name"] uppercaseString];
//    cell.lblNameFriend.text=[[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"friendname"] uppercaseString];
//    UIImage *imgPlaceHolder=[UIImage imageNamed:@"user_img"];
//
//   NSArray *arrAllfriendChild_Temp=[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"finfo"];
//    
//    int xCordinateImagVWAccepted=0;
//    int xCordinateLabelAccepted=0;
//    
//    int xCordinateImagVWPending=0;
//    int xCordinateLabelPending=0;
//    
//    BOOL checkForAccepted=0;
//    BOOL checkForPending=0;
//    for (int i=0; i<[arrAllfriendChild_Temp count]; i++)
//    {
//        if ([@"accepted" isEqualToString:[[arrAllfriendChild_Temp objectAtIndex:i]valueForKey:@"friend_status"]])
//        {
//           
//
//            UIImageView *imgvwTemp=[[UIImageView alloc]initWithFrame:CGRectMake(xCordinateImagVWAccepted, 2, 40, 40)];
//            [imgvwTemp setImageWithURL:[[arrAllfriendChild_Temp objectAtIndex:i]valueForKey:@"friend_profile_image"] placeholderImage:imgPlaceHolder];
//            
//            UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(xCordinateLabelAccepted, 42, 40, 24)];
//            lblName.font=[UIFont fontWithName:@"GillSans" size:11.0];
//            lblName.text=[[arrAllfriendChild_Temp objectAtIndex:i]valueForKey:@"friendname"];
//            lblName.textColor=[UIColor blackColor];
//            lblName.textAlignment=NSTextAlignmentCenter;
//            
//            [cell.scrollVwAccepted addSubview:imgvwTemp];
//            [cell.scrollVwAccepted addSubview:lblName];
//            [cell.scrollVwAccepted setContentSize:CGSizeMake(xCordinateLabelAccepted, 60)];
//           
//            xCordinateImagVWAccepted=xCordinateImagVWAccepted+41+8;
//            xCordinateLabelAccepted=xCordinateLabelAccepted+41+8;
//            checkForAccepted=1;
//            
//
//        }
//        if([@"pending" isEqualToString:[[arrAllfriendChild_Temp objectAtIndex:i]valueForKey:@"friend_status"]])
//        {
//            UIImageView *imgvwTemp=[[UIImageView alloc]initWithFrame:CGRectMake(xCordinateImagVWPending, 2, 40, 40)];
//            [imgvwTemp setImageWithURL:[[arrAllfriendChild_Temp objectAtIndex:i]valueForKey:@"friend_profile_image"] placeholderImage:imgPlaceHolder];
//            
//            UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(xCordinateLabelPending, 35, 40, 40)];
//            lblName.font=[UIFont fontWithName:@"GillSans" size:11.0];
//            lblName.text=[[arrAllfriendChild_Temp objectAtIndex:i]valueForKey:@"friendname"];
//            lblName.backgroundColor=[UIColor clearColor];
//            lblName.textColor=[UIColor blackColor];
//            lblName.textAlignment=NSTextAlignmentCenter;
//
//
//            [cell.scrollVwPending addSubview:imgvwTemp];
//            [cell.scrollVwPending addSubview:lblName];
//            [cell.scrollVwAccepted setContentSize:CGSizeMake(xCordinateImagVWPending, 60)];
//           
//            xCordinateImagVWPending=xCordinateImagVWPending+41+8;
//            xCordinateLabelPending=xCordinateLabelPending+41+8;
//            checkForPending=1;
//            
//        }
//    }
//     cell.imgVwStatus.image=[UIImage imageNamed:@"accepted"];
//        if (checkForPending==0)
//        {
//            cell.scrollVwPending.hidden=YES;
//            cell.lbltittlePending.hidden=YES;
//           
//        }
//        if (checkForAccepted==0)
//        {
//               cell.imgVwStatus.image=[UIImage imageNamed:@"pending"];
//            cell.scrollVwAccepted.hidden=YES;
//            cell.lbltittleAccepted.hidden=YES;
//            CGRect rect= cell.scrollVwPending.frame;
//            rect.origin.y=95;
//            cell.scrollVwPending.frame=rect;
//            rect=cell.lbltittlePending.frame;
//            rect.origin.y=114;
//            cell.lbltittlePending.frame=rect;
//
//            
//            
//        }
//
//    if (checkForPending==1&&checkForAccepted==1)
//    {
//        
//    }
//    
//    else
//    {
//        CGRect rect= cell.vwDateTime.frame;
//        rect.origin.y=160;
//        
//        cell.vwDateTime.frame=rect;
//    }
//    cell.vwDateTime.backgroundColor=[UIColor lightGrayColor];
//    cell.lblNameParent.text=[[NSString stringWithFormat:@"%@",[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"name"]]uppercaseString];
//    cell.lblNameChild.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
//    cell.lblNameFriend.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
//    cell.lblNameParent.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
//    cell.lblTopStatus.textColor=[[PDHelper sharedHelper]applicationThemeBlueColor];
//  
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
////    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
////    [df setTimeZone:[NSTimeZone systemTimeZone]];
//    [df setDateFormat:@"HH:mm"];
//    
//
//    
//    
//   
//    NSDate* newDateStart=[df dateFromString:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"Starttime"]];
//    [df setDateFormat:@"hh:mm a"];
//    NSString  *startTime = [df stringFromDate:newDateStart];
//   
//    [df setDateFormat:@"HH:mm"];
//    NSDate* newDateEnd = [df dateFromString:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"endtime"]];
//    [df setDateFormat:@"hh:mm a"];
//    NSString  *endTime = [df stringFromDate:newDateEnd];
//
//    
//    
////    cell.lblTime.text=[[NSString stringWithFormat:@"%@-%@", [[arrTableData objectAtIndex:indexPath.row]valueForKey:@"Starttime"],[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"endtime"] ]uppercaseString];
//    
//    cell.lblTime.text=[[NSString stringWithFormat:@"%@-%@", startTime,endTime] uppercaseString];
// 
//    
//    cell.lblTime.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    
//     [df setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [df dateFromString:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"date"]];
//    [df setDateFormat:@"dd"];
//    NSString *strDay= [df stringFromDate:date];
//      [df setDateFormat:@"MMMM"];
//    NSString *strMonth= [df stringFromDate:date];
//    [df setDateFormat:@"yyyy"];
//    NSString *strYear= [df stringFromDate:date];
//
//
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    [gregorian setFirstWeekday:1]; // Sunday == 1, Saturday == 7
//    NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
//
//    NSString *strWeekDay;
//    
//    NSLog(@"Day %lu",(unsigned long)adjustedWeekdayOrdinal);
//    if (adjustedWeekdayOrdinal==1)
//      strWeekDay=@"Sunday";
//    
//    else  if (adjustedWeekdayOrdinal==2)
//       strWeekDay=@"Monday";
//    else  if (adjustedWeekdayOrdinal==3)
//        strWeekDay=@"Tuesday";
//    else  if (adjustedWeekdayOrdinal==4)
//            strWeekDay=@"Wednesday";
//    else  if (adjustedWeekdayOrdinal==5)
//               strWeekDay=@"Thrusday";
//    else  if (adjustedWeekdayOrdinal==6)
//              strWeekDay=@"Friday";
//    else  if (adjustedWeekdayOrdinal==7)
//       strWeekDay=@"Saturday";
// 
//    cell.lblDate.text=[NSString stringWithFormat:@"%@ %@ %@ %@",strWeekDay,strMonth,strDay,strYear];
//    
// 
//    [cell.imgVwChild setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"profile_image"] placeholderImage:imgPlaceHolder];
//   
//    
////    if ([[arrTableData objectAtIndex:indexPath.row]valueForKey:@"profile_image"]==nil)
//        [cell.imgVwFriend setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"friend_profile_image"] placeholderImage:imgPlaceHolder];
////    if ([[arrTableData objectAtIndex:indexPath.row]valueForKey:@"friend_profile_image"]==nil)
////        cell.imgVwFriend.image=imgPlaceHolder;
//
//    [cell.imgVwParent setImageWithURL:[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"parent_profile_image"] placeholderImage:imgPlaceHolder];
//    
////    if ([[arrTableData objectAtIndex:indexPath.row]valueForKey:@"parent_profile_image"]==nil)
////        cell.imgVwParent.image=imgPlaceHolder;
//    
//    
//
//    NSString *strStatus=[[arrTableData objectAtIndex:indexPath.row]valueForKey:@"status"];
//
////          if ([strStatus isEqualToString:@"accepted"]) {
////        cell.imgVwStatus.image=[UIImage imageNamed:@"accepted"];
////        cell.lblStatus.textColor=[UIColor colorWithRed:127.0/255.0 green:206.0/255.0 blue:49.0/255.0 alpha:1.0];
////    }
////    else  if ([strStatus isEqualToString:@"pending"])
////    {
////        cell.imgVwStatus.image=[UIImage imageNamed:@"pending"];
////        cell.lblStatus.textColor=[UIColor colorWithRed:145.0/255.0 green:49.0/255.0 blue:206.0/255.0 alpha:1.0];
////
////    }
////    else
////    {   cell.lblStatus.textColor=[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
////
////    }
//    cell.lblStatus.text=[strStatus uppercaseString];
//  
//    
//    
//    return cell;
//
//}
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
