//
//  PDAddChildViewController.m
//  PlayDate
//
//  Created by Vakul on 07/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDAddChildViewController.h"
#import "VSOptionsView.h"
#import "PDOptionsViewController.h"
#import "PDDateTimePicker.h"
#import "PDCalenderViewController.h"
#import "PDMainViewController.h"
#import "PDRequestArrangeViewController.h"

@interface PDAddChildViewController () <VSOptionsViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *infoBackgroundView;
    IBOutlet UIButton *btnProfilePic;
    IBOutlet UIButton *btnSave;
    
    IBOutlet UITextField *tFName;
    IBOutlet UITextField *tFDOB;
    IBOutlet UITextField *tFSiblings;
    IBOutlet UILabel *lblFreeTime;
//    IBOutlet UITextField *tFFreeTime;
    //IBOutlet UITextField *tFConditions;
    IBOutlet UITextField *tFSchool;
    IBOutlet UITextField *tFYouthClub;
    

    IBOutlet UIScrollView *svFreeTime;
   IBOutlet UIView *vwAllergies;
   IBOutlet UIView *vwHobbies;
    IBOutlet UILabel *lblAllergies;
    IBOutlet UILabel *lblHobbies;
    IBOutlet UILabel *lblStar_Hobbies;
    
    
    BOOL isEditMode;
    
    VSOptionsView *imagePickerOptionsView;
    
    NSArray *alreadySelectedAllergies;
    NSArray *alreadySelectedHobbies;
    
    PDDateTimePicker *datePicker;
    PDDateTimePicker *freeTimePicker;
}

@property (strong, nonatomic) IBOutlet UIView *topMenuView;

-(void)setUpViewContents;
-(void)setContentInsectOfEachTextField;
-(void)resignKeyBoard;
-(BOOL)validateFields;

-(IBAction)menuAction:(id)sender;
-(IBAction)changePicAction:(id)sender;
-(IBAction)saveAction:(id)sender;
-(IBAction)menuArrange:(id)sender;
-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;
-(IBAction)btnFreeTimeAction:(id)sender;

@end

@implementation PDAddChildViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    
    // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];
    
    
    // SETTING CONTENT INSECT OF TEXTFIELD BECAUSE IT HAS BACKGROUND IMAGE WE WILL HAVE TO MOVE ITS CONTENT A BIT LEFT
    [self setContentInsectOfEachTextField];

    
    isEditMode = NO;
    
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
    
    // TAP GESTURE ON HOBBIES AND ALLERGIES
    UITapGestureRecognizer *tapOnAllergies = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allergiesAction:)];
    [lblAllergies addGestureRecognizer:tapOnAllergies];
    
    UITapGestureRecognizer *tapOnHobbies = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hobbiesAction:)];
    [lblHobbies addGestureRecognizer:tapOnHobbies];

    
    UITapGestureRecognizer *tapOnFreeTime= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(freeTimeAction:)];
    [lblFreeTime addGestureRecognizer:tapOnFreeTime];

    

    
    
    // DATE PICKER && FREE TIME PICKER
    datePicker = [[PDDateTimePicker alloc] initWithType:PDPickerTypeDate];
    freeTimePicker = [[PDDateTimePicker alloc] initWithType:PDPickerTypeFreeTime];
    // [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 37.0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [scrollView setContentOffset:CGPointZero animated:NO];
}


#pragma mark - Methods
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
    
    
    rect = scrollView.frame;
    rect.origin.y = CGRectGetMaxY(self.topMenuView.frame);
    rect.size.height = totalHeight - CGRectGetMaxY(self.topMenuView.frame);
    scrollView.frame = rect;
    
//    if(![[PDHelper sharedHelper] isIPhone5])
//    {
//        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 37.0)];
//    }
    
    
    if([[PDHelper sharedHelper] isIPhone5])
    {
        [scrollView setContentOffset:CGPointZero animated:YES];    }
    else
    {
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 37.0)];
    }
    
}


-(void)setContentInsectOfEachTextField
{
    for (UITextField *tF in infoBackgroundView.subviews)
    {
        if ([tF isKindOfClass:[UITextField class]]) {
            
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, tF.frame.size.height)];
            leftView.backgroundColor = tF.backgroundColor;
            tF.leftView = leftView;
            tF.leftViewMode = UITextFieldViewModeAlways;
        }
    }
}

-(void)resignKeyBoard
{
    for (UITextField *tF in infoBackgroundView.subviews)
    {
        if ([tF isKindOfClass:[UITextField class]]) {
            [tF resignFirstResponder];
        }
    }
}

-(BOOL)validateFields
{
    
    NSString *stringOnlyRegex = @"[a-z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[C] %@", stringOnlyRegex];
    
    // VALIDATE NAME
    NSString *str = tFName.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length>0 && [predicate evaluateWithObject:str])
    {
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    
//    
//    // VALIDATE DOB
//    str = tFDOB.text;
//    if (str.length>0)
//    {
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter date of birth." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
//
//    
//    // VALIDATE FREE TIME
//    str = tFFreeTime.text;
//    if (str.length>0)
//    {
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter free time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
//
//    // VALIDATE CONDITIONS
//    str = tFConditions.text;
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (str.length>0)
//    {
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter conditions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
//
//    
//    // VALIDATE ALLERGIES
//    str = lblAllergies.text;
//    if (str.length>0)
//    {
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter allergies." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
//
//    
//    // VALIDATE HOBBIES
//    str = lblHobbies.text;
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (str.length>0)
//    {
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter hobbies." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
//
//    
//    
    
    return YES;
}

#pragma mark - Button Actions
-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
        
        
    }];
}

-(IBAction)changePicAction:(id)sender
{
    [imagePickerOptionsView showAtCenter];
}



-(IBAction)saveAction:(id)sender
{
    [self resignKeyBoard];
   
    if([[PDHelper sharedHelper] isIPhone5])
    {
        [scrollView setContentSize:CGSizeZero];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 37.0)];
    }
    
    
    
    if ([self validateFields])
    {
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Saving..."];
        [self performSelector:@selector(activityDidAppear) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - Activity Appear
-(void)activityDidAppear
{
    
    NSString *guardianID = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebGID];
    
    // http://112.196.34.179/playdate/child.php?profile_image=pic&name=deepak&dob=1989/1/12&set_fixed_freetime=1989/2/4&school=DPS&conditions=TRUE&allergies=test&hobbies=demo&siblings=mother&youth_club=abc&g_id=10
    
    NSString *DOB = [tFDOB text];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MMMM-yyyy"];
    NSDate *date = [df dateFromString:DOB];
    NSString *dateToSend = [[[PDHelper sharedHelper] backEndDateFormatter] stringFromDate:date];
    if (!dateToSend)
        dateToSend = @"";
    
    NSData *data = UIImageJPEGRepresentation([btnProfilePic currentImage], 0.1);
    Base64Transcoder *base64 = [[Base64Transcoder alloc] init];
    NSString *imageString = [base64 base64EncodedStringfromData:data];
    NSString *strAllergies=lblAllergies.text;
    strAllergies=   [strAllergies stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    NSString *strHobbies=lblHobbies.text;
    strHobbies=   [strHobbies stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:imageString forKey:PDWebProfileImage];
    [params setObject:tFName.text forKey:FBName];
    [params setObject:dateToSend forKey:PDWebDOB];
    [params setObject:lblFreeTime.text forKey:PDWebFreeTime];
    [params setObject:tFSchool.text forKey:PDWebSchool];
    [params setObject:tFYouthClub.text forKey:PDWebYouthClub];
   // [params setObject:tFConditions.text forKey:PDWebConditions];
    [params setObject:strAllergies forKey:PDWebAllergies];
    [params setObject:strHobbies forKey:PDWebHobbies];
    
    [[PDWebHandler sharedWebHandler] addChildWithParams:params forGuardian:guardianID];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
       
        [[PDAppDelegate sharedDelegate] hideActivity];
        
        if(error)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            if ([[response objectForKey:PDWebSuccess] boolValue])
            {
                // CLEAR ALL FIELDS AND SHOW USER AN ALERT FOR SUCCESSFULLY SAVED
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Child added successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                
                for (UITextField *tF in infoBackgroundView.subviews)
                {
                    if ([tF isKindOfClass:[UITextField class]]) {
                        [tF setText:@""];
                    }
                }
                
                [btnProfilePic setImage:[UIImage imageNamed:@"user_img"] forState:UIControlStateNormal];
                
                lblFreeTime.text =@"FREE TIME";
                lblFreeTime.textColor=[UIColor colorWithRed:170./255.0 green:170.0/255.0 blue:170.0/255 alpha:1.0];
                lblHobbies.text = @"HOBBIES";
                lblHobbies.textColor = [UIColor lightGrayColor];
                CGRect rect  = lblHobbies.frame;
                rect.size.height = 30.0;
                 rect.size.width = 245.0;
                lblHobbies.frame =rect;

                lblAllergies.text = @"AlLERGIES" ;
                lblAllergies.textColor = [UIColor lightGrayColor];
                rect  = lblAllergies.frame;
                rect.size.height = 30.0;
                rect.size.width = 245.0;
                lblAllergies.frame =rect;
                [self Adjust_Size_height];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"" message:@"An error occured please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }
        
    }];
    
}

#pragma mark - Options Delegate
-(void)optionView:(VSOptionsView *)optionView clickedAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        // Gallery
        [[PDHelper sharedHelper] openGalleryFromController:self withCompletionBlock:^(UIImage *image) {
            [self dismissViewControllerAnimated:YES completion:NULL];
            if (image)
                [btnProfilePic setImage:image forState:UIControlStateNormal];
        }];
    }
    else if (index == 1)
    {
        // Camera
        [[PDHelper sharedHelper] openCameraFromController:self withCompletionBlock:^(UIImage *image) {
            [self dismissViewControllerAnimated:YES completion:NULL];
            if (image)
                [btnProfilePic setImage:image forState:UIControlStateNormal];
        }];

    }
}


#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if([[PDHelper sharedHelper] isIPhone5])
//    {
      [scrollView setContentOffset:CGPointZero animated:YES];
//}
//    else
//    {
//        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 37.0)];
//    }
  //  [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame))];

 
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == tFDOB) {
        
        [self resignKeyBoard];
        
        if (![[self.view subviews] containsObject:datePicker])
        {
            if ([[self.view subviews] containsObject:freeTimePicker]) {
                [freeTimePicker hide];
            }
          
    [datePicker showInView:self.view hideday:0 withType:PDPickerTypeDate withPickingBlock:^(NSString *pickedResult) {
          
//            [datePicker showInView:self.view withType:PDPickerTypeDate withPickingBlock:^(NSString *pickedResult) {
                
            } andPickerDoneBlock:^(NSString *currentResult) {
                tFDOB.text = [currentResult uppercaseString] ;
                
                
            } cancelBlock:^{
                [scrollView setContentOffset:CGPointZero animated:YES];
                
            }];
            

            
    
        }
        
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
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseStringWithLocale:[NSLocale currentLocale]]];
    
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y-10.0);
    [scrollView setContentOffset:scrollPoint animated:YES];

    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame)+180.0)];

}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

#pragma mark - Allergies & Hobbies Action
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

    
    rect =lblStar_Hobbies .frame;
    rect.origin.y=CGRectGetMinY(vwHobbies.frame)+3.0;
    lblStar_Hobbies.frame=rect;
    
    rect =tFSchool.frame;
    rect.origin.y=CGRectGetMaxY(vwHobbies.frame)+7.0;
    tFSchool.frame=rect;
    
    rect =tFYouthClub.frame;
    rect.origin.y=CGRectGetMaxY(tFSchool.frame)+7.0;
    tFYouthClub.frame=rect;
    
    rect =infoBackgroundView.frame;
    rect.size.height=CGRectGetMaxY(tFYouthClub.frame)+25.0;
    infoBackgroundView.frame=rect;
    
    rect =btnSave.frame;
    rect.origin.y=CGRectGetMaxY(infoBackgroundView.frame)+25.0;
    btnSave.frame=rect;
   [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 37.0)];
}
-(void)allergiesAction:(UIGestureRecognizer *)recognizer
{
    
    [self resignKeyBoard];
    [freeTimePicker hide];
    [datePicker hide];

    PDOptionsViewController *optionsController = [[PDOptionsViewController alloc] initWithNibName:@"PDOptionsViewController" bundle:nil];
    optionsController.listType = ListChildAllergies;
    optionsController.selectedTexts = [alreadySelectedAllergies mutableCopy];
    [optionsController openFromController:self withCompletionBlock:^(NSArray *options, NSArray *indexes) {
        alreadySelectedAllergies = options;
        if ([options count] > 0)
        {
            NSString *allergies = [options componentsJoinedByString:@"\n"];
            lblAllergies.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
            lblAllergies.text = allergies;
            [lblAllergies sizeToFit];
            
            CGRect rect  = lblAllergies.frame;
            if (rect.size.height < 30.0) {
                rect.size.height = 30.0;
                     rect.size.width = 245.0;
                lblAllergies.frame =rect;
            }
           
            [self Adjust_Size_height];
      }
        else
        {
         //   [svAllergies setContentSize:CGSizeZero];
            lblAllergies.text = @"ALLERGIES" ;
            lblAllergies.textColor = [UIColor lightGrayColor];
               CGRect rect  = lblAllergies.frame;
                rect.size.height = 30.0;
                 rect.size.width = 245.0;
                lblAllergies.frame =rect;
            [self Adjust_Size_height];



        }
    }];

}
-(void)freeTimeAction:(UIGestureRecognizer *)recognizer
{
     [datePicker hide];
     [self resignKeyBoard];
        
        if (![[self.view subviews] containsObject:freeTimePicker])
        {
            if ([[self.view subviews] containsObject:datePicker]) {
                [datePicker hide];
            }
            
    [freeTimePicker showInView:self.view hideday:-1 withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
//     [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
                
            } andPickerDoneBlock:^(NSString *currentResult) {
                
                if (currentResult.length==0)
                {
                    [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start time can't be same or greater than end time" delegate:nil cancelButtonTitle:@"ok'" otherButtonTitles:nil]show];
                }

                else
                {
                currentResult= [currentResult uppercaseString];
                lblFreeTime.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
                lblFreeTime.text = currentResult ;
                
                CGSize size = [currentResult sizeWithFont:lblFreeTime.font];
                CGRect rect = lblFreeTime.frame;
                rect.size.width = size.width;
                lblFreeTime.frame = rect;
                }
             [svFreeTime setContentSize:CGSizeMake(lblFreeTime.frame.size.width + 5.0, lblFreeTime.frame.size.height)];
                
            } cancelBlock:^{
                [scrollView setContentOffset:CGPointZero animated:YES];
                
            }];
        }
}
-(void)hobbiesAction:(UIGestureRecognizer *)recognizer
{
    
    [self resignKeyBoard];
    [freeTimePicker hide];
    [datePicker hide];

    PDOptionsViewController *optionsController = [[PDOptionsViewController alloc] initWithNibName:@"PDOptionsViewController" bundle:nil];
    optionsController.listType = ListChildHobbies;
    optionsController.selectedTexts = [alreadySelectedHobbies mutableCopy];
    [optionsController openFromController:self withCompletionBlock:^(NSArray *options, NSArray *indexes) {
        alreadySelectedHobbies = options;
        if ([options count] > 0)
        {
            NSString *hobbies = [options componentsJoinedByString:@"\n"];
            
            lblHobbies.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
            lblHobbies.text = hobbies;
              [lblHobbies sizeToFit];
            CGRect rect  = lblHobbies.frame;
            if (rect.size.height < 30.0) {
                rect.size.height = 30.0;
                rect.size.width = 245.0;
                lblHobbies.frame =rect;
            }
            [self Adjust_Size_height];

           
    

        }
        else
        {
           // [svHobbies setContentSize:CGSizeZero];
            lblHobbies.text = @"HOBBIES";
            lblHobbies.textColor = [UIColor lightGrayColor];
               CGRect rect  = lblHobbies.frame;
                rect.size.height = 30.0;
               rect.size.width = 245.0;

                lblHobbies.frame =rect;
            [self Adjust_Size_height];



        }
    }];

}

-(IBAction)btnFreeTimeAction:(id)sender
{
    [datePicker hide];
    [self resignKeyBoard];
    
    if (![[self.view subviews] containsObject:freeTimePicker])
    {
        if ([[self.view subviews] containsObject:datePicker]) {
            [datePicker hide];
        }
        
         [freeTimePicker showInView:self.view hideday:-1 withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
//        [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
        
        } andPickerDoneBlock:^(NSString *currentResult) {
            
            NSString *strTemp;
            if (currentResult.length==0)
            {
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start time can't be same or greater than end time" delegate:nil cancelButtonTitle:@"ok'" otherButtonTitles:nil]show];
            }
            

            else if ([lblFreeTime.text isEqualToString:@"FREE TIME"])
            {
                strTemp = [currentResult uppercaseString];
                lblFreeTime.text = strTemp;
            }
            else
            {
               strTemp = [[lblFreeTime.text stringByAppendingFormat:@" ,%@", currentResult] uppercaseString];
            
              
            
            lblFreeTime.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
            lblFreeTime.text = strTemp;
            
            CGSize size = [strTemp sizeWithFont:lblFreeTime.font];
            CGRect rect = lblFreeTime.frame;
            rect.size.width = size.width;
            lblFreeTime.frame = rect;
            }
            [svFreeTime setContentSize:CGSizeMake(lblFreeTime.frame.size.width + 5.0, lblFreeTime.frame.size.height)];
            
            
            
            
            
            
        } cancelBlock:^{
            [scrollView setContentOffset:CGPointZero animated:YES];
            
        }];
        
        
    }
    
    

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
