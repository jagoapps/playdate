//
//  PDProfileViewController.h
//  PlayDate
//
//  Created by Vakul on 29/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDProfileViewController : UIViewController

@property (nonatomic,strong)NSArray *friendProfileArray;
@property (nonatomic,strong)NSString *str_Parent_gid;

@property (nonatomic)BOOL isFromSets;
-(IBAction)menuArrange:(id)sender;
-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;
@end
