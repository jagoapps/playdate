//
//  DetailOfEventVC.h
//  PlayDate
//
//  Created by iApp on 16/06/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOfEventVC : UIViewController
{
   IBOutlet  UIImageView *imgPlayer1;
    IBOutlet  UIImageView *imgPlayer2;
    IBOutlet  UITextField *txtWhen;
    IBOutlet  UITextField *txtTime;
      IBOutlet UIView *vwNotes;
    
    IBOutlet UIView *vw1Time1;
      IBOutlet UIView *vw1when1;
    IBOutlet  UILabel *lblAlternative1;
    IBOutlet  UITextField *txtWhen1;
    IBOutlet  UITextField *txtTime1;
    
    IBOutlet UIView *vw2Time2;
    IBOutlet UIView *vw2when2;

    IBOutlet  UILabel *lblAlternative2;
    IBOutlet  UITextField *txtWhen2;
    IBOutlet  UITextField *txtTime2;
    
    
    
    IBOutlet UIView *vw3Time3;
    IBOutlet UIView *vw3when3;

    IBOutlet  UILabel *lblAlternative3;
    IBOutlet  UITextField *txtWhen3;
    IBOutlet  UITextField *txtTime3;
    
     
    
    
    IBOutlet  UITextField *txtWhere;
    IBOutlet  UILabel *lblNotes;
    IBOutlet UITextField *txtPlayerName1;
    IBOutlet UITextField *txtPlayerName2;
    IBOutlet UIView *vwButtons;
    IBOutlet UIScrollView *scrollView;

    IBOutlet UIButton *btnAccept;
    IBOutlet UIButton *btnReject;
    IBOutlet UIButton *btnEdit;
    
}
@property(nonatomic,retain)    NSDictionary *dictSlected_EventInfo;
@property(nonatomic)    BOOL fromCalendar;
-(IBAction)menuAction:(id)sender;
-(void)btnActionAccepted;
-(IBAction)btnActionRejcted;
-(IBAction)btnActionEdit;
-(IBAction)btnBack:(id)sender;
@end
