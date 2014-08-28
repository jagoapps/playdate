//
//  PDCalenderViewController.m
//  PlayDate
//
//  Created by Simpy on 12/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDCalenderViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIImageView+WebCache.h"
#import "DetailOfEventVC.h"
#import "PDMainViewController.h"
#import "PDRequestArrangeViewController.h"
#import <EventKit/EventKit.h>


@interface PDCalenderViewController ()<UITableViewDataSource, UITableViewDelegate,CKCalendarDelegate>
{
 
    NSDictionary *dictAllData;
    NSArray *arrAllData;
    NSMutableArray    *arrTbleData;
    IBOutlet UITableView *tblView;
    NSArray              *markDateArray;
   
    IBOutlet UIView *eventContainer;
    UIActivityIndicatorView *activityIndicator;
    NSString *strMothshowImageonCalender;
    int varhideActivity;
    int varCalenderSlect;
}

@property(nonatomic, strong) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSMutableArray *serverEventDates;
@property(nonatomic, strong) NSMutableArray *iosCalenderEventDates;
@property(nonatomic, strong) NSMutableArray *arrAllEventDates;




-(IBAction)menuArrange:(id)sender;
-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;


-(void)setUpViewContents;

@end

@implementation PDCalenderViewController

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
    
    varCalenderSlect=0;
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    activityIndicator.center = self.view.center;
   
     // Do any additional setup after loading the view from its nib.
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.view.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor;
    tblView.backgroundColor=[UIColor clearColor];
    tblView.backgroundView=nil;
    tblView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.dateFormatter setDateFormat:@"MM"];
    
    strMothshowImageonCalender=  [NSString stringWithFormat:@"%ld",(long)[[self.dateFormatter stringFromDate:[NSDate date]]integerValue]];

      [self setUpViewContents];
   if ([[PDUser currentUser] hasDetail])
    {
         varhideActivity=0;
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading  Calender..."];
        [self performSelector:@selector(callWebServices) withObject:nil afterDelay:0.1];
    }

    eventContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    eventContainer.layer.shadowOffset = CGSizeMake(-1.0, -1.0);
    eventContainer.layer.shadowOpacity = 0.8;
    eventContainer.layer.shadowRadius = 2.0;
   
}

-(void)viewDidAppear:(BOOL)animated
{
    
   
}


-(void)callWebServices
{
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    
    NSDictionary *params = @{PDWebGID: strGid,PDWebStatus:PDWebAccepted};
    //NSDictionary *params = @{PDWebGID: @"46"};
    
    
    //http://112.196.34.179/playdate/eventaccept_date_time.php?g_id=47&status=accepted

    [[PDWebHandler sharedWebHandler]event_Accepted_ForCalander:params];
    
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         
         id result =response;
         NSString *strval=[NSString stringWithString: [result valueForKey:PDWebSuccess]];
         if ([strval isEqualToString:@"1"])
         {
             
            dictAllData=[response valueForKey:@"data"];
             if (![dictAllData isKindOfClass:[NSDictionary class]])
             {
                 dictAllData =  nil;
             }
       }
        else
        {
             NSLog(@"%@",error.description);
        }
         
     [self setUpCalendarView];
         
    }];
}

-(void)setUpCalendarView
{
    
    self.serverEventDates=nil;
    self.serverEventDates = [[NSMutableArray alloc]init];
    // Server Events
    
    NSArray *yearKeys = [dictAllData allKeys];
    
    for (NSString *year in yearKeys)
    {
        NSDictionary *monthsDetail = [dictAllData valueForKey:year];
        NSArray *monthKeys = [monthsDetail allKeys];
        for (NSString *month in monthKeys)
        {
            NSArray *events = [monthsDetail objectForKey:month];
            for (id event in events) {
                
                NSMutableDictionary *dict = [(NSMutableDictionary *)event mutableCopy];
                [dict setObject:year forKey:@"year"];
                [dict setObject:month forKey:@"month"];
                [self.serverEventDates addObject:dict];
            }
        }
    }
    
    
    
    
// ios Calender Enents


    self.calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar.delegate = self;
    self.calendar.backgroundColor = [UIColor clearColor];
    //[self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/01/2000"];
    self.calendar.onlyShowCurrentMonth = NO;
    self.calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    self.calendar.frame = CGRectMake(20, 70, 280, 200);
    [self.view addSubview:self.calendar];
    [self.view addSubview: activityIndicator];
    activityIndicator.hidden =YES;

 
    [self Fetch_ios_CalenderEvent:[NSDate date] ];

//  [[PDAppDelegate sharedDelegate] hideActivity];
}

#pragma mark - Methods

-(void)Fetch_ios_CalenderEvent :(NSDate*)Startdate
{
    
    [self AddEvent_IN_iosCalender];

    
    
    NSDate *start =Startdate;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
   // [dateComponents setMonth:1];
    [dateComponents setYear:3];
    NSDate *finish = [gregorian dateByAddingComponents:dateComponents toDate:start  options:0];
    ///////////////ios calender event fetch
    NSDate* currentStart = [NSDate dateWithTimeInterval:0 sinceDate:start];
    int seconds_in_year = 60*60*24*365;
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    self.arrAllEventDates =nil;
    self.arrAllEventDates =[[NSMutableArray alloc]init];
    
      if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 self.iosCalenderEventDates =nil;
                 self.iosCalenderEventDates =[[NSMutableArray alloc]init];
                if ([currentStart compare:finish]==NSOrderedAscending)
                 {
                    NSDate* currentFinish = [NSDate dateWithTimeInterval:seconds_in_year sinceDate:currentStart];
                    if ([currentFinish compare:finish] == NSOrderedDescending)
                     {
                         currentFinish = [NSDate dateWithTimeInterval:0 sinceDate:finish];
                     }
                    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:currentStart endDate:currentFinish calendars:nil];
                    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
                     for (EKEvent *event in events)
                     {
                        
                         NSDate *Sdate =event.startDate ;
                         [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                         NSString *startDatestr= [self.dateFormatter stringFromDate:Sdate];
                         
                         NSDate *Edate =event.endDate ;
                        
                         NSString *endDatestr= [self.dateFormatter stringFromDate:Edate];
                         NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc]init];
                           [dictTemp setObject:startDatestr forKey:@"date"];
                           [dictTemp setObject:endDatestr forKey:@"EndDate"];
                           [dictTemp setObject:event.title forKey:@"friendname"];
                         
                           [dictTemp setObject:@" " forKey:@"starttime"];
                           [dictTemp setObject:@" " forKey:@"endtime"];
                           [dictTemp setObject:@" " forKey:@"friend_profile_image"];
                         
                         [self.dateFormatter setDateFormat:@"MM"];
                         NSString  *strMonth=[NSString stringWithFormat:@"%ld",(long)[[self.dateFormatter stringFromDate:Sdate]integerValue]];
                        [dictTemp setObject:strMonth forKey:@"month"];
                         
                          [self.dateFormatter setDateFormat:@"yyyy"];
                         [dictTemp setObject:[self.dateFormatter stringFromDate:Sdate] forKey:@"year"];
                          // [dictTemp setValue:@" " forKey:@"friendname"];
                         if ([event.title  localizedCaseInsensitiveCompare:@"Playdate"] == NSOrderedSame)
                        // if ([event.title isEqualToString:@"Playdate"])
                         {
                             NSLog(@"play date events\n");
                         }
                         else
                           [self.iosCalenderEventDates addObject:dictTemp];
                      }
               }
                 
                 
                 
                 
                 [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
                 self.arrAllEventDates = [[self.serverEventDates arrayByAddingObjectsFromArray:self.iosCalenderEventDates] mutableCopy];
           }
             else // if he does not allow
             {
                self.arrAllEventDates = [[NSMutableArray alloc] initWithArray:self.serverEventDates];
            }
             
    
             [self.calendar reloadData];
             [self eventShown_Table:[NSDate date]];

          
             
         }];
    }
}

    
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
                if ([subView isKindOfClass:[UIView class]] && subView != eventContainer)
                {
                    rect = subView.frame;
                    rect.origin.y += 20.0;
                    subView.frame = rect;
                }
            }
        }

}
-(void)eventShown_Table:(NSDate *)date
{
    NSDate *dat=date;
    [self.dateFormatter setDateFormat:@"MM"];
    NSString *strMonth=[NSString stringWithFormat:@"%ld", (long)[[self.dateFormatter stringFromDate:dat]integerValue]];
    [self.dateFormatter setDateFormat:@"yyyy"];
    NSString *strYear=[self.dateFormatter stringFromDate:dat];
    arrTbleData=nil;
    arrTbleData=[[NSMutableArray alloc]init];
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ && month == %@", strYear, strMonth];
    arrAllData = [self.arrAllEventDates filteredArrayUsingPredicate:predicate];
    arrTbleData =[arrAllData copy];
    
    NSLog(@"%@",arrTbleData);
    if ([arrTbleData count]==0)
    {
        tblView.hidden=YES;
        lblDataNotFound.hidden=NO;
    }
    
    else
    {
        tblView.hidden=NO;
        lblDataNotFound.hidden=YES;
        [tblView reloadData];
    }
    
    activityIndicator.hidden =YES;
    [activityIndicator stopAnimating];
}
#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrTbleData count];
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
    {
        [subView removeFromSuperview];
    }
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 210, 20)];
    lblName.text = [[[arrTbleData objectAtIndex:indexPath.row] valueForKey:@"friendname"] uppercaseString];
    lblName.font = [UIFont systemFontOfSize:14.0];
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 100, 20)];
    lblTime.text = [[NSString stringWithFormat:@"%@-%@", [[arrTbleData objectAtIndex:indexPath.row]valueForKey:@"starttime"],[[arrTbleData objectAtIndex:indexPath.row]valueForKey:@"endtime"] ]uppercaseString];
    lblTime.font = [UIFont systemFontOfSize:12.0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:[[arrTbleData objectAtIndex:indexPath.row]valueForKey:@"date"]];
    [df setDateFormat:@"dd-MM-YYY"];
    NSString *strDate= [df stringFromDate:date];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 100, 20)];
    lbl.text = strDate;
    lbl.font = [UIFont systemFontOfSize:12.0];
    [cell.contentView addSubview:lbl];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 10.0, 50.0,50.0)];
    NSURL *url = [[arrTbleData objectAtIndex:indexPath.row]valueForKey:@"friend_profile_image"];
    NSLog(@"%@",url);
    
    if (url == nil)
    {
        [imgView setImage:[UIImage imageNamed:@""]];
    }
    else
    {
        [imgView setImageWithURL:url];
    }
    
    UIImage *img = [UIImage imageNamed:@"message_icon"];
    UIImageView *chatImgView = [[UIImageView alloc]initWithFrame:CGRectMake(270.0, 10.0, img.size.width,img.size.height)];
    [chatImgView setImage:img];
    
    
    [cell.contentView addSubview:chatImgView];
    [cell.contentView addSubview:lblName];
    [cell.contentView addSubview:lblTime];
    [cell.contentView addSubview:imgView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(0, 74.0, 320, 1)];
    vw.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255 blue:170.0/255 alpha:0.36];
    [cell.contentView addSubview:vw];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[arrAllData objectAtIndex:indexPath.row] allKeys] containsObject:@"event_id"]) {
        
        DetailOfEventVC  *objDetailOfEventVC=[[DetailOfEventVC alloc]initWithNibName:@"DetailOfEventVC" bundle:nil];
        objDetailOfEventVC.dictSlected_EventInfo=[arrAllData objectAtIndex:indexPath.row];
        objDetailOfEventVC.fromCalendar = YES;
        [self.navigationController pushViewController:objDetailOfEventVC animated:YES];

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)localeDidChange
{
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date
{

    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    for (id obj  in self.arrAllEventDates)
    {
        NSDate *disabledDate = [self.dateFormatter dateFromString:[obj objectForKey:@"date"]];
        if ([disabledDate isEqualToDate:date])
        {
           return YES;
        }
    }
    return NO;
}


#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date andDateButton:(UIButton *)dateButton
{
    [self.dateFormatter setDateFormat:@"MM"];

    NSString  *strDateTemp=[NSString stringWithFormat:@"%ld", (long)[[self.dateFormatter stringFromDate:date]integerValue]];

    if (![strDateTemp isEqualToString:strMothshowImageonCalender])
    {
           [dateButton setBackgroundImage:[UIImage imageNamed:@"" ] forState:UIControlStateNormal];
        return ;
    }
    
    if ([self dateIsDisabled:date])
    {
      
         [dateButton setBackgroundImage:[UIImage imageNamed:@"gift_icon_new" ] forState:UIControlStateNormal];
         dateItem.textColor = [PDHelper sharedHelper].applicationThemeBlueColor;
        
    }
    else
    {
          [dateButton setBackgroundImage:[UIImage imageNamed:@"" ] forState:UIControlStateNormal];
    }
}
 -(void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date
{
    [self.dateFormatter setDateFormat:@"MM"];
strMothshowImageonCalender=[NSString stringWithFormat:@"%ld", (long)[[self.dateFormatter stringFromDate:date]integerValue]];
    [self eventShown_Table:date];
    
   // [self performSelector:@selector(eventShown_Table:) withObject:date afterDelay:0.5];
  
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date
{
    self.calendar.userInteractionEnabled=NO;
    NSDate *dat=date;

    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading  Calender..."];
    
    [self performSelectorOnMainThread:@selector(SelectCalenderDate:) withObject:dat waitUntilDone:YES];
    
    BOOL tempBool=![self dateIsDisabled:date];
    varCalenderSlect=1;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:1.4];

    return tempBool;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date
{
    
    if ([date laterDate:self.minimumDate] == date)
    {
        self.calendar.backgroundColor = [UIColor clearColor];
        activityIndicator.hidden =NO;
        [activityIndicator startAnimating];
        return YES;
    }
    else
    {
        self.calendar.backgroundColor = [UIColor clearColor];
        activityIndicator.hidden =YES;
        [activityIndicator stopAnimating];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
    
    if ( varhideActivity==1)
    {
          [[PDAppDelegate sharedDelegate] hideActivity];
    }
    else if(varhideActivity==0)
        varhideActivity++;
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
-(void)hideActivityIndicator
{
    [[PDAppDelegate sharedDelegate]hideActivity];
    self.calendar.userInteractionEnabled=YES;
}
-(void)SelectCalenderDate:(NSDate*)dat
{
    [self.dateFormatter setDateFormat:@"MM"];
    NSString *strMonth=[self.dateFormatter stringFromDate:dat];
    [self.dateFormatter setDateFormat:@"yyyy"];
    NSString *strYear=[self.dateFormatter stringFromDate:dat];
    [self.dateFormatter setDateFormat:@"dd"];
    NSString *strDay=[self.dateFormatter stringFromDate:dat];
    arrTbleData=nil;
    arrTbleData=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[arrAllData count] ;i++)
    {
        NSDictionary *dictTemp=[arrAllData objectAtIndex:i];
        NSString  *strDate=[dictTemp valueForKey:@"date"];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate  *date=[self.dateFormatter dateFromString:strDate];
        [self.dateFormatter setDateFormat:@"dd"];
        NSString *strday=[self.dateFormatter stringFromDate:date];
        [self.dateFormatter setDateFormat:@"MM"];
        NSString *strMon=[self.dateFormatter stringFromDate:date];
        [self.dateFormatter setDateFormat:@"yyyy"];
        NSString *stryear=[self.dateFormatter stringFromDate:date];
        
        NSLog(@"original date Day %@",strDay);
        NSLog(@"calender date day %@",strday);
        
        if ([strYear isEqualToString:stryear]&&[strMonth isEqualToString:strMon]&&[strday isEqualToString:strDay] )
        {
            //            [arrTbleData addObject: [self.arrAllEventDates  objectAtIndex:i]];
            
            [arrTbleData addObject: [arrAllData  objectAtIndex:i]];
        }
    }
    
    
    if (arrTbleData.count==0)
    {
        tblView.hidden=YES;
        lblDataNotFound.hidden=NO;
    }
    else
    {
        tblView.hidden=NO;
        lblDataNotFound.hidden=YES;
        [tblView reloadData];
    }

}
-(void)AddEvent_IN_iosCalender
{
    
    
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // iOS 6 and later
        // This line asks user's permission to access his calendar
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (granted) // user user is ok with it
             {

                 NSMutableArray *arrCopyserverEventDates =[[NSMutableArray alloc]init];
                 NSMutableArray *arrTempSaveEvent_id=[[NSMutableArray alloc]init];
           
                 if ( ![[[Database sharedDatabase]readAllRecords]count]) // data base doesnot conatin any record
                 {
                     arrCopyserverEventDates = [self.serverEventDates mutableCopy];
                 }
                 else
                 {
                     
                    for (id obj in  [[Database sharedDatabase]readAllRecords])  // Fetch id from data base
                 {
                     SaveEntity *saveObj=obj;
                     [arrTempSaveEvent_id addObject:saveObj.eventid];
                 }
           NSMutableArray *arrTempSaveServerEvent=[[NSMutableArray alloc]init];
                
                 for (id obj in self.serverEventDates) // get same record of data base
                 {
                     
               NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id == %@" , [obj objectForKey:@"event_id"]];
  
                     
                 [arrTempSaveServerEvent  addObject:[[self.serverEventDates filteredArrayUsingPredicate:predicate]objectAtIndex:0]];
            }
                 
                 [arrCopyserverEventDates removeObjectsInArray:[arrTempSaveServerEvent copy]]; // contain unique object;
                 }
            for ( int i=0; i<[ arrCopyserverEventDates count]; i++)
                 {
                     [[Database sharedDatabase] saveFavroiteForTeam:[[arrCopyserverEventDates objectAtIndex:i]valueForKey:@"event_id"]];
                     
                     NSLog(@"%@",[arrCopyserverEventDates objectAtIndex:i]);
                 
                 
                 
                 EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                 event.title  = @"PlayDate";
                 event.allDay = YES;
                     event.notes=[[arrCopyserverEventDates objectAtIndex:i]valueForKey:@"friendname"];
                 //    event.description=@"asd";
                     [event setLocation:[[arrCopyserverEventDates objectAtIndex:i]valueForKey:@"location"]];
                     
                //  event set =[NSString stringWithFormat:@"%@-%@", [[self.serverEventDates objectAtIndex:i]valueForKey:@"firstname"],[[self.serverEventDates objectAtIndex:i]valueForKey:@"friendname"]];
                     
//                     NSMutableString *strTem=[[[self.serverEventDates objectAtIndex:i]valueForKey:@"starttime"]mutableCopy];
//                     
//                     NSUInteger len=strTem.length;
//                     [strTem insertString:@" " atIndex:len-2];
//                     
//                     NSString *strTemp=[NSString stringWithFormat:@"%@ %@",[[self.serverEventDates objectAtIndex:i]valueForKey:@"date"],strTem];
//                     
//                     strTemp=@"2014-07-16 12:01 pm";
//                     [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
             
//                     NSDate *dateTemp=[self.dateFormatter dateFromString:strTemp];

                // NSDate *duedate = [NSDate date];
                     
                     
                     
//                     NSMutableString *strTem=[[[self.serverEventDates objectAtIndex:i]valueForKey:@"starttime"]mutableCopy];
                     NSString *strTempStart=[NSString stringWithFormat:@"%@ %@",[[self.serverEventDates objectAtIndex:i]valueForKey:@"date"],[[self.serverEventDates objectAtIndex:i]valueForKey:@"starttime"]];
                     
                     NSString *strTempEnd=[NSString stringWithFormat:@"%@ %@",[[self.serverEventDates objectAtIndex:i]valueForKey:@"date"],[[self.serverEventDates objectAtIndex:i]valueForKey:@"endtime"]];
                     
                     
//                     strTemp=@"2014-07-16 12:01";
                     [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                     
                     
                     NSDate *DateStart=[self.dateFormatter dateFromString:strTempStart];

                        NSDate *DateEnd=[self.dateFormatter dateFromString:strTempEnd];
                     
                     
                     
                     
                     
//                     NSString *strTemStart=[[arrCopyserverEventDates objectAtIndex:i]valueForKey:@"date"];
//                     [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
//                     NSDate *datStart=    [self.dateFormatter dateFromString:strTemStart];
//                       [self.dateFormatter setDateFormat:@"dd.MM.yyyy"];
//                     NSString *str=  [self.dateFormatter stringFromDate:datStart];
                     event.startDate =DateStart;
                     event.endDate=DateEnd;
                 
                 
                 
                 [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                 NSError *err;
                 
                 [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                 
                 if(err)
                     NSLog(@"unable to save event to the calendar!: Error= %@", err);
                 }
             }
             else // if he does not allow
             {
                 [[[UIAlertView alloc]initWithTitle:nil message:@"Alert" delegate:nil cancelButtonTitle:NSLocalizedString(@"Please on the calender option from setting", nil)  otherButtonTitles: nil] show];
                 return;
             }
         }];
    }
    
    // iOS < 6
    else
    {
        NSMutableArray *arrCopyserverEventDates =[[NSMutableArray alloc]init];
        NSMutableArray *arrTempSaveEvent_id=[[NSMutableArray alloc]init];
        //NSLog(@"%d", [[[Database sharedDatabase]readAllRecords]count]);
        if ( ![[[Database sharedDatabase]readAllRecords]count]) // data base doesnot conatin any record
        {
            arrCopyserverEventDates = [self.serverEventDates mutableCopy];
        }
        else
        {
            
            for (id obj in  [[Database sharedDatabase]readAllRecords])  // Fetch id from data base
            {
                SaveEntity *saveObj=obj;
                [arrTempSaveEvent_id addObject:saveObj.eventid];
            }
            NSMutableArray *arrTempSaveServerEvent=[[NSMutableArray alloc]init];
            
            for (id obj in self.serverEventDates) // get same record of data base
            {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id == %@" , [obj objectForKey:@"event_id"]];
                
                
                [arrTempSaveServerEvent  addObject:[[self.serverEventDates filteredArrayUsingPredicate:predicate]objectAtIndex:0]];
            }
            
            [arrCopyserverEventDates removeObjectsInArray:[arrTempSaveServerEvent copy]]; // contain unique object;
        }
        for ( int i=0; i<[ arrCopyserverEventDates count]; i++)
        {
            [[Database sharedDatabase] saveFavroiteForTeam:[[arrCopyserverEventDates objectAtIndex:i]valueForKey:@"event_id"]];
            
            NSLog(@"%@",[arrCopyserverEventDates objectAtIndex:i]);
            
            
            
            EKEvent *event = [EKEvent eventWithEventStore:eventStore];
            event.title  = @"PlayDate";
            event.allDay = YES;
            event.notes=[[arrCopyserverEventDates objectAtIndex:i]valueForKey:@"friendname"];
            //    event.description=@"asd";
            [event setLocation:[[arrCopyserverEventDates objectAtIndex:i]valueForKey:@"location"]];
            
            //  event set =[NSString stringWithFormat:@"%@-%@", [[self.serverEventDates objectAtIndex:i]valueForKey:@"firstname"],[[self.serverEventDates objectAtIndex:i]valueForKey:@"friendname"]];
            
            NSMutableString *strTem=[[[self.serverEventDates objectAtIndex:i]valueForKey:@"starttime"]mutableCopy];
               NSUInteger len=strTem.length;
                                 [strTem insertString:@" " atIndex:len-2];
            
                                 NSString *strTemp=[NSString stringWithFormat:@"%@ %@",[[self.serverEventDates objectAtIndex:i]valueForKey:@"date"],strTem];
            
                                 strTemp=@"2014-07-16 12:01 pm";
                                 [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
            
            

            
            NSString *strTemStart=[[arrCopyserverEventDates objectAtIndex:i]valueForKey:@"date"];
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *datStart=    [self.dateFormatter dateFromString:strTemStart];
            [self.dateFormatter setDateFormat:@"dd.MM.yyyy"];
            NSString *str=  [self.dateFormatter stringFromDate:datStart];
            event.startDate = [self.dateFormatter dateFromString:str];
            event.endDate= [self.dateFormatter dateFromString:str];
            
            
            
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
            
            if(err)
                NSLog(@"unable to save event to the calendar!: Error= %@", err);
        
        }
        
    }
}

@end
