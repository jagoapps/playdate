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

#import <CoreData/CoreData.h>
#import "PDChatData.h"
#import "XMPPFramework.h"
NSMutableArray *arr_Custom_messageFirstLogin;
@interface PDAppDelegate : UIResponder <UIApplicationDelegate,RecipeProductsDelegate,XMPPRosterDelegate>
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	
	NSString *password;
	BOOL customCertEvaluation;
	BOOL isXmppConnected;
	
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PDChatData *objChatdata;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) MFSideMenuContainerViewController *menuController;
@property (strong, nonatomic) RecipeProducts *recipeProducts;
@property (strong, nonatomic) NSArray *allProducts;
//// xmpp
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;



- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;
///
+(PDAppDelegate *)sharedDelegate;

-(void)showActivityWithTitle:(NSString *)title;
-(void)hideActivity;
-(void)pushViewController:(UIViewController *)toController fromController:(UIViewController *)fromController;
-(void)popViewController:(UIViewController *)controller;
typedef void (^ReciveChatMessage) (NSString *Message);
@end

