//
//  PDUser.h
//  PlayDate
//
//  Created by Vakul on 05/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const FBBirthday;
extern NSString *const FBFirstName;
extern NSString *const FBGender;
extern NSString *const FBId;
extern NSString *const FBName;
extern NSString *const FBHometown;
extern NSString *const FBLastName;
extern NSString *const FBLocation;
extern NSString *const FBPicture;
extern NSString *const FBData;
extern NSString *const FBImageURL;
extern NSString *const FBEmail;
extern NSString *const FBURL;

extern NSString *const PDUserInfo;
extern NSString *const PDFriends;

extern NSString *const PDChildHobbies;
extern NSString *const PDChildAllergies;
extern NSString *const PDFacebook_id;


typedef enum {
    
    G_MOTHER,
    G_FATHER,
    G_GRAND_MOTHER,
    G_GRAND_FATHER,
    NON
    
}GUARDIAN_TYPE;


@interface PDUser : NSObject

@property (strong, nonatomic) id detail;

+(PDUser *)currentUser;

-(BOOL)hasDetail;
-(void)save;
-(void)reuse;
-(void)delete;

-(NSString *)compositeName;
-(NSArray *)childAllergies;
-(NSArray *)childHobbies;

@end
