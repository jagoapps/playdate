//
//  PDUpgradeViewController.m
//  PlayDate
//
//  Created by Simpy on 12/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDUpgradeViewController.h"
#import "RecipeProducts.h"
#import "PDCalenderViewController.h"
#import "PDRequestArrangeViewController.h"
#import "PDMainViewController.h"
#import "PDExtentedPermissions.h"

@interface PDUpgradeViewController ()<RecipeProductsDelegate>
{
    IBOutlet UIButton *addAddminBtn;
    IBOutlet UIButton *addAccountBtn;
    IBOutlet UIButton *syncBtn;
    IBOutlet UIButton *upgradeBtn;
}

@end

@implementation PDUpgradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[PDAppDelegate sharedDelegate].recipeProducts  cancelRequest];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpViewContents];
    
    if ( [PDAppDelegate sharedDelegate].allProducts.count==0 )
    {
        
        
        [PDAppDelegate sharedDelegate].recipeProducts  = [RecipeProducts sharedInstance];
        [[PDAppDelegate sharedDelegate].recipeProducts  initialize];
        
        [[PDAppDelegate sharedDelegate].recipeProducts  setDelegate:self];
        [PDAppDelegate sharedDelegate].recipeProducts.controller = self;
        
        if ([PDAppDelegate sharedDelegate].recipeProducts.products == nil)
            [[PDAppDelegate sharedDelegate].recipeProducts  requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
             {
                 if (success)
                 {
                     [PDAppDelegate sharedDelegate].allProducts = products;
                 }
                 else
                 {
                     UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Please wait While Product is loaded" delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
                     [alert show];
                 }
             }];
    }
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
#pragma mark InAppPurchase delegate
-(void)didFinishWithTransaction:(SKPaymentTransaction *)transaction
{
    
    [[PDAppDelegate sharedDelegate] hideActivity];
    PDExtentedPermissions *objPDExtentedPermissions=[[PDExtentedPermissions alloc]initWithNibName:@"PDExtentedPermissions" bundle:nil];
    [self.navigationController pushViewController:objPDExtentedPermissions animated:YES];
    
    
    
    
}
-(void)didFailWithError:(NSError *)error transaction:(SKPaymentTransaction *)transaction
{
    [[[UIAlertView alloc]initWithTitle:@"" message:@"error while purchasing please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    [[PDAppDelegate sharedDelegate] hideActivity];
}
#pragma mark - Button Actions
-(IBAction)btnRestore:(id)sender
{
    //    if ([[PDAppDelegate sharedDelegate].recipeProducts  productIsAlreadyPurchased:@"com.jagoapps.playdate.exchangechilds"])// Change product here
    //    {
    [[PDAppDelegate sharedDelegate] showActivityWithTitle:@"Loading..."];
    [self performSelector:@selector(btnActivity_Purchase) withObject:self afterDelay:0.1];
    
    //    }
    //    else
    //        [[[UIAlertView alloc]initWithTitle:@"" message:@"we cann't restore now Please firstly Puchase" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    
}
-(IBAction)menuAction:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
        
        
    }];
}

-(IBAction)upgradeBtn:(id)sender
{
    if ([[PDAppDelegate sharedDelegate].allProducts count]>0)
    {
        if ([[PDAppDelegate sharedDelegate].recipeProducts  productIsAlreadyPurchased:@"com.jagoapps.playdate.exchangechilds"])// Change product here
        {
            PDExtentedPermissions *objPDExtentedPermissions=[[PDExtentedPermissions alloc]initWithNibName:@"PDExtentedPermissions" bundle:nil];
            [self.navigationController pushViewController:objPDExtentedPermissions animated:YES];
            
        }
        else
        {
                SKProduct *product =  [PDAppDelegate sharedDelegate].allProducts[0];
                [ [PDAppDelegate sharedDelegate].recipeProducts  buyProduct:product];
        }
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Please wait While Product is loaded" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
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

-(void)btnActivity_Purchase
{
    [[PDAppDelegate sharedDelegate].recipeProducts restoreLastTrasanction];
    //    SKProduct *product =  [PDAppDelegate sharedDelegate].allProducts[0];
    //    [ [PDAppDelegate sharedDelegate].recipeProducts  buyProduct:product];
    
}
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if ([@"There is no product purchased by you."isEqualToString:alertView.message]) {
            [[PDAppDelegate sharedDelegate] hideActivity];
        }
        else
        {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"com.jagoapps.playdate.exchangechilds"];
        [[PDAppDelegate sharedDelegate] hideActivity];
       PDExtentedPermissions *objPDExtentedPermissions=[[PDExtentedPermissions alloc]initWithNibName:@"PDExtentedPermissions" bundle:nil];
        [self.navigationController pushViewController:objPDExtentedPermissions animated:YES];
        }
    }
}
@end