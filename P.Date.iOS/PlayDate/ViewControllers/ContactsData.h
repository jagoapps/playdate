//
//  ContactsData.h
//  PlayDate
//
//  Created by iapp on 30/10/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsData : NSObject

@property (nonatomic,retain)NSString *firstNames;
@property (nonatomic,retain)NSString *lastNames;
@property (nonatomic,retain)NSString *compositeName;
@property (nonatomic,retain)UIImage *image;
@property (nonatomic,retain)NSArray *Numbers;
@property (nonatomic,retain)NSArray *Emails;
@property (nonatomic)BOOL hasFriend;


@end
