//
//  PDChildProfileViewController.m
//  PlayDate
//
//  Created by Simpy on 09/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDChildProfileViewController.h"
#import "VSOptionsView.h"
#import "PDDateTimePicker.h"
#import "UIImageView+WebCache.h"
#import "PDOptionsViewController.h"
#import "PDProfileViewController.h"
#import "VSOptionsView.h"
#import "PDMainViewController.h"
#import "PDCalenderViewController.h"
#import "PDRequestArrangeViewController.h"
@interface PDChildProfileViewController ()<VSOptionsViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *childProfileImageViewContainer;
    IBOutlet UIImageView *iVChildProfile;
    IBOutlet UIButton *btnSave;
    
    
    IBOutlet UIView *dobBackgroundView;
   // IBOutlet UIView *conditionsBackgroundView;
    IBOutlet UIView *allergiesBackgroundView;
    IBOutlet UIView *hobbiesBackgroundView;
    IBOutlet UIView *schoolBackgroundView;
    IBOutlet UIView *youthClubBackgroundView;
    IBOutlet UIView *freeTimeBackgroundView;
   
    
    
    IBOutlet UITextField *tFChildName;
    IBOutlet UITextField *tFChildDOB;
    //IBOutlet UITextField *tFConditions;
  //  IBOutlet UIScrollView *svAllergies;
    //IBOutlet UIScrollView *svHobbies;
    IBOutlet UILabel *lblAllergies;
    IBOutlet UILabel *lblHobbies;
    IBOutlet UITextField *tFSchool;
    IBOutlet UITextField *tFYouthClub;
    IBOutlet UILabel     *lblFreeTime;
    IBOutlet UIButton *addfreeTimeBtn;
    
    VSOptionsView *imagePickerOptionsView;
    PDDateTimePicker *datePicker;
    PDDateTimePicker *freeTimePicker;
    VSOptionsView *optionsView;
    
    NSMutableArray *alreadySelectedAllergies;
    NSMutableArray *alreadySelectedHobbies;
    
    IBOutlet UIScrollView *childScrollView;
    NSArray *arrParentData;
    NSArray *arrParent_Ids;
    NSDictionary *detail;
    NSString *strChild_id;
   
    IBOutlet UIImageView *imgVwTop;
    IBOutlet UIButton   *btnArrange;
    IBOutlet UIButton   *btnCalender;
    IBOutlet UIButton   *btnMenu;
    IBOutlet UIButton  *btnHome;
    NSMutableArray *arrSetFixedTime;

}
@property (strong, nonatomic) IBOutlet UIView *topMenuView;
@property (nonatomic) GUARDIAN_TYPE guardianType;
@end

@implementation PDChildProfileViewController
@synthesize childProfileArray = _childProfileArray;
@synthesize parentProfileArray = _parentProfileArray;
@synthesize index = _index;

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
    
    arrSetFixedTime=[[NSMutableArray alloc]init];
    iVChildProfile.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    iVChildProfile.layer.shadowRadius = 2.0;
    iVChildProfile.layer.shadowOpacity = 0.5;
    iVChildProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    iVChildProfile.layer.borderWidth = 2.0;
    
    
    
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
    
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [self setUpViewContents];
    
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(infoShowCallWebServices) withObject:nil afterDelay:0.1];

 
   
    NSString *guardianType = @"FATHER";
    self.guardianType = G_FATHER;
    if ([[detail objectForKey:PDWebGuardianType] isEqualToString:@"m"])
    {
        guardianType = @"MOTHER";
        self.guardianType = G_MOTHER;
    }
    else if ([[detail objectForKey:PDWebGuardianType] isEqualToString:@"gm"])
    {
        guardianType = @"GRAND MOTHER";
        self.guardianType = G_GRAND_MOTHER;
    }
    else if ([[detail objectForKey:PDWebGuardianType] isEqualToString:@"gf"])
    {
        guardianType = @"GRAND FATHER";
        self.guardianType = G_GRAND_FATHER;
    }
    
   

    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
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
    [tFChildDOB resignFirstResponder];
    [tFChildName resignFirstResponder];
 //   [tFConditions resignFirstResponder];
    [tFSchool resignFirstResponder];
    [tFYouthClub resignFirstResponder];
}

-(void)resignPhonePad
{
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 50.0)];
    [scrollView setContentOffset:CGPointZero animated:YES];
  
}

-(IBAction)addFreeTimeAction:(id)sender
{
    [self resignKeyBoard];
    CGPoint scrollPoint = CGPointMake(0.0, lblFreeTime.frame.origin.y+190.0);
    [scrollView setContentOffset:scrollPoint animated:YES];
 
    if (![[self.view subviews] containsObject:freeTimePicker])
    {
        if ([[self.view subviews] containsObject:datePicker]) {
            [datePicker hide];
        }
        
     [freeTimePicker showInView:self.view hideday:-1 withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
//        [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
        
        } andPickerDoneBlock:^(NSString *currentResult) {
            
            
            if (currentResult.length==0)
            {
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start time can't be same or greater than end time" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            }
            
            else  if ([lblFreeTime.text isEqualToString:@"FREE TIME"]) {
                lblFreeTime.text = [currentResult uppercaseString];
                [arrSetFixedTime removeAllObjects];
                [arrSetFixedTime addObject:currentResult];
            }
            else {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", currentResult];
                BOOL containsResult = ([[arrSetFixedTime filteredArrayUsingPredicate:predicate] count] > 0) ? YES : NO;
                if (containsResult)
                    [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Free time shouldn't be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
                else
                {
                lblFreeTime.text = [[lblFreeTime.text stringByAppendingFormat:@"\n%@", currentResult] uppercaseString];
                [arrSetFixedTime addObject:currentResult];
                }
            }
            [scrollView setContentOffset:CGPointZero animated:YES];
            
            
            [self changeContentsForFreeTime];
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
            [scrollView setContentOffset:CGPointZero animated:YES];
            
        } cancelBlock:^{
            [scrollView setContentOffset:CGPointZero animated:YES];
            
        }];

        
        
        
        
        
        
//        
//        [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
//            
//            NSLog(@"%@", pickedResult);
//            
//        } andPickerDoneBlock:^(NSString *currentResult) {
//            
//            if ([lblFreeTime.text isEqualToString:@"FREE TIME"]) {
//                lblFreeTime.text = [currentResult uppercaseString];
//            }
//            else {
//                
//                lblFreeTime.text = [[lblFreeTime.text stringByAppendingFormat:@"\n%@", currentResult] uppercaseString];
//            }
//            [scrollView setContentOffset:CGPointZero animated:YES];
//
//            
//            [self changeContentsForFreeTime];
//            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
//            [scrollView setContentOffset:CGPointZero animated:YES];
//        }];
    }
}

-(void)tapOnFreeTime:(UIGestureRecognizer *)gesture
{
    [self resignKeyBoard];
    CGPoint scrollPoint = CGPointMake(0.0, lblFreeTime.frame.origin.y+190.0);
    [scrollView setContentOffset:scrollPoint animated:YES];
    
    if (![[self.view subviews] containsObject:freeTimePicker])
    {
        if ([[self.view subviews] containsObject:datePicker]) {
            [datePicker hide];
        }
        
        
        
          [freeTimePicker showInView:self.view hideday:-1 withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
        
//        [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
            
        } andPickerDoneBlock:^(NSString *currentResult) {
            
            NSLog(@"%@",currentResult);
            
            if (currentResult.length==0)
            {
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start time is less than end time" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
                            }
            
         else   if ([lblFreeTime.text isEqualToString:@"FREE TIME"]) {
                lblFreeTime.text = [currentResult uppercaseString];
             [arrSetFixedTime removeAllObjects];
             [arrSetFixedTime addObject:currentResult];

            }
            else {
                
                lblFreeTime.text = [currentResult uppercaseString];
                [arrSetFixedTime removeAllObjects];
                 [arrSetFixedTime addObject:currentResult];

                // [[lblFreeTime.text stringByAppendingFormat:@"\n%@", currentResult] uppercaseString];
            }
            
            
            [self changeContentsForFreeTime];
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
            [scrollView setContentOffset:CGPointZero animated:YES];

            
        } cancelBlock:^{
            [scrollView setContentOffset:CGPointZero animated:YES];
            
        }];
        

        
        
        
//        
//        [freeTimePicker showInView:self.view withType:PDPickerTypeFreeTime withPickingBlock:^(NSString *pickedResult) {
//            
//            NSLog(@"%@", pickedResult);
//            
//        } andPickerDoneBlock:^(NSString *currentResult) {
//            
//            if ([lblFreeTime.text isEqualToString:@"FREE TIME"]) {
//                lblFreeTime.text = [currentResult uppercaseString];
//            }
//            else {
//                
//                lblFreeTime.text = [[lblFreeTime.text stringByAppendingFormat:@"\n%@", currentResult] uppercaseString];
//            }
//            [scrollView setContentOffset:CGPointZero animated:YES];
//            
//            
//            [self changeContentsForFreeTime];
//            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
//            [scrollView setContentOffset:CGPointZero animated:YES];
//        }];
    }
}

-(void)changeContentsForFreeTime
{
    
    CGFloat fixedWidth = lblFreeTime.frame.size.width;
    CGSize newSize = [lblFreeTime sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = lblFreeTime.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    lblFreeTime.frame = newFrame;

    
    
    //[lblFreeTime sizeToFit];
    
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
    
    //rect = conditionsBackgroundView.frame;
    //rect.origin.y = CGRectGetMaxY(freeTimeBackgroundView.frame) + 5.0;
  //  conditionsBackgroundView.frame = rect;
    
    
    
    rect = allergiesBackgroundView.frame;
    rect.origin.y = CGRectGetMaxY(freeTimeBackgroundView.frame) + 5.0;
    allergiesBackgroundView.frame = rect;
    
    
    rect = hobbiesBackgroundView.frame;
    rect.origin.y = CGRectGetMaxY(allergiesBackgroundView.frame) + 5.0;
    hobbiesBackgroundView.frame = rect;
    
    
    rect = schoolBackgroundView.frame;
    rect.origin.y = CGRectGetMaxY(hobbiesBackgroundView.frame) + 5.0;
    schoolBackgroundView.frame = rect;
    
    
    rect = youthClubBackgroundView.frame;
    rect.origin.y = CGRectGetMaxY(schoolBackgroundView.frame) + 5.0;
    youthClubBackgroundView.frame = rect;

    
    
    
    rect = btnSave.frame;
    rect.origin.y = CGRectGetMaxY(youthClubBackgroundView.frame) + 25.0;
    btnSave.frame = rect;
}

#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
    
    [scrollView setContentOffset:CGPointZero animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseStringWithLocale:[NSLocale currentLocale]]];
    
    return NO;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == tFChildDOB) {
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
            NSString  *strDate = [df stringFromDate:[NSDate date]];
       //     NSDate *date=[df dateFromString:strDate];
//            datePicker.endDate=date;
//             datePicker.startDate=nil;
   
            [datePicker showInView:self.view hideday:0 withType:PDPickerTypeDate withPickingBlock:^(NSString *pickedResult) {
            
//            [datePicker showInView:self.view withType:PDPickerTypeDate withPickingBlock:^(NSString *pickedResult) {
//                
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
                    tFChildDOB.text = [currentResult uppercaseString];
                }
                else
                {
                    [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Date of Birth Date must be Less than current date" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
                }
          [scrollView setContentOffset:CGPointZero animated:YES];
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



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *vw;
    if (textField==tFSchool)
        vw=schoolBackgroundView;
    
    else if (textField==tFYouthClub)
        vw=youthClubBackgroundView;
//    else if (textField==tFConditions)
//        vw=conditionsBackgroundView;

    CGPoint scrollPoint = CGPointMake(0.0, vw.frame.origin.y-100);
    [scrollView setContentOffset:scrollPoint animated:YES];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 300.0)];
    
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
    
//    [self changeContentsForLocation];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [freeTimePicker hide];
    [datePicker hide];
    
    CGPoint scrollPoint = CGPointMake(0.0, textView.frame.origin.y+150.0);
    [scrollView setContentOffset:scrollPoint animated:YES];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 260.0)];
}

#pragma mark - Allergies & Hobbies Action
-(void)allergiesAction:(UIGestureRecognizer *)recognizer
{
    
    [self resignKeyBoard];
    [freeTimePicker hide];
     [datePicker hide];
        [scrollView setContentOffset:CGPointZero animated:NO];
    PDOptionsViewController *optionsController = [[PDOptionsViewController alloc] initWithNibName:@"PDOptionsViewController" bundle:nil];
    optionsController.listType = ListChildAllergies;
    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
    for (int i=0; i<[alreadySelectedAllergies count]; i++)
    {
        [arrTemp addObject:[[NSString stringWithFormat:@"%@",[alreadySelectedAllergies objectAtIndex:i]]uppercaseString]];
    }

    optionsController.selectedTexts = [arrTemp mutableCopy];
    [optionsController openFromController:self withCompletionBlock:^(NSArray *options, NSArray *indexes) {
           //   [alreadySelectedAllergies addObjectsFromArray:options];
        alreadySelectedAllergies=[options mutableCopy];
        if ([options count] > 0)
        {
            NSString *allergies = [options componentsJoinedByString:@"\n"];
        //    lblAllergies.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
            lblAllergies.text = allergies;
            
            CGSize size = [allergies sizeWithFont:lblAllergies.font];
            CGRect rect = lblAllergies.frame;
            rect.size.width = size.width;
            lblAllergies.frame = rect;
            [lblAllergies sizeToFit];
            
            rect  = lblAllergies.frame;
            if (rect.size.height < 30.0) {
                rect.size.height = 30.0;
                rect.size.width = 150.0;
                lblAllergies.frame =rect;
            }
            
         //   [svAllergies setContentSize:CGSizeMake(lblAllergies.frame.size.width + 5.0, svAllergies.frame.size.height)];
        }
        else
        {
         //   [svAllergies setContentSize:CGSizeZero];
            lblAllergies.text = @"ALLERGIES";
            lblAllergies.textColor = [UIColor lightGrayColor];
            CGRect rect  = lblAllergies.frame;
            rect.size.height = 30.0;
            rect.size.width = 150.0;
            lblAllergies.frame =rect;
        }
        [self adjustFrame_size];
    }];
    
}

-(void)hobbiesAction:(UIGestureRecognizer *)recognizer
{
    
    [self resignKeyBoard];
    [freeTimePicker hide];
    [datePicker hide];
    [scrollView setContentOffset:CGPointZero animated:NO];
    PDOptionsViewController *optionsController = [[PDOptionsViewController alloc] initWithNibName:@"PDOptionsViewController" bundle:nil];
    optionsController.listType = ListChildHobbies;
    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
    for (int i=0; i<[alreadySelectedHobbies count]; i++)
    {
        [arrTemp addObject:[[NSString stringWithFormat:@"%@",[alreadySelectedHobbies objectAtIndex:i]]uppercaseString]];
    }
    
    optionsController.selectedTexts = [arrTemp mutableCopy];
    [optionsController openFromController:self withCompletionBlock:^(NSArray *options, NSArray *indexes) {
            alreadySelectedHobbies=[options mutableCopy];
    //    [alreadySelectedHobbies addObjectsFromArray:options];
        if ([options count] > 0)
        {
            NSString *hobbies = [options componentsJoinedByString:@"\n"];

           // lblHobbies.textColor =[] [[PDHelper sharedHelper] applicationThemeBlueColor];
            lblHobbies.text = hobbies;
            CGRect rect ;
//            CGSize size = [hobbies sizeWithFont:lblHobbies.font];
//            CGRect rect = lblHobbies.frame;
//            rect.size.width = size.width;
//            lblHobbies.frame = rect;
            
            [lblHobbies sizeToFit];
            
            rect  = lblHobbies.frame;
            if (rect.size.height < 30.0) {
                rect.size.height = 30.0;
                rect.size.width = 150.0;
                lblHobbies.frame =rect;
            }
            

            
            
        //    [svHobbies setContentSize:CGSizeMake(lblHobbies.frame.size.width + 5.0 + 5.0, svHobbies.frame.size.height)];
        }
        else
        {
       //     [svHobbies setContentSize:CGSizeZero];
            lblHobbies.text = @"HOBBIES";
            lblHobbies.textColor = [UIColor lightGrayColor];
            CGRect rect  = lblHobbies.frame;
            rect.size.height = 30.0;
            rect.size.width = 150.0;
            lblHobbies.frame =rect;
          

        }
          [self adjustFrame_size];
    }];
    
}

-(BOOL)validateFields
{
    
    NSString *stringOnlyRegex = @"[a-z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[C] %@", stringOnlyRegex];
    
    // VALIDATE NAME
    NSString *str = tFChildName.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length>0 && [predicate evaluateWithObject:str])
    {
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter  valid name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
       
    return YES;
}


-(IBAction)saveAction:(id)sender
{
    [self resignKeyBoard];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
    
    
    if ([self validateFields])
    {
        [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Saving..."];
        [self performSelector:@selector(activityDidAppear) withObject:nil afterDelay:0.1];
    }
}
-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)activityDidAppear
{
    
    NSString *DOB = [tFChildDOB text];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MMMM-yyyy"];
    NSDate *date = [df dateFromString:DOB];
    NSString *dateToSend = [[[PDHelper sharedHelper] backEndDateFormatter] stringFromDate:date];
    if (!dateToSend)
        dateToSend = @"";
    
    
    
    /*
     *
     */
    
    NSString *gType = @"m";
    if (self.guardianType == G_FATHER)
        gType = @"f";
    else if (self.guardianType == G_GRAND_MOTHER)
        gType = @"gm";
    else if (self.guardianType == G_GRAND_FATHER)
        gType = @"gf";
    
    NSString *strAllergies=lblAllergies.text;
 strAllergies=   [strAllergies stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    NSString *strHobbies=lblHobbies.text;
 strHobbies=   [strHobbies stringByReplacingOccurrencesOfString:@"\n" withString:@","];
  
    // g_id=1&name=abcde&dob=1989-07-08&location=aaabcde&phone=9872742345&set_fixed_freetime=12
    NSDictionary *params = @{FBName: tFChildName.text,
                             PDWebDOB: dateToSend,
                           /*  PDWebConditions:tFConditions.text,*/
                             PDWebAllergies:strAllergies,
                             PDWebHobbies:strHobbies,
                             PDWebSchool:tFSchool.text,
                             PDWebYouthClub:tFYouthClub.text,
                             PDWebFreeTime: [lblFreeTime.text stringByReplacingOccurrencesOfString:@"\n" withString:@","],
                             @"childid": strChild_id};
    

    
      [[PDWebHandler sharedWebHandler] editChildParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
        [[PDAppDelegate sharedDelegate] hideActivity];
        
        if (!error)
        {
            if ([[response objectForKey:PDWebSuccess] boolValue]) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Profile has been updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                
//                NSMutableDictionary *detail = [[[PDUser currentUser] detail] mutableCopy];
//                NSArray *newUserInfo  = [response objectForKey:PDFriends];
//                for (int i=0;i<[newUserInfo count];i++)
//                {
//                    if ([ [newUserInfo objectAtIndex:i]valueForKey:@""
//
//                
//                }
//                [detail setObject:newUserInfo forKey:PDUserInfo];
//                
//                [[PDUser currentUser] setDetail:detail];
//                [[PDUser currentUser] save];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark iBoutlets

-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
        
        
    }];
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
    
    for (int i=0; i<[arrParentData count]; i++)
    {
       // NSLog(@"%d",indexOfChild);
        NSDictionary *detail1 = [arrParentData objectAtIndex:i];
        
        row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
        row.tag=i;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
        bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row.layer addSublayer:bottomBorder];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 36.0, 36.0)];
        [imageView setImageWithURL:[NSURL URLWithString:[detail1 objectForKey:PDWebProfileImage]] placeholderImage:[UIImage imageNamed:@"user_img"]];
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row addSubview:imageView];
        
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, childScrollView.frame.size.width-55.0, 50.0)];
        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:9.0];
     //   titleView.text = [detail objectForKey:PDWebChildName];Parentname
        titleView.text=   [detail1 objectForKey:@"Parentname"];

        titleView.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        titleView.numberOfLines = 1;
        [row addSubview:titleView];
        [childScrollView addSubview:row];
        row_Y = row_Y + 50.0;
       UITapGestureRecognizer   *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getChildInfo:)];
        [row addGestureRecognizer:tapGes];
    }
    
    [childScrollView setContentSize:CGSizeMake(childScrollView.frame.size.width, row_Y)];
  //  [activity stopAnimating];
   // [activity setHidden:YES];
}
-(void)infoShowCallWebServices
{
    if (self.fromSets)
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
        
        
        
        [self  callWebService_ChildInfo];
        [addfreeTimeBtn setHidden:YES];
        [btnSave setHidden:YES];
        tFChildName.userInteractionEnabled = NO;
        tFChildDOB.userInteractionEnabled = NO;
        // tFConditions.userInteractionEnabled = NO;
        tFSchool.userInteractionEnabled = NO;
        tFYouthClub.userInteractionEnabled = NO;
    }
    else
    {
        if (self.fromDirectlyParent)
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

        }
        
        [self  callWebService_ChildInfo];
    }
}
-(void)reloadFriendChildParent
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
    
    for (int i=0; i<[self.parentProfileArray count]; i++)
    {
        // NSLog(@"%d",indexOfChild);
        NSDictionary *details = [self.parentProfileArray objectAtIndex:i];
        
        row = [[UIView alloc] initWithFrame:CGRectMake(row_X, row_Y, rowWidth, rowHeight)];
        row.tag=i;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0, rowHeight-1.0, rowWidth, 1.0);
        bottomBorder.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row.layer addSublayer:bottomBorder];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 36.0, 36.0)];
        NSURL *url = [details valueForKey:PDWebProfileImage];
        [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_img"]];
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [PDHelper sharedHelper].applicationBackgroundColor.CGColor;
        [row addSubview:imageView];
        
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 0.0, childScrollView.frame.size.width-55.0, 50.0)];
        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:9.0];
        //   titleView.text = [detail objectForKey:PDWebChildName];
        titleView.text = [[details valueForKey:@"name"] uppercaseString];
        
        titleView.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
        titleView.numberOfLines = 0;
        [row addSubview:titleView];
        [childScrollView addSubview:row];
        row_Y = row_Y + 50.0;
        UITapGestureRecognizer   *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getChildInfo:)];
        [row addGestureRecognizer:tapGes];
    }
    
    [childScrollView setContentSize:CGSizeMake(childScrollView.frame.size.width, row_Y)];
}


-(void)getChildInfo:(UITapGestureRecognizer *)Gesture
{
    PDProfileViewController *objPDProfileViewController = [[PDProfileViewController alloc]initWithNibName:@"PDProfileViewController" bundle:nil];
    NSLog(@"%@",arrParentData);
    NSString *strTempID=[arrParent_Ids objectAtIndex:Gesture.view.tag];
//    if ([[[arrParentData objectAtIndex:Gesture.view.tag] allKeys] containsObject:@"g_id"])
//    
//        strTempID=[[arrParentData objectAtIndex:Gesture.view.tag]objectForKey:@"g_id"];
//    else
//    strTempID=[[arrParentData objectAtIndex:Gesture.view.tag]objectForKey:@"auth_g_id"];
    
    
    
    objPDProfileViewController.str_Parent_gid=strTempID;
    if (self.fromSets) {
        objPDProfileViewController.isFromSets = YES;
         //objPDProfileViewController.friendProfileArray = self.childProfileArray;
    }
    else
    {
        objPDProfileViewController.isFromSets = NO;
        //arrParentData
    }
    [self.navigationController pushViewController:objPDProfileViewController animated:NO];
}
-(void)actionImageGesture
{
           [imagePickerOptionsView showAtCenter];
    

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
            {
                [iVChildProfile setImage:image ];
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
                [iVChildProfile setImage:image ];
            
            [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Saving..."];
            [self performSelector:@selector(callWebService_SendImage:) withObject:image afterDelay:0.1];
            }
            

        }];
        
    }
 

    
}
-(void)adjustFrame_size
{
    CGRect rect;
    rect=allergiesBackgroundView.frame;
    rect.origin.y=CGRectGetMaxY(freeTimeBackgroundView.frame)+5.0;
    allergiesBackgroundView.frame=rect;
    rect=allergiesBackgroundView.frame;
    rect.size.height=CGRectGetMaxY(lblAllergies.frame);
    allergiesBackgroundView.frame=rect;
    
    
    
    rect=hobbiesBackgroundView.frame;
    rect.origin.y=CGRectGetMaxY(allergiesBackgroundView.frame)+5.0;
    hobbiesBackgroundView.frame=rect;
    rect=hobbiesBackgroundView.frame;
    rect.size.height=CGRectGetMaxY(lblHobbies.frame);
    hobbiesBackgroundView.frame=rect;

    rect=schoolBackgroundView.frame;
    rect.origin.y=CGRectGetMaxY(hobbiesBackgroundView.frame)+5.0;
    schoolBackgroundView.frame=rect;
    
    rect=youthClubBackgroundView.frame;
    rect.origin.y=CGRectGetMaxY(schoolBackgroundView.frame)+5.0;
    youthClubBackgroundView.frame=rect;

    rect=btnSave.frame;
    rect.origin.y=CGRectGetMaxY(youthClubBackgroundView.frame)+15.0;
    btnSave.frame=rect;
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];

}
-(void)callWebService_ChildInfo
{

      NSDictionary *params = @{PDWebChildId:[[self.childProfileArray objectAtIndex:self.index] valueForKey:PDWebChildId] };
    
    
    
    [[PDWebHandler sharedWebHandler] childInfoBasedOnChildID_ListParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
        if (!error)
        {
            if ([[response objectForKey:PDWebSuccess] boolValue]) {
                
                [btnSave setHidden:NO];
                tFChildName.userInteractionEnabled = NO;
                tFChildDOB.userInteractionEnabled = YES;

                tFSchool.userInteractionEnabled = YES;
                tFYouthClub.userInteractionEnabled = YES;
                
                detail = [response valueForKey:@"childinfo"];
                tFChildName.text = [[detail objectForKey:PDWebChildName] uppercaseString];
                
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString =  [detail objectForKey:PDWebDOB];
                NSDate *date = [dateFormatter dateFromString:dateString];
                [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
                tFChildDOB.text = [[dateFormatter stringFromDate:date] uppercaseString];
                
                //  tFConditions.text = [[detail objectForKey:PDWebConditions] uppercaseString];
                NSString *strAllergiesTemp=  [[[detail objectForKey:PDWebAllergies] uppercaseString] stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
                NSString *strHobbiesTemp=  [[[detail objectForKey:PDWebHobbies] uppercaseString] stringByReplacingOccurrencesOfString:@"," withString:@"\n"];

                lblAllergies.text = strAllergiesTemp;
                lblHobbies.text = strHobbiesTemp;
                tFSchool.text = [[detail objectForKey:PDWebSchool] uppercaseString];
                tFYouthClub.text = [[detail objectForKey:PDWebYouthClub]uppercaseString];
                lblFreeTime.text =[[[detail objectForKey:PDWebFreeTime]uppercaseString]stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
                arrSetFixedTime=[[[detail objectForKey:PDWebFreeTime] componentsSeparatedByString:@","]mutableCopy];
          

                strChild_id=[detail objectForKey:PDWebChildId];
                
                
                alreadySelectedAllergies = [[[detail objectForKey:PDWebAllergies] componentsSeparatedByString:@","] mutableCopy];
                alreadySelectedHobbies = [[[detail objectForKey:PDWebHobbies] componentsSeparatedByString:@","] mutableCopy];
                [lblAllergies sizeToFit];
                [lblHobbies sizeToFit];
                
               CGRect rect  = lblAllergies.frame;
                if (rect.size.height < 30.0) {
                    rect.size.height = 30.0;
                    rect.size.width = 150.0;
                    lblAllergies.frame =rect;
                }
                rect  = lblHobbies.frame;
                if (rect.size.height < 30.0) {
                    rect.size.height = 30.0;
                    rect.size.width = 150.0;
                    lblHobbies.frame =rect;
                }

                [self changeContentsForFreeTime];
                [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(btnSave.frame) + 19.0)];
                [scrollView setContentOffset:CGPointZero animated:YES];

                
                [self adjustFrame_size];

                
//                NSDictionary *detailParent = [[[PDUser currentUser] detail] objectForKey:PDUserInfo];// get from local data base
//                
//                NSLog(@"%@",detailParent);
//                 [response valueForKey:@"parent"];
                 
                NSMutableArray *arrTemp=[[NSMutableArray alloc]initWithArray:[response valueForKey:@"auth_parent"]];
               // NSMutableArray *arrTemp=[[NSMutableArray alloc]init] ;
                [arrTemp addObject:  [response valueForKey:@"parent"]];
                
                 arrParentData=[arrTemp mutableCopy];
      
                NSMutableArray *arrTemp_ID=[[NSMutableArray alloc]init];
                for (int i=0; i<[arrParentData count]; i++)
                {
                    if ([[[arrParentData objectAtIndex:i]allKeys] containsObject:@"auth_g_id"])
                        [arrTemp_ID addObject:[[arrParentData objectAtIndex:i]objectForKey:@"auth_g_id"]];
                    else
                        [arrTemp_ID addObject:[[arrParentData objectAtIndex:i]objectForKey:@"g_id"]];

                }
                
                
                // Array contain parent id  and Check is it editable or not
                arrParent_Ids =[arrTemp_ID copy];

             if (![arrParent_Ids containsObject:[[[[PDUser currentUser] detail]objectForKey:PDUserInfo] objectForKey:PDWebGID]])
             {
                 
                   [btnSave setHidden:YES];

             }
              else
              {
                  // DATE PICKER && FREE TIME PICKER
                  datePicker = [[PDDateTimePicker alloc] initWithType:PDPickerTypeDate];
                  freeTimePicker = [[PDDateTimePicker alloc] initWithType:PDPickerTypeFreeTime];
                  
                  // ADD TAP GESTURE TO FREE TIME LABEL
                  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnFreeTime:)];
                  lblFreeTime.userInteractionEnabled = YES;
                  [lblFreeTime addGestureRecognizer:tapGesture];
                  
                  // TAP GESTURE ON HOBBIES AND ALLERGIES
                  UITapGestureRecognizer *tapOnAllergies = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allergiesAction:)];
                  [lblAllergies addGestureRecognizer:tapOnAllergies];
                  
                  UITapGestureRecognizer *tapOnHobbies = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hobbiesAction:)];
                  [lblHobbies addGestureRecognizer:tapOnHobbies];
                  
                  
                  
                  UITapGestureRecognizer   *tapGestureImage =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionImageGesture)];
                  
                  [iVChildProfile addGestureRecognizer:tapGestureImage];
                  [btnSave setHidden:NO];


              }
                
                __block UIImageView *iV = iVChildProfile;
                __block UIView *iVC = childProfileImageViewContainer;
                
                [iVChildProfile setImageWithURL:[NSURL URLWithString:[detail objectForKey:PDWebProfileImage]] placeholderImage:[UIImage imageNamed:@"user_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    
                    if (!error)
                    {
                        CGSize perfectSize = [[PDHelper sharedHelper] perfectSizeOfImage:image withMaximumHeight:iV.frame.size.height andMaximumWidth:iV.frame.size.width];
                        CGRect r = CGRectMake((iVC.frame.size.width - perfectSize.width)/2.0, (iVC.frame.size.height - perfectSize.height)/2.0, perfectSize.width, perfectSize.height);
                        iV.frame = r;
                    }
                    
                }];
                
                
                [self reloadChilds];

                
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
        [[PDAppDelegate sharedDelegate] hideActivity];
        
    }];

    
    

}
-(void)callWebService_SendImage:(UIImage *)img
{
    NSString *guardianID = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebGID];
    NSDictionary *detail1 = [self.childProfileArray objectAtIndex:self.index];
    NSString *strChild_idTemp= [detail1 valueForKey:PDWebChildId];
    NSData *data = UIImageJPEGRepresentation(iVChildProfile.image, 0.1);
    Base64Transcoder *base64 = [[Base64Transcoder alloc] init];
    NSString *imageString = [base64 base64EncodedStringfromData:data];
    NSDictionary *params = @{PDWebGID:guardianID,
                             @"img": imageString,
                             @"childid":strChild_idTemp
                             };

 
    
    [[PDWebHandler sharedWebHandler] editChildPicListParams:params];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
     if (!error)
        {
            if ([[response objectForKey:PDWebSuccess] boolValue]) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Profile has been updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

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

@end
