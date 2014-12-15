//
//  PDSetsViewController.m
//  PlayDate
//
//  Created by Simpy on 18/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDSetsViewController.h"
#import "PDFriendListViewController.h"
#import "PDRequestArrangeViewController.h"
#import "PDMainViewController.h"
#import "PDCalenderViewController.h"
#import "UIImageView+WebCache.h"

#define TICK_IMAGE [UIImage imageNamed:@"blueTick"]

@interface PDSetsViewController ()
{
    BOOL fromNewSet;
    IBOutlet UILabel  *lblFriends;
    IBOutlet UILabel  *lblFriendCount;
    IBOutlet UILabel  *lblMembers;
    IBOutlet UIButton *btnView;
    
    
    IBOutlet UIView *dropDownView;

    IBOutlet UIView *childScrollViewContainer;
    IBOutlet UIScrollView *childScrollView;

    
   // IBOutlet UITableView *friendTbleVw;
    IBOutlet UITableView *allSetsTbleVw;
  //  IBOutlet UIView *vwNewSet;
    IBOutlet UITextField *txtSetName;

    
   // NSArray *arrTempSet;
    //NSArray           *friendsArray;
    NSMutableArray *arrAllFriendList;
   // NSArray   *arrTableData;
    
    NSMutableArray *arrSlectedFriends;
    NSArray *arrAllSets;
    NSString *strFacebookFiriend_Id;
    NSString *strSlectedSetName;
    BOOL editingEnable;
    NSString *strEdit_SetId;

    
    
}
-(IBAction)menuArrange:(id)sender;
-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;
@end

@implementation PDSetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    editingEnable=0;
    fromNewSet=0;
    childScrollViewContainer.layer.borderWidth = 5.0;
    childScrollViewContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    childScrollViewContainer.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    childScrollViewContainer.layer.shadowRadius = 2.0;
    childScrollViewContainer.layer.shadowOpacity = 0.5;

    arrAllFriendList=[[NSMutableArray alloc]init];
    arrSlectedFriends=[[NSMutableArray alloc]init];
    allSetsTbleVw.backgroundView = nil;
    allSetsTbleVw.backgroundColor = [UIColor clearColor];
    allSetsTbleVw.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    self.view.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor;
    [self.view addSubview:dropDownView];
    
  
    if ([[PDUser currentUser] hasDetail])
    {
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
        [self performSelector:@selector(callWebServices) withObject:nil afterDelay:0.1];
    }
    
    

    dropDownView.hidden = YES;
    [self setContentInsectOfEachTextField];
    [self setUpViewContents];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - iBoutlet Action
-(IBAction)viewAction:(id)sender
{
    PDFriendListViewController *friendListView = [[PDFriendListViewController alloc]initWithNibName:@"PDFriendListViewController" bundle:nil];
    friendListView.fromSet=1;
    [self.navigationController pushViewController:friendListView animated:YES];
}


#pragma mark - ibActions
-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
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
-(IBAction)btn_AddnewSet:(id)sender
{
    dropDownView.hidden = NO;
    txtSetName.text=@"";
    txtSetName.hidden=NO;
    fromNewSet=1;
     [self   reloadChild];
}
-(IBAction)btn_SaveEditSet:(id)sender
{
    arrSlectedFriends =nil;
    arrSlectedFriends=[[NSMutableArray alloc]init];
    NSArray *arrIndexTemp=[self checkedIndex];
    for (int i=0; i<[arrIndexTemp count]; i++)
    {
        int indexTemp=[[arrIndexTemp objectAtIndex:i]intValue];
        [arrSlectedFriends addObject:[[arrAllFriendList objectAtIndex:indexTemp] valueForKey:PDWebGID]];
    }
    if (editingEnable)
    {
         if([arrSlectedFriends count]==0)
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select at least one friend" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        
        else
        {
            [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
            [self saveEditSetInfo_WebServices];
        }

    }
    else
    {
      if (txtSetName.text.length==0)
      {
       [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter name of set" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
          return;
      }
    else if([arrSlectedFriends count]==0)
    {
          [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select at least one friend" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        return;
    }
        
    else
    {
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
        [self saveWebservice];
    }
  }
     [self allSetsWebServices];
     txtSetName.hidden=NO;
     txtSetName.text=@"";
     dropDownView.hidden = YES;

}

#pragma mark tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return  [arrAllSets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 58.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *subView in [cell.contentView subviews])
        [subView removeFromSuperview];
    cell.backgroundColor=[UIColor clearColor];

        UIView *vwBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 307, 57)];
        vwBg.backgroundColor=[UIColor whiteColor];
        UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 62, 29)];
        lblName.text =[[NSString stringWithFormat:@"%@",[[arrAllSets objectAtIndex:indexPath.row] valueForKey:PDWebSetName]]uppercaseString];
        lblName.textColor =[UIColor blackColor];
        lblName.font =[[PDHelper sharedHelper] applicationFontWithSize:13.0];
        lblName.numberOfLines=0;
        [lblName sizeToFit];
        
    
        [vwBg addSubview:lblName];
        [cell.contentView addSubview:vwBg];
        UIButton *btnViewFriendList=[UIButton buttonWithType:UIButtonTypeCustom];
        btnViewFriendList.frame=CGRectMake(72, 14, 70, 30);
        btnViewFriendList.backgroundColor=[UIColor colorWithRed:0/255.0 green:151/255.0 blue:220.0/255 alpha:1.0];
        [btnViewFriendList setTitle:@"View" forState:UIControlStateNormal];
        btnViewFriendList.titleLabel.font =[[PDHelper sharedHelper] applicationFontWithSize:15.0];

        [btnViewFriendList setTag:(int)indexPath.row];
        [btnViewFriendList addTarget:self action:@selector(btnActionViewSetmembers:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnEditFriendList=[UIButton buttonWithType:UIButtonTypeCustom];
    btnEditFriendList.frame=CGRectMake(150, 14, 70, 30);
    btnEditFriendList.backgroundColor=[[PDHelper sharedHelper]applicationThemeGreenColor];
    [btnEditFriendList setTitle:@"Edit" forState:UIControlStateNormal];
    btnEditFriendList.titleLabel.font =[[PDHelper sharedHelper] applicationFontWithSize:15.0];
    [btnEditFriendList setTag:(int)indexPath.row];
    [btnEditFriendList addTarget:self action:@selector(btnActionEditSlectedSet:) forControlEvents:UIControlEventTouchUpInside];
    
    
        UILabel *lblMemberNo = [[UILabel alloc]initWithFrame:CGRectMake(230, 10, 57, 21)];
        lblMemberNo.text =[[NSString stringWithFormat:@"%@",[[arrAllSets objectAtIndex:indexPath.row] valueForKey:@"total_count"]]uppercaseString];
        lblMemberNo.textColor =[UIColor blackColor];
        lblMemberNo.font =[[PDHelper sharedHelper] applicationFontWithSize:13.0];
        lblMemberNo.numberOfLines=0;
        [lblMemberNo setTextAlignment:NSTextAlignmentCenter];
       // [lblMemberNo sizeToFit];
        
        UILabel *lblMember = [[UILabel alloc]initWithFrame:CGRectMake(230, 30, 57, 13)];
        lblMember.text =@"Members";
        lblMember.textColor =[UIColor blackColor];
        lblMember.font =[[PDHelper sharedHelper] applicationFontWithSize:13.0];
        lblMember.numberOfLines=0;
        [lblMember sizeToFit];
        UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(0, 57.0, 320, 1)];
        vw.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255 blue:170.0/255 alpha:0.36];
    
    
       NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    if ([[[arrAllSets objectAtIndex:indexPath.row] valueForKey:PDWebGID] isEqualToString:strGid])
    {
        
       
              [vwBg addSubview:btnEditFriendList];
    }
    else
    {
             btnViewFriendList.frame=CGRectMake(110, 14, 70, 30);
    }
  
        [vwBg addSubview:btnViewFriendList];
        [vwBg addSubview:lblMember];
        [vwBg addSubview:lblMemberNo];
        [vwBg addSubview:lblName];
    
        [cell.contentView addSubview:vwBg];
        [cell.contentView addSubview:vw];

        return cell;
}

#pragma mark gestureDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ((touch.view == dropDownView)||(touch.view==dropDownSubView))
//    {
//        editingEnable=0;
//        txtSetName.hidden=NO;
//        return 1;
//    }
//       return  0;
//}

#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseStringWithLocale:[NSLocale currentLocale]]];
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return 1;
}
#pragma mark self method

-(IBAction)dismissView
{
    dropDownView.hidden = YES;
    [txtSetName resignFirstResponder];
    
}
-(void)getChildInfo:(UIGestureRecognizer *)gesture
{
    UIButton *clickedButton = nil;
    UIView *row = [gesture view];
    for (UIButton *btn in row.subviews) {
        if ([btn isKindOfClass:[UIButton class]])
        {
            clickedButton = btn;
            break;
        }
    }
    
    if (clickedButton) {
        
        if ([[clickedButton currentImage] isEqual:TICK_IMAGE])
            [clickedButton setImage:nil forState:UIControlStateNormal];
        else
             [clickedButton setImage:TICK_IMAGE forState:UIControlStateNormal];
    }
}
-(NSArray *)checkedIndex
{
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    UIButton *clickedButton = nil;
    for (UIView *row in childScrollView.subviews)
    {
        for (UIButton *btn in row.subviews) {
            if ([btn isKindOfClass:[UIButton class]])
            {
                clickedButton = btn;
                break;
            }
        }
        
        if (clickedButton) {
            
            if ([[clickedButton currentImage] isEqual:TICK_IMAGE])
            {
                [indexes addObject:[NSString stringWithFormat:@"%ld", (long)row.tag]];
            }
        }
    }
    return indexes;
}

-(void)btnActionEditSlectedSet:(UIButton*)btn
{
    strEdit_SetId=  [[arrAllSets objectAtIndex:btn.tag] valueForKey:PDWebSetID];
    txtSetName.text= [[arrAllSets objectAtIndex:btn.tag] valueForKey:@"name"];
    editingEnable=1;
    txtSetName.hidden=YES;
    
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(slectedSetInfo_WebServices) withObject:nil afterDelay:0.1];

}
-(void)btnActionViewSetmembers:(UIButton*)btn
{
    PDFriendListViewController *friendListView = [[PDFriendListViewController alloc]initWithNibName:@"PDFriendListViewController" bundle:nil];
    friendListView.fromSet=1;
    friendListView.strSet_Id=[[arrAllSets objectAtIndex:btn.tag] valueForKey:PDWebSetID];
    friendListView.strFacebook_Ids=strFacebookFiriend_Id;
    [self.navigationController pushViewController:friendListView animated:YES];
}
-(void)setContentInsectOfEachTextField
{
    
    
    for (UITextField *tF in dropDownView.subviews)
    {
        if ([tF isKindOfClass:[UITextField class]])
        {
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, tF.frame.size.height)];
            leftView.backgroundColor = tF.backgroundColor;
            tF.leftView = leftView;
            tF.leftViewMode = UITextFieldViewModeAlways;
        }
    }
}

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
        
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, childScrollView.frame.size.width-70.0, 50.0)];
        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:13.0];
        titleView.text = [detail valueForKey:@"name"];
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
        btnCheckmark = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCheckmark setFrame:r];
        [btnCheckmark setUserInteractionEnabled:FALSE];
        [row addSubview:btnCheckmark];
        
        if (!fromNewSet)
       {
        for (NSString *strKey in [detail allKeys])
        {
            if ([strKey isEqualToString:@"checked"])
               if ([[detail valueForKey:@"checked"] isEqualToString:@"true"])
                 [btnCheckmark setImage:TICK_IMAGE forState:UIControlStateNormal];
        }
       }
        
        UIGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getChildInfo:)];
        [row addGestureRecognizer:tapGes];
        
    }
    
    [childScrollView setContentSize:CGSizeMake(childScrollView.frame.size.width, row_Y)];
    if (fromNewSet)
       fromNewSet=0;
    
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
#pragma mark WebService method
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
    if (str.length > 0)
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    
    strFacebookFiriend_Id=str;
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
             [self allSetsWebServices];
         }
         else
         {
             NSLog(@"%@",[response valueForKey:PDWebData]);
            NSArray *arrTemp = [response valueForKey:PDWebData];
             
             for (int i=0; i<[arrTemp count]; i++)
                 [arrAllFriendList addObject:[[arrTemp objectAtIndex:i] valueForKey:@"friendinfo"]];

            NSString *count =  [NSString stringWithFormat:@"%lu", (unsigned long)[arrTemp count]];
             lblFriendCount.text = count;
             [self allSetsWebServices];
         }
         [[PDAppDelegate sharedDelegate]hideActivity];
     }];
}
-(void)allSetsWebServices
{
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    
    NSDictionary *params = @{PDWebGID:strGid};
    
    [[PDWebHandler sharedWebHandler]allSetsListParams:params];
    
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         id result = response;
         
         if ([result valueForKey:PDWebSuccess]  )
         {
             NSArray *arrTemp=[response valueForKey:PDWebData];
             if ([arrTemp count]!=0)
             {
                 arrAllSets=arrTemp;
                 [allSetsTbleVw reloadData];
             }
       }
         else
            NSLog(@"%@",error.description);
     [[PDAppDelegate sharedDelegate]hideActivity];
     }];
    
}
-(void)saveWebservice
{
    NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    
 //   NSString *strFriend_id=[arrSlectedFriends componentsJoinedByString:@","];
    NSMutableString *strFriend_id=[[NSMutableString alloc]init];
    
    [arrSlectedFriends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [strFriend_id appendFormat:@"'%@'", obj];
        [strFriend_id appendString:@","];
        
    }];
    if (strFriend_id.length > 0){
        [strFriend_id deleteCharactersInRange:NSMakeRange(strFriend_id.length-1, 1)];
    }

    
    NSDictionary *params = @{PDWebSetName: txtSetName.text,@"friend_id":strFriend_id,PDWebGID:strGid};
    
    [[PDWebHandler sharedWebHandler]addCreateNewSetListParams:params];
    
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         id result = response;
         NSString *strval = [NSString stringWithString: [result valueForKey:@"msg"]];
         NSLog(@"%@",strval);
         if ([response valueForKey:PDWebSuccess])
         {
             
             
             [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"New set created sucessfully" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
             [[PDAppDelegate sharedDelegate]hideActivity];
             
         }
         else
            NSLog(@"%@",error.description);
   
         [[PDAppDelegate sharedDelegate]hideActivity];
     }];
    
}

-(void)slectedSetInfo_WebServices
{
    NSDictionary *params = @{PDWebSetID: strEdit_SetId,@"friend_id":strFacebookFiriend_Id};
    [[PDWebHandler sharedWebHandler]setDetail_For_Editing_ListParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         id result = response;
         
         if ([result valueForKey:PDWebSuccess] )
         {
             NSArray *arrTemp = [response valueForKey:PDWebData];
             
             arrAllFriendList =nil;
             arrAllFriendList=[[NSMutableArray alloc]init];
             for (int i=0; i<[arrTemp count]; i++)
             [arrAllFriendList addObject:[[arrTemp objectAtIndex:i] valueForKey:@"friendinfo"]];
         }
             
      else
         {
             NSLog(@"%@",error.description);
         }
         dropDownView.hidden = NO;
 
         [self   reloadChild];

         [[PDAppDelegate sharedDelegate]hideActivity];
     }];
    
}
-(void)saveEditSetInfo_WebServices
{
    
    NSString *strFriend_id=[arrSlectedFriends componentsJoinedByString:@","];
     NSDictionary *params = @{PDWebSetID: strEdit_SetId,@"friend_fbid":strFriend_id};
    [[PDWebHandler sharedWebHandler]saveEditSet_ListParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         id result = response;
         
         if ([result valueForKey:PDWebSuccess]  )
         {

         }
         
         else
         {
             NSLog(@"%@",error.description);
         }
         dropDownView.hidden = NO;
         txtSetName.text=@"";
         [self   reloadChild];
         editingEnable=NO;
         [[PDAppDelegate sharedDelegate]hideActivity];
     }];
    
}

@end
