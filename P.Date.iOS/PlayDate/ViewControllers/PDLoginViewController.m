//
//  PDLoginViewController.m
//  PlayDate
//
//  Created by Vakul on 06/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDLoginViewController.h"
#import "PDRegistrationViewController.h"
#import "PDForgetPasswordViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface PDLoginViewController () <UITextFieldDelegate>
{
    IBOutlet UIView *navigationView;
    IBOutlet UITextField *tFEmail;
    IBOutlet UITextField *tFPassword;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *loginView;
    IBOutlet UIButton *btnRegister;
    IBOutlet UIButton *btnLogin;
}

-(void)setUpViewContents;
-(void)setContentInsectOfEachTextField;
-(void)resignKeyBoard;
-(BOOL)validateFields;

-(IBAction)registerAction:(id)sender;
-(IBAction)loginAction:(id)sender;
-(IBAction)forgotPasswordAction:(id)sender;


@end

@implementation PDLoginViewController

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
    // Do any additional setup after loading the view.
    
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    
    
    // DROP SHADWO TO LOGIN BACKGROUND VIEW
    loginView.layer.shadowOpacity = 0.5;
    loginView.layer.shadowColor = [UIColor blackColor].CGColor;
    loginView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    
    // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];
    
    
    // SETTING CONTENT INSECT OF TEXTFIELD BECAUSE IT HAS BACKGROUND IMAGE WE WILL HAVE TO MOVE ITS CONTENT A BIT LEFT
    [self setContentInsectOfEachTextField];

    
    
    //tFEmail.text = @"def@gmail.com";
    //tFPassword.text = @"456";
}


-(void)viewDidAppear:(BOOL)animated
{
    if ([[PDUser currentUser] hasDetail]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
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
    for (UITextField *tF in loginView.subviews)
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
    for (UITextField *tF in loginView.subviews)
    {
        if ([tF isKindOfClass:[UITextField class]]) {
            [tF resignFirstResponder];
        }
    }
    
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
    
    
    // PASSWORD VALIDATION
    str = tFPassword.text;
    if (str.length > 0)
    {
        return YES;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    
}


#pragma mark - Button Action
-(IBAction)registerAction:(id)sender
{
    [scrollView setContentSize:CGSizeZero];
    [scrollView setContentOffset:CGPointZero animated:YES];
    [self resignKeyBoard];
    
    PDRegistrationViewController *registrationViewController = [[PDRegistrationViewController alloc] initWithNibName:@"PDRegistrationViewController" bundle:nil];
   // [self presentViewController:registrationViewController animated:NO completion:nil];

    [[AppDelegate sharedDelegate] pushViewController:registrationViewController fromController:self];
}

-(IBAction)loginAction:(id)sender
{
    [scrollView setContentSize:CGSizeZero];
    [scrollView setContentOffset:CGPointZero animated:YES];
    [self resignKeyBoard];
    
    if ([self validateFields])
    {
        [[AppDelegate sharedDelegate] showActivityWithTitle:@"Logging in..."];
        [self performSelector:@selector(activityDidAppear) withObject:nil afterDelay:0.2];
    }
    
    
//    [[AppDelegate sharedDelegate] showActivityWithTitle:@"Logging in..."];
//    [NSTimer scheduledTimerWithTimeInterval:5 target:[AppDelegate sharedDelegate] selector:@selector(hideActivity) userInfo:nil repeats:NO];

}

-(IBAction)forgotPasswordAction:(id)sender
{
    [scrollView setContentSize:CGSizeZero];
    [scrollView setContentOffset:CGPointZero animated:YES];
    [self resignKeyBoard];
    
    PDForgetPasswordViewController *forgetPasswordViewController = [[PDForgetPasswordViewController alloc] initWithNibName:@"PDForgetPasswordViewController" bundle:nil];
    
   // [self presentViewController:forgetPasswordViewController animated:YES completion:nil];

    [[AppDelegate sharedDelegate] pushViewController:forgetPasswordViewController fromController:self];
}


-(void)activityDidAppear
{
    [[PDWebHandler sharedWebHandler] logginUserWithParams:@{EMAIL:   tFEmail.text,
                                                            PASSWORD:tFPassword.text}];
    
    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error) {
        
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            if ([[[response objectForKey:DATA] objectForKey:SUCCESS] boolValue])
            {
                NSDictionary *detail = [response objectForKey:DATA];
                [[PDUser currentUser] setDetail:detail];
                [[AppDelegate sharedDelegate] hideActivity];
                [self dismissViewControllerAnimated:NO completion:nil];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"" message:[response objectForKey:MSG] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }
        
        
        
           [[AppDelegate sharedDelegate] hideActivity];
 
    }];

}


#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentSize:CGSizeZero];
    [scrollView setContentOffset:CGPointZero animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (![[PDHelper sharedHelper] isIPhone5])
    {
        CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y-28.0);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}



@end
