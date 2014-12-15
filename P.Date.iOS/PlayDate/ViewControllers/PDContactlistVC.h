//
//  PDContactlistVC.h
//  PlayDate
//
//  Created by iapp on 30/10/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDContactlistVC : UIViewController
{
    IBOutlet UISegmentedControl *segment;
}
@property(nonatomic,strong)NSString *strFacebook_Ids;
-(IBAction)menuArrange:(id)sender;

-(IBAction)menuCalender:(id)sender;
-(IBAction)menuHome:(id)sender;
-(IBAction)menuAction:(id)sender;
@end
