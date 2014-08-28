//
//  PDUser.m
//  PlayDate
//
//  Created by Vakul on 05/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDUser.h"

NSString *const FBBirthday  = @"birthday";
NSString *const FBFirstName = @"first_name";
NSString *const FBGender    = @"gender";
NSString *const FBId        = @"id";
NSString *const FBHometown  = @"hometown";
NSString *const FBLastName  = @"last_name";
NSString *const FBLocation  = @"location";
NSString *const FBName      = @"name";
NSString *const FBPicture   = @"picture";
NSString *const FBData      = @"data";
NSString *const FBImageURL  = @"url";
NSString *const FBEmail     = @"email";
NSString *const FBURL       = @"url";

NSString *const PDUserInfo  = @"userinfo";
NSString *const PDFriends   = @"friends";

NSString *const PDChildHobbies = @"ChildHobbies";
NSString *const PDChildAllergies = @"ChildAllergies";
NSString *const PDFacebook_id=@"facebook_id";
@implementation PDUser

static PDUser *user = nil;
+(PDUser *)currentUser
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[PDUser alloc] init];
    });
    
    return user;
}



#pragma mark - User Detail Methods
-(BOOL)hasDetail
{
    NSLog(@"%@",self.detail);
    if (!self.detail) {
        return NO;
    }
    
    return ([[self.detail allKeys] count] > 0);
}

-(void)save
{
    [[NSUserDefaults standardUserDefaults] setObject:self.detail forKey:@"UserDetail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)reuse
{
    self.detail = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetail"];
}

-(void)delete
{
    // REMOVE ALL KEY & OBJECTS FROM detail OBJECT
    self.detail = nil;
    
    // ALSO REMOVE IT FROM NSUserDefault
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserDetail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)compositeName
{
    NSDictionary *userInfo = [self.detail objectForKey:PDUserInfo];
    return [[userInfo objectForKey:PDWebFirstName] stringByAppendingFormat:@" %@", [userInfo objectForKey:PDWebLastName]];
}

#pragma mark - Plist Data
static id plistInfo = nil;
-(void)loadPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PDInfo" ofType:@"plist"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    plistInfo = [NSDictionary dictionaryWithContentsOfURL:fileURL];
}

-(NSArray *)childAllergies
{
    if (plistInfo == nil) {
        [self loadPlist];
    }
    
    return [plistInfo objectForKey:PDChildAllergies];
}

-(NSArray *)childHobbies
{
    if (plistInfo == nil) {
        [self loadPlist];
    }
    
    return [plistInfo objectForKey:PDChildHobbies];
}

@end
