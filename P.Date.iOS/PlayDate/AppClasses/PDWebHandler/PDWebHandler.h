//
//  PDWebHandler.h
//  PlayDate
//
//  Created by Vakul on 05/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base64Transcoder.h"

//#define SERVER_URL @"http://112.196.34.179/playdate/" // office testing server
#define SERVER_URL @"http://54.191.67.152/playdate/" // Client Server
//#define SERVER_URL @"http://192.168.1.193/playdate/"  // Jabber server

#define SHOW_NO_INTERNET_ALERT() [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection. It might be slow or disconnected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]

extern NSString *const PDWebData;
extern NSString *const PDWebSuccess;
extern NSString *const PDWebGID;
extern NSString *const PDWebFirstName;
extern NSString *const PDWebLastName;
extern NSString *const PDWebEmail;
extern NSString *const PDWebFacebookId;
extern NSString *const PDWebGuardianType;
extern NSString *const PDWebDOB;
extern NSString *const PDWebLocation;
extern NSString *const PDWebFreeTime;
extern NSString *const PDWebProfileImage;
extern NSString *const PDWebFriendFBId;
extern NSString *const PDWebPhone;

extern NSString *const PDWebSchool;
extern NSString *const PDWebYouthClub;
extern NSString *const PDWebConditions;
extern NSString *const PDWebAllergies;
extern NSString *const PDWebHobbies;
extern NSString *const PDWebChildName;

extern NSString *const PDWebStartTime;
extern NSString *const PDWebEndTime;
extern NSString *const PDWebDate;
extern NSString *const PDWebStartTime1;
extern NSString *const PDWebEndTime1;
extern NSString *const PDWebDate1;
extern NSString *const PDWebStartTime2;
extern NSString *const PDWebEndTime2;
extern NSString *const PDWebDate2;
extern NSString *const PDWebStartTime3;
extern NSString *const PDWebEndTime3;
extern NSString *const PDWebDate3;
extern NSString *const PDWebEventLocation;
extern NSString *const PDWebNotes;
extern NSString *const PDWebFriendName;
extern NSString *const PDWebMessage;
extern NSString *const PDWebChildId;
extern NSString *const PDWebStatus;
extern NSString *const PDWebAccepted;
extern NSString *const PDWebSetID;
extern NSString *const PDWebSetName;
extern NSString *const PDDeviceToken;

extern NSString *const PDWebFriendProfileImage;

typedef void (^PDWebRequestFinishBlock) (id response, NSError *error);

@interface PDWebHandler : NSObject


+(PDWebHandler *)sharedWebHandler;
-(void)startRequestWithCompletionBlock:(PDWebRequestFinishBlock)block;
-(void)cancelRequest;


-(void)registerUserWithParams:(NSDictionary *)params;
-(void)addChildWithParams:(NSDictionary *)params forGuardian:(NSString *)guardianID;
-(void)getChildForGuardian:(NSString *)guardianID;
-(void)editGuardianWithParams:(NSDictionary *)params ;
-(void)getGuardianFriendChild:(NSString *)guardianFriendID withParams:(NSDictionary *)params;
-(void)createEventWithParams:(NSDictionary *)params forGuardian:(NSString *)guardianID;
-(void)editEventWithParams:(NSDictionary *)params forGuardian:(NSString *)guardianID;
-(void)getChildListWithParams:(NSDictionary *)params;
-(void)getEventRequestListParams:(NSDictionary *)params;
-(void)editChildPicListParams:(NSDictionary *)params;
-(void)editChildParams:(NSDictionary *)params;
-(void)event_Accepted_RejectedEvent:(NSDictionary *)params;
-(void)event_Accepted_ForCalander:(NSDictionary *)params;
-(void)getFriend_Detail:(NSDictionary *)params;
-(void)editParentPicListParams:(NSDictionary *)params;
-(void)addCreateNewSetListParams:(NSDictionary *)params;
-(void)allSetsListParams:(NSDictionary *)params;
-(void)slectedSet_ViewListParams:(NSDictionary *)params;
-(void)setDetail_For_Editing_ListParams:(NSDictionary *)params;
-(void)saveEditSet_ListParams:(NSDictionary *)params;
-(void)extendPermissionChildInfo_ListParams:(NSDictionary *)params;
-(void)extendPermissionToFriendandChild_ListParams:(NSDictionary *)params;
-(void)childInfoBasedOnChildID_ListParams:(NSDictionary *)params;
-(void)deviceToken_ListParams:(NSDictionary *)params;
-(void)authFaciltygetParentList_ListParams:(NSDictionary *)params;
-(void)Notificationlist_ListParams:(NSDictionary *)params;
-(void)deleteAuthChild_ListParams:(NSDictionary *)params;
-(void)allreadyFriendFromContactlist_ListParams:(NSDictionary *)params;
-(void)createEventMultiPersonWithParams:(NSDictionary *)params forGuardian:(NSString *)guardianID;
@end
