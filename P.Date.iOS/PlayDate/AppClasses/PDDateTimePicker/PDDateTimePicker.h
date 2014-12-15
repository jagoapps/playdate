//
//  PDDateTimePicker.h
//  PlayDate
//
//  Created by Vakul on 28/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    PDPickerTypeDate,
    PDPickerTypeFreeTime
    
} PDPickerType;

typedef void (^PDPickerDidFinishPickingBlock) (NSString *pickedResult);
typedef void (^PDPickerDoneBlock) (NSString *currentResult);
typedef void (^PDPickerCancelBlock)(void);

@interface PDDateTimePicker : UIView
{
    
}
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;

-(id)initWithType:(PDPickerType)type;
-(void)showInView:(UIView *)view hideday:(int)hide withType:(PDPickerType)type withPickingBlock:(PDPickerDidFinishPickingBlock)block andPickerDoneBlock:(PDPickerDoneBlock)doneBlock cancelBlock:(PDPickerCancelBlock)cancelBlock;
-(void)hide;


-(IBAction)cancelAction:(id)sender;
@end
