//
//  PDRegistrationViewController.m
//  PlayDate
//
//  Created by Vakul on 05/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDRegistrationViewController.h"
#import "VSOptionsView.h"

@interface PDRegistrationViewController () <UITextFieldDelegate, VSOptionsViewDelegate>
{
    IBOutlet UIView *navigationView;
    
    IBOutlet UITextField *tFFirstName;
    IBOutlet UITextField *tFLastName;
    IBOutlet UITextField *tFGuardianType;
    IBOutlet UITextField *tFEmail;
    IBOutlet UITextField *tFPassword;
    IBOutlet UITextField *tFConfirmPassword;
    
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *registrationView;
    IBOutlet UIButton *btnRegister;
    
    
    VSOptionsView *optionsView;
}

@property (nonatomic) GUARDIAN_TYPE guardianType;

-(void)setUpViewContents;
-(void)setContentInsectOfEachTextField;
-(void)resignKeyBoard;
-(BOOL)validateFields;

-(IBAction)registerAction:(id)sender;
-(IBAction)backAction:(id)sender;

@end

@implementation PDRegistrationViewController

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

    
    // DROP SHADWO TO REGISTRATION BACKGROUND VIEW
    registrationView.layer.shadowOpacity = 0.5;
    registrationView.layer.shadowColor = [UIColor blackColor].CGColor;
    registrationView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    
    // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];
    
    
    // SETTING CONTENT INSECT OF TEXTFIELD BECAUSE IT HAS BACKGROUND IMAGE WE WILL HAVE TO MOVE ITS CONTENT A BIT LEFT
    [self setContentInsectOfEachTextField];
    
    
    // OPTIONS VIEW
    optionsView = [[VSOptionsView alloc] initWithDelegate:self andTitles:@"MOTHER", @"FATHER", @"GRAND MOTHER", @"GRAND FATHER", nil];
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
    
    
    self.guardianType = NON;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    for (UITextField *tF in registrationView.subviews)
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
    for (UITextField *tF in registrationView.subviews)
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
    
    // VALID NAME
    NSString *str = tFFirstName.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length>0 && [predicate evaluateWithObject:str])
    {
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    
    str = tFLastName.text;
    if (str.length>0 && [predicate evaluateWithObject:str])
    {
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }

    
    // EMAIL VALIDATION
    str = tFEmail.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length>0 && [[PDHelper sharedHelper] validateEmail:str])
    {
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    
   
    // GUARDIAN TYPE VALIDATION
    if (self.guardianType != NON)
    {
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select Guardian Type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

        return NO;
    }
    
    
    // PASSWORD VALIDATION
    str = tFPassword.text;
    if (str.length > 0)
    {
        if ([str isEqualToString:tFConfirmPassword.text])
        {
            return YES;
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Password and Confirm Password doesn't match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            return NO;
        }
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
    
    if ([self validateFields])
    {
        [[AppDelegate sharedDelegate] showActivityWithTitle:@"Registering..."];
        [self performSelector:@selector(activityDidAppear) withObject:nil afterDelay:0.1];
    }
    
//    [[AppDelegate sharedDelegate] showActivityWithTitle:@"Registering..."];
//    [NSTimer scheduledTimerWithTimeInterval:5 target:[AppDelegate sharedDelegate] selector:@selector(hideActivity) userInfo:nil repeats:NO];
}

-(IBAction)backAction:(id)sender
{
    [[AppDelegate sharedDelegate] popViewController:self];
}

-(void)activityDidAppear
{
    /*
     *  G_MOTHER,
     *  G_FATHER,
     *  G_GRAND_MOTHER,
     *  G_GRAND_FATHER,
     *
     */

    
    NSString *gType = @"m";
    if (self.guardianType == G_FATHER)
        gType = @"f";
    else if (self.guardianType == G_GRAND_MOTHER)
        gType = @"gm";
    else if (self.guardianType == G_GRAND_FATHER)
        gType = @"gf";
    
    [[PDWebHandler sharedWebHandler] registerUserWithParams:@{FIRST_NAME: tFFirstName.text,
                                                              LAST_NAME:  tFLastName.text,
                                                              EMAIL:      tFEmail.text,
                                                              PASSWORD:   tFPassword.text,
                                                              GUARDIAN_TYPE_ID: gType}];
    
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
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"" message:[response objectForKey:MSG] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }
        
        
        [[AppDelegate sharedDelegate] hideActivity];
        [self dismissViewControllerAnimated:NO completion:nil];

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
    if (textField != tFGuardianType)
    {
        CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y-28.0);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == tFGuardianType)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self resignKeyBoard];
            [scrollView setContentSize:CGSizeZero];
            [scrollView setContentOffset:CGPointZero animated:NO];
        }];
        
        [optionsView showAtCenter];

        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == tFGuardianType)
        self.guardianType = NON;
    
    return YES;
}


#pragma mark - VSOptionsView Delegate
-(void)optionView:(VSOptionsView *)optionView clickedAtIndex:(NSInteger)index
{
    NSLog(@"%@", [optionsView.titles objectAtIndex:index]);
    
    self.guardianType = (GUARDIAN_TYPE)index;
    tFGuardianType.text = [optionsView.titles objectAtIndex:index];
}


@end
