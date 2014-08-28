//
//  PDOptionsViewController.h
//  PlayDate
//
//  Created by Vakul on 26/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ListChildHobbies,
    ListChildAllergies
    
}ListType;

typedef void (^PDOptionsDidFinishBlock) (NSArray *options, NSArray *indexes);

@interface PDOptionsViewController : UIViewController

@property (nonatomic) ListType listType;
@property (strong, nonatomic) NSMutableArray *selectedTexts;

-(void)openFromController:(UIViewController *)controller withCompletionBlock:(PDOptionsDidFinishBlock)block;

@end
