//
//  PDAppDelegate.h
//  PlayDate
//
//  Created by Vakul on 01/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MONActivityIndicatorView.h"
#import "MFSideMenuContainerViewController.h"
#import "RecipeProducts.h"
@interface PDAppDelegate : UIResponder <UIApplicationDelegate,RecipeProductsDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) MFSideMenuContainerViewController *menuController;
@property (strong, nonatomic) RecipeProducts *recipeProducts;
@property (strong, nonatomic) NSArray *allProducts;

+(PDAppDelegate *)sharedDelegate;

-(void)showActivityWithTitle:(NSString *)title;
-(void)hideActivity;
-(void)pushViewController:(UIViewController *)toController fromController:(UIViewController *)fromController;
-(void)popViewController:(UIViewController *)controller;

@end

