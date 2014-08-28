//
//  PDMainViewController.h
//  PlayDate
//
//  Created by Vakul on 01/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellProfilePage.h"
#import "GAITrackedViewController.h"
@interface PDMainViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblVwEventRequstList;
}

@end
