//
//  PDAppDelegate.m
//  PlayDate
//
//  Created by Vakul on 01/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDAppDelegate.h"
#import "PDLeftViewController.h"
#import "PDMainViewController.h"
#import "PDLoginWithFBViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PDMenuBar.h"
#import "Flurry.h"
#import "GAI.h"
#import "GAIFields.h"
#import "Database.h"

// xmpp

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import <CFNetwork/CFNetwork.h>
// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
static NSString *const kTrackingId = @"UA-50425737-2";
@interface PDAppDelegate () <MONActivityIndicatorViewDelegate>

-(void)addMenuBar;
- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end

@implementation PDAppDelegate
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

    // Configure logging framework
	
	[DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    
    // Setup the XMPP stream
    
	[self setupStream];
    
    
    arr_Custom_messageFirstLogin=[[NSMutableArray alloc]init];
   [PDHelper sharedHelper].recentArray= [[NSMutableArray alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults objectForKey:@"g_id"];
    if ([array count]== 0)
    {
        [[[PDHelper sharedHelper]recentArray]addObjectsFromArray:array];
    }
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];

    
//   // Google analiyts
//        [GAI sharedInstance].trackUncaughtExceptions = YES;
//        [GAI sharedInstance].dispatchInterval = 20;
//
//    //  [GAI sharedInstance].debug = YES;
//        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    
// Remote Notifation inform to Device
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    application.applicationIconBadgeNumber = 0;
    
    
    
    [Flurry startSession:@"2XTHZPMK5JVYHB25P65Q"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
   // [self Inappproducts];
    
    // SIDE BAR CONTROLLER
    PDLeftViewController *leftMenuViewController = [[PDLeftViewController alloc] initWithNibName:@"PDLeftViewController" bundle:nil];
    
    // MAIN VIEW CONTROLLER
    PDMainViewController *mainViewController = [[PDMainViewController alloc] initWithNibName:@"PDMainViewController" bundle:nil];
    
    // APP NAVIGATION CONTROLLER
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    
    // INTIALIZING SIDE BAR AND MAIN VIEWCONTROLLER AS MENU BAR
    self.menuController = [MFSideMenuContainerViewController containerWithCenterViewController:self.navigationController
                                                                        leftMenuViewController:leftMenuViewController
                                                                       rightMenuViewController:nil];
    self.menuController.menuWidth = 240.0;
    
    self.window.rootViewController = self.menuController;
    self.window.backgroundColor = [PDHelper sharedHelper].applicationBackgroundColor;
    [self.window makeKeyAndVisible];

//    if (launchOptions != nil)
//    {
//        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (dictionary != nil)
//        {
//            // get the necessary information out of the dictionary
//            // (the data you sent with your push message)
//            // and load your data
//        }
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
    // HERE SAVE CURRENT USER DETAIL
       [[PDUser currentUser] save];
    // offline the user in xmpp chat
	    [self disconnect];
    	[[self xmppvCardTempModule] removeDelegate:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
    
    
     NSString *strGid = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo]objectForKey:PDWebGID];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString *strurl=[NSString stringWithFormat:@"http://54.191.67.152/playdate/badge_counter.php?user_id=%@",strGid];
  //   NSString *strurl=[NSString stringWithFormat:@"http://112.196.34.179/playdate/badge_counter.php?user_id=%@",strGid];
  //   NSString *strurl=[NSString stringWithFormat:@"http://192.168.1.193/playdate/badge_counter.php?user_id=%@",strGid];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strurl]];
    NSURLConnection *connect=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connect)
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Server Problem" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
    [FBAppCall handleDidBecomeActive];
    
    
    // REUSE CURRENT USER
    [[PDUser currentUser] reuse];
    
    
    // SHOW LOGIN & REGISTRATION VIEW IF USER IS NOT LOGGED IN
    if (![[PDUser currentUser] hasDetail]) {
        PDLoginWithFBViewController *loginView = [[PDLoginWithFBViewController alloc] initWithNibName:@"PDLoginWithFBViewController" bundle:nil];
        [self.navigationController presentViewController:loginView animated:NO completion:nil];
    }
    else {
            [self connect];
        [(PDLeftViewController *)self.menuController.leftMenuViewController setUpUserProfile];
        
       NSLog(@"%@", [self.navigationController viewControllers]);
        PDMainViewController *controller = (PDMainViewController *)[[self.navigationController viewControllers] objectAtIndex:0];
//        if (controller)
//        {
//            [controller viewDidAppear:NO];
//        }
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [FBSession.activeSession close];
    
    // xmpp
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self teardownStream];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
                      
                  }];
}


#pragma mark - My Methods
+(PDAppDelegate *)sharedDelegate
{
    return (PDAppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark - MenuBar
-(void)addMenuBar
{
    PDMenuBar *menuBAR = [PDMenuBar menuBar];
    if ([[PDHelper sharedHelper] isIOS7]) {
        CGRect rect = menuBAR.frame;
        rect.origin.y = 20.0;
        menuBAR.frame = rect;
    }
    
    [menuBAR addAction:@selector(menuItemCliecked:) andTarget:self];
    
    [self.window addSubview:menuBAR];
}

-(void)menuItemCliecked:(id)sender
{
    [self.menuController toggleLeftSideMenuCompletion:^{
        
    }];
}



#pragma mark - Activity
static UIView *activityBGView = nil;
-(void)showActivityWithTitle:(NSString *)title
{
    
    if (activityBGView == nil) {
        
        activityBGView = [[UIView alloc] initWithFrame:self.window.bounds];
        activityBGView.backgroundColor = [[PDHelper sharedHelper].applicationBackgroundColor colorWithAlphaComponent:0.6];
        
        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
        indicatorView.delegate = self;
        indicatorView.numberOfCircles = 5;
        indicatorView.radius = 8;
        indicatorView.internalSpacing = 3;
        indicatorView.center = activityBGView.center;
        indicatorView.tag = 13;
        [activityBGView addSubview:indicatorView];
        
        UILabel *titleView = [[UILabel alloc] init];
        titleView.backgroundColor = [PDHelper sharedHelper].applicationThemeBlueColor;
        titleView.textColor = [UIColor whiteColor];
        titleView.font = [[PDHelper sharedHelper] applicationFontWithSize:18.0];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.tag = 31;
        [activityBGView addSubview:titleView];
    }
    
#define TITILE_LABEL_HEIGHT 44.0
    CGRect rect = CGRectMake(0.0, CGRectGetHeight(activityBGView.frame), CGRectGetWidth(activityBGView.frame), TITILE_LABEL_HEIGHT);
    UILabel *titleView = (UILabel *)[activityBGView viewWithTag:31];
    titleView.frame = rect;
    titleView.text = title;

    rect.origin.y = CGRectGetHeight(activityBGView.frame)-TITILE_LABEL_HEIGHT;
    [UIView animateWithDuration:0.4 animations:^{
        titleView.frame = rect;
    }];
    
    [self.window addSubview:activityBGView];
    [(MONActivityIndicatorView *)[activityBGView viewWithTag:13] startAnimating];
}

-(void)hideActivity
{
    UILabel *titleView = (UILabel *)[activityBGView viewWithTag:31];
    CGRect rect = titleView.frame;
    rect.origin.y = CGRectGetHeight(activityBGView.frame);
    
    [UIView animateWithDuration:0.4 animations:^{
        titleView.frame = rect;
    } completion:^(BOOL finished) {
        
        [(MONActivityIndicatorView *)[activityBGView viewWithTag:13] stopAnimating];
        [activityBGView removeFromSuperview];

    }];
}

#pragma mark - MONActivityIndicatorViewDelegate Methods
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    
    return [PDHelper sharedHelper].applicationThemeBlueColor;
    
}


#pragma mark - Push & Pop
-(void)pushViewController:(UIViewController *)toController fromController:(UIViewController *)fromController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [fromController.view.window.layer addAnimation:transition forKey:nil];
    [fromController presentViewController:toController animated:NO completion:nil];
}


-(void)popViewController:(UIViewController *)controller
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [controller.view.window.layer addAnimation:transition forKey:nil];
    [controller dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark RemoteNotification
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[PDHelper sharedHelper] setStrUd_Id:newToken];
	NSLog(@"My token is: %@", newToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *strTemp=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if ([strTemp isEqualToString:@"Playdate Requested"]||[strTemp isEqualToString:@"Playdate Accepted"]||[strTemp isEqualToString:@"Playdate Rejected"]||[strTemp isEqualToString:@"Playdate Updated"]||[strTemp isEqualToString:@"Set Created"]||[strTemp isEqualToString:@"Set updated"]||[strTemp isEqualToString:@"Child added to your  profile"])
    {
         [[Database sharedDatabase]saveFavroite_NotificationMessage:strTemp];
    }
    
    
   

    
    [[[UIAlertView alloc] initWithTitle:@"Notification" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    // [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber +[[[userInfo valueForKey:@"aps"]valueForKey:@"badge"] intValue];
}
-(void)Inappproducts
{
    
    self.recipeProducts = [RecipeProducts sharedInstance];
    [self.recipeProducts initialize];
    [self.recipeProducts setDelegate:self];
    self.recipeProducts.controller = self;
    
    if (self.recipeProducts.products == nil)
        [self.recipeProducts requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
         {
             if (success)
             {
                 self.allProducts = products;
             }
             else
             {
                 UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Please wait While Product is loaded" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alert show];
             }
         }];
    
}

/////// xmpp
- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
    //	[xmppStream setHostName:@"talk.google.com"];
    //	[xmppStream setHostPort:5222];
	
    
	// You may need to alter these settings depending on the server you're connecting to
	customCertEvaluation = YES;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// https://github.com/robbiehanson/XMPPFramework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
//     @"561663237293563@192.168.1.193"
    //@"92849098"

    
	NSString *myJID =[NSString stringWithFormat:@"%@@192.168.1.193",[[NSUserDefaults standardUserDefaults] objectForKey:@"Chat_Id"]];//  kXMPPmyJID];
	NSString *myPassword =[[NSUserDefaults standardUserDefaults] objectForKey:@"Chat_Password"];//kXMPPmyPassword];
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//	// Use this method to release shared resources, save user data, invalidate timers, and store
//	// enough application state information to restore your application to its current state in case
//	// it is terminated later.
//	//
//	// If your application supports background execution,
//	// called instead of applicationWillTerminate: when the user quits.
//	
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//    
//#if TARGET_IPHONE_SIMULATOR
//	DDLogError(@"The iPhone simulator does not process background network traffic. "
//			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
//#endif
//    
//	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
//	{
//		[application setKeepAliveTimeout:600 handler:^{
//			
//			DDLogVerbose(@"KeepAliveHandler");
//			
//			// Do other keep alive stuff here.
//		}];
//	}
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//    
//    [self teardownStream];
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	NSString *expectedCertName = [xmppStream.myJID domain];
	if (expectedCertName)
	{
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
	
	if (customCertEvaluation)
	{
		[settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
	}
}

/**
 * Allows a delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *
 * This is only called if the stream is secured with settings that include:
 * - GCDAsyncSocketManuallyEvaluateTrust == YES
 * That is, if a delegate implements xmppStream:willSecureWithSettings:, and plugs in that key/value pair.
 *
 * Thus this delegate method is forwarding the TLS evaluation callback from the underlying GCDAsyncSocket.
 *
 * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
 *
 * Note from Apple's documentation:
 *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
 *   [it] might block while attempting network access. You should never call it from your main thread;
 *   call it only from within a function running on a dispatch queue or on a separate thread.
 *
 * This is why this method uses a completionHandler block rather than a normal return value.
 * The idea is that you should be performing SecTrustEvaluate on a background thread.
 * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
 * It is safe to invoke the completionHandler block even if the socket has been closed.
 *
 * Keep in mind that you can do all kinds of cool stuff here.
 * For example:
 *
 * If your development server is using a self-signed certificate,
 * then you could embed info about the self-signed cert within your app, and use this callback to ensure that
 * you're actually connecting to the expected dev server.
 *
 * Also, you could present certificates that don't pass SecTrustEvaluate to the client.
 * That is, if SecTrustEvaluate comes back with problems, you could invoke the completionHandler with NO,
 * and then ask the client if the cert can be trusted. This is similar to how most browsers act.
 *
 * Generally, only one delegate should implement this method.
 * However, if multiple delegates implement this method, then the first to invoke the completionHandler "wins".
 * And subsequent invocations of the completionHandler are ignored.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	// The delegate method should likely have code similar to this,
	// but will presumably perform some extra security code stuff.
	// For example, allowing a specific self-signed certificate that is known to the app.
	
	dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(bgQueue, ^{
		
		SecTrustResultType result = kSecTrustResultDeny;
		OSStatus status = SecTrustEvaluate(trust, &result);
		
		if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
			completionHandler(YES);
		}
		else {
			completionHandler(NO);
		}
	});
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.

	if ([message isChatMessageWithBody])
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];
		
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];
        NSString *strImage = [[message elementForName:@"attachement"] stringValue];
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
//                                                                message:body
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//			[alertView show];
            if (strImage.length!=0)
                [self.objChatdata message_receiveToMe_Message:strImage type:@"Image"];
            else
                [self.objChatdata message_receiveToMe_Message:body type:@"text"];

           
		}
		else
		{
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser =[[presence from] user];
//    NSLog (@"\n-------------------------User-%@\n",presenceFromUser);
//     NSLog (@"\n----------------------Status----%@\n",presenceType);
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
            
            NSLog(@"\n-------------------------Avalilable\n");
//            [_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"]];
            
        } else if ([presenceType isEqualToString:@"UnAvailable"]) {
            NSLog(@"\n-------------UnAvalilable\n");

            
//            [_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"]];
            
        }
        
    }
    


    NSLog(@"%@",[presence fromStr]);
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
        
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

@end
