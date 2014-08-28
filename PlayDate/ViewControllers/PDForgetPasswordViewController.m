//
//  PDForgetPasswordViewController.m
//  PlayDate
//
//  Created by Vakul on 07/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDForgetPasswordViewController.h"

@interface PDForgetPasswordViewController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    IBOutlet UIView *navigationView;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *tFEmail;
    IBOutlet UIView *forgetPasswordView;
    
    IBOutlet UIScrollView *changePasswordScrollView;
    IBOutlet UITextField *tFToken;
    IBOutlet UITextField *tFNewPassword;
    IBOutlet UITextField *tFConfirmPassword;
    IBOutlet UIView *changePasswordView;
    
    NSDictionary *responseDict;
}

-(void)setUpViewContents;
-(void)setContentInsectOfEachTextField;
-(void)resignKeyBoard;
-(BOOL)validateFields;

-(IBAction)sendEmailAction:(id)sender;
-(IBAction)backAction:(id)sender;

@end

@implementation PDForgetPasswordViewController

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
    
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    //changePasswordScrollView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    
    
    // DROP SHADWO TO FORGET PASSWORD BACKGROUND VIEW
    forgetPasswordView.layer.shadowOpacity = 0.5;
    forgetPasswordView.layer.shadowColor = [UIColor blackColor].CGColor;
    forgetPasswordView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    
    // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];
    
    
    // SETTING CONTENT INSECT OF TEXTFIELD BECAUSE IT HAS BACKGROUND IMAGE WE WILL HAVE TO MOVE ITS CONTENT A BIT LEFT
    [self setContentInsectOfEachTextField];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions
-(IBAction)sendEmailAction:(id)sender
{
    [self resignKeyBoard];
    
    if ([self validateFields])
    {
        [[AppDelegate sharedDelegate] showActivityWithTitle:@"Sending Email..."];
        [self performSelector:@selector(activityDidAppear) withObject:nil afterDelay:0.2];
    }

}
-(IBAction)backAction:(id)sender
{
    [[AppDelegate sharedDelegate] popViewController:self];

   // [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Methods
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
    }
    
    
    rect = scrollView.frame;
    rect.origin.y = CGRectGetMaxY(navigationView.frame);
    rect.size.height = totalHeight - CGRectGetMaxY(navigationView.frame);
    scrollView.frame = rect;
}


-(void)setContentInsectOfEachTextField
{
    for (UITextField *tF in forgetPasswordView.subviews)
    {
        if ([tF isKindOfClass:[UITextField class]]) {
            
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, tF.frame.size.height)];
            leftView.backgroundColor = tF.backgroundColor;
            tF.leftView = leftView;
            tF.leftViewMode = UITextFieldViewModeAlways;
        }
    }
    
//    for (UITextField *tF in changePasswordView.subviews)
//    {
//        if ([tF isKindOfClass:[UITextField class]]) {
//            
//            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, tF.frame.size.height)];
//            leftView.backgroundColor = tF.backgroundColor;
//            tF.leftView = leftView;
//            tF.leftViewMode = UITextFieldViewModeAlways;
//        }
//    }

}


-(void)resignKeyBoard
{
    for (UITextField *tF in forgetPasswordView.subviews)
    {
        if ([tF isKindOfClass:[UITextField class]]) {
            [tF resignFirstResponder];
        }
    }
    
//    for (UITextField *tF in changePasswordView.subviews)
//    {
//        if ([tF isKindOfClass:[UITextField class]]) {
//            [tF resignFirstResponder];
//        }
//    }

}


-(void)activityDidAppear
{
    [[PDWebHandler sharedWebHandler] recoverPasswordWithParams:@{EMAIL:tFEmail.text}];
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
        
        responseDict = response;
        [[AppDelegate sharedDelegate] hideActivity];
        
        
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:[response objectForKey:MSG] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}


-(BOOL)validateFields
{
    // EMAIL VALIDATION
    NSString *str = tFEmail.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length>0 && [[PDHelper sharedHelper] validateEmail:str])
    {
        return YES;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
}


#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentSize:CGSizeZero];
    [scrollView setContentOffset:CGPointZero animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - AlertView Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[[responseDict objectForKey:DATA] objectForKey:SUCCESS] boolValue]) {
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        [[AppDelegate sharedDelegate] popViewController:self];
        
        //changePasswordScrollView.frame = scrollView.frame;
        //[self.view addSubview:changePasswordScrollView];
    }
}

@end
