//
//  PDMenuBar.h
//  PlayDate
//
//  Created by Vakul on 08/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MENU,
    ARRANGE,
    CHAT,
    HOME
    
}MENU_TYPES;

@interface PDMenuBar : UIView

+(PDMenuBar *)menuBar;
-(void)addAction:(SEL)action andTarget:(id)target;

@end
