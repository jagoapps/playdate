//
//  PDProfileViewController.m
//  PlayDate
//
//  Created by Vakul on 29/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDProfileViewController.h"
#import "VSOptionsView.h"
#import "PDDateTimePicker.h"
#import "UIImageView+WebCache.h"
#import "PDChildProfileViewController.h"
#import "PDRequestArrangeViewController.h"
#import "PDCalenderViewController.h"
#import "PDMainViewController.h"
#import "PDLeftViewController.h"

@interface PDProfileViewController () <VSOptionsViewDelegate, UITextFieldDelegate, UITextViewDelegate>

{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *profileImageViewContainer;
    IBOutlet UIImageView *iVProfile;
    IBOutlet UIButton *btnSave;
    
    
    IBOutlet UIView *dobBackgroundView;
    IBOutlet UIView *locationBackgroundView;
    IBOutlet UIView *phoneBackgroundView;
    IBOutlet UIView *freeTimeBackgroundView;
    IBOutlet UIView *usersBackgroundView;
    
    
    IBOutlet UITextField *tFName;
    IBOutlet UITextField *tFDOB;
    IBOutlet UITextField *tFPhone;
    IBOutlet UITextView  *tVLocation;
    IBOutlet UITextField *tFUsers;
    
    IBOutlet UILabel *lblFreeTime;
    
    IBOutlet UIView *childScrollViewContainer;
    IBOutlet UIScrollView *childScrollView;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIButton *setfreeTimeBtn;
    
    VSOptionsView *imagePickerOptionsView;
    PDDateTimePicker *datePicker;
    PDDateTimePicker *freeTimePicker;
    VSOptionsView *optionsView;
    
    NSArray *childs;
    UITapGestureRecognizer *tapGes;
    NSInteger indexOfChild;
    BOOL openSideVwSetForImage;
    
    NSDictionary *dictParentInfo;
    
    IBOutlet UIImageView *imgVwTop;
    IBOutlet UIButton *btnMenu;
    IBOutlet UIButton *btnCalender;
    IBOutlet UIButton *btnHome;
    IBOutlet UIButton *btnArrange;
}

@property (strong, nonatomic) IBOutlet UIView *topMenuView;
@property (nonatomic) GUARDIAN_TYPE guardianType;

-(void)setUpViewContents;
-(void)resignKeyBoard;
-(BOOL)validateFields;
-(void)reloadChilds;

-(IBAction)menuAction:(id)sender;
-(IBAction)saveAction:(id)sender;
-(IBAction)changePicAction:(id)sender;
-(IBAction)addFreeTimeAction:(id)sender;

@end

@implementation PDProfileViewController
@synthesize friendProfileArray = _friendProfileArray;

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
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    
    // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];
    
    // SHADOW
    iVProfile.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    iVProfile.layer.shadowRadius = 2.0;
    iVProfile.layer.shadowOpacity = 0.5;
    iVProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    iVProfile.layer.borderWidth = 2.0;
 //   iVProfile.layer.cornerRadius = 5.0;
    
    childScrollViewContainer.layer.borderWidth = 5.0;
    childScrollViewContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    childScrollViewContainer.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    childScrollViewContainer.layer.shadowRadius = 2.0;
    childScrollViewContainer.layer.shadowOpacity = 0.5;
    

    
    if (self.isFromSets)
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
        [self.topMenuView addSubview:btnBack];
        
        [btnSave setHidden:YES];
        
        [setfreeTimeBtn setHidden:YES];
        tFName.userInteractionEnabled = NO;
        tFDOB.userInteractionEnabled = NO;
        tFPhone.userInteractionEnabled = NO;
        tFUsers.userInteractionEnabled = NO;
        tVLocation.userInteractionEnabled = NO;
        
    }
    else
    {
        // FOR USER PROFILE
        
        if (!(self.str_Parent_gid.length==0))
        {// Check authnonication of parent Edtable or not
            if (!([self.str_Parent_gid isEqualToString:[[[[PDUser currentUser] detail]objectForKey:PDUserInfo] objectForKey:PDWebGID]]))
            {
                [btnSave setHidden:YES];
                [setfreeTimeBtn setHidden:YES];
                tFName.userInteractionEnabled = NO;
                tFDOB.userInteractionEnabled = NO;
                tFPhone.userInteractionEnabled = NO;
                tFUsers.userInteractionEnabled = NO;
                tVLocation.userInteractionEnabled = NO;

            }
   
       else
       {
        [btnSave setHidden:NO];
        [setfreeTimeBtn setHidden:NO];
        tFName.userInteractionEnabled = YES;
        tFDOB.userInteractionEnabled = YES;
        tFPhone.userInteractionEnabled = YES;
        tFUsers.userInteractionEnabled = YES;
        tVLocation.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureImage =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionImageGesture)];
           [iVProfile addGestureRecognizer:tapGestureImage];
       }
        }
        else
        {
            [btnSave setHidden:NO];
            [setfreeTimeBtn setHidden:NO];
            tFName.userInteractionEnabled = YES;
            tFDOB.userInteractionEnabled = YES;
            tFPhone.userInteractionEnabled = YES;
            tFUsers.userInteractionEnabled = YES;
            tVLocation.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureImage =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionImageGesture)];
            [iVProfile addGestureRecognizer:tapGestureImage];
        }

    }
    
        
        imagePickerOptionsView = [[VSOptionsView alloc] initWithDelegate:self andTitles:@"Photo Gallery",@"Camera", nil];
        imagePickerOptionsView.dismissAfterAction = YES;
        // imagePickerOptionsView.mainTitle = @"  Choose Photo From:";
        imagePickerOptionsView.lineColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        imagePickerOptionsView.rowColor = [UIColor whiteColor];
        imagePickerOptionsView.titleColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        imagePickerOptionsView.selectedRowColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        imagePickerOptionsView.selectedTitleColor = [UIColor whiteColor];
        imagePickerOptionsView.mainTitleColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        imagePickerOptionsView.mainTitleLineColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        
        
        // OPTIONS VIEW - GUARDIAN TYPE PICKER
        optionsView = [[VSOptionsView alloc] initWithDelegate:self andTitles:@"MOTHER", @"FATHER", @"GRAND MOTHER", @"GRAND FATHER",@"NANNY",@"BROTHER",@"SISTER",@"TEACHER",@"OTHER", nil];
        optionsView.delegate = self;
        optionsView.selectedRowColor = [PDHelper sharedHelper].applicationThemeBlueColor;
        optionsView.selectedTitleColor = [UIColor whiteColor];
        optionsView.rowColor = [PDHelper sharedHelper].applicationBackgroundColor;
        optionsView.titleColor = [PDHelper sharedHelper].applicationThemeBlueColor;
        optionsView.lineColor = [PDHelper sharedHelper].applicationThemeBlueColor;
        optionsView.linePaddingFromLeft = 5.0;
        optionsView.linePaddingFromRight = 5.0;
        optionsView.font = [[PDHelper sharedHelper] applicationFontWithSize:12.0];
        optionsView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        optionsView.dismissAfterAction = YES;
        
        
        
        // DATE PICKER && FREE TIME PICKER
        datePicker = [[PDDateTimePicker alloc] initWithType:PDPickerTypeDate];
        freeTimePicker = [[PDDateTimePicker alloc] initWithType:PDPickerTypeFreeTime];
        
        
        
        
        // ADD TAP GESTURE TO FREE TIME LABEL
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnFreeTime:)];
        lblFreeTime.userInteractionEnabled = YES;
        [lblFreeTime addGestureRecognizer:tapGesture];
    
        
     
        
        [activity startAnimating];
        
        
        // DONE BUTTON INPUT VIEW FOR PHONE NUMBER PAD
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
        inputView.backgroundColor = [PDHelper sharedHelper].applicationThemeBlueColor;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(260.0, 0.0, 60.0, 40.0)];
        [btn setTitle:@"Done" forState:UIControlStateNormal];
        [inputView addSubview:btn];
        [btn addTarget:self action:@selector(resignPhonePad) forControlEvents:UIControlEventTouchUpInside];
        
        tFPhone.inputAccessoryView = inputView;
        tVLocation.inputAccessoryView = inputView;

    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [scrollView setContentOffset:CGPointZero animated:NO];

        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
        [self performSelector:@selector(infoShowCallWebService) withObject:nil afterDelay:0.1];
        
    
}


#pragma mark - Methods
-(void)infoShowCallWebService
{
    
    if (self.isFromSets)
    {
        
        if (self.str_Parent_gid.length==0)
        {
            [[PDAppDelegate sharedDelegate]hideActivity];
            activity.hidden=YES;
            return;

        }
    }
    
    if (self.str_Parent_gid.length==0)
        [[PDWebHandler sharedWebHandler] getChildForGuardian:[[[[PDUser currentUser] detail]objectForKey:PDUserInfo] objectForKey:PDWebGID]];
    else
        [[PDWebHandler sharedWebHandler] getChildForGuardian:self.str_Parent_gid];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
     {
         
         id result = [response objectForKey:PDWebData];
         dictParentInfo = [response objectForKey:@"parentinfo"];
         id authChild = [response objectForKey:@"auth_child"];
         if ([result isKindOfClass:[NSArray class]]) {
             NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:result];
             if ([authChild isKindOfClass:[NSArray class]])
             {
                 for (int i=0; i<[authChild count]; i++)
                     [arrTemp addObject:[authChild objectAtIndex:i]];
             }
             childs = [arrTemp copy];
             tFName.text =[dictParentInfo objectForKey:@"Parentname"];
             tFPhone.text=[dictParentInfo objectForKey:@"phone"];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd"];
             NSString *dateString =[dictParentInfo objectForKey:@"dob"];
             NSDate *date = [dateFormatter dateFromString:dateString];
             [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
             tFDOB.text = [[dateFormatter stringFromDate:date] uppercaseString];
             NSString *location = [[dictParentInfo objectForKey:@"location"]uppercaseString];
             
             if (location.length > 0)
                 tVLocation.text = location;
             
             NSString *guardianType = @"FATHER";
             self.guardianType = G_FATHER;
             if ([[dictParentInfo objectForKey:@"guardian_type"] isEqualToString:@"m"])
             {
                 guardianType = @"MOTHER";
                 self.guardianType = G_MOTHER;
             }
             else if ([[dictParentInfo objectForKey:@"guardian_type"] isEqualToString:@"gm"])
             {
                 guardianType = @"GRAND MOTHER";
                 self.guardianType = G_GRAND_MOTHER;
             }
             else if ([[dictParentInfo objectForKey:@"guardian_type"] isEqualToString:@"gf"])
             {
                 guardianType = @"GRAND FATHER";
                 self.guardianType = G_GRAND_FATHER;
             }
             else if ([[dictParentInfo objectForKey:@"guardian_type"] isEqualToString:@"b"])
             {
                 guardianType = @"BROTHER";
                 self.guardianType = G_BROTHER;
             }

             else if ([[dictParentInfo objectForKey:@"guardian_type"] isEqualToString:@"s"])
             {
                 guardianType = @"SISTER";
                 self.guardianType = G_SISTER;
             }

             else if ([[dictParentInfo objectForKey:@"guardian_type"] isEqualToString:@"n"])
             {
                 guardianType = @"NANNY";
                 self.guardianType = G_NANY;
             }
             else if  ([[dictParentInfo objectForKey:@"guardian_type"] isEqualToString:@"t"])
             {
                 guardianType = @"TEACHER";
                 self.guardianType = G_TEACHER;
             }

             else if ([[dictParentInfo objectForKey:@"guardian_type"] isEqualToString:@"o"])
             {
                 guardianType = @"OTHER";
                 self.guardianType = G_OTHER;
             }

             tFUsers.text = guardianType;
             __block UIImageView *iV = iVProfile;
             __block UIView *iVC = profileImageViewContainer;
             [iVProfile setImageWithURL:[NSURL URLWithString:[dictParentInfo objectForKey:PDWebProfileImage]] placeholderImage:[UIImage imageNamed:@"user_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                 
                 if (!error)
                 {
                     CGSize perfectSize = [[PDHelper sharedHelper] perfectSizeOfImage:image withMaximumHeight:iV.frame.size.height andMaximumWidth:iV.frame.size.width];
                     CGRect r = CGRectMake((iVC.frame.size.width - perfectSize.width)/2.0, (iVC.frame.size.height - perfectSize.height)/2.0, perfectSize.width, perfectSize.height);
                     iV.frame = r;
                 }
                 [[PDAppDelegate sharedDelegate]hideActivity];
             }];
             
             [self reloadChilds];
         }
         else
         {
             [activity stopAnimating];
             // [childScrollView setHidden:YES];
             [childScrollViewContainer setHidden:YES];
             [activity setHidden:YES];
         }
         
     }];
    

}
-(void)actionImageGesture
{
    openSideVwSetForImage=1;
    [imagePickerOptionsView showAtCenter];
    
    
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
    rect.origin.y = CGRectGetMaxY(self.topMenuView.frame);
    rect.size.height = totalHeight - CGRectGetMaxY(self.topMenuView.frame);
    scrollView.frame = rect;
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
}


-(void)resignKeyBoard
{
    [tFDOB resignFirstResponder];
    [tVLocation resignFirstResponder];
    [tFName resignFirstResponder];
    [tFPhone resignFirstResponder];
    [tFUsers resignFirstResponder];
}

-(void)resignPhonePad
{
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
    [scrollView setContentOffset:CGPointZero animated:YES];

    [tFPhone resignFirstResponder];
    [tVLocation resignFirstResponder];
}


-(BOOL)validateFields
{
    
 //   NSString *stringOnlyRegex = @"[a-z]*";
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[C] %@", stringOnlyRegex];
    
    // VALIDATE NAME
//    NSString *str = tFName.text;
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (str.length>0 && [predicate evaluateWithObject:str])
//    {
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }


    return YES;
}


-(void)tapOnFreeTime:(UIGestureRecognizer *)gesture
{
    [self resignKeyBoard];
    
    if (![[self.view subviews] containsObject:freeTimePicker])
    {
        if ([[self.view subviews] containsObject:datePicker])
        {
            [datePicker hide];
        }
        
        CGPoint scrollPoint = CGPointMake(0.0, lblFreeTime.frame.origin.y+190.0);
        [scrollView setContentOffset:scrollPoint animated:YES];
        
        
        
        [freeTimePicker showInView:self.view hideday:0 withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
  
//        [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
            
        } andPickerDoneBlock:^(NSString *currentResult) {
            
            if (currentResult.length==0)
            {
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start time can't be same or greater than end time" delegate:nil cancelButtonTitle:@"ok'" otherButtonTitles:nil]show];
            }
            
            else   if ([lblFreeTime.text isEqualToString:@"FREE TIME"])
            {
                lblFreeTime.text = [currentResult uppercaseString];
            }
            else
            {
                lblFreeTime.text = [currentResult uppercaseString];//   [[lblFreeTime.text stringByAppendingFormat:@"\n%@", currentResult] uppercaseString];
            }
            
            
            [self changeContentsForFreeTime];
            [scrollView setContentOffset:CGPointZero animated:YES];
            
        } cancelBlock:^{
            [scrollView setContentOffset:CGPointZero animated:YES];
            
        }];
    }
}

-(void)changeContentsForFreeTime
{
    [lblFreeTime sizeToFit];
    
    CGRect rect = lblFreeTime.frame;
    if (rect.size.height <= 30.0) {
        rect.size.height = 30.0;
        lblFreeTime.frame = rect;
        
        rect = freeTimeBackgroundView.frame;
        rect.size.height = 40.0;
        freeTimeBackgroundView.frame = rect;
    }
    else {
        
        rect = freeTimeBackgroundView.frame;
        rect.size.height = CGRectGetMaxY(lblFreeTime.frame) + 5.0;
        freeTimeBackgroundView.frame = rect;
    }
    
    rect = usersBackgroundView.frame;
    rect.origin.y = CGRectGetMaxY(freeTimeBackgroundView.frame) + 5.0;
    usersBackgroundView.frame = rect;
    
    rect = btnSave.frame;
    rect.origin.y = CGRectGetMaxY(usersBackgroundView.frame) + 25.0;
    btnSave.frame = rect;
    
    
   
    
}


-(void)changeContentsForLocation
{
    CGRect rect = tVLocation.frame;

    if (rect.size.height <= 30.0)
    {
        rect.size.height = 30.0;
        tVLocation.frame = rect;
        
        rect = locationBackgroundView.frame;
        rect.size.height = 40.0;
        locationBackgroundView.frame = rect;
    }
    else
    {
        rect = locationBackgroundView.frame;
        rect.size.height = CGRectGetMaxY(tVLocation.frame) + 5.0;
        locationBackgroundView.frame = rect;
    }

    rect = phoneBackgroundView.frame;
    rect.origin.y = CGRectGetMaxY(locationBackgroundView.frame) + 5.0;
    phoneBackgroundView.frame = rect;

//    rect = freeTimeBackgroundView.frame;
//    rect.origin.y = CGRectGetMaxY(phoneBackgroundView.frame) + 5.0;
//    freeTimeBackgroundView.frame = rect;

    rect = usersBackgroundView.frame;
    rect.origin.y = CGRectGetMaxY(phoneBackgroundView.frame) + 5.0;
    usersBackgroundView.frame = rect;
    
    rect = btnSave.frame;
    rect.origin.y = CGRectGetMaxY(usersBackgroundView.frame) + 25.0;
    btnSave.frame = rect;

  //  [self changeContentsForFreeTime];
}


-(void)callWebserviceSave_ChangeParentInfo
{
    
    NSString *DOB = [tFDOB text];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MMMM-yyyy"];
    NSDate *date = [df dateFromString:DOB];
    NSString *dateToSend = [[[PDHelper sharedHelper] backEndDateFormatter] stringFromDate:date];
    if (!dateToSend)
        dateToSend = @"";
    
    
    
    
    NSString *gType = @"m";
    if (self.guardianType == G_FATHER)
        gType = @"f";
    else if (self.guardianType == G_GRAND_MOTHER)
        gType = @"gm";
    else if (self.guardianType == G_GRAND_FATHER)
        gType = @"gf";
    else if (self.guardianType == G_BROTHER)
        gType = @"b";
    else if (self.guardianType == G_SISTER)
        gType = @"s";
    else if (self.guardianType == G_NANY)
        gType = @"n";
    else if (self.guardianType == G_TEACHER)
        gType = @"t";

    else if (self.guardianType == G_OTHER)
        gType = @"o";
    
    
    // g_id=1&name=abcde&dob=1989-07-08&location=aaabcde&phone=9872742345&set_fixed_freetime=12
    NSString *guardianID = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebGID];

//      NSString *strName=[[tFName.text componentsSeparatedByString:@" "]objectAtIndex:0];
    
    NSString *strName=tFName.text;
    NSDictionary *params = @{FBName: strName,
                             PDWebDOB: dateToSend,
                             PDWebLocation: tVLocation.text,
                             PDWebPhone: tFPhone.text,
                            /* PDWebFreeTime: [lblFreeTime.text stringByReplacingOccurrencesOfString:@"\n" withString:@","],*/
                             PDWebGuardianType: gType,
                             PDFacebook_id:[[NSUserDefaults standardUserDefaults]valueForKey:PDFacebook_id],
                             PDWebGID: guardianID
                             };
    
      [[PDWebHandler sharedWebHandler] editGuardianWithParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
        [[PDAppDelegate sharedDelegate] hideActivity];
        
        if (!error)
        {
            if ([[response objectForKey:PDWebSuccess] boolValue]) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Profile has been updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                
                NSMutableDictionary *detail = [[[PDUser currentUser] detail] mutableCopy];
                NSDictionary *newUserInfo  = [response objectForKey:PDUserInfo];
                [detail setObject:newUserInfo forKey:PDUserInfo];
                
                [[PDUser currentUser] setDetail:detail];
                [[PDUser currentUser] save];
                PDLeftViewController *controller = (PDLeftViewController *)[PDAppDelegate sharedDelegate].menuController.leftMenuViewController;
                controller.lblName.text =tFName.text;
               
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"" message:@"An error occured please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        
    }];
}



#pragma mark - Button Actions
-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
        
        
    }];
}
-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)changePicAction:(id)sender
{
    [imagePickerOptionsView showAtCenter];
}


-(IBAction)saveAction:(id)sender
{
    [self resignKeyBoard];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
    
    if ([self validateFields])
    {
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Saving..."];
        [self performSelector:@selector(callWebserviceSave_ChangeParentInfo) withObject:nil afterDelay:0.1];
    }
}

-(IBAction)addFreeTimeAction:(id)sender
{
    [self resignKeyBoard];
    
       if (![[self.view subviews] containsObject:freeTimePicker])
    {
        if ([[self.view subviews] containsObject:datePicker])
        {
            [datePicker hide];
        }
        
        CGPoint scrollPoint = CGPointMake(0.0, lblFreeTime.frame.origin.y+190.0);
        [scrollView setContentOffset:scrollPoint animated:YES];

    [freeTimePicker showInView:self.view hideday:0 withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
        
//        [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
        
        } andPickerDoneBlock:^(NSString *currentResult) {
            
            if (currentResult.length==0)
            {
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start time can't be same or greater than end time" delegate:nil cancelButtonTitle:@"ok'" otherButtonTitles:nil]show];
            }
            
           else if ([lblFreeTime.text isEqualToString:@"FREE TIME"])
            {
                lblFreeTime.text = [currentResult uppercaseString];
            }
            else
            {
                lblFreeTime.text = [[lblFreeTime.text stringByAppendingFormat:@"\n%@", currentResult] uppercaseString];
            }
            
            
            [self changeContentsForFreeTime];
            [scrollView setContentOffset:CGPointZero animated:YES];
            
            
        } cancelBlock:^{
            [scrollView setContentOffset:CGPointZero animated:YES];
            
        }];

    }
}



#pragma mark - TextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
    
    [scrollView setContentOffset:CGPointZero animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == tFDOB) {
        CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y+130.0);
        [scrollView setContentOffset:scrollPoint animated:YES];

        [self resignKeyBoard];
        
        if (![[self.view subviews] containsObject:datePicker])
        {
            if ([[self.view subviews] containsObject:freeTimePicker]) {
                [freeTimePicker hide];
            }
          
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd-MMMM-yyyy"];
         //   NSString  *strDate = [df stringFromDate:[NSDate date]];
         //   NSDate *date=[df dateFromString:strDate];
       
//            datePicker.endDate=date;
//            datePicker.startDate=nil;
                 NSLog(@"%@",datePicker.endDate);
        [datePicker showInView:self.view hideday:0 withType:PDPickerTypeDate withPickingBlock:^(NSString *pickedResult) {
            
//            [datePicker showInView:self.view withType:PDPickerTypeDate withPickingBlock:^(NSString *pickedResult) {
               
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
                
                if ([CurrentDate compare:pickerDate]==NSOrderedSame||[CurrentDate compare:pickerDate]==NSOrderedDescending)
                {
                    tFDOB.text = [currentResult uppercaseString];
                    
                }
                else
                {
                    [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Date of Birth Date must be Less than current date" delegate:nil cancelButtonTitle:@"ok"otherButtonTitles:nil]show];
                    
                }

                
                           [scrollView setContentOffset:CGPointZero animated:YES];

                
            } cancelBlock:^{
                [scrollView setContentOffset:CGPointZero animated:YES];
                
            }];
    }
        
        return NO;
    }
    else if (textField == tFUsers)
    {
        [scrollView setContentOffset:CGPointZero animated:YES];
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self resignKeyBoard];
            [freeTimePicker hide];
            [datePicker hide];
        }];
        
        [optionsView showAtCenter];
        
        return NO;
    }

    else
    {
        [freeTimePicker hide];
        [datePicker hide];
    }
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (tFName==textField)
    {
        return YES;
    }
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseStringWithLocale:[NSLocale currentLocale]]];
      return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (tFName==textField)
    {
        
    }
        else
        {
    CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y+190.0);
    [scrollView setContentOffset:scrollPoint animated:YES];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 260.0)];
        }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
#pragma mark - TextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    
    [self changeContentsForLocation];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [freeTimePicker hide];
    [datePicker hide];
    CGPoint scrollPoint = CGPointMake(0.0, textView.frame.origin.y+150.0);
    [scrollView setContentOffset:scrollPoint animated:YES];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 260.0)];
}



#pragma mark - Reload Childs
-(void)reloadChilds
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
    
    for (int i=0; i<[childs count]; i++)
    {
        NSLog(@"%ld",(long)indexOfChild);
        NSDictionary *detail = [childs objectAtIndex:i];
        
        row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
        row.tag=i;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
        bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row.layer addSublayer:bottomBorder];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 36.0, 36.0)];
        [imageView setImageWithURL:[NSURL URLWithString:[detail objectForKey:PDWebProfileImage]] placeholderImage:[UIImage imageNamed:@"user_img"]];
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row addSubview:imageView];
        
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, childScrollView.frame.size.width-55.0, 50.0)];
        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:9.0];
        titleView.text = [[detail objectForKey:PDWebChildName] uppercaseString];
        titleView.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        titleView.numberOfLines = 1;
        [row addSubview:titleView];
        [childScrollView addSubview:row];
        row_Y = row_Y + 50.0;
        tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getChildInfo:)];
        [row addGestureRecognizer:tapGes];
    }
    
    [childScrollView setContentSize:CGSizeMake(childScrollView.frame.size.width, row_Y)];
    [activity stopAnimating];
    [activity setHidden:YES];
}

// IF IS FROM SETS
//-(void)reloadFriendChild
//{
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
//    for (int i=0; i<[childs count]; i++)
//    {
//     
//       // NSDictionary *detail = [childs objectAtIndex:i];
//        
//        row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
//        row.tag=i;
//        CALayer *bottomBorder = [CALayer layer];
//        bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
//        bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
//        [row.layer addSublayer:bottomBorder];
//        
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 36.0, 36.0)];
//        NSURL *url = [[childs  objectAtIndex:i]valueForKey:@"profile_image"];
//        [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_img"]];
//        imageView.layer.borderWidth = 1.0;
//        imageView.layer.borderColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
//        [row addSubview:imageView];
//        
//        titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, childScrollView.frame.size.width-55.0, 50.0)];
//        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:9.0];
//        titleView.text = [[childs  objectAtIndex:i]valueForKey:@"name"];
//        titleView.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
//        titleView.numberOfLines = 1;
//        [row addSubview:titleView];
//        [childScrollView addSubview:row];
//        row_Y = row_Y + 50.0;
//        tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getChildInfoFromSets:)];
//        [row addGestureRecognizer:tapGes];
//    }
//    
//    [childScrollView setContentSize:CGSizeMake(childScrollView.frame.size.width, row_Y)];
//    [activity stopAnimating];
//    [activity setHidden:YES];
//
//}

#pragma mark - Get child Info
-(void)getChildInfo:(UITapGestureRecognizer *)gest
{
    PDChildProfileViewController *pdChildProfile = [[PDChildProfileViewController alloc]initWithNibName:@"PDChildProfileViewController" bundle:nil];
    pdChildProfile.childProfileArray = childs;
    pdChildProfile.fromDirectlyParent=YES;
    if (self.isFromSets)
        pdChildProfile.fromSets = YES;
    else
    pdChildProfile.fromSets = NO;
    pdChildProfile.index = gest.view.tag;
    [self.navigationController pushViewController:pdChildProfile animated:NO];
}

// IF IS FROM SETS

//-(void)getChildInfoFromSets:(UITapGestureRecognizer *)gest
//{
////    PDChildProfileViewController *pdChildProfile = [[PDChildProfileViewController alloc]initWithNibName:@"PDChildProfileViewController" bundle:nil];
////    pdChildProfile.childProfileArray = self.friendProfileArray;
////    pdChildProfile.parentProfileArray = @[[self.friendProfileArray valueForKey:@"friendinfo"]];
////    pdChildProfile.fromSets = YES;
////    pdChildProfile.index = gest.view.tag;
////    [self.navigationController pushViewController:pdChildProfile animated:NO];
//    
//    
//    PDChildProfileViewController *pdChildProfile = [[PDChildProfileViewController alloc]initWithNibName:@"PDChildProfileViewController" bundle:nil];
//    pdChildProfile.childProfileArray = childs;
//    pdChildProfile.fromSets = YES;
//    pdChildProfile.index = gest.view.tag;
//    [self.navigationController pushViewController:pdChildProfile animated:NO];
//    
//}
#pragma mark - Options Delegate
-(void)optionView:(VSOptionsView *)optionView clickedAtIndex:(NSInteger)index
{
    if (!openSideVwSetForImage) {
                 self.guardianType = (GUARDIAN_TYPE)index;
              tFUsers.text = [optionsView.titles objectAtIndex:index];
        return;
    }
    
   if (index == 0)
    {
        // Gallery
        [[PDHelper sharedHelper] openGalleryFromController:self withCompletionBlock:^(UIImage *image) {
            [self dismissViewControllerAnimated:YES completion:NULL];
            if (image)
            {
                [iVProfile setImage:image ];
                CGSize perfectSize = [[PDHelper sharedHelper] perfectSizeOfImage:image withMaximumHeight:iVProfile.frame.size.height andMaximumWidth:iVProfile.frame.size.width];
                CGRect r = CGRectMake((profileImageViewContainer.frame.size.width - perfectSize.width)/2.0, (profileImageViewContainer.frame.size.height - perfectSize.height)/2.0, perfectSize.width, perfectSize.height);
                iVProfile.frame = r;
                [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Saving..."];
                [self performSelector:@selector(callWebService_SendImage:) withObject:image afterDelay:0.1];
                
            }
        }];
    }
    else if (index == 1)
    {
        // Camera
        [[PDHelper sharedHelper] openCameraFromController:self withCompletionBlock:^(UIImage *image) {
            [self dismissViewControllerAnimated:YES completion:NULL];
            if (image)
            {
                [iVProfile setImage:image ];
                CGSize perfectSize = [[PDHelper sharedHelper] perfectSizeOfImage:image withMaximumHeight:iVProfile.frame.size.height andMaximumWidth:iVProfile.frame.size.width];
                CGRect r = CGRectMake((profileImageViewContainer.frame.size.width - perfectSize.width)/2.0, (profileImageViewContainer.frame.size.height - perfectSize.height)/2.0, perfectSize.width, perfectSize.height);
                iVProfile.frame = r;
                [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Saving..."];
            [self performSelector:@selector(callWebService_SendImage:) withObject:image afterDelay:0.1];
                
            }
         }];
     }
}

-(void)callWebService_SendImage:(UIImage *)img
{
    NSString *guardianID = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebGID];

    NSData *data = UIImageJPEGRepresentation(iVProfile.image, 0.1);
    Base64Transcoder *base64 = [[Base64Transcoder alloc] init];
    NSString *imageString = [base64 base64EncodedStringfromData:data];
    NSDictionary *params = @{PDWebGID:guardianID,
                             @"img": imageString,
                             @"profile_image":@"1.jpg"
                             };
    [[PDWebHandler sharedWebHandler] editParentPicListParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
        if (!error)
        {
        
            PDLeftViewController *controller = (PDLeftViewController *)[PDAppDelegate sharedDelegate].menuController.leftMenuViewController;
            controller.iVProfile.image=iVProfile.image;
            
            if ([[response objectForKey:PDWebSuccess] boolValue]) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Image has been updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                NSMutableDictionary *detail = [[[PDUser currentUser] detail] mutableCopy];
                NSMutableDictionary *newUserInfo  = [[detail objectForKey:PDUserInfo]mutableCopy];
                [newUserInfo setObject:[response valueForKey:@"url"] forKey:@"profile_image"];
                [detail setObject:newUserInfo forKey:PDUserInfo];
                [[PDUser currentUser] setDetail:detail];
                [[PDUser currentUser] save];
            }
            else
              [[[UIAlertView alloc] initWithTitle:@"" message:@"An error occured please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        [[PDAppDelegate sharedDelegate] hideActivity];
        
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
//http://112.196.34.179/playdate/child_parent_auth.php?child_id=287";
//-(void)childInfoBasedOnChildID_ListParams:(NSDictionary *)params;
@end
