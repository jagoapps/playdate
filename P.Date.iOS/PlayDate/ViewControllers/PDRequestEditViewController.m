//
//  PDRequestArrangeViewController.m
//  PlayDate
//
//  Created by Simpy on 10/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDRequestEditViewController.h"
#import "PDDateTimePicker.h"
#import "UIImageView+WebCache.h"
#import "PDCalenderViewController.h"
#import "PDMainViewController.h"
#import "vwAdditionalChild.h"
#define CancelImage [UIImage imageNamed:@"Cancel_button"]
@interface PDRequestEditViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *dropDownView;
 //   IBOutlet UIButton *saveBtn;
    IBOutlet UIButton *sendBtn;
    IBOutlet UILabel *tfChildName;
    IBOutlet UILabel *tfGuardianFrndChildName;
    IBOutlet UIImageView *imgVwGuardianFrndChildName;
    IBOutlet UIImageView *imgVwChildName;

    
    IBOutlet UIButton    *alternateButton;
    IBOutlet UITextField *tfDate1;
    IBOutlet UITextField *tfDate2;
    IBOutlet UITextField *tfDate3;
    IBOutlet UITextField *tfDate4;
    IBOutlet UITextField *tfStartTime1;
    IBOutlet UITextField *tfStartTime2;
    IBOutlet UITextField *tfStartTime3;
    IBOutlet UITextField *tfStartTime4;
    IBOutlet UITextField *tfEndTime1;
    IBOutlet UITextField *tfEndTime2;
    IBOutlet UITextField *tfEndTime3;
    IBOutlet UITextField *tfEndTime4;
    IBOutlet UITextView *tfLocation;
    IBOutlet UITextView *tVNotes;
    
    IBOutlet UIView *containerView;
    IBOutlet UILabel *lblChild;
    IBOutlet UIView *vwBackView;

    IBOutlet UIView *vwChildDetail;
    ///
    IBOutlet UILabel  *lblName;
    IBOutlet UILabel  *lblDob;
    
    IBOutlet UILabel *lblFreetime;
    IBOutlet UIView *vwFreetime;
    
    IBOutlet UILabel *lblAllergies;;
    IBOutlet UIView *vwAllergies;
    IBOutlet UILabel *lblHobbies;
    IBOutlet UIView *vwHobbies;
    IBOutlet UIView *vwSchool;
    IBOutlet UIView *vwYouthClub;
    IBOutlet UILabel  *lblSchool;
    IBOutlet UILabel *lblYouthclub;
    IBOutlet UIScrollView  *scollvw;
    
    PDDateTimePicker *datePicker;
    PDDateTimePicker *freeTimePicker;

    NSArray *child;
    NSArray *friendChild;
    UITapGestureRecognizer *tapOnDropDown;
    UITapGestureRecognizer *tapOnRow;
    NSInteger index;
    BOOL getChild;
    BOOL firstClicked;
    BOOL secondClicked;
    BOOL thirdClicked;
    BOOL anyOneClick;
    BOOL anyOneClickTime;
    NSArray *arrFriendChild;
    NSArray *arrChild;
    NSArray *arrTableData;
    
    NSString *str_Me_slected_Childname;
    NSString *str_Friend_slected_Childname;
    
    NSString *str_Me_slected_Child_Id;
    NSMutableString *str_Friend_slected_Child_Id;
    NSMutableString *str_Friend_slected_Child_g_id;

    
    NSString *str_Whilch_childtable_open;
    
    int  str_Whilch_FriendchildtagNo;
    

    
    IBOutlet UIView *childScrollViewContainer;
    IBOutlet UIScrollView *childScrollView;
    
  

    NSString *strEventId;
    NSDictionary *dictSlectd_ChildInfo;
    NSDictionary *dictSlectdFriend_ChildInfo;
    

    
    

 
     IBOutlet UIView *vwFriendChild;
//  
//    NSMutableArray *arrVwFriendChild_Add;
//    NSMutableArray *arrVwFriendChild_Add_ID;
//     NSMutableArray *arrVwFriendChild_Add_Name;
//      NSMutableArray *arrVwFriendChild_Add_G_ID;

    IBOutlet UILabel *lblownPlayerName1;
    
    IBOutlet  UILabel *lblownCopyPlayerName1;
    IBOutlet UIImageView *imgPlayer1;
    IBOutlet UIImageView *imgPlayer2;
//    IBOutlet UIScrollView *scrollVwFriendImages;
    
    IBOutlet  UILabel *lblfriendPlayerName2;
    NSMutableArray *arrAllOtherChilds;
    NSMutableArray *arrAllOwnerChilds;
}

@end

@implementation PDRequestEditViewController

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
    
    
    arrAllOwnerChilds=[[NSMutableArray alloc]init];
    arrAllOtherChilds=[[NSMutableArray alloc]init];
//    
//    arrVwFriendChild_Add=[[NSMutableArray alloc]init];
//    arrVwFriendChild_Add_ID=[[NSMutableArray alloc]init];
//    arrVwFriendChild_Add_Name=[[NSMutableArray alloc]init];
//    arrVwFriendChild_Add_G_ID=[[NSMutableArray alloc]init];

    arrFriendChild=[[NSArray alloc]init];
    arrTableData=[[NSArray alloc]init];
    arrChild=[[NSArray alloc]init];
    tfChildName.enabled = NO;
    tfGuardianFrndChildName.enabled = NO;
    // Do any additional setup after loading the view from its nib.
    [self setContentInsectOfEachTextField];
    [self.view addSubview:dropDownView];
    
 
    
    
    [alternateButton setUserInteractionEnabled:YES];
    firstClicked = NO;
    secondClicked = NO;
    thirdClicked = NO;
    anyOneClick = NO;
    dropDownView.hidden = YES;
    anyOneClickTime = NO;

    
    childScrollViewContainer.layer.borderWidth = 5.0;
    childScrollViewContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    childScrollViewContainer.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    childScrollViewContainer.layer.shadowRadius = 2.0;
    childScrollViewContainer.layer.shadowOpacity = 0.5;

    
    [tfDate2 setHidden:YES];
    [tfDate3 setHidden:YES];
    [tfDate4 setHidden:YES];
    [tfEndTime2 setHidden:YES];
    [tfEndTime3 setHidden:YES];
    [tfEndTime4 setHidden:YES];
    [tfStartTime2 setHidden:YES];
    [tfStartTime3 setHidden:YES];
    [tfStartTime4 setHidden:YES];
    
    // DATE PICKER && FREE TIME PICKER
    datePicker = [[PDDateTimePicker alloc] initWithType:PDPickerTypeDate];
    freeTimePicker = [[PDDateTimePicker alloc] initWithType:PDPickerTypeFreeTime];

    
    // DONE BUTTON INPUT VIEW FOR PHONE NUMBER PAD
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    inputView.backgroundColor = [PDHelper sharedHelper].applicationThemeBlueColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(260.0, 0.0, 60.0, 40.0)];
    [btn setTitle:@"Done" forState:UIControlStateNormal];
    [inputView addSubview:btn];
    [btn addTarget:self action:@selector(resignPhonePad) forControlEvents:UIControlEventTouchUpInside];
    
    tfLocation.inputAccessoryView = inputView;
    tVNotes.inputAccessoryView = inputView;


    
        
        
        //receiver_id
//        btn_friend_child.enabled=NO;
//        btn_our_child.enabled=NO;
        NSLog(@"%@",[self.dictEventInfo_edit valueForKey:@"date"]);

        NSString *strdate=[self.dictEventInfo_edit valueForKey:@"date"];
        NSDateFormatter *format =[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date = [format dateFromString:strdate];
       [format setDateFormat:@"dd-MMMM-yyyy"];
        NSString *strSetDate=[format stringFromDate:date];
        NSLog(@"%@",strSetDate);
        

        
            NSLog(@"%@",self.dictEventInfo_edit);
        
              //// check who is sender
    //    NSString *str_id=[self.dictEventInfo_edit valueForKey:@"senderid"];

      //  NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
        
//        if ([str_id isEqualToString:strGid])// if event onwer is same
//        {
//            
//          tfChildName.text=[self.dictEventInfo_edit valueForKey:@"child_name"];
//          [imgVwChildName setImageWithURL:[self.dictEventInfo_edit valueForKey:@"profile_image"] placeholderImage:[UIImage imageNamed:@"user_img"]];
//            str_Me_slected_Child_Id=[self.dictEventInfo_edit valueForKey:@"Child_id"];
//
//           NSArray *arrTemp=[self.dictEventInfo_edit valueForKey:@"finfo"];
//            
//            for (int i=0; i<[arrTemp count]; i++)
//            {
//                if (i==0)
//                {
//               
//                    tfGuardianFrndChildName.text=[[arrTemp objectAtIndex:i]valueForKey:@"friendname"];
//                    
//                    str_Friend_slected_Childname= [[arrTemp objectAtIndex:i]valueForKey:@"friendname"];
//
//                    str_Friend_slected_Child_Id= [[arrTemp objectAtIndex:i]valueForKey:@"friend_child_id"];
//
//                    str_Friend_slected_Child_g_id=[[arrTemp objectAtIndex:i]valueForKey:@"friend_g_id"];
//                    
//
//                }
//                
//              else
//              {
//
//                  
////                  [arrVwFriendChild_Add_ID addObject:[[arrTemp objectAtIndex:i]valueForKey:@"friend_child_id"]];
////                  [arrVwFriendChild_Add_G_ID addObject:[[arrTemp objectAtIndex:i]valueForKey:@"friend_g_id"]];
////                  [arrVwFriendChild_Add_Name addObject: [[arrTemp objectAtIndex:i]valueForKey:@"friendname"]];
//                  
//                  
//              }
//                
//            }
//        }
//       else
//       {
//           tfGuardianFrndChildName.text=[self.dictEventInfo_edit valueForKey:@"child_name"];
//           
//           str_Friend_slected_Childname=[self.dictEventInfo_edit valueForKey:@"child_name"];
//           str_Friend_slected_Child_Id= [self.dictEventInfo_edit valueForKey:@"Child_id"];
//           
//           str_Friend_slected_Child_g_id=[self.dictEventInfo_edit valueForKey:@"senderid"];
//           
//           [imgVwGuardianFrndChildName setImageWithURL:[self.dictEventInfo_edit valueForKey:@"profile_image"] placeholderImage:[UIImage imageNamed:@"user_img"]];
//           
//           NSArray *arrTemp=[self.dictEventInfo_edit valueForKey:@"finfo"];
//           
//           for (int i=0; i<[arrTemp count]; i++)
//           {
//               
//               
//               if ([strGid isEqualToString:[[arrTemp objectAtIndex:i]valueForKey:@"friend_g_id"]])
//               {
//                   tfChildName.text=[[arrTemp objectAtIndex:i]valueForKey:@"friendname"];
//                   [imgVwChildName setImageWithURL:[[arrTemp objectAtIndex:i]valueForKey:@"friend_profile_image"] placeholderImage:[UIImage imageNamed:@"user_img"]];
//                   str_Me_slected_Child_Id=[[arrTemp objectAtIndex:i]valueForKey:@"friend_child_id"];
//                   
//               }
//               else
//               {
//                   [arrVwFriendChild_Add_ID addObject:[[arrTemp objectAtIndex:i]valueForKey:@"friend_child_id"]];
//                   [arrVwFriendChild_Add_G_ID addObject:[[arrTemp objectAtIndex:i]valueForKey:@"friend_g_id"]];
//                   [arrVwFriendChild_Add_Name addObject: [[arrTemp objectAtIndex:i]valueForKey:@"friendname"]];
//               }
//               
//               
//           }
//           
//
//       }
    
   

//    [self ShowAll_Childs];
    [imgPlayer1 setImageWithURL:[self.dictEventInfo_edit valueForKey:@"profile_image"] placeholderImage:[UIImage imageNamed:@"user_img"]];
     [imgPlayer2 setImageWithURL:[self.dictEventInfo_edit valueForKey:@"friend_profile_image"] placeholderImage:[UIImage imageNamed:@"user_img"]];
    lblownPlayerName1.text =[[self.dictEventInfo_edit valueForKey:@"child_name"]uppercaseString];
    lblfriendPlayerName2.text=[[self.dictEventInfo_edit valueForKey:@"friendname"]uppercaseString];
        tfLocation.text=[self.dictEventInfo_edit valueForKey:@"location"];
        tVNotes.text=[self.dictEventInfo_edit valueForKey:@"notes"];
        tfStartTime1.text=[self.dictEventInfo_edit valueForKey:@"Starttime"];
        tfDate1.text=strSetDate;
        tfEndTime1.text=[self.dictEventInfo_edit valueForKey:@"endtime"];
         strEventId=[self.dictEventInfo_edit valueForKey:@"Eventid"];

        if ([tVNotes.text isEqualToString:@"NOTES"])
            tVNotes.textColor =[UIColor lightGrayColor];
        else
            tVNotes.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        if ([tfLocation.text isEqualToString:@"LOCATION"])
            tfLocation.textColor =[UIColor lightGrayColor];
        else
            tfLocation.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];

      

        NSString *strStartTime1= [self.dictEventInfo_edit valueForKey:@"Starttime1"];
        if (strStartTime1.length!=0)   // start date1 then
        {
            
            NSString *strdate=[self.dictEventInfo_edit valueForKey:@"date1"];
            NSDateFormatter *format =[[NSDateFormatter alloc]init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *date = [format dateFromString:strdate];
            [format setDateFormat:@"dd-MMMM-yyyy"];
            NSString *strSetDate=[format stringFromDate:date];
            NSLog(@"%@",strSetDate);
            
            tfStartTime2.text=[self.dictEventInfo_edit valueForKey:@"Starttime1"];
            tfDate2.text=strSetDate;
            tfEndTime2.text=[self.dictEventInfo_edit valueForKey:@"endtime1"];
            firstClicked=YES;
            [self firstAlternateClick];
            secondClicked = YES;
        }
        
        NSString *strStartTime2=  [self.dictEventInfo_edit valueForKey:@"Starttime2"];
        if (strStartTime2.length!=0)
        {
            
            NSString *strdate=[self.dictEventInfo_edit valueForKey:@"date2"];
            NSDateFormatter *format =[[NSDateFormatter alloc]init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *date = [format dateFromString:strdate];
            [format setDateFormat:@"dd-MMMM-yyyy"];
            NSString *strSetDate=[format stringFromDate:date];
            NSLog(@"%@",strSetDate);

            tfStartTime3.text=[self.dictEventInfo_edit valueForKey:@"Starttime2"];
            tfDate3.text=strSetDate;
            tfEndTime3.text=[self.dictEventInfo_edit valueForKey:@"endtime2"];

            secondClicked=YES;
         
            [self secondAlternateClick];
               thirdClicked=NO;
        }
        NSString *strStartTime3=  [self.dictEventInfo_edit valueForKey:@"Starttime3"];
        if (strStartTime3.length!=0)
        {
            
            
            NSString *strdate=[self.dictEventInfo_edit valueForKey:@"date3"];
            NSDateFormatter *format =[[NSDateFormatter alloc]init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *date = [format dateFromString:strdate];
            [format setDateFormat:@"dd-MMMM-yyyy"];
            NSString *strSetDate=[format stringFromDate:date];
            NSLog(@"%@",strSetDate);

            tfStartTime4.text=[self.dictEventInfo_edit valueForKey:@"Starttime3"];
            tfDate4.text=strSetDate;
            tfEndTime4.text=[self.dictEventInfo_edit valueForKey:@"endtime3"];

            thirdClicked=YES;
            
            [self thirdAlternateClick];
        }
  


        [self Adjust_Size_height_EditInfo];
        

  
 [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
    
    
       [self setUpViewContents];
        // Getrure
    
    UITapGestureRecognizer *gestureVwRemove=[[UITapGestureRecognizer alloc]init];
    [gestureVwRemove addTarget:self action:@selector(gestureActionChildDetail_VWRemove:)];
    
    [vwChildDetail addGestureRecognizer:gestureVwRemove];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    if (!firstClicked)
    {
        [self setUpView];
        
        
        // chage for showing save button in  edit
        CGRect rect;
        rect=tfLocation.frame;
        rect.origin.y =CGRectGetMaxY(alternateButton.frame)+10.0;
        tfLocation.frame=rect;
        
        CGFloat fixedWidth = tfLocation.frame.size.width;
        CGSize newSize = [tfLocation sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = tfLocation.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        tfLocation.frame = newFrame;
       
        
        rect=tVNotes.frame;
        rect.origin.y =CGRectGetMaxY(tfLocation.frame)+10.0;
        tVNotes.frame=rect;
        
        
        CGFloat fixedWidthtVNotes = tVNotes.frame.size.width;
        CGSize newSizetVNotes = [tVNotes sizeThatFits:CGSizeMake(fixedWidthtVNotes, MAXFLOAT)];
        CGRect newFrametVNotes= tVNotes.frame;
        newFrametVNotes.size = CGSizeMake(fmaxf(newSizetVNotes.width, fixedWidthtVNotes), newSizetVNotes.height);
        tVNotes.frame = newFrametVNotes;
        
        rect=containerView.frame;
        rect.size.height =CGRectGetMaxY(tVNotes.frame)+15.0;
        containerView.frame=rect;
        
        rect=   sendBtn.frame;
        rect.origin.y =  CGRectGetMaxY(containerView.frame)+20;
        sendBtn.frame =rect;
       [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
//        [self setUpViewContents];
        ///////////
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)ShowAll_Childs
//{
//    NSMutableDictionary *dictOwerChildTemp=[[NSMutableDictionary alloc]initWithDictionary:self.dictEventInfo_edit];
//    [dictOwerChildTemp removeObjectForKey:@"finfo"];
//    
//    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
//    [arrTemp addObject:[self.dictEventInfo_edit valueForKey:@"finfo"]];
//    
//    [arrAllOwnerChilds addObject:dictOwerChildTemp];
//    [arrAllOtherChilds addObjectsFromArray:[self.dictEventInfo_edit valueForKey:@"finfo"]];
//
//    
//    
//    
//    
//    lblownPlayerName1.text =[[[arrAllOwnerChilds objectAtIndex:0]valueForKey:@"child_name"]uppercaseString];
//    lblownCopyPlayerName1.text=[[[arrAllOwnerChilds objectAtIndex:0]valueForKey:@"child_name"]uppercaseString];
//    
//    UIImage *imgPlaceHolder=[UIImage imageNamed:@"user_img"];
//    
//    [imgPlayer1 setImageWithURL:[NSURL URLWithString:[[arrAllOwnerChilds objectAtIndex:0]valueForKey:PDWebProfileImage]] placeholderImage:imgPlaceHolder];
//    
//    UITapGestureRecognizer *gestureImgVw_EventOwnerChildInfo=[[UITapGestureRecognizer alloc]init];
//    [gestureImgVw_EventOwnerChildInfo addTarget:self action:@selector(gestureAction_EventOwnerChildInfo:)];
//    
//    [imgPlayer1 addGestureRecognizer:gestureImgVw_EventOwnerChildInfo];
//    
//  
//    
//  //  int xCordinateImagVWAccepted=0;
//    
// //   NSMutableString *strFriendChildname=[[NSMutableString alloc]init];
////    for (int i=0; i<[arrAllOtherChilds count]; i++)
////    {
////        UIImageView *imgvwTemp=[[UIImageView alloc]initWithFrame:CGRectMake(xCordinateImagVWAccepted,1, 65, 65)];
////        imgvwTemp.contentMode = UIViewContentModeScaleAspectFit;
////        imgvwTemp.userInteractionEnabled=YES;
////        [imgvwTemp setImageWithURL:[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friend_profile_image"] placeholderImage:imgPlaceHolder];
////        imgvwTemp.tag=i;
////        
////        UILabel *lblNameFriendchildName=[[UILabel alloc]initWithFrame:CGRectMake(xCordinateImagVWAccepted,63, 65,22)];
////        lblNameFriendchildName.font=[UIFont fontWithName:@"GillSans" size:11.0];
////        //     strFriendChildname=[strFriendChildname stringByAppendingFormat:@"%@ %@",strFriendChildname,[[arrFriendChild objectAtIndex:i]valueForKey:@"friendname"]];
////        
////        
////        [strFriendChildname appendString:[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friendname"]];
////        [strFriendChildname appendString:@","];
////        
////        
////        lblNameFriendchildName.text=[[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friendname"] uppercaseString];
////        
////        
////        lblNameFriendchildName.backgroundColor=[UIColor clearColor];
////        lblNameFriendchildName.textColor=[UIColor blackColor];
////        lblNameFriendchildName.textAlignment=NSTextAlignmentCenter;
////        
////        
////        [scrollVwFriendImages addSubview:imgvwTemp];
////        [scrollVwFriendImages addSubview:lblNameFriendchildName];
////        [scrollVwFriendImages setContentSize:CGSizeMake(xCordinateImagVWAccepted, 89)];
////        
////        xCordinateImagVWAccepted=xCordinateImagVWAccepted+65+8;
////        
////        
////        
////        UITapGestureRecognizer *gestureImgVwGuardianFrndChildInfo=[[UITapGestureRecognizer alloc]init];
////        [gestureImgVwGuardianFrndChildInfo addTarget:self action:@selector(gestureAction_OtherChildInfo:)];
////        
////        [imgvwTemp addGestureRecognizer:gestureImgVwGuardianFrndChildInfo];
////        
////        
////    }
//    
// //   lblfriendPlayerName2.text=[[strFriendChildname substringToIndex:[strFriendChildname length]-1]uppercaseString];
//  
//    
//}
-(void)dismissView
{
    dropDownView.hidden = YES;
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,CGRectGetMaxY(sendBtn.frame)+40.0)];

}



#pragma mark - Reload Childs
//-(void)reloadChilds
//{
//
//    CGFloat row_Y = 0.0;
//    
//    UIView *row;
//  
//    UILabel *titleView;
//    
//    if (getChild) {
//        for (int i=0; i<[child count]; i++)
//        {
//        ///    NSLog(@"%d",index);
//            index = i;
//            NSDictionary *detail = [child objectAtIndex:i];
//            
//          //  row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
//            
//            CALayer *bottomBorder = [CALayer layer];
//       //     bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
//            bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
//            [row.layer addSublayer:bottomBorder];
//            
//            
//      //      titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, dropDownScrollView.frame.size.width-55.0, 50.0)];
//            titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:13.0];
//            titleView.text = [detail objectForKey:PDWebChildName];
//            titleView.textColor =[UIColor blackColor];
//            titleView.numberOfLines = 0;
//            [row addSubview:titleView];
//         //   [dropDownScrollView addSubview:row];
//            row_Y = row_Y + 50.0;
//            tapOnRow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rowClickAtindex)];
//            [row addGestureRecognizer:tapOnRow];
//        }
//
//    }
//    else
//    {
//        for (int i=0; i<[friendChild count]; i++)
//        {
//            
//            index = i;
//            
//            NSDictionary *detail = [friendChild objectAtIndex:i];
//            
//         //   row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
//            
//            CALayer *bottomBorder = [CALayer layer];
//      //      bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
//            bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
//            [row.layer addSublayer:bottomBorder];
//            
//            
//        //    titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, dropDownScrollView.frame.size.width-55.0, 50.0)];
//            titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:13.0];
//            titleView.text = [detail objectForKey:PDWebChildName];
//            titleView.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
//            titleView.numberOfLines = 0;
//            [row addSubview:titleView];
//         //   [dropDownScrollView addSubview:row];
//            row_Y = row_Y + 50.0;
//            tapOnRow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rowClickAtindex)];
//            [row addGestureRecognizer:tapOnRow];
//        }
//
//    }
//    
//   // [dropDownScrollView setContentSize:CGSizeMake(dropDownScrollView.frame.size.width, row_Y)];
//    
//}

-(void)rowClickAtindex
{
   
    tfChildName.text = [[child objectAtIndex:index] objectForKey:@"Childname"];
    tfGuardianFrndChildName.text = [[friendChild objectAtIndex:index]objectForKey:@"Childname"];
}

-(void)setContentInsectOfEachTextField
{
    for (UITextField *tF in containerView.subviews)
    {
        if ([tF isKindOfClass:[UITextField class]]) {
            
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, tF.frame.size.height)];
            leftView.backgroundColor = tF.backgroundColor;
            tF.leftView = leftView;
            tF.leftViewMode = UITextFieldViewModeAlways;
        }
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
    
    rect = scrollView.frame;

    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
}

-(void)setUpView
{
    
    CGRect rect=alternateButton.frame;
    rect.origin.y= CGRectGetMaxY(tfEndTime1.frame)+10;
    alternateButton.frame=rect;
    
    rect = tfLocation.frame;
    rect.origin.y =CGRectGetMaxY(alternateButton.frame)+10;
    tfLocation.frame = rect;
    
    rect = tVNotes.frame;
    rect.origin.y = CGRectGetMaxY(tfLocation.frame)+10;
    tVNotes.frame = rect;
    
    rect = containerView.frame;
    rect.size.height = CGRectGetMaxY(tVNotes.frame)+10;
    containerView.frame=rect;

    rect = sendBtn.frame;
    rect.origin.y =CGRectGetMaxY(containerView.frame)+10;
    sendBtn.frame = rect;
}


-(void)AlterMethodTwo
{
     if (secondClicked)
    {
        secondClicked = NO;
        thirdClicked = YES;
        [self secondAlternateClick];
    }
   
}
-(void)AlterMethodThree
{
    if (thirdClicked)
    {
        thirdClicked = NO;
        secondClicked = NO;
        [self thirdAlternateClick];
    }

}

-(void)AlternateMethod
{
    if (!firstClicked)
    {
        firstClicked = YES;
        secondClicked = YES;
        [self firstAlternateClick];
    }
    if ([self SecondvalidateFields]) {
        if (secondClicked)
        {
            secondClicked = NO;
            
            [self secondAlternateClick];
        }

    }
    if ([self ThirdValidateFields]) {
        if (!thirdClicked)
        {
            thirdClicked = YES;
            secondClicked = NO;
            [self thirdAlternateClick];
        }

    }
   
}

-(void)firstAlternateClick
{
    
    CGRect rect;
    
    rect=tfDate2.frame;
    rect.origin.y= CGRectGetMaxY(tfEndTime1.frame)+10;
    tfDate2.frame=rect;
    
    
    rect=tfStartTime2.frame;
    rect.origin.y= CGRectGetMaxY(tfDate2.frame)+10;
    tfStartTime2.frame=rect;
    
    rect=tfEndTime2.frame;
    rect.origin.y= CGRectGetMaxY(tfStartTime2.frame)+10;
    tfEndTime2.frame=rect;
    
    tfDate2.hidden = NO;
    tfStartTime2.hidden = NO;
    tfEndTime2.hidden = NO;
   
    rect=alternateButton.frame;
    rect.origin.y= CGRectGetMaxY(tfEndTime2.frame)+10;
    alternateButton.frame=rect;


    rect = tfLocation.frame;
      rect.origin.y = CGRectGetMaxY(alternateButton.frame)+10;
    tfLocation.frame = rect;
  
    rect = tVNotes.frame;
    rect.origin.y =  CGRectGetMaxY( tfLocation.frame)+10;
    tVNotes.frame = rect;
    
    
    rect = containerView.frame;
    rect.size.height = CGRectGetMaxY(tVNotes.frame)+10;
    containerView.frame=rect;
    
    rect = sendBtn.frame;
    rect.origin.y =CGRectGetMaxY(containerView.frame)+10;
    sendBtn.frame = rect;
    
    
    [self viewWillAppear:YES];
    
    NSLog(@"%@",NSStringFromCGRect(sendBtn.frame));
    
 

 
}

-(void)secondAlternateClick
{
    
    CGRect rect;
    
    rect=tfDate3.frame;
    rect.origin.y= CGRectGetMaxY(tfEndTime2.frame)+10;
    tfDate3.frame=rect;
    
    
    rect=tfStartTime3.frame;
    rect.origin.y= CGRectGetMaxY(tfDate3.frame)+10;
    tfStartTime3.frame=rect;
    
    rect=tfEndTime3.frame;
    rect.origin.y= CGRectGetMaxY(tfStartTime3.frame)+10;
    tfEndTime3.frame=rect;

    
    

    
    rect=alternateButton.frame;
    rect.origin.y= CGRectGetMaxY(tfEndTime3.frame)+10;
    alternateButton.frame=rect;

    rect = tfLocation.frame;
    rect.origin.y = CGRectGetMaxY(alternateButton.frame)+10;
    tfLocation.frame = rect;
    
    rect = tVNotes.frame;
    rect.origin.y =  CGRectGetMaxY( tfLocation.frame)+10;
    tVNotes.frame = rect;

    
    
    
    rect = containerView.frame;
    rect.size.height = CGRectGetMaxY(tVNotes.frame)+10;
    containerView.frame=rect;
    
    rect = sendBtn.frame;
    rect.origin.y =CGRectGetMaxY(containerView.frame)+10;
    sendBtn.frame = rect;


    
    tfDate3.hidden = NO;
    tfStartTime3.hidden = NO;
    tfEndTime3.hidden = NO;

    
    [self viewWillAppear:YES];

}

-(void)thirdAlternateClick
{
    
    CGRect rect;
    
    rect=tfDate4.frame;
    rect.origin.y= CGRectGetMaxY(tfEndTime3.frame)+10;
    tfDate4.frame=rect;
    
    
    rect=tfStartTime4.frame;
    rect.origin.y= CGRectGetMaxY(tfDate4.frame)+10;
    tfStartTime4.frame=rect;
    
    rect=tfEndTime4.frame;
    rect.origin.y= CGRectGetMaxY(tfStartTime4.frame)+10;
    tfEndTime4.frame=rect;
    
    
    
    
    
    
    rect=alternateButton.frame;
    rect.origin.y= CGRectGetMaxY(tfEndTime4.frame)+10;
    alternateButton.frame=rect;

    
    
    
    rect = tfLocation.frame;
    rect.origin.y = CGRectGetMaxY(alternateButton.frame)+10;
    tfLocation.frame = rect;
    
    
    rect = tVNotes.frame;
    rect.origin.y =  CGRectGetMaxY( tfLocation.frame)+10;
    tVNotes.frame = rect;

    rect = containerView.frame;
    rect.size.height = CGRectGetMaxY(tVNotes.frame)+10;
    containerView.frame=rect;
    
    rect = sendBtn.frame;
    rect.origin.y =CGRectGetMaxY(containerView.frame)+10;
    sendBtn.frame = rect;


    tfDate4.hidden = NO;
    tfStartTime4.hidden = NO;
    tfEndTime4.hidden = NO;

    [self viewWillAppear:YES];
// [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
}

-(void)resignKeyBoard
{
    [tfDate1 resignFirstResponder];
    [tfStartTime1 resignFirstResponder];
    [tfEndTime1 resignFirstResponder];
    [tfDate2 resignFirstResponder];
    [tfStartTime2 resignFirstResponder];
    [tfEndTime2 resignFirstResponder];

    [tfDate3 resignFirstResponder];
    [tfStartTime3 resignFirstResponder];
    [tfEndTime3 resignFirstResponder];

    [tfDate4 resignFirstResponder];
    [tfStartTime4 resignFirstResponder];
    [tfEndTime4 resignFirstResponder];

    
    [tfGuardianFrndChildName resignFirstResponder];
    [tfChildName resignFirstResponder];
    [tfLocation resignFirstResponder];
    [tVNotes resignFirstResponder];

    
    if (tfLocation.text.length==0)
    {
        tfLocation.textColor=[UIColor lightGrayColor];
        tfLocation.text=@"LOCATION";
    }
    
    

    if (tVNotes.text.length==0)
    {
        tVNotes.textColor=[UIColor lightGrayColor];
        tVNotes.text=@"NOTES";
    }

}

#pragma mark - TextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
    
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    CGPoint scrollPoint = CGPointMake(0.0,  CGRectGetMaxY(textField.frame)-100);
    [scrollView setContentOffset:scrollPoint animated:YES];
 //// set slectedDay while setting time
    NSInteger slectedDay ;
    NSString *weekdayName;
    if (textField==tfEndTime1||textField==tfStartTime1)
    {
        if (tfDate1.text.length!=0)
        {
            NSString *myDateString= tfDate1.text;
         //   NSString *myDateString = @"2013-04-14";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
            
            NSDate *date = [dateFormatter dateFromString:myDateString];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
            
            NSInteger weekday = [components weekday];
            weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
            slectedDay=weekday;
            NSLog(@"%@ is a %@", myDateString, weekdayName);
        }
   
    }
    else if(textField==tfEndTime2||textField==tfStartTime2)
    {
        if (tfDate2.text.length!=0)
        {
            NSString *myDateString= tfDate2.text;
            //   NSString *myDateString = @"2013-04-14";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
            
            NSDate *date = [dateFormatter dateFromString:myDateString];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
            
            NSInteger weekday = [components weekday];
            weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
            slectedDay=weekday;
            NSLog(@"%@ is a %@", myDateString, weekdayName);
        }
 
    }
    else if(textField==tfEndTime3||textField==tfStartTime3)
    {
        if (tfDate3.text.length!=0)
        {
            NSString *myDateString= tfDate3.text;
            //   NSString *myDateString = @"2013-04-14";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
            
            NSDate *date = [dateFormatter dateFromString:myDateString];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
            
            NSInteger weekday = [components weekday];
            weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
            slectedDay=weekday;
            NSLog(@"%@ is a %@", myDateString, weekdayName);
        }
  

    }
    else if(textField==tfEndTime4||textField==tfStartTime4)
    {
        if (tfDate4.text.length!=0)
        {
            NSString *myDateString= tfDate4.text;
            //   NSString *myDateString = @"2013-04-14";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
            
            NSDate *date = [dateFormatter dateFromString:myDateString];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
            
            NSInteger weekday = [components weekday];
            weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
            slectedDay=weekday;
            NSLog(@"%@ is a %@", myDateString, weekdayName);
        }


    }
    
     if ([weekdayName isEqualToString:@"Sunday"])
        slectedDay=6;
     else if ([weekdayName isEqualToString:@"Monday"])
             slectedDay=0;
     else if ([weekdayName isEqualToString:@"Tuesday"])
        slectedDay=1;
     else if ([weekdayName isEqualToString:@"Wednesday"])
        slectedDay=2;
     else if ([weekdayName isEqualToString:@"Thursday"])
        slectedDay=3;
     else if ([weekdayName isEqualToString:@"Friday"])
        slectedDay=4;
     else if ([weekdayName isEqualToString:@"Saturday"])
        slectedDay=5;
     else
        slectedDay=-1;
////////////////  set slectedDay while setting time End
     if ((textField == tfDate1)||(textField == tfDate2)||(textField == tfDate3)||(textField == tfDate4))
        {
            [self resignKeyBoard];
           NSDateFormatter *df = [[NSDateFormatter alloc] init];
           [df setDateFormat:@"dd-MMMM-yyyy"];
            if ([[self.view subviews] containsObject:freeTimePicker])
                [freeTimePicker hide];

       //    NSString  *strDate = [df stringFromDate:[NSDate date]];
       //   NSDate *date=[df dateFromString:strDate];
   
           
       //    datePicker.startDate=date;

          [datePicker showInView:self.view hideday:0 withType:PDPickerTypeDate withPickingBlock:^(NSString *pickedResult) {
            
//           [datePicker showInView:self.view withType:PDPickerTypeDate withPickingBlock:^(NSString *pickedResult) {
              
           } andPickerDoneBlock:^(NSString *currentResult) {
               NSLog(@"%@", currentResult);
               
                   NSString  *strDate = [df stringFromDate:[NSDate date]];
                  NSDate *date=[df dateFromString:strDate];
               
               NSDateFormatter *df = [[NSDateFormatter alloc] init];
                   [df setDateFormat:@"dd-MMMM-yyyy"];
               NSString *strTemp=[df stringFromDate:date];
               NSDate *CurrentDate=[df dateFromString:strTemp];
               [df setDateFormat:@"dd-MMMM-yyyy"];
               NSDate *pickerDate=[df dateFromString:currentResult];
               
               if ([CurrentDate compare:pickerDate]==NSOrderedSame||[CurrentDate compare:pickerDate]==NSOrderedAscending)
               {
                   textField.text = [currentResult uppercaseString];

               }
               else
               {
                   [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Event Date must be Greater than current date" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];

               }
                //   datePicker.startDate=date;
               
               
               //textField.text = [currentResult uppercaseString];
               [scrollView setContentOffset:CGPointZero animated:YES];
           } cancelBlock:^{
               [scrollView setContentOffset:CGPointZero animated:YES];
               
           }];

     }
    
    else
    {
        
    if (![[self.view subviews] containsObject:freeTimePicker])
          {
                    [self resignKeyBoard];
            if ([[self.view subviews] containsObject:datePicker])
                      [datePicker hide];
           
        [freeTimePicker showInView:self.view hideday:(int)slectedDay withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
              
//    [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
                 
              } andPickerDoneBlock:^(NSString *currentResult) {
                  NSLog(@"%@", currentResult);
                  NSArray *array = [currentResult componentsSeparatedByString:@" "];
                  if (currentResult.length==0)
                  {
                      [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start time can't be same or greater than end time" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
                      [scrollView setContentOffset:CGPointZero animated:YES];

                  }

               else  if (textField==tfStartTime1||textField==tfEndTime1)
                  {
                      tfStartTime1.text=[array objectAtIndex:1];
                      tfEndTime1.text=[array objectAtIndex:3];
                 }
                  else  if (textField==tfStartTime2||textField==tfEndTime2)
                  {
                      tfStartTime2.text=[array objectAtIndex:1];
                      tfEndTime2.text=[array objectAtIndex:3];
                      
                  }
                  else  if (textField==tfStartTime3||textField==tfEndTime3)
                  {
                      tfStartTime3.text=[array objectAtIndex:1];
                      tfEndTime3.text=[array objectAtIndex:3];
                      
                  }
                  else  if (textField==tfStartTime4||textField==tfEndTime4)
                  {
                      tfStartTime4.text=[array objectAtIndex:1];
                      tfEndTime4.text=[array objectAtIndex:3];
                  }
                   [scrollView setContentOffset:CGPointZero animated:YES];
              } cancelBlock:^{
                  [scrollView setContentOffset:CGPointZero animated:YES];
                  
              }];
          }
    }

    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseStringWithLocale:[NSLocale currentLocale]]];
    
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
[scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    if (textField==tfStartTime1||textField==tfEndTime1)
    {
        tfStartTime1.text=@"";
        tfEndTime1.text=@"";
    }
    else  if (textField==tfStartTime2||textField==tfEndTime2)
    {
        tfStartTime2.text=@"";
        tfEndTime2.text=@"";
    }
    else  if (textField==tfStartTime3||textField==tfEndTime3)
    {
        tfStartTime3.text=@"";
        tfEndTime3.text=@"";
    }

    else  if (textField==tfStartTime4||textField==tfEndTime4)
    {
        tfStartTime4.text=@"";
        tfEndTime4.text=@"";
    }

    return YES;
}



#pragma mark - TextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [freeTimePicker hide];
    [datePicker hide];
    
    //    CGPoint scrollPoint = CGPointMake(0.0, textView.frame.origin.y+150.0);
    //    [scrollView setContentOffset:scrollPoint animated:YES];
    CGPoint scrollPoint;
    if (tfLocation==textView)
    {
        
        if ([textView.text isEqualToString:@"LOCATION"])
        {
            tfLocation.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
             textView.text=@"";
           }
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 210.0)];
        
        scrollPoint = CGPointMake(0.0,  CGRectGetMaxY(tfLocation.frame)-100);
        [scrollView setContentOffset:scrollPoint animated:YES];
        
    }
    
    
    else
    {
        if ([textView.text isEqualToString:@"NOTES"])
        {
            tVNotes.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
            textView.text=@"";

        }
 
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 180.0)];
        scrollPoint = CGPointMake(0.0,  CGRectGetMaxY(tVNotes.frame)-100);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
    
    if (tVNotes==textView)
    {
        if (tfLocation.text.length==0)
        {
        tfLocation.textColor=[UIColor lightGrayColor];
        tfLocation.text=@"LOCATION";
        }
        
        
    }
    if (tfLocation==textView)
    {
        if (tVNotes.text.length==0)
        {
            tVNotes.textColor=[UIColor lightGrayColor];
            tVNotes.text=@"NOTES";
        }
    }
  
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    
    [self changeContentsForLocation:textView];

}
-(void)changeContentsForLocation:(UITextView *)textvw
{
 
    if (textvw==tfLocation)
    {
        CGRect rect = tVNotes.frame;
        rect = tVNotes.frame;

    
        rect.origin.y = CGRectGetMaxY(tfLocation.frame) + 5.0;
        tVNotes.frame = rect;

        rect = containerView.frame;
        rect.size.height = CGRectGetMaxY(tVNotes.frame) + 30.0;
        containerView.frame = rect;

        CGRect rectbtn;
        
        rectbtn=   sendBtn.frame;
        
        rectbtn.origin.y =  CGRectGetMaxY(containerView.frame)+20;

        
        sendBtn.frame =rectbtn;
    }
    else
    {
    CGRect rect = tVNotes.frame;
    
    if (rect.size.height <= 35.0)
    {
        rect.size.height = 35.0;
        tVNotes.frame = rect;
        
   }
    else
    {
        rect = containerView.frame;
        rect.size.height = CGRectGetMaxY(tVNotes.frame) +30.0;
        containerView.frame = rect;
    }
    
        CGRect rectbtn;
    
     rectbtn=   sendBtn.frame;
    
        rectbtn.origin.y =  CGRectGetMaxY(containerView.frame)+20;
    
    sendBtn.frame =rectbtn;
    }
    
}



-(BOOL)validateFields
{
    
//    if ([tfChildName.text isEqualToString:tfGuardianFrndChildName.text])
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select different child" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//
//    }
//    if (str_Me_slected_Child_Id.length==0||str_Friend_slected_Child_Id.length==0)
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select child" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
//    if ([str_Me_slected_Child_Id isEqualToString:str_Friend_slected_Child_Id])
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select different child" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }

   // NSString *stringOnlyRegex = @"[a-z]*";
  //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[C] %@", stringOnlyRegex];
    
    // VALIDATE NAME
    NSString *str;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
 
    str = tfDate1.text;
    if (str.length>0)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MMMM-yyyy"];

        NSString  *strDate = [df stringFromDate:[NSDate date]];
        NSDate *date=[df dateFromString:strDate];
                [df setDateFormat:@"dd-MMMM-yyyy"];
            NSString *strTemp=[df stringFromDate:date];
        NSDate *CurrentDate=[df dateFromString:strTemp];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSDate *pickerDate=[df dateFromString:tfDate1.text];
        
        if ([CurrentDate compare:pickerDate]==NSOrderedSame||[CurrentDate compare:pickerDate]==NSOrderedAscending)
        {

            
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Event Date must be Greater than current date" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
            return 0;
        }
        
        
        
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }

    str = tfStartTime1.text;
    if (str.length>0)
    {
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter start time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfEndTime1.text;
    if (!(str.length>0))
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter end time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    
    if ( tfDate2.text.length>0)
    {
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MMMM-yyyy"];
        NSString  *strDate = [df stringFromDate:[NSDate date]];
        NSDate *date=[df dateFromString:strDate];
        
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSString *strTemp=[df stringFromDate:date];
        NSDate *CurrentDate=[df dateFromString:strTemp];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSDate *pickerDate=[df dateFromString:tfDate2.text];
        
        if ([CurrentDate compare:pickerDate]==NSOrderedSame||[CurrentDate compare:pickerDate]==NSOrderedAscending)
        {
            
            
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Event Date must be Greater than current date" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
            return 0;
        }

        
        
        
        
        if (tfEndTime2.text.length==0 ||tfStartTime2.text.length==0)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter alternative time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return NO;
       }
        if ( [tfDate2.text isEqualToString: tfDate1.text])
        {
            if ([tfStartTime1.text isEqualToString:tfStartTime2.text])
            {
                if ([tfEndTime1.text isEqualToString:tfEndTime2.text])
                {
                       [[[UIAlertView alloc] initWithTitle:nil message:@"Alternate  time should not be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    return NO;
                }
            }


        }
    }
    if ( tfDate3.text.length>0)
    {
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MMMM-yyyy"];
        NSString  *strDate = [df stringFromDate:[NSDate date]];
        NSDate *date=[df dateFromString:strDate];
        
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSString *strTemp=[df stringFromDate:date];
        NSDate *CurrentDate=[df dateFromString:strTemp];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSDate *pickerDate=[df dateFromString:tfDate3.text];
        
        if ([CurrentDate compare:pickerDate]==NSOrderedSame||[CurrentDate compare:pickerDate]==NSOrderedAscending)
        {
            
            
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Event Date must be Greater than current date" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
            return 0;
        }

        
        
        
        if (tfEndTime3.text.length==0 ||tfStartTime3.text.length==0)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter alternative time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return NO;
            
        }

        if ( [tfDate2.text isEqualToString: tfDate3.text])
        {
            if ([tfStartTime2.text isEqualToString:tfStartTime3.text])
            {
                if ([tfEndTime2.text isEqualToString:tfEndTime3.text])
                {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Alternate  time should not be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    return NO;
                }
            }
            
            
        }
        if ( [tfDate3.text isEqualToString: tfDate1.text])
        {
            if ([tfStartTime3.text isEqualToString:tfStartTime1.text])
            {
                if ([tfEndTime3.text isEqualToString:tfEndTime1.text])
                {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Alternate  time should not be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    return NO;
                }
            }
        }

        
        
        
    }
    if ( tfDate4.text.length>0)
    {
        
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MMMM-yyyy"];
        NSString  *strDate = [df stringFromDate:[NSDate date]];
        NSDate *date=[df dateFromString:strDate];
        
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSString *strTemp=[df stringFromDate:date];
        NSDate *CurrentDate=[df dateFromString:strTemp];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSDate *pickerDate=[df dateFromString:tfDate4.text];
        
        if ([CurrentDate compare:pickerDate]==NSOrderedSame||[CurrentDate compare:pickerDate]==NSOrderedAscending)
        {
            
            
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Event Date must be Greater than current date" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
            return 0;
        }

        
        
        
        if (tfEndTime4.text.length==0 ||tfStartTime4.text.length==0)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter alternative time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return NO;
            
        }

        if ( [tfDate3.text isEqualToString: tfDate4.text])
        {
            if ([tfStartTime3.text isEqualToString:tfStartTime4.text])
            {
                if ([tfEndTime3.text isEqualToString:tfEndTime4.text])
                {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Alternate  time should not be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    return NO;
                }
            }
        }
        if ( [tfDate4.text isEqualToString: tfDate1.text])
        {
            if ([tfStartTime4.text isEqualToString:tfStartTime1.text])
            {
                if ([tfEndTime4.text isEqualToString:tfEndTime1.text])
                {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Alternate  time should not be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    return NO;
                }
            }
        }
        if ( [tfDate4.text isEqualToString: tfDate2.text])
        {
            if ([tfStartTime4.text isEqualToString:tfStartTime2.text])
            {
                if ([tfEndTime4.text isEqualToString:tfEndTime2.text])
                {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Alternate  time should not be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    return NO;
                }
            }
        }

        
    }
    

    
    
    
    
    
    return YES;
}
-(BOOL)validateLocation
{
    if ([tfLocation.text isEqualToString:@"LOCATION"]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return YES;
}
-(BOOL)SecondvalidateFields
{
    
   // NSString *stringOnlyRegex = @"[a-z]*";
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[C] %@", stringOnlyRegex];
    
    // VALIDATE NAME
    NSString *str;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (str.length>0 && [predicate evaluateWithObject:str])
//    {
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
    
    str = tfDate1.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    // VALIDATE TIME
    str = tfStartTime1.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter start time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfEndTime1.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter end time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfDate2.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    // VALIDATE TIME
    str = tfStartTime2.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter start time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfEndTime2.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter end time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }

    
    return YES;
}

-(BOOL)ThirdValidateFields
{
    
   // NSString *stringOnlyRegex = @"[a-z]*";
  //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[C] %@", stringOnlyRegex];
    
    // VALIDATE NAME
    NSString *str;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (str.length>0 && [predicate evaluateWithObject:str])
//    {
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
    
    str = tfDate1.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    // VALIDATE TIME
    str = tfStartTime1.text;
    if (str.length>0)
    {
    }
    else
    {
        //[[[UIAlertView alloc] initWithTitle:nil message:@"Please enter start time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfEndTime1.text;
    if (str.length>0)
    {
    }
    else
    {
      //  [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter end time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfDate2.text;
    if (str.length>0)
    {
    }
    else
    {
        //[[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    // VALIDATE TIME
    str = tfStartTime2.text;
    if (str.length>0)
    {
    }
    else
    {
      //  [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter start time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfEndTime2.text;
    if (str.length>0)
    {
    }
    else
    {
      //  [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter end time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfDate3.text;
    if (str.length>0)
    {
    }
    else
    {
      //  [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    // VALIDATE TIME
    str = tfStartTime3.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter start time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    str = tfEndTime3.text;
    if (str.length>0)
    {
    }
    else
    {
       // [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter end time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }

    
    return YES;
}
-(IBAction)alternateBtn:(id)sender
{
    if (thirdClicked) {
        thirdClicked = NO;
        [alternateButton setUserInteractionEnabled:NO];
    }
    else if ([self validateFields]) {
        [self AlternateMethod];
    }
    
    
    CGRect rectbtn;

    rectbtn=   sendBtn.frame;
    rectbtn.origin.y =  CGRectGetMaxY(containerView.frame)+20;
    sendBtn.frame =rectbtn;
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
}
-(IBAction)btnSend
{
    [self resignKeyBoard];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
    
    
  
    
    if ([self validateFields])
    {
        
       if([self validateLocation])
       {
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Sending..."];
        [self performSelector:@selector(activityDidAppear) withObject:nil afterDelay:0.1];
       }
    }

}


#pragma mark - Activity Appear
-(void)activityDidAppear
{
    
    NSString *guardianID = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebGID];
    
 
    
    NSString *Date = [tfDate1 text];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MMMM-yyyy"];
    NSDate *date = [df dateFromString:Date];
    NSString *date1ToSend = [[[PDHelper sharedHelper] backEndDateFormatter] stringFromDate:date];
    if (!date1ToSend)
        date1ToSend = @"";
    
//    NSData *data = UIImageJPEGRepresentation([btnProfilePic currentImage], 0.1);
//    Base64Transcoder *base64 = [[Base64Transcoder alloc] init];
//    NSString *imageString = [base64 base64EncodedStringfromData:data];
    
    
//    NSDateFormatter *dff = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"dd-MMMM-yyyy"];
//    NSDate *date = [df dateFromString:DOB];
//    NSString *dateToSend = [[[PDHelper sharedHelper] backEndDateFormatter] stringFromDate:date];
    
    NSString *strtempNotes=tVNotes.text;
    if ([tVNotes.text isEqualToString:@"NOTES"]) {
        strtempNotes=@"";
    }


    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
   
    [params setObject:date1ToSend forKey:PDWebDate];
    [params setObject:tfStartTime1.text forKey:PDWebStartTime];
    [params setObject:tfEndTime1.text forKey:PDWebEndTime];
    [params setObject:tfLocation.text forKey:PDWebEventLocation];
    [params setObject:strtempNotes forKey:PDWebNotes];
    
    if (tfDate2.text .length!=0)
    {
        NSString *Date = [tfDate2 text];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSDate *date = [df dateFromString:Date];
        NSString *date2ToSend = [[[PDHelper sharedHelper] backEndDateFormatter] stringFromDate:date];
        if (!date2ToSend)
            date2ToSend = @"";

        [params setObject:date2ToSend forKey:PDWebDate1];

    }
    if (tfDate3.text .length!=0)
    {
        
        NSString *Date = [tfDate3 text];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSDate *date = [df dateFromString:Date];
        NSString *date3ToSend = [[[PDHelper sharedHelper] backEndDateFormatter] stringFromDate:date];
        if (!date3ToSend)
            date3ToSend = @"";

        [params setObject:date3ToSend forKey:PDWebDate2];

    }

    if (tfDate4.text .length!=0)
    {
        
        NSString *Date = [tfDate4 text];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MMMM-yyyy"];
        NSDate *date = [df dateFromString:Date];
        NSString *date4ToSend = [[[PDHelper sharedHelper] backEndDateFormatter] stringFromDate:date];
        if (!date4ToSend)
            date4ToSend = @"";

        [params setObject:date4ToSend forKey:PDWebDate3];

    }
    if (tfStartTime2.text.length!=0)
    {
        [params setObject:tfStartTime2.text forKey:PDWebStartTime1];

    }
    if (tfStartTime3.text.length!=0)
    {
        [params setObject:tfStartTime3.text forKey:PDWebStartTime2];

    }
    if (tfStartTime4.text.length!=0)
    {
        [params setObject:tfStartTime4.text forKey:PDWebStartTime3];

    }
    if (tfEndTime2.text .length!=0)
    {
        [params setObject:tfEndTime2.text forKey:PDWebEndTime1];

    }
    if (tfEndTime3.text .length!=0)
    {
        [params setObject:tfEndTime3.text forKey:PDWebEndTime2];

    }
    if (tfEndTime4.text .length!=0)
    {
        [params setObject:tfEndTime4.text forKey:PDWebEndTime3];

    }
    
    
    
//    if ([arrVwFriendChild_Add_ID count]>0)
//    {
//        
//         NSString *strChild_Id=[arrVwFriendChild_Add_ID componentsJoinedByString:@","];
//        [params setObject:[NSString stringWithFormat:@"%@,%@",str_Friend_slected_Child_Id,strChild_Id] forKey:@"friend_childid"];
//        
//        NSString *strChild_G_Id=[arrVwFriendChild_Add_G_ID componentsJoinedByString:@","];
//        [params setObject:[NSString stringWithFormat:@"%@,%@",str_Friend_slected_Child_g_id,strChild_G_Id] forKey:@"receiver_id"];
//
//    }
//    else
//    {
//        [params setObject:str_Friend_slected_Child_Id forKey:@"friend_childid"];
//        [params setObject:str_Friend_slected_Child_g_id forKey:@"receiver_id"];
//    }



   NSString *str_id=[self.dictEventInfo_edit valueForKey:@"senderid"];
   NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];
    
    str_Friend_slected_Child_Id=[[NSMutableString alloc]init];
    str_Friend_slected_Child_g_id=[[NSMutableString alloc]init];
    str_Me_slected_Child_Id=   [self.dictEventInfo_edit valueForKey:@"Child_id"];
    if ([strGid isEqualToString:str_id])
    {
        
        [params setObject:strGid forKey:@"receiver_id"];
        
       // str_Me_slected_Child_Id=[[arrAllOwnerChilds  objectAtIndex:0]valueForKey:@"Child_id"];
        
//        for (int i=0; i<[arrAllOtherChilds count]; i++)
//        {
//       //  str_Me_slected_Child_Id
//        [str_Friend_slected_Child_Id appendString:[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friend_child_id"]];
//        [str_Friend_slected_Child_Id appendString:@","];
//
//         [str_Friend_slected_Child_g_id appendString:[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friend_g_id"]];
//         [str_Friend_slected_Child_g_id appendString:@","];
//
//        }
      
    }
    else
    {
       
        [params setObject:str_id forKey:@"receiver_id"];
        
        
        
//        [str_Friend_slected_Child_Id appendString:[[arrAllOwnerChilds objectAtIndex:0]valueForKey:@"Child_id"]];
//        [str_Friend_slected_Child_Id appendString:@","];
//        
//        [str_Friend_slected_Child_g_id appendString:[[arrAllOwnerChilds objectAtIndex:0]valueForKey:@"senderid"]];
//        [str_Friend_slected_Child_g_id appendString:@","];
        
        
//        for (int i=0; i<[arrAllOtherChilds count]; i++)
//        {
//            if ([[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friend_g_id"]isEqualToString:strGid])
//            {
//               str_Me_slected_Child_Id=[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friend_child_id"];
//            }
//            else
//            {
//                
//                [str_Friend_slected_Child_Id appendString:[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friend_child_id"]];
//                [str_Friend_slected_Child_Id appendString:@","];
//                
//                [str_Friend_slected_Child_g_id appendString:[[arrAllOtherChilds objectAtIndex:i]valueForKey:@"friend_g_id"]];
//                [str_Friend_slected_Child_g_id appendString:@","];
//            }
//        }
        
        
    }
    ;
    
    [params setObject:str_Me_slected_Child_Id forKey:@"child_id"];

    [params setObject:[self.dictEventInfo_edit valueForKey:@"friend_childid"] forKey:@"friend_childid"];
//    [params setObject:[str_Friend_slected_Child_g_id substringToIndex:(str_Friend_slected_Child_g_id.length-1)] forKey:@"receiver_id"];

   
    
       [params setObject:[NSString stringWithFormat:@"%d",1] forKey:@"publish"];
       [params setObject:@"requested" forKey:@"receiver_status"];
    

 
          [params setObject:strEventId forKey:@"event_id"];
          [[PDWebHandler sharedWebHandler]editEventWithParams:params forGuardian:guardianID];
   
    
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
    [[PDAppDelegate sharedDelegate] hideActivity];
        
      if(error)
       {
         [[[UIAlertView alloc] initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil, nil] show];
       }
      else
       {
          if ([[response objectForKey:PDWebSuccess] boolValue])
            {
                // CLEAR ALL FIELDS AND SHOW USER AN ALERT FOR SUCCESSFULLY SAVED
                
                
                      [[[UIAlertView alloc] initWithTitle:@"" message:@"Sent Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                
                
               

            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"" message:@"An error occured please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }
        
    }];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
}

#pragma mark - Button Actions
-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(IBAction)menuAction:(id)sender
//{
//    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
//        
//        
//        
//    }];
//}
//-(IBAction)guardianFriendDropDown:(id)sender
//{
//    UIButton *btn=(UIButton *)sender;
//    if (btn.currentImage==CancelImage)
//    { // delete Child
//        vwAdditionalChild *vwAdditional=(vwAdditionalChild *)[arrVwFriendChild_Add objectAtIndex:btn.tag];
//
//        
//       [arrVwFriendChild_Add removeObjectAtIndex:btn.tag];
//
//        [arrVwFriendChild_Add_ID removeObjectAtIndex:btn.tag];
//        [arrVwFriendChild_Add_G_ID removeObjectAtIndex:btn.tag];
//        [arrVwFriendChild_Add_Name removeObjectAtIndex:btn.tag];
//        
//
//        
//        [vwAdditional removeFromSuperview];
//        for (int i=0; i<[arrVwFriendChild_Add count]; i++)
//        {
//            
//             vwAdditional=(vwAdditionalChild *)[arrVwFriendChild_Add objectAtIndex:i];
//            for (UIView *vw in [vwAdditional subviews])
//            {
//                if ([vw isKindOfClass:[UILabel class]])
//                {
//                    UILabel *lbl=(UILabel *)vw;
//                    
//                    lbl.tag=i;
//                }
//                if ([vw isKindOfClass:[UIButton class]])
//                {
//                    
//                    UIButton *btnVw=(UIButton *)vw;
////                    [btnVw setImage:CancelImage forState:UIControlStateNormal];
//                    btnVw.tag=i;
//
//                }
//            }
//
//        }
//     
//        return;
//    }
//    
//    
//    if ([[self.view subviews] containsObject:freeTimePicker])
//    {
//        [freeTimePicker hide];
//        [scrollView setContentOffset:CGPointZero animated:YES];
//        
//    }
//    if ([[self.view subviews] containsObject:datePicker])
//    {
//        [datePicker hide];
//        [scrollView setContentOffset:CGPointZero animated:YES];
//        
//    }
//
//    [self resignKeyBoard];
//    lblChild.text=@"Select friend's child:";
//    str_Whilch_childtable_open=@"FriendChild";
//    str_Whilch_FriendchildtagNo=(int)((UIButton *)sender).tag;
//    arrTableData=arrFriendChild;
//    [self   reloadChild];
//    dropDownView.hidden=NO;
//}
//-(IBAction)childDropDownBtn:(id)sender
//{
//    
//    if ([[self.view subviews] containsObject:freeTimePicker])
//    {
//        [freeTimePicker hide];
//        [scrollView setContentOffset:CGPointZero animated:YES];
//
//    }
//    if ([[self.view subviews] containsObject:datePicker])
//    {
//        [datePicker hide];
//        [scrollView setContentOffset:CGPointZero animated:YES];
//
//    }
//
//    [self resignKeyBoard];
//    lblChild.text= @"Select your child:";
//    
//    str_Whilch_childtable_open=@"MeChild";
//    
//    arrTableData=arrChild;
//    [self   reloadChild];
//    
//    dropDownView.hidden=NO;
//    
//}
-(void)Adjust_Size_height_EditInfo
{
       // Adjust height According to edit info
    NSString *strStartTime1= [self.dictEventInfo_edit valueForKey:@"Starttime1"];
    NSString *strStartTime2=  [self.dictEventInfo_edit valueForKey:@"Starttime2"];
    NSString *strStartTime3=  [self.dictEventInfo_edit valueForKey:@"Starttime3"];
    UITextField *txtTemp;
      if (strStartTime1.length!=0)
      {
        txtTemp=tfEndTime2;
      }
      if (strStartTime2.length!=0)
      {
            txtTemp=tfEndTime3;
      }
      if (strStartTime3.length!=0)
      {
            txtTemp=tfEndTime4;
           alternateButton.userInteractionEnabled=NO;
      }
    CGRect rect=alternateButton.frame;
     rect.origin.y =CGRectGetMaxY(txtTemp.frame)+20.0;
    alternateButton.frame=rect;
    
    rect=tfLocation.frame;
    rect.origin.y =CGRectGetMaxY(alternateButton.frame)+10.0;
    tfLocation.frame=rect;

    CGFloat fixedWidth = tfLocation.frame.size.width;
    CGSize newSize = [tfLocation sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = tfLocation.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    tfLocation.frame = newFrame;

    /////
    
    
    
    /////

    
    rect=tVNotes.frame;
    rect.origin.y =CGRectGetMaxY(tfLocation.frame)+10.0;
    tVNotes.frame=rect;
    
    
    CGFloat fixedWidthtVNotes = tVNotes.frame.size.width;
    CGSize newSizetVNotes = [tVNotes sizeThatFits:CGSizeMake(fixedWidthtVNotes, MAXFLOAT)];
    CGRect newFrametVNotes= tVNotes.frame;
    newFrametVNotes.size = CGSizeMake(fmaxf(newSizetVNotes.width, fixedWidthtVNotes), newSizetVNotes.height);
    tVNotes.frame = newFrametVNotes;

    rect=containerView.frame;
    rect.size.height =CGRectGetMaxY(tVNotes.frame)+15.0;
    containerView.frame=rect;

    rect=   sendBtn.frame;
    rect.origin.y =  CGRectGetMaxY(containerView.frame)+20;
    sendBtn.frame =rect;

}

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
    
    rect =vwYouthClub.frame;
    rect.origin.y=CGRectGetMaxY(vwSchool.frame)+7.0;
    vwYouthClub.frame=rect;
    
    rect =vwBackView.frame;
    rect.size.height=CGRectGetMaxY(vwYouthClub.frame)+25.0;
    vwBackView.frame=rect;
    
   [scollvw setContentSize:CGSizeMake(scollvw.frame.size.width, CGRectGetMaxY(vwBackView.frame) + 37.0)];
}

-(void)resignPhonePad
{
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
    [tVNotes resignFirstResponder];
    [tfLocation resignFirstResponder];
    
    if (tfLocation.text.length==0)
        
    {
        tfLocation.textColor=[UIColor lightGrayColor];
        tfLocation.text=@"LOCATION";
    }
        
        
  if (tVNotes.text.length==0)
  {
      tVNotes.textColor=[UIColor lightGrayColor];
       tVNotes.text=@"NOTES";
  }
  

    
}

-(void) gestureActionChildDetail_VWRemove:(UITapGestureRecognizer*)ges
{
    [vwChildDetail removeFromSuperview];
}
-(void)gestureAction_EventOwnerChildInfo:(UITapGestureRecognizer*)ges
{
    NSArray *arrHobbies=[[[arrAllOwnerChilds objectAtIndex:0] valueForKey:@"child_hobbies"] componentsSeparatedByString:@","];
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
    
    
    NSArray *arrAllergies=[[[arrAllOwnerChilds objectAtIndex:0] valueForKey:@"child_allergies"] componentsSeparatedByString:@","];
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
    
    
    
    
    
    
    lblName.text=[[arrAllOwnerChilds objectAtIndex:0] valueForKey:@"name"];
    lblDob.text=[[[arrAllOwnerChilds objectAtIndex:0] valueForKey:@"child_dob"] uppercaseString];
    lblFreetime.text=[[[arrAllOwnerChilds objectAtIndex:0] valueForKey:@"child_c_set_fixed_freetime"]uppercaseString];
    lblAllergies.text=strAllergies;
    lblHobbies.text=strHobbies;
    lblYouthclub.text=[[arrAllOwnerChilds objectAtIndex:0] valueForKey:@"child_youth_club"];
    lblSchool.text=[[arrAllOwnerChilds objectAtIndex:0] valueForKey:@"child_school"];
    
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

//-(void) gestureActionChildInfo:(UITapGestureRecognizer*)ges
//{
//    if (![dictSlectd_ChildInfo count]>0)
//        return;
//    
//
//   NSArray *arrHobbies=[[dictSlectd_ChildInfo valueForKey:@"hobbies"] componentsSeparatedByString:@","];
//    NSMutableString *strHobbies=[[NSMutableString alloc]init];
//    
//    if ([arrHobbies count]>1)
//    {
//        
//    
//    
//    for ( int i=0;i<[arrHobbies count]; i++)
//    {
//        NSString *test = [arrHobbies objectAtIndex:i];
//         if ([test characterAtIndex:0] == 32)
//        {
//            test = [test stringByReplacingCharactersInRange:NSMakeRange(1,1) withString:@""];
//           [strHobbies appendString:test];
//        }
//        else
//           [strHobbies appendString:test];
//        [strHobbies appendString:@"\n"];
//    }
//    }
//    
//    else
//    {
//        [strHobbies appendString:[arrHobbies objectAtIndex:0]];
//        
//    }
//
//        
//   NSArray *arrAllergies=[[dictSlectd_ChildInfo valueForKey:@"allergies"]componentsSeparatedByString:@","];
//    NSMutableString *strAllergies=[[NSMutableString alloc]init];
//    
//    if ([arrAllergies count]>1)
//    {
//    for ( int i=0;i<[arrAllergies count]; i++)
//    {
//        NSString *test = [arrAllergies objectAtIndex:i];
//              if ([test characterAtIndex:0] == 32)
//        {
//            test = [test stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
//            [strAllergies appendString:test];
//        }
//        else
//            [strAllergies appendString:test];
//        
//        [strAllergies appendString:@"\n"];
//
//    }
//    }
//  else
//  {
//      [strAllergies appendString:[arrAllergies objectAtIndex:0]];
//
//  }
//
//    CGSize maximumLabelSize=CGSizeMake(150, CGFLOAT_MAX);
//    CGSize lblAllergiesSize = [strAllergies sizeWithFont:lblAllergies.font
//                                  constrainedToSize:maximumLabelSize
//                                      lineBreakMode:lblAllergies.lineBreakMode];
//    
//    CGRect rect= lblAllergies.frame;
//    rect.size.height=lblAllergiesSize.height;
//    lblAllergies.frame=rect;
//    
//    
//    CGSize lblHobbiesSize = [strHobbies sizeWithFont:lblHobbies.font
//                                       constrainedToSize:maximumLabelSize
//                                           lineBreakMode:lblHobbies.lineBreakMode];
//    
//    rect= lblHobbies.frame;
//    rect.size.height=lblHobbiesSize.height;
//    lblHobbies.frame=rect;
//    
//    
//    
//    lblName.text=[dictSlectd_ChildInfo valueForKey:@"Childname"];
//    lblDob.text=[[dictSlectd_ChildInfo valueForKey:@"dob"] uppercaseString];
//    lblFreetime.text=[[dictSlectd_ChildInfo valueForKey:@"c_set_fixed_freetime"]uppercaseString];
//    lblAllergies.text=strAllergies;
//    lblHobbies.text=strHobbies;
//    lblYouthclub.text=[dictSlectd_ChildInfo valueForKey:@"youth_club"];
//    lblSchool.text=[dictSlectd_ChildInfo valueForKey:@"school"];
//  
//
//     rect  = lblAllergies.frame;
//    if (rect.size.height < 30.0) {
//        rect.size.height = 30.0;
//        lblAllergies.frame =rect;
//    }
//    rect  = lblHobbies.frame;
//    if (rect.size.height < 30.0) {
//        rect.size.height = 30.0;
//        lblHobbies.frame =rect;
//    }
//    rect  = lblFreetime.frame;
//    if (rect.size.height < 30.0) {
//        rect.size.height = 30.0;
//        lblFreetime.frame =rect;
//    }
//    
//
//    [self.view addSubview:vwChildDetail];
//     [self  Adjust_Size_height];
//
//}
-(void) gestureAction_OtherChildInfo:(UITapGestureRecognizer*)ges
{
    
    
    NSArray *arrHobbies=[[[arrAllOtherChilds objectAtIndex:ges.view.tag] valueForKey:@"friend_hobbies"] componentsSeparatedByString:@","];
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
    
   
    NSArray *arrAllergies=[[[arrAllOtherChilds objectAtIndex:ges.view.tag] valueForKey:@"friend_allergies"] componentsSeparatedByString:@","];
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

    
    
    
    
    
    lblName.text=[[arrAllOtherChilds objectAtIndex:ges.view.tag] valueForKey:@"friendname"];
    lblDob.text=[[[arrAllOtherChilds objectAtIndex:ges.view.tag] valueForKey:@"friend_dob"] uppercaseString];
    lblFreetime.text=[[[arrAllOtherChilds objectAtIndex:ges.view.tag] valueForKey:@"friend_c_set_fixed_freetime"]uppercaseString];
    lblAllergies.text=strAllergies;
    lblHobbies.text=strHobbies;
    lblYouthclub.text=[[arrAllOtherChilds objectAtIndex:ges.view.tag] valueForKey:@"friend_youth_club"];
    lblSchool.text=[[arrAllOtherChilds objectAtIndex:ges.view.tag] valueForKey:@"friend_school"];
    
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

//gestureActionChildDetail_VWRemove
#pragma mark - Reload Childs
//-(void)reloadChild
//{
//    // REMOVE ALL SUBVIEWS
//    for (id obj in childScrollView.subviews)
//        [obj removeFromSuperview];
//    
//    // ADD SUBVIEWS
//    CGFloat rowHeight = 51.0;
//    CGFloat rowWidth  = childScrollView.frame.size.width;
//    CGFloat row_X = 0.0;
//    CGFloat row_Y = 0.0;
//    
//    UIView *row;
//    UIImageView *imageView;
//    UILabel *titleView;
//       
//    for (int i=0; i<[arrTableData count]; i++)
//    {
//        NSDictionary *detail = [arrTableData objectAtIndex:i];
//        
//        row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
//        row.tag = i;
//        
//        CALayer *bottomBorder = [CALayer layer];
//        bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
//        bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
//        [row.layer addSublayer:bottomBorder];
//        
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 36.0, 36.0)];
//     
//        imageView.layer.borderWidth = 1.0;
//        imageView.layer.borderColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
//        [row addSubview:imageView];
//        
//        [imageView setImageWithURL:[NSURL URLWithString:[detail objectForKey:@"c_profile_image"]] placeholderImage:[UIImage imageNamed:@"user_img"]];
//
//        NSString *childName = nil;
//        if ([str_Whilch_childtable_open isEqualToString:@"FriendChild"])
//        {
//              childName = [detail valueForKey:@"name"];
//          
//        }
//        else
//        {
//               childName = [detail valueForKey:@"Childname"];
//        }
//
//
//        titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, childScrollView.frame.size.width-55.0, 50.0)];
//        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:13.0];
//        titleView.text =childName;
//        titleView.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
//        titleView.numberOfLines = 0;
//        [row addSubview:titleView];
//        [childScrollView addSubview:row];
//        row_Y = row_Y + 50.0;
//        UIGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getChildInfo:)];
//        [row addGestureRecognizer:tapGes];
//        
//        
//        
//    }
//    
//    [childScrollView setContentSize:CGSizeMake(childScrollView.frame.size.width, row_Y)];
//}
//-(void)getChildInfo:(UIGestureRecognizer *)gesture
//{
//    
//    
//    
//    if ([str_Whilch_childtable_open isEqualToString:@"FriendChild"])
//    {
//          tfGuardianFrndChildName.textColor=  [[PDHelper sharedHelper] applicationThemeBlueColor];
//          dictSlectdFriend_ChildInfo=[arrTableData objectAtIndex:gesture.view.tag];
//        
//        if (str_Whilch_FriendchildtagNo==1000)
//        {
//            
//            NSString *tempId=[[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"child_id"];
//            
//            if (([arrVwFriendChild_Add_ID count]!=0)&& [arrVwFriendChild_Add_ID containsObject:tempId])
//            {
//                [[[UIAlertView alloc] initWithTitle:nil message:@"Please Select different child." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//                return;
//            }
//
//            
//        
//            [imgVwGuardianFrndChildName setImageWithURL:[NSURL URLWithString: [[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"c_profile_image"]]placeholderImage:[UIImage imageNamed:@"user_img"]];
//            
//            str_Friend_slected_Childname=   [[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"name"];
//            str_Friend_slected_Child_Id=  [[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"child_id"];
//            str_Friend_slected_Child_g_id= [[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"g_id"];
//            tfGuardianFrndChildName.text=[str_Friend_slected_Childname uppercaseString];
//        }
//       else
//       {
//           
//           
//           NSString *tempId=[[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"child_id"];
//           
//           if ([tempId isEqualToString:str_Friend_slected_Child_Id]||(([arrVwFriendChild_Add_ID count]!=0)&& [arrVwFriendChild_Add_ID containsObject:tempId]))
//           {
//               [[[UIAlertView alloc] initWithTitle:nil message:@"Please Select different child." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//               return;
//           }
//  
//           
//           
//       vwAdditionalChild *vwAdditional=[arrVwFriendChild_Add objectAtIndex:str_Whilch_FriendchildtagNo];
//           
//           for (UIView *vw in [vwAdditional subviews])
//           {
//               if ([vw isKindOfClass:[UILabel class]])
//               {
//                   UILabel *lbl=(UILabel *)vw;
//                   lbl.text=[[[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"name"] uppercaseString];
//                   lbl.textColor=  [[PDHelper sharedHelper] applicationThemeBlueColor];
//               }
//               if ([vw isKindOfClass:[UIImageView class]])
//               {
//                   UIImageView *imgVw=(UIImageView *)vw;
//                   
//                   
//                   [imgVw setImageWithURL:[NSURL URLWithString: [[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"c_profile_image"]] placeholderImage:[UIImage imageNamed:@"user_img"]];
//
//               }
//               if ([vw isKindOfClass:[UIButton class]])
//               {
//                   UIButton *btnVw=(UIButton *)vw;
//                   [btnVw setImage:CancelImage forState:UIControlStateNormal];
//                }
//           }
//       [arrVwFriendChild_Add_ID addObject:[[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"child_id"]];
//       [arrVwFriendChild_Add_G_ID addObject: [[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"g_id"]];
//       [arrVwFriendChild_Add_Name addObject:[[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"name"]];
//       
//       }
//        
//        
// 
//      
//       
//    }
//    else if ([str_Whilch_childtable_open isEqualToString:@"MeChild"])
//    {
//        tfChildName.textColor= [[PDHelper sharedHelper] applicationThemeBlueColor];
//        dictSlectd_ChildInfo=[arrTableData objectAtIndex:gesture.view.tag];
//        str_Me_slected_Childname= [[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"Childname"];
//        tfChildName.text=[str_Me_slected_Childname uppercaseString];
//          str_Me_slected_Child_Id=[[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"child_id"];
//        [imgVwChildName setImageWithURL:[NSURL URLWithString: [[arrTableData objectAtIndex:gesture.view.tag]valueForKey:@"c_profile_image"]]];
//    }
//    
//    dropDownView.hidden=YES;
//    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(sendBtn.frame) + 40.0)];
//}
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
