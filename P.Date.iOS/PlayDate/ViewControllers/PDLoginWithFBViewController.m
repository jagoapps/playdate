//
//  PDLoginWithFBViewController.m
//  PlayDate
//
//  Created by Vakul on 22/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//
// @"https://graph.facebook.com/me/friends?access_token=%@"

#import "PDLoginWithFBViewController.h"
#import "PDLeftViewController.h"

@interface PDLoginWithFBViewController ()
{
    IBOutlet UIButton *btnFBLogin;
    IBOutlet UIView *viewActivity;
    IBOutlet UIActivityIndicatorView *indicator;
}

-(IBAction)loginAction:(id)sender;
-(void)startLoginProcess;

@end



@implementation PDLoginWithFBViewController

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
    
    [viewActivity setHidden:YES];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login Action
-(IBAction)loginAction:(id)sender
{
    if ([[PDHelper sharedHelper] isInternetAvailable])
    {
        [self startLoginProcess];
    }
    else
    {
        SHOW_NO_INTERNET_ALERT();
    }
}


-(void)startLoginProcess
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        // [FBSession.activeSession closeAndClearTokenInformation];
        
        [indicator startAnimating];
        [viewActivity setHidden:NO];
        [self performSelector:@selector(fetchUserDetail) withObject:nil afterDelay:0.2];
        
    }
    else
    {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        // [self showActivity];
        
        [FBSession openActiveSessionWithReadPermissions:@[@"user_about_me", @"email", @"user_birthday", @"user_location", @"user_hometown", @"user_friends",@"read_friendlists"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             if (!error)
             {
                 
                 [indicator startAnimating];
                 [viewActivity setHidden:NO];
                 [self performSelector:@selector(fetchUserDetail) withObject:nil afterDelay:0.2];
                 
             }
             else
             {
                 [[PDAppDelegate sharedDelegate] hideActivity];
               //  [[[UIAlertView alloc] initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             }
             
         }];
    }

}


-(void)fetchUserDetail
{
    if ([[PDHelper sharedHelper] isInternetAvailable])
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.0/me?fields=id,name,picture.type(large),email,location,gender,birthday,hometown,first_name,last_name&access_token=%@", [FBSession activeSession].accessTokenData.accessToken]];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        // https://graph.facebook.com/v2.0/me/friends?access_token=
        
        
        FBRequest *request = [FBRequest requestForMyFriends];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id friends_result, NSError *error) {
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[result valueForKey:FBId]   forKey:PDFacebook_id];
            [[NSUserDefaults standardUserDefaults]synchronize];

            NSArray  *friends_fb_ids = [[friends_result objectForKey:FBData] valueForKey:FBId];
            NSMutableString *str = [[NSMutableString alloc] init];
            [friends_fb_ids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [str appendFormat:@"'%@'", obj];
                [str appendString:@","];
                
            }];
            
            NSLog(@"friends_fb_ids String: \n%@", str);
            if (str.length > 0){
                [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
            }
            
            
            NSString *guardian_type = @"";
            guardian_type = ([[result objectForKey:FBGender] isEqualToString:@"male"]) ? @"f" : @"m";
            NSString *free_time = @"";
            NSString *phone = @"";
            NSString *picture = [[[result objectForKey:FBPicture] objectForKey:FBData] objectForKey:FBURL];
            
            NSString *location = [[result objectForKey:FBLocation] objectForKey:FBName];
            if (!location) {
                location = @"";
            }
            NSString *email = [result objectForKey:FBEmail];
            if (!email) {
                email = @"";
            }
            NSString *firstname= [result objectForKey:FBFirstName];
            if (!firstname) {
                firstname = @"";
            }

            NSString *dob=[result objectForKey:FBBirthday] ;
            if (!dob) {
                dob = @"";
            }
            NSString *lastname=[result objectForKey:FBLastName] ;
            if (!lastname) {
                lastname = @"";
            }
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setObject:firstname    forKey:PDWebFirstName];
            [params setObject:lastname     forKey:PDWebLastName];
            [params setObject:email                                 forKey:PDWebEmail];
            [params setObject:[result objectForKey:FBId]            forKey:PDWebFacebookId];
            [params setObject:guardian_type                         forKey:PDWebGuardianType];
            [params setObject:dob     forKey:PDWebDOB];
            [params setObject:location                              forKey:PDWebLocation];
            [params setObject:phone                                 forKey:PDWebPhone];
            [params setObject:free_time                             forKey:PDWebFreeTime];
            [params setObject:picture                               forKey:PDWebProfileImage];
            [params setObject:str                                   forKey:PDWebFriendFBId];
            
            [[PDWebHandler sharedWebHandler] registerUserWithParams:params];
            [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
             {
                [indicator stopAnimating];
                [viewActivity setHidden:YES];
                
                if (!error)
                {
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:[response objectForKey:PDWebData] forKey:PDFriends];
                    [dict setObject:[response objectForKey:PDUserInfo] forKey:PDUserInfo];
                    
                    [[PDUser currentUser] setDetail:dict];
                    [[PDUser currentUser] save];
                    
                    
                     NSString *guardianID = [[[[PDUser currentUser] detail] objectForKey:PDUserInfo] objectForKey:PDWebGID];
                    NSString *strUd_Id=  [[PDHelper sharedHelper] strUd_Id];
                    NSMutableDictionary *paramsTokenService = [[NSMutableDictionary alloc] init];
                    [paramsTokenService setObject:guardianID    forKey:PDWebGID];
                    [paramsTokenService setObject:strUd_Id     forKey:PDDeviceToken];
                    [paramsTokenService setObject:@"0"     forKey:@"type"];

                    [[PDWebHandler sharedWebHandler] deviceToken_ListParams:paramsTokenService];
                    [[PDWebHandler sharedWebHandler] startRequestWithCompletionBlock:^(id response, NSError *error)
                     {
                         
                         [indicator stopAnimating];
                         [viewActivity setHidden:YES];
                         //  http://112.196.34.179/playdate/devicetoken.php?g_id=100001122279977&device_token=43654fghfg262456yuigiuhgihghkjhgjhgjhg12345&type=1
                         if (!error) {
                             [(PDLeftViewController *)[PDAppDelegate sharedDelegate].menuController.leftMenuViewController setUpUserProfile];
                             [self dismissViewControllerAnimated:NO completion:NULL];}
                         else
                         {
                         }
                         
                     }];

                }
                else
                {
                    [[[UIAlertView alloc] initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
                
            }];
          
        }];

    }
    else
    {
        [indicator stopAnimating];
        [viewActivity setHidden:YES];
        
        SHOW_NO_INTERNET_ALERT();
    }
}


@end
