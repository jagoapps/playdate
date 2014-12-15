//
//  DetailOfEventVC.m
//  PlayDate
//
//  Created by iApp on 16/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "DetailOfEventVC.h"
#import "PDWebHandler.h"
#import "PDRequestArrangeViewController.h"
#import "UIImageView+WebCache.h"
#import "PDCalenderViewController.h"
#import "PDMainViewController.h"
#import "PDRequestEditViewController.h"
@interface DetailOfEventVC ()
{
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblDob;
    IBOutlet UILabel *lblFreetime;
    IBOutlet UILabel *lblAllergies;
    IBOutlet UILabel *lblHobbies;
    IBOutlet UILabel *lblSchool;
    IBOutlet UILabel *lblYouthclub;
    IBOutlet UIView *vwChildDetail;
    IBOutlet UIView *vwBackView;
    IBOutlet UIScrollView *scrollvw;
        
    IBOutlet UIView *vwFreetime;
    IBOutlet UIView *vwAllergies;
    IBOutlet UIView *vwHobbies;
    IBOutlet UIView *vwSchool;
    IBOutlet UIView *vwYouthClub;

    
}
-(IBAction)menuArrange:(id)sender;
-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;
@end

@implementation DetailOfEventVC

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
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Saving..."];
    [self performSelector:@selector(activityDidAppear) withObject:nil afterDelay:0.1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.dictSlected_EventInfo);
    
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    
       [self setUpViewContents];
    
    UITapGestureRecognizer *gestureChildDetail_VW=[[UITapGestureRecognizer alloc]init];
    [gestureChildDetail_VW addTarget:self action:@selector(gestureActionChildDetail_VW:)];
    [vwChildDetail addGestureRecognizer:gestureChildDetail_VW];

    
    
 
    
    // Do any additional setup after loading the view from its nib.
}
-(void)LoadData
{
    
    lblownPlayerName1.text =[[self.dictSlected_EventInfo valueForKey:@"child_name"]uppercaseString];
    lblownCopyPlayerName1.text=[[self.dictSlected_EventInfo valueForKey:@"child_name"]uppercaseString];
    lblfriendPlayerName2.text =[[self.dictSlected_EventInfo valueForKey:@"friendname"]uppercaseString];
       UIImage *imgPlaceHolder=[UIImage imageNamed:@"user_img"];
    
    [imgPlayer1 setImageWithURL:[NSURL URLWithString:[self.dictSlected_EventInfo objectForKey:PDWebProfileImage]] placeholderImage:imgPlaceHolder];
    
    [imgPlayer2 setImageWithURL:[NSURL URLWithString:[self.dictSlected_EventInfo objectForKey:@"friend_profile_image"]] placeholderImage:imgPlaceHolder];
    
    
   // NSArray *arrFriendChild=[self.dictSlected_EventInfo valueForKey:@"finfo"];
    
//    int xCordinateImagVWAccepted=0;
//
//    NSMutableString *strFriendChildname=[[NSMutableString alloc]init];
//    for (int i=0; i<[arrFriendChild count]; i++)
//    {
//        UIImageView *imgvwTemp=[[UIImageView alloc]initWithFrame:CGRectMake(xCordinateImagVWAccepted,1, 65, 65)];
//        imgvwTemp.contentMode = UIViewContentModeScaleAspectFit;
//        imgvwTemp.userInteractionEnabled=YES;
//        [imgvwTemp setImageWithURL:[[arrFriendChild objectAtIndex:i]valueForKey:@"friend_profile_image"] placeholderImage:imgPlaceHolder];
//        imgvwTemp.tag=i;
//        
//        UILabel *lblNameFriendchildName=[[UILabel alloc]initWithFrame:CGRectMake(xCordinateImagVWAccepted,63, 65,22)];
//        lblNameFriendchildName.font=[UIFont fontWithName:@"GillSans" size:11.0];
////     strFriendChildname=[strFriendChildname stringByAppendingFormat:@"%@ %@",strFriendChildname,[[arrFriendChild objectAtIndex:i]valueForKey:@"friendname"]];
//
//        
//        [strFriendChildname appendString:[[arrFriendChild objectAtIndex:i]valueForKey:@"friendname"]];
//        [strFriendChildname appendString:@","];
//
//        
//        lblNameFriendchildName.text=[[[arrFriendChild objectAtIndex:i]valueForKey:@"friendname"] uppercaseString];
//       
//        
//        lblNameFriendchildName.backgroundColor=[UIColor clearColor];
//        lblNameFriendchildName.textColor=[UIColor blackColor];
//        lblNameFriendchildName.textAlignment=NSTextAlignmentCenter;
//        
//        
//        [scrollVwFriendImages addSubview:imgvwTemp];
//        [scrollVwFriendImages addSubview:lblNameFriendchildName];
//        [scrollVwFriendImages setContentSize:CGSizeMake(xCordinateImagVWAccepted, 89)];
//        
//        xCordinateImagVWAccepted=xCordinateImagVWAccepted+65+8;
//       
//        
//        
//        UITapGestureRecognizer *gestureImgVwGuardianFrndChildInfo=[[UITapGestureRecognizer alloc]init];
//        [gestureImgVwGuardianFrndChildInfo addTarget:self action:@selector(gestureActionFrndChildInfo:)];
//        
//        [imgvwTemp addGestureRecognizer:gestureImgVwGuardianFrndChildInfo];
//        
//        
//    }
    
//    lblfriendPlayerName2.text=[[strFriendChildname substringToIndex:[strFriendChildname length]-1]uppercaseString];
    txtWhere.text=  [[self.dictSlected_EventInfo valueForKey:PDWebLocation]uppercaseString] ;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *Date = [[self.dictSlected_EventInfo valueForKey:PDWebDate]uppercaseString];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:Date];
    [df setDateFormat:@"dd-MMMM-yyyy"];
    // [df stringFromDate:date];
    txtWhen.text= [df stringFromDate:date];
    
    
    
    
    if (self.fromCalendar)
        txtTime.text= [NSString stringWithFormat:@"%@-%@",[self.dictSlected_EventInfo valueForKey:@"starttime"],[self.dictSlected_EventInfo valueForKey:PDWebEndTime]];
    
    
    else
        txtTime.text= [NSString stringWithFormat:@"%@-%@",[self.dictSlected_EventInfo valueForKey:@"Starttime"],[self.dictSlected_EventInfo valueForKey:PDWebEndTime]];
    
    
    
    
    NSString *strNotes=  [[self.dictSlected_EventInfo valueForKey:PDWebNotes] uppercaseString];
    lblNotes.text=strNotes;
    [lblNotes sizeToFit];
    
    CGRect rect = lblNotes.frame;
    
    if (rect.size.height <= 30.0)
    {
        rect.size.height = 30.0;
        lblNotes.frame = rect;
        
        rect = vwNotes.frame;
        rect.size.height = 40.0;
        vwNotes.frame = rect;
    }
    
    else
    {
        CGRect rectvwNotes=  vwNotes .frame;
        rectvwNotes.size.height=CGRectGetMaxY(lblNotes.frame)+5;
        vwNotes.frame=rectvwNotes;
        
    }
    
    //  CGSize maximumLabelSize = CGSizeMake(150,MAXFLOAT);
    //    CGSize expectedLabelSize = [strNotes sizeWithFont:lblNotes.font
    //                                  constrainedToSize:maximumLabelSize
    //                                      lineBreakMode:lblNotes.lineBreakMode];
    //    CGRect frm=lblNotes.frame;
    //    frm.size.height = expectedLabelSize.height+10;
    //    lblNotes.frame=frm;
    
    
    
    CGRect rectVwButtons=  vwButtons .frame;
    rectVwButtons.origin.y=CGRectGetMaxY(vwNotes.frame)+30;
    vwButtons.frame=rectVwButtons;
    
    
    
    
    
    
    
    
    NSString *strStartTime1=  [self.dictSlected_EventInfo valueForKey:@"Starttime1"];
    if (strStartTime1.length!=0)
    {
        vw1when1.hidden=NO;
        vw1Time1.hidden=NO;
        lblAlternative1.hidden=NO;
        Date = [[self.dictSlected_EventInfo valueForKey:PDWebDate1]uppercaseString];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [df dateFromString:Date];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        txtWhen1.text=   [df stringFromDate:date];
        txtTime1.text= [NSString stringWithFormat:@"%@-%@",[self.dictSlected_EventInfo valueForKey:@"Starttime1"],[self.dictSlected_EventInfo valueForKey:PDWebEndTime1]];
        CGRect rectVwButtons=  vwButtons .frame;
        rectVwButtons.origin.y=CGRectGetMaxY(vw1Time1.frame)+30;
        vwButtons.frame=rectVwButtons;
        
        
    }
    NSString *strStartTime2=  [self.dictSlected_EventInfo valueForKey:@"Starttime2"];
    if (strStartTime2.length!=0)
    {
        vw2when2.hidden=NO;
        vw2Time2.hidden=NO;
        lblAlternative2.hidden=NO;
        Date = [[self.dictSlected_EventInfo valueForKey:PDWebDate2]uppercaseString];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [df dateFromString:Date];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        txtWhen2.text=   [df stringFromDate:date];
        txtTime2.text= [NSString stringWithFormat:@"%@-%@",[self.dictSlected_EventInfo valueForKey:@"Starttime2"],[self.dictSlected_EventInfo valueForKey:PDWebEndTime2]];
        
        CGRect rectVwButtons=  vwButtons .frame;
        rectVwButtons.origin.y=CGRectGetMaxY(vw2Time2.frame)+30;
        vwButtons.frame=rectVwButtons;
    }
    
    NSString *strStartTime3=  [self.dictSlected_EventInfo valueForKey:@"Starttime3"];
    if (strStartTime3.length!=0)
    {
        vw3when3.hidden=NO;
        vw3Time3.hidden=NO;
        lblAlternative3.hidden=NO;
        
        
        Date = [[self.dictSlected_EventInfo valueForKey:PDWebDate3]uppercaseString];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [df dateFromString:Date];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        txtWhen3.text=   [df stringFromDate:date];
        txtTime3.text= [NSString stringWithFormat:@"%@-%@",[self.dictSlected_EventInfo valueForKey:@"Starttime3"],[self.dictSlected_EventInfo valueForKey:PDWebEndTime3]];
        
        CGRect rectVwButtons=  vwButtons .frame;
        rectVwButtons.origin.y=CGRectGetMaxY(vw3Time3.frame)+30;
        vwButtons.frame=rectVwButtons;
    }
    NSLog(@"%@",[self.dictSlected_EventInfo  objectForKey:@"status"]);
    
    
    
    //   if ([[self.dictSlected_EventInfo  objectForKey:@"status"] isEqualToString:@"accepted"]||self.fromCalendar)
    //           vwButtons.hidden=YES;
    if (self.fromCalendar)
        vwButtons.hidden=YES;
    
    if([[self.dictSlected_EventInfo  objectForKey:@"status"] isEqualToString:@"accepted"])
    {
        btnAccept.hidden=YES;
        btnReject.hidden=YES;
    }
    
    
    NSString *strSender_id=[self.dictSlected_EventInfo  objectForKey:@"senderid"];
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    
    if ([strSender_id isEqualToString:strGid])
    {
        btnAccept.hidden=YES;
        btnReject.hidden=YES;
        //  vwButtons.hidden=YES;
    }
    
    if (vwButtons.hidden==YES)
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(vwButtons.frame)-40)];
    
    
    else
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(vwButtons.frame) + 60.0)];
    

    
    
    // chid info work
    
    
    
    UITapGestureRecognizer *gestureImgVwChildInfo=[[UITapGestureRecognizer alloc]init];
    [gestureImgVwChildInfo addTarget:self action:@selector(gestureActionChildInfo:)];
    [imgPlayer1 addGestureRecognizer:gestureImgVwChildInfo];
    [[PDAppDelegate sharedDelegate] hideActivity];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark gesture methods
-(void) gestureActionChildDetail_VW:(UITapGestureRecognizer*)ges
{
    [vwChildDetail removeFromSuperview];
}
-(void) gestureActionChildInfo:(UITapGestureRecognizer*)ges
{
    if (![self.dictSlected_EventInfo count]>0)
        return;
    
    
    NSArray *arrHobbies=[[self.dictSlected_EventInfo valueForKey:@"child_hobbies"] componentsSeparatedByString:@","];
    NSMutableString *strHobbies=[[NSMutableString alloc]init];
    
    if ([arrHobbies count]>1)
    {
        
        
        
        for ( int i=0;i<[arrHobbies count]; i++)
        {
            NSString *test = [arrHobbies objectAtIndex:i];
            if ([test characterAtIndex:0] == 32)
            {
                test = [test stringByReplacingCharactersInRange:NSMakeRange(1,1) withString:@""];
                [strHobbies appendString:test];
            }
            else
                [strHobbies appendString:test];
            [strHobbies appendString:@"\n"];
        }
    }
    
    else
    {
        [strHobbies appendString:[arrHobbies objectAtIndex:0]];
        
    }
    
    
    NSArray *arrAllergies=[[self.dictSlected_EventInfo valueForKey:@"child_allergies"] componentsSeparatedByString:@","];
    NSMutableString *strAllergies=[[NSMutableString alloc]init];
    
    if ([arrAllergies count]>1)
    {
        for ( int i=0;i<[arrAllergies count]; i++)
        {
            NSString *test = [arrAllergies objectAtIndex:i];
            if ([test characterAtIndex:0] == 32)
            {
                test = [test stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
                [strAllergies appendString:test];
            }
            else
                [strAllergies appendString:test];
            
            [strAllergies appendString:@"\n"];
            
        }
    }
    else
    {
        [strAllergies appendString:[arrAllergies objectAtIndex:0]];
        
    }
    
    CGSize maximumLabelSize=CGSizeMake(150, CGFLOAT_MAX);
    CGSize lblAllergiesSize = [strAllergies sizeWithFont:lblAllergies.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:lblAllergies.lineBreakMode];
    
    CGRect rect= lblAllergies.frame;
    rect.size.height=lblAllergiesSize.height;
    lblAllergies.frame=rect;
    
    
    CGSize lblHobbiesSize = [strHobbies sizeWithFont:lblHobbies.font
                                   constrainedToSize:maximumLabelSize
                                       lineBreakMode:lblHobbies.lineBreakMode];
    
    rect= lblHobbies.frame;
    rect.size.height=lblHobbiesSize.height;
    lblHobbies.frame=rect;
    
    
    
    lblName.text=[self.dictSlected_EventInfo valueForKey:@"child_name"];
    lblDob.text=[[self.dictSlected_EventInfo valueForKey:@"child_dob"] uppercaseString];
    lblFreetime.text=[[self.dictSlected_EventInfo valueForKey:@"child_c_set_fixed_freetime"]uppercaseString];
    lblAllergies.text=strAllergies;
    lblHobbies.text=strHobbies;
    lblYouthclub.text=[self.dictSlected_EventInfo valueForKey:@"child_youth_club"];
    lblSchool.text=[self.dictSlected_EventInfo valueForKey:@"child_school"];
    
    
    rect  = lblAllergies.frame;
    if (rect.size.height < 30.0) {
        rect.size.height = 30.0;
        lblAllergies.frame =rect;
    }
    rect  = lblHobbies.frame;
    if (rect.size.height < 30.0) {
        rect.size.height = 30.0;
        lblHobbies.frame =rect;
    }
    rect  = lblFreetime.frame;
    if (rect.size.height < 30.0) {
        rect.size.height = 30.0;
        lblFreetime.frame =rect;
    }
    
    
    [self.view addSubview:vwChildDetail];
    [self  Adjust_Size_height];
    
}
-(void) gestureActionFrndChildInfo:(UITapGestureRecognizer*)ges
{
    
    // freiend chid detail
    
    if (![self.dictSlected_EventInfo count]>0)
        return;
    NSArray *arrTemp= [self.dictSlected_EventInfo valueForKey:@"finfo"];
    NSArray *arrHobbies=[[[arrTemp objectAtIndex:ges.view.tag] valueForKey:@"friend_hobbies"] componentsSeparatedByString:@","];
    NSMutableString *strHobbies=[[NSMutableString alloc]init];
    if ([arrHobbies count]>1) {
        
        
        for ( int i=0;i<[arrHobbies count]; i++)
        {
            NSString *test = [arrHobbies objectAtIndex:i];
            if ([test characterAtIndex:0] == 32)
            {
                test = [test stringByReplacingCharactersInRange:NSMakeRange(1,1) withString:@""];
                [strHobbies appendString:test];
            }
            else
                [strHobbies appendString:test];
            [strHobbies appendString:@"\n"];
        }
        
    }
    else
    {
        NSString *test = [arrHobbies objectAtIndex:0];
        [strHobbies appendString:test];
        
    }
    
    
    NSArray *arrAllergies=[[[arrTemp objectAtIndex:ges.view.tag] valueForKey:@"friend_allergies"] componentsSeparatedByString:@","];
    NSMutableString *strAllergies=[[NSMutableString alloc]init];
    
    if ([arrAllergies count]>1) {
        
        
        for ( int i=0;i<[arrAllergies count]; i++)
        {
            NSString *test = [arrAllergies objectAtIndex:i];
            if ([test characterAtIndex:0] == 32)
            {
                test = [test stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
                [strAllergies appendString:test];
            }
            else
                [strAllergies appendString:test];
            
            [strAllergies appendString:@"\n"];
            
        }
        
    }
    else
    {
        NSString *test = [arrAllergies objectAtIndex:0];
        [strAllergies appendString:test];
        
    }
    
    CGSize maximumLabelSize=CGSizeMake(150, CGFLOAT_MAX);
    CGSize lblAllergiesSize = [strAllergies sizeWithFont:lblAllergies.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:lblAllergies.lineBreakMode];
    
    CGRect rect= lblAllergies.frame;
    rect.size.height=lblAllergiesSize.height;
    lblAllergies.frame=rect;
    
    
    CGSize lblHobbiesSize = [strHobbies sizeWithFont:lblHobbies.font
                                   constrainedToSize:maximumLabelSize
                                       lineBreakMode:lblHobbies.lineBreakMode];
    
    rect= lblHobbies.frame;
    rect.size.height=lblHobbiesSize.height;
    lblHobbies.frame=rect;
    
    
    
    
    
    
    lblName.text=[[arrTemp objectAtIndex:ges.view.tag] valueForKey:@"friendname"];
    lblDob.text=[[[arrTemp objectAtIndex:ges.view.tag] valueForKey:@"friend_dob"] uppercaseString];
    lblFreetime.text=[[[arrTemp objectAtIndex:ges.view.tag] valueForKey:@"friend_c_set_fixed_freetime"]uppercaseString];
    lblAllergies.text=strAllergies;
    lblHobbies.text=strHobbies;
    lblYouthclub.text=[[arrTemp objectAtIndex:ges.view.tag] valueForKey:@"friend_youth_club"];
    lblSchool.text=[[arrTemp objectAtIndex:ges.view.tag] valueForKey:@"friend_school"];
    
    rect  = lblAllergies.frame;
    if (rect.size.height < 30.0) {
        rect.size.height = 30.0;
        lblAllergies.frame =rect;
    }
    rect  = lblHobbies.frame;
    if (rect.size.height < 30.0) {
        rect.size.height = 30.0;
        lblHobbies.frame =rect;
    }
    rect  = lblFreetime.frame;
    if (rect.size.height < 30.0) {
        rect.size.height = 30.0;
        lblFreetime.frame =rect;
    }
    
    [self.view addSubview:vwChildDetail];
    [self  Adjust_Size_height];
}

#pragma mark self methos
-(void)Adjust_Size_height
{
    
    CGRect rect;
    rect =vwAllergies.frame;
    rect.size.height=CGRectGetMaxY(lblAllergies.frame)+5.0;
    vwAllergies.frame=rect;
    rect =vwHobbies.frame;
    rect.size.height=CGRectGetMaxY(lblHobbies.frame)+7.0;
    vwHobbies.frame=rect;
    
    rect =vwHobbies.frame;
    rect.origin.y=CGRectGetMaxY(vwAllergies.frame)+5.0;
    vwHobbies.frame=rect;
    
    
    
    rect =vwSchool.frame;
    rect.origin.y=CGRectGetMaxY(vwHobbies.frame)+7.0;
    vwSchool.frame=rect;
    
//    rect =vwYouthClub.frame;
//    rect.origin.y=CGRectGetMaxY(vwSchool.frame)+7.0;
//    vwYouthClub.frame=rect;
    
    rect =vwBackView.frame;
    rect.size.height=CGRectGetMaxY(vwSchool.frame)+25.0;
    vwBackView.frame=rect;
    
    
    [scrollvw setContentSize:CGSizeMake(scrollvw.frame.size.width, CGRectGetMaxY(vwBackView.frame) + 37.0)];
 
    NSLog(@"%@",NSStringFromCGRect(vwChildDetail.frame));
      NSLog(@"%@",NSStringFromCGRect(scrollvw.frame));
         NSLog(@"%@",NSStringFromCGRect(vwBackView.frame));
}
- (void)activityDidAppear
{
//  
//    __block UIImageView *iV = imgPlayer2;
//    __block NSDictionary *dict = self.dictSlected_EventInfo;
//    
//    [imgPlayer1 setImageWithURL:[NSURL URLWithString:[ self.dictSlected_EventInfo objectForKey:PDWebProfileImage]] placeholderImage:[UIImage imageNamed:@"user_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        
//        if (!error)
//        {
//            [iV setImageWithURL:[NSURL URLWithString:[dict objectForKey:PDWebFriendProfileImage]] placeholderImage:[UIImage imageNamed:@"user_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                
//                if (!error)
//                {}
//                else
//                {}
//                
//                 [[PDAppDelegate sharedDelegate] hideActivity];
//                }];
//
//
//        }
//        else {
//            [iV setImageWithURL:[NSURL URLWithString:[dict objectForKey:PDWebFriendProfileImage]] placeholderImage:[UIImage imageNamed:@"user_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                
//                if (!error)
//                {
//                    
//                    
//                }
//                else {
//                    
//                }
//                
//                [[PDAppDelegate sharedDelegate] hideActivity];
//                
//            }];
//
//        }
//        
//    }];
    [self LoadData];

}
-(void)setUpViewContents
{
    CGRect rect;
    
    CGFloat totalHeight = [UIScreen mainScreen].bounds.size.height;
    if (![[PDHelper sharedHelper] isIOS7]){
        totalHeight -= 20.0;
    }
    else
    {
        for (UIView *subView in self.view.subviews) {
            if ([subView isKindOfClass:[UIView class]]) {
                rect = subView.frame;
                rect.origin.y += 20.0;
                subView.frame = rect;
            }
        }
    }
    
    
   }
-(void)accepted
{
    
    
    
    NSString *guardianID = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebGID];
    NSDictionary *params = @{@"event_id" :[self.dictSlected_EventInfo objectForKey:@"Eventid"],
                             @"status": @"accepted",
                             @"logged_in_user_id":guardianID
                             };
    
    
    [[PDWebHandler sharedWebHandler] event_Accepted_RejectedEvent:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
        [[PDAppDelegate sharedDelegate] hideActivity];
            [self .navigationController popViewControllerAnimated:YES];


    }];
    
    
    //http://112.196.34.179/playdate/event_accept_or_reject.php?event_id=57&status=accepted
}
-(void)rejcted
{    //http://112.196.34.179/playdate/event_accept_or_reject.php?event_id=64&status=rejected
    NSString *guardianID = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebGID];

    
    NSDictionary *params = @{@"event_id" :[self.dictSlected_EventInfo objectForKey:@"Eventid"],
                             @"status": @"rejected",
                             @"logged_in_user_id":guardianID
                             };
    
    
    [[PDWebHandler sharedWebHandler] event_Accepted_RejectedEvent:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
        [[PDAppDelegate sharedDelegate] hideActivity];
        [self .navigationController popViewControllerAnimated:YES];
        
    }];


}
#pragma mark iBoutlets
-(IBAction)btnActionRejcted
{
    
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Rejecting Request..."];
    [self performSelector:@selector(rejcted) withObject:nil afterDelay:0.1];

}

-(IBAction)btnActionAccepted
{
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Accepting Request..."];
    [self performSelector:@selector(accepted) withObject:nil afterDelay:0.1];

}

-(IBAction)homeAction:(id)sender
{
   //[self.menuContainerViewController ]
}
-(IBAction)calendarAction:(id)sender
{
}
-(IBAction)arrangeAction:(id)sender
{
}


-(IBAction)btnActionEdit
{
    
    
    PDRequestEditViewController  *objPDRequestEditViewController=[[PDRequestEditViewController alloc]initWithNibName:@"PDRequestEditViewController" bundle:nil];
    
    objPDRequestEditViewController.dictEventInfo_edit=self.dictSlected_EventInfo;
    [self.navigationController pushViewController:objPDRequestEditViewController animated:YES];
    
    
    
//    
//    PDRequestEditViewController *objPDRequestEditViewController=[[PDRequestEditViewController alloc]initWithNibName:@"PDRequestEditViewController" bundle:nil];
//
//    objPDRequestEditViewController.dictEventInfo_edit=self.dictSlected_EventInfo;
//    [self.navigationController pushViewController:objPDRequestEditViewController animated:YES];
    
}

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
@end
