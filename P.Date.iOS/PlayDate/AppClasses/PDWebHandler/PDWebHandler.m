//
//  PDWebHandler.m
//  PlayDate
//
//  Created by Vakul on 05/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDWebHandler.h"
#import "ASIFormDataRequest.h"


NSString *const PDWebSuccess            = @"success";
NSString *const PDWebData                  = @"data";
NSString *const PDWebGID                   = @"g_id";
NSString *const PDWebFirstName         = @"firstname";
NSString *const PDWebLastName         = @"lastname";
NSString *const PDWebEmail                 = @"email";
NSString *const PDWebFacebookId       = @"facebook_id";
NSString *const PDWebGuardianType   = @"guardian_type";
NSString *const PDWebDOB                  = @"dob";
NSString *const PDWebLocation            = @"location";
NSString *const PDWebFreeTime          = @"set_fixed_freetime";
NSString *const PDWebProfileImage     = @"profile_image";
NSString *const PDWebFriendFBId       = @"friend_fbid";
NSString *const PDWebPhone               = @"phone";


NSString *const PDWebSchool              = @"school";
NSString *const PDWebYouthClub         = @"youth_club";
NSString *const PDWebConditions        = @"conditions";
NSString *const PDWebAllergies           = @"allergies";
NSString *const PDWebHobbies            = @"hobbies";
NSString *const PDWebChildName       = @"Childname";

 NSString *const PDWebStartTime        = @"starttime";
 NSString *const PDWebEndTime         = @"endtime";
 NSString *const PDWebDate                = @"date";
 NSString *const PDWebStartTime1      = @"starttime1";
 NSString *const PDWebEndTime1       = @"endtime1";
 NSString *const PDWebDate1              = @"date1";
 NSString *const PDWebStartTime2      = @"starttime2";
 NSString *const PDWebEndTime2       = @"endtime2";
 NSString *const PDWebDate2              = @"date2";
 NSString *const PDWebStartTime3      = @"starttime3";
 NSString *const PDWebEndTime3       = @"endtime3";
 NSString *const PDWebDate3              = @"date3";
 NSString *const PDWebEventLocation = @"location";
 NSString *const PDWebNotes              = @"notes";
 NSString *const PDWebFriendName    =@"friendname";
 NSString *const PDWebChildId             = @"child_id";
 NSString *const PDWebMessage          =@"msg";
 NSString *const PDWebStatus              =@"status";
 NSString *const PDWebAccepted         =@"accepted";
 NSString *const PDWebFriendProfileImage=@"friend_profile_image";

 NSString *const PDWebSetID               =@"set_id";
 NSString *const PDWebSetName         =@"set_name";
NSString *const PDDeviceToken            =@"device_token";
@interface PDWebHandler ()

@property (strong, nonatomic) PDWebRequestFinishBlock requestFinishBlock;
@property (strong, nonatomic) ASIFormDataRequest *request;

-(void)configureASIRequestWithParameters:(NSDictionary *)parameters andURL:(NSString *)urlString;

@end

@implementation PDWebHandler

static PDWebHandler *handler = nil;
+(PDWebHandler *)sharedWebHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[PDWebHandler alloc] init];
    });
    
    return handler;
}

#pragma mark - ASIRequest Methods
-(void)startRequestWithCompletionBlock:(PDWebRequestFinishBlock)block
{
    self.requestFinishBlock = block;
    
    if ([[PDHelper sharedHelper] isInternetAvailable])
    {
        [self.request startSynchronous];
    }
    else
    {
        self.request = nil;
        self.requestFinishBlock = nil;
        
        SHOW_NO_INTERNET_ALERT();
    }
}

-(void)cancelRequest
{
    if (self.request)
    {
        [self.request cancel];
        self.requestFinishBlock = nil;
        self.request=nil;
    }
}


-(void)configureASIRequestWithParameters:(NSDictionary *)parameters andURL:(NSString *)urlString
{
    // CANCEL PREVIOUSLY SENT REQUEST IF ANY
    [self cancelRequest];
    
    
    // INITIALIZE ASIFormDataRequest
    if (self.request == nil)
    {
        self.request = [[ASIFormDataRequest alloc] init];
        self.request.delegate = self;
        [self.request setRequestMethod:@"POST"];
        [self.request setDidFinishSelector:@selector(requestSucceeded:)];
        [self.request setDidFailSelector:@selector(requestFailed:)];
    }
    
    urlString = [SERVER_URL stringByAppendingString:urlString];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSLog(@"CurrentURL: %@", URL);
    
    
    NSMutableString *logString = [[NSMutableString alloc] initWithString:urlString];
    
    [self.request setURL:URL];
    
    for (NSString *key in parameters.allKeys)
    {
        [self.request setPostValue:[parameters objectForKey:key] forKey:key];
        [logString appendFormat:@"%@=%@", key, [parameters objectForKey:key] ];
        [logString appendString:@"&"];
    }
    
    NSLog(@"MyCurrentURL: ........... \n%@", logString);
    
}



-(void)requestSucceeded:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"URL: %@\nResponse: %@", request.url, result);
    
    
//    [[[UIAlertView alloc]initWithTitle:@"RESULT" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    
    if (self.requestFinishBlock)
    {
        self.requestFinishBlock (result, nil);
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"URL: %@\nError: %@", request.url, error.localizedDescription);
    [[[UIAlertView alloc]initWithTitle:@"ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];

    if (self.requestFinishBlock) {
        self.requestFinishBlock (nil, error);
    }
}

#pragma mark - WebServices
-(void)registerUserWithParams:(NSDictionary *)params
{
    //  http://112.196.34.179/playdate/guardian.php?firstname=aa&lastname=bb&email=cc@gmail.com&facebook_id=295&guardian_type=m&dob=1989-12-11&location=123&set_fixed_freetime=123&profile_image=&friend_fbid=%272%27
    
    [self configureASIRequestWithParameters:params andURL:@"guardian.php?"];
}

-(void)addChildWithParams:(NSDictionary *)params forGuardian:(NSString *)guardianID
{
    // http://112.196.34.179/playdate/child.php?profile_image=pic&name=deepak&dob=1989/1/12&set_fixed_freetime=1989/2/4&school=DPS&conditions=TRUE&allergies=test&hobbies=demo&siblings=mother&youth_club=abc&g_id=10
    
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithDictionary:params];
    [d setObject:guardianID forKey:PDWebGID];
    [self configureASIRequestWithParameters:d andURL:@"child.php?"];
}

-(void)getChildForGuardian:(NSString *)guardianID
{
    [self configureASIRequestWithParameters:@{PDWebGID: guardianID} andURL:@"guardian_child.php?"];
}

-(void)getGuardianFriendChild:(NSString *)guardianFriendID withParams:(NSDictionary *)params
{
   // http://112.196.34.179/playdate/guardianfriend_child.php?g_id=46&friend_fbid=%2750%27,%2746%27
   
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithDictionary:params];
    [d setObject:guardianFriendID forKey:PDWebGID];
    [self configureASIRequestWithParameters:d andURL:@"guardianfriend_child.php?"];
}

-(void)editGuardianWithParams:(NSDictionary *)params 
{
    //http://112.196.34.179/playdate/guardianinfo_edit.php?g_id=73&name=pooja&dob=1975-07-08&location=delhi&phone=9872742345&guardian_type=f&set_fixed_freetime=tuesday
    
    [self configureASIRequestWithParameters:params andURL:@"guardianinfo_edit.php?"];
}

-(void)createEventWithParams:(NSDictionary *)params forGuardian:(NSString *)guardianID
{
    //http://112.196.34.179/playdate/event.php?child_id=68&friend_childid=69&date=31-5-2014&starttime=11:04&endtime=3:00&date1=31-1-2014&starttime1=12:34&endtime1=4:00&date2=28-3-2014&g_id=46&starttime2=1:34&endtime2=7:00&date3=3-4-2014&starttime3=2:34&endtime3=6:00&location=delhi&notes=abc&publish=1&receiver_id=1&receiver_status=requested
    

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [dic setObject:guardianID forKey:PDWebGID];
    [self configureASIRequestWithParameters:dic andURL:@"event.php?"];
}
-(void)editEventWithParams:(NSDictionary *)params forGuardian:(NSString *)guardianID
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [dic setObject:guardianID forKey:PDWebGID];
    [self configureASIRequestWithParameters:dic andURL:@"event_edit.php?"];
}
-(void)getChildListWithParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"guardianfriend_child.php?"];
}
-(void)getEventRequestListParams:(NSDictionary *)params
{
   [self configureASIRequestWithParameters:params andURL:@"event_with.php?"];
}
-(void)editChildPicListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"childprofile_pic_edit.php?"];
}
-(void)editChildParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"childinfo_edit.php?"];
}
-(void)event_Accepted_RejectedEvent:(NSDictionary *)params
{
      [self configureASIRequestWithParameters:params andURL:@"event_accept_or_reject.php?"];
}
-(void)event_Accepted_ForCalander:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"eventaccept_date_time.php?"];
}
-(void)getFriend_Detail:(NSDictionary *)params
{
   [self configureASIRequestWithParameters:params andURL:@"facebook_friend_detail.php?"];
}
-(void)editParentPicListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"guardian_edit.php?"];
}
-(void)addCreateNewSetListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"set_friend.php?"];
}
-(void)allSetsListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"setting_set_friend.php?"];
}
-(void)slectedSet_ViewListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"set_friend_child.php?"];
}
-(void)setDetail_For_Editing_ListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"get_friend_ids_by_set.php?"];
}
-(void)saveEditSet_ListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"edit_set.php?"];
}
-(void)extendPermissionChildInfo_ListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"guard_child.php?"];
}
-(void)extendPermissionToFriendandChild_ListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"edit_auth_child.php?"];
}
-(void)childInfoBasedOnChildID_ListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"child_parent_auth.php?"];
}
-(void)deviceToken_ListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"devicetoken.php?"];
}
-(void)authFaciltygetParentList_ListParams:(NSDictionary *)params
{
    [self configureASIRequestWithParameters:params andURL:@"guardian_assigned_unsigned_friends.php?"];
}
-(void)Notificationlist_ListParams:(NSDictionary *)params
{
   [self configureASIRequestWithParameters:params andURL:@"admin_push_msg.php?"];
}
@end
