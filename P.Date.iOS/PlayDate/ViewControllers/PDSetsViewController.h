//
//  PDSetsViewController.h
//  PlayDate
//
//  Created by Simpy on 18/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface PDSetsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
   }
-(IBAction)btn_AddnewSet:(id)sender;
-(IBAction)dismissView;
-(IBAction)btn_SaveEditSet:(id)sender;
@end
