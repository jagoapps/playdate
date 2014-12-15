//
//  PDExtentedPermissions.m
//  PlayDate
//
//  Created by iApp on 02/07/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDExtentedPermissions.h"
#import "PDRequestArrangeViewController.h"
#import "PDCalenderViewController.h"
#import "PDMainViewController.h"
#import "UIImageView+WebCache.h"



#define TICK_IMAGE [UIImage imageNamed:@"blueTick"]
@interface PDExtentedPermissions ()<UIAlertViewDelegate>
{
    
    IBOutlet UILabel *lblFriendList;

    IBOutlet UIScrollView *childScrollView;
    IBOutlet UIScrollView *friendScrollView;
    
        IBOutlet UIView *friendScrollViewContainer;
        IBOutlet UIView *childScrollViewContainer;
    NSMutableArray *arrAllFriendList;
    NSArray *arrAllChildList;
    
    IBOutlet UIButton *btnSave;
    
    IBOutlet UIScrollView *scrollVw;
    
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
-(IBAction)menuAction:(id)sender;
-(IBAction)btnActionSave:(id)sender;
@end

@implementation PDExtentedPermissions

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
    
    btnSave.hidden=YES;
    lblFriendList.hidden=YES;
    friendScrollViewContainer.hidden=YES;
    scrollVw.contentSize=CGSizeMake(320, CGRectGetMaxY(btnSave.frame)+30);
    self.navigationController.navigationBarHidden = YES;

    childScrollViewContainer.layer.borderWidth = 5.0;
    childScrollViewContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    childScrollViewContainer.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    childScrollViewContainer.layer.shadowRadius = 2.0;
    childScrollViewContainer.layer.shadowOpacity = 0.5;
    
    friendScrollViewContainer.layer.borderWidth = 5.0;
    friendScrollViewContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    friendScrollViewContainer.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    friendScrollViewContainer.layer.shadowRadius = 2.0;
    friendScrollViewContainer.layer.shadowOpacity = 0.5;

    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"com.jagoapps.playdate.exchangechilds"]) //un comment the code
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
    
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(ChildListWebservice) withObject:nil afterDelay:0.1];
    [self setUpViewContents];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark iboutlets
-(IBAction)btnActionSave:(id)sender
{
//    NSArray *arrChildIndexes=[self checkedIndex:childScrollView];
//    NSArray *arrFriendIndexes=[self checkedIndex:friendScrollView];
//    if ([arrChildIndexes count]==0||[arrFriendIndexes count]==0)
//            [[[UIAlertView alloc]initWithTitle:@"" message:@"Please select from friend list " delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
//    else
//    {
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(ExtendPermissionWebservice) withObject:nil afterDelay:0.1];
  //  }
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
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}
-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark self method
-(void)reloadChild
{
    // REMOVE ALL SUBVIEWS
    for (id obj in childScrollView.subviews)
        [obj removeFromSuperview];
    
    // ADD SUBVIEWS
    CGFloat rowHeight = 51.0;
    CGFloat rowWidth  = childScrollView.frame.size.width;
    CGFloat row_X = 0.0;
    CGFloat row_Y = 0.0;
    
    UIView *row;
    UIImageView *imageView;
    UILabel *titleView;
    UIButton *btnCheckmark;
    for (int i=0; i<[arrAllChildList count]; i++)
    {
        NSDictionary *detail = [arrAllChildList objectAtIndex:i];
        row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
        row.tag = i;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
        bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row.layer addSublayer:bottomBorder];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 36.0, 36.0)];
        
        NSURL *url = [detail valueForKey:@"profile_image"];
        [imageView setImageWithURL:url];
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row addSubview:imageView];
        
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, childScrollView.frame.size.width-70.0, 50.0)];
        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:13.0];
        titleView.text = [detail valueForKey:@"Childname"];
        titleView.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        titleView.numberOfLines = 0;
        [row addSubview:titleView];
        [childScrollView addSubview:row];
        row_Y = row_Y + 50.0;
        
        btnCheckmark=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCheckmark.tag=i;
            CGRect r = CGRectMake(0.0, 0.0, 17.0, 13.0);
        r.origin.x = CGRectGetMaxX(titleView.frame);
        r.origin.y = (CGRectGetHeight(row.frame) - CGRectGetHeight(r))/2.0;
        [btnCheckmark setFrame:r];
        [btnCheckmark setUserInteractionEnabled:FALSE];
        [row addSubview:btnCheckmark];
        for (NSString *strKey in [detail allKeys])
        {
            if ([strKey isEqualToString:@"checked"])
                if ([[detail valueForKey:@"checked"] isEqualToString:@"true"])
                    [btnCheckmark setImage:TICK_IMAGE forState:UIControlStateNormal];
        }
  UIGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getChildInfo:)];
  [row addGestureRecognizer:tapGes];
    }
    
    [childScrollView setContentSize:CGSizeMake(childScrollView.frame.size.width, row_Y)];
}
-(void)reloadFriends
{
    // REMOVE ALL SUBVIEWS
    for (id obj in friendScrollView.subviews)
        [obj removeFromSuperview];
    
    // ADD SUBVIEWS
    CGFloat rowHeight = 51.0;
    CGFloat rowWidth  = friendScrollView.frame.size.width;
    CGFloat row_X = 0.0;
    CGFloat row_Y = 0.0;
    
    UIView *row;
    UIImageView *imageView;
    UILabel *titleView;
    UIButton *btnCheckmark;
    
    for (int i=0; i<[arrAllFriendList count]; i++)
    {
        NSDictionary *detail = [arrAllFriendList objectAtIndex:i];
        row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
        row.tag = i;
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
        bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row.layer addSublayer:bottomBorder];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 36.0, 36.0)];
        
        NSURL *url = [detail valueForKey:@"profile_image"];
        [imageView setImageWithURL:url];
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row addSubview:imageView];
        
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, friendScrollView.frame.size.width-70.0, 50.0)];
        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:13.0];
        titleView.text = [detail valueForKey:@"firstname"];
        titleView.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        titleView.numberOfLines = 0;
        [row addSubview:titleView];
        [friendScrollView addSubview:row];
        row_Y = row_Y + 50.0;
        
        btnCheckmark=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCheckmark.tag=i;
        
        CGRect r = CGRectMake(0.0, 0.0, 17.0, 13.0);
        r.origin.x = CGRectGetMaxX(titleView.frame);
        r.origin.y = (CGRectGetHeight(row.frame) - CGRectGetHeight(r))/2.0;
        btnCheckmark = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCheckmark setFrame:r];
        [btnCheckmark setUserInteractionEnabled:FALSE];
        [row addSubview:btnCheckmark];
        for (NSString *strKey in [detail allKeys])
        {
            if ([strKey isEqualToString:@"checked"])
                if ([[detail valueForKey:@"checked"] isEqualToString:@"true"])
                    [btnCheckmark setImage:TICK_IMAGE forState:UIControlStateNormal];
        }
        UIGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getFriendInfo:)];
        [row addGestureRecognizer:tapGes];
    }
  [friendScrollView setContentSize:CGSizeMake(friendScrollView.frame.size.width, row_Y)];
}
-(void)getChildInfo:(UIGestureRecognizer *)gesture
{
    UIButton *clickedButton = nil;
    UIView *row = [gesture view];
    for (UIButton *btn in row.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            clickedButton = btn;
            break;
        }
    }
    for (UIView *vwTemp in childScrollView.subviews)
    {
        for (UIButton *btn in vwTemp.subviews)
        {
         if ([btn isKindOfClass:[UIButton class]])
           [btn setImage:nil forState:UIControlStateNormal];
        }
    }
   if (clickedButton)
    {
        if ([[clickedButton currentImage] isEqual:TICK_IMAGE])
            [clickedButton setImage:nil forState:UIControlStateNormal];
        else
            [clickedButton setImage:TICK_IMAGE forState:UIControlStateNormal];
    }
    
    // Remove previous friend list
    for (UIView *vwTemp in friendScrollView.subviews)
                      [vwTemp  removeFromSuperview];
    

// Call friend list from webser
    
        NSArray *arrTemp= [self checkedIndex:childScrollView];

 NSString *strChild_id=   [[arrAllChildList objectAtIndex: [[arrTemp objectAtIndex:0] integerValue]]valueForKey:PDWebChildId];

 
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(FriendListWebservice:) withObject:  strChild_id afterDelay:0.1];
    
  
}
#pragma mark gesture
-(void)getFriendInfo:(UIGestureRecognizer *)gesture
{
    UIButton *clickedButton = nil;
    UIView *row = [gesture view];
    for (UIButton *btn in row.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            clickedButton = btn;
            break;
       }
    }
    
    if (clickedButton)
    {
        if ([[clickedButton currentImage] isEqual:TICK_IMAGE])
            [clickedButton setImage:nil forState:UIControlStateNormal];
        else
            [clickedButton setImage:TICK_IMAGE forState:UIControlStateNormal];
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
            if ([subView isKindOfClass:[UIView class]])
            {
                rect = subView.frame;
                rect.origin.y += 20.0;
                subView.frame = rect;
            }
        }
    }
}
-(NSArray *)checkedIndex :(UIScrollView *)scrollView
{
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    UIButton *clickedButton = nil;
    for (UIView *row in scrollView.subviews)
    {
        for (UIButton *btn in row.subviews)
        {
            if ([btn isKindOfClass:[UIButton class]])
            {
                clickedButton = btn;
                break;
            }
        }
       if (clickedButton)
       {
           if ([[clickedButton currentImage] isEqual:TICK_IMAGE])
                 [indexes addObject:[NSString stringWithFormat:@"%ld", (long)row.tag]];
       }
    }
    return indexes;
}

#pragma mark webservice
-(void)ChildListWebservice
{
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    NSDictionary *params = @{PDWebGID:strGid};
    
    [[PDWebHandler sharedWebHandler]extendPermissionChildInfo_ListParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         id result = response;
         if ([result valueForKey:PDWebSuccess])
         {
             arrAllChildList=[response valueForKey:PDWebData];
             [self reloadChild];
        }
       else
             NSLog(@"%@",error.description);
         
        [[PDAppDelegate sharedDelegate]hideActivity];
     }];
}
-(void)FriendListWebservice:(NSString *)strChildid
{
    
        NSString *strurl= [NSString stringWithFormat:@"https://graph.facebook.com/v2.0/me/friends?fields=id,name,picture.type(large)&access_token=%@" ,[FBSession activeSession].accessTokenData.accessToken];
        
        NSURL *url = [NSURL URLWithString:strurl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        id friends_result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray  *friends_fb_ids = [[friends_result objectForKey:FBData] valueForKey:FBId];
        NSMutableString *str = [[NSMutableString alloc] init];
        [friends_fb_ids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
            [str appendFormat:@"'%@'", obj];
            [str appendString:@","];
        }];
        if (str.length > 0)
            [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];

     //   strFacebookFiriend_Id=str;

    
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];


    NSDictionary *params = @{@"friend_fbids": str,PDWebGID:strGid,PDWebChildId:strChildid};
        [[PDWebHandler sharedWebHandler]authFaciltygetParentList_ListParams:params];
        
        [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
         {
             id result = response;
              if  ([[response valueForKey:@"friendinfo"] isKindOfClass:[NSNull class]])
              {
                 NSLog(@"%@",error.description);
             //    [self ChildListWebservice];
             }
            else
             {
                 if  ([[response valueForKey:PDWebSuccess]integerValue] ==1)
                 {
                     btnSave.hidden=NO;
                     lblFriendList.hidden=NO;
                     friendScrollViewContainer.hidden=NO;
                     

                     
                 arrAllFriendList=nil;
                 arrAllFriendList=[[NSMutableArray alloc]init];
//                 NSArray *arrTemp = [response valueForKey:PDWebData];
//                 for (int i=0; i<[arrTemp count]; i++)
                   arrAllFriendList=[[result valueForKey:@"friendinfo"]mutableCopy];
                     [self reloadFriends];
                 }
            //    [self ChildListWebservice];
   
            }
             [[PDAppDelegate sharedDelegate]hideActivity];
         }];
}
-(void)ExtendPermissionWebservice
{
    
    
    NSArray *arrChildIndexes=[self checkedIndex:childScrollView];
    NSArray *arrFriendIndexes=[self checkedIndex:friendScrollView];
    NSMutableArray *arrSlectedChild_Id=[[NSMutableArray alloc]init];
    NSMutableArray *arrSlectedFriend_Id=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[arrChildIndexes count]; i++)
    {
        NSInteger index_No=[[arrChildIndexes objectAtIndex:i] integerValue];
        [arrSlectedChild_Id addObject:[[arrAllChildList objectAtIndex:index_No]valueForKey:PDWebChildId]];
    }
    for (int i=0; i<[arrFriendIndexes count]; i++)
    {
        NSInteger index_No=[[arrFriendIndexes objectAtIndex:i] integerValue];
        [arrSlectedFriend_Id addObject:[[arrAllFriendList objectAtIndex:index_No]valueForKey:PDWebGID]];
    }

    NSString *strChild_id= [arrSlectedChild_Id componentsJoinedByString:@","];
    NSString *strFriend_id= [arrSlectedFriend_Id componentsJoinedByString:@","];
    if (strFriend_id.length==0) {
        strFriend_id=@"";
    }


    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    NSDictionary *params = @{PDWebGID:strGid,PDWebChildId:strChild_id,@"friend_id":strFriend_id};
    [[PDWebHandler sharedWebHandler]extendPermissionToFriendandChild_ListParams:params];
    
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         id result = response;
         if ([[response valueForKey:PDWebSuccess] isKindOfClass:[NSNull class]])
         {
             NSLog(@"%@",error.description);
         }
         else
         {
            if ([[result valueForKey:PDWebSuccess]integerValue])
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Saved Sucessfully" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
          }
         [[PDAppDelegate sharedDelegate]hideActivity];
     }];

}
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PDMainViewController *mainViewController = [[PDMainViewController alloc] initWithNibName:@"PDMainViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:mainViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
}
@end
