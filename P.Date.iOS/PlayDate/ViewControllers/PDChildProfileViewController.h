//
//  PDChildProfileViewController.h
//  PlayDate
//
//  Created by Simpy on 09/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDChildProfileViewController : UIViewController
{
    UITapGestureRecognizer *tapGesure;
}
@property (nonatomic,strong)NSArray *childProfileArray;
@property (nonatomic,strong)NSArray *parentProfileArray;
@property (nonatomic)NSInteger index;
@property (nonatomic)BOOL fromSets;
@property (nonatomic)BOOL fromDirectlyParent;
-(IBAction)menuArrange:(id)sender;

-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;
@end
