//
//  PDDateTimePicker.m
//  PlayDate
//
//  Created by Vakul on 28/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDDateTimePicker.h"
#import "DjuPickerView.h"

@interface PDDateTimePicker () <DjuPickerViewDelegate, DjuPickerViewDataSource>
{
    NSInteger row1;
    NSInteger row2;
    NSInteger row3;
    NSInteger row4;
    NSInteger row5;
    
    IBOutlet UIButton *btnDone;
    IBOutlet UIView *blueHeaderView;
    IBOutlet UILabel *titleView;
    int slectedDay;
}

@property (nonatomic) PDPickerType pickerType;
@property (strong, nonatomic) PDPickerDidFinishPickingBlock pickingDidFinishBlock;
@property (strong, nonatomic) PDPickerDoneBlock pickerDoneBlock;
@property (strong, nonatomic) PDPickerCancelBlock pickeCancelBlock;
@property (strong, nonatomic) UIView *parentView;

@property (strong, nonatomic) NSMutableArray *arrayForFirstPicker;
@property (strong, nonatomic) NSMutableArray *arrayForSecondPicker;
@property (strong, nonatomic) NSMutableArray *arrayForThirdPicker;

@property (strong, nonatomic) DjuPickerView *firstPickerView;
@property (strong, nonatomic) DjuPickerView *secondPickerView;
@property (strong, nonatomic) DjuPickerView *thirdPickerView;

/*Two Extra Picker For Hour Time*/
@property (strong, nonatomic) DjuPickerView *fourthPickerView;
@property (strong, nonatomic) DjuPickerView *fifthPickerView;



-(void)initializeDatePicker;
-(void)initializeFreeTimePicker;
-(void)show;

-(void)filterDaysArrayAccordingToMonth:(NSInteger)month;

-(IBAction)doneAction:(id)sender;

@end

@implementation PDDateTimePicker


-(id)initWithType:(PDPickerType)type
{
    self.pickerType = type;
    
    PDDateTimePicker *picker = nil;
    
    NSArray *outlets = [[NSBundle mainBundle] loadNibNamed:@"PDDateTimePicker" owner:self options:nil];
    for (id outlet in outlets) {
        
        if ([outlet isKindOfClass:[PDDateTimePicker class]])
        {
            UIView *tempVw=(UIView *)outlet;
            if ([tempVw tag] == type) {
                picker = (PDDateTimePicker *)outlet;
                break;
            }
        }
    }
    
    return picker;

}


-(void)showInView:(UIView *)view hideday:(int)hide withType:(PDPickerType)type withPickingBlock:(PDPickerDidFinishPickingBlock)block andPickerDoneBlock:(PDPickerDoneBlock)doneBlock cancelBlock:(PDPickerCancelBlock)cancelBlock
{
    

    slectedDay=hide;
    self.pickerType = type;
    
    blueHeaderView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    blueHeaderView.layer.shadowRadius = 5.0;
    blueHeaderView.layer.shadowOpacity = 0.4;
    blueHeaderView.layer.shadowColor = [[UIColor blackColor] CGColor];

    self.pickingDidFinishBlock = block;
    self.pickerDoneBlock = doneBlock;
    self.pickeCancelBlock = cancelBlock;
    self.parentView = view;
    
    if (self.pickerType == PDPickerTypeDate)
        [self initializeDatePicker];
    else
        [self initializeFreeTimePicker];
    
    [self show];
}

-(void)initializeDatePicker
{
    NSDate *today = [NSDate date];
    
    
    // GETTING DAYS ACCORDING TO CURRENT MONTH
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[monthFormatter stringFromDate:today] integerValue];
    [self filterDaysArrayAccordingToMonth:currentMonth];
    
    
    
    // MONTHS
    self.arrayForSecondPicker = [@[@"January",
                                   @"Febuary",
                                   @"March",
                                   @"April",
                                   @"May",
                                   @"June",
                                   @"July",
                                   @"August",
                                   @"September",
                                   @"October",
                                   @"November",
                                   @"December"] mutableCopy];
    
   
    
    
    // WE ARE TAKING MAX YEAR CURRENT YEAR AND MIN YEAR 80 YEARS BEFORE
    self.arrayForThirdPicker = [[NSMutableArray alloc] init];
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"YYYY"];
    int currentYear = [[yearFormatter stringFromDate:today] intValue];
    currentYear += 10;
    
    for (int i=79; i>=0; i--) {
        [self.arrayForThirdPicker addObject:[NSString stringWithFormat:@"%d", currentYear - i]];
    }
    
    
    
    CGRect rect = CGRectZero;
    // DAYS PICKER
    rect = [[self viewWithTag:1] bounds];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"dd"];
    NSInteger currentDay = [[dayFormatter stringFromDate:today] integerValue];
    
    self.firstPickerView = [[DjuPickerView alloc] initWithFrame:rect];
    self.firstPickerView.delegate = self;
    self.firstPickerView.dataSource = self;
    self.firstPickerView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [[self viewWithTag:1] addSubview:self.firstPickerView];

    self.firstPickerView.overlayCell.backgroundColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    [self.firstPickerView selectRow:currentDay-1 animated:NO];
    row1 = currentDay-1;
    
    
    // MONTH PICKER
    rect = [[self viewWithTag:2] bounds];
    self.secondPickerView = [[DjuPickerView alloc] initWithFrame:rect];
    self.secondPickerView.delegate = self;
    self.secondPickerView.dataSource = self;
    self.secondPickerView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [[self viewWithTag:2] addSubview:self.secondPickerView];
    
    self.secondPickerView.overlayCell.backgroundColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    [self.secondPickerView selectRow:currentMonth-1 animated:NO];
    row2 = currentMonth-1;
    
    
    // YEAR PICKER
    rect = [[self viewWithTag:3] bounds];
    self.thirdPickerView = [[DjuPickerView alloc] initWithFrame:rect];
    self.thirdPickerView.delegate = self;
    self.thirdPickerView.dataSource = self;
    self.thirdPickerView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [[self viewWithTag:3] addSubview:self.thirdPickerView];
    
    self.thirdPickerView.overlayCell.backgroundColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    [self.thirdPickerView selectRow:69 animated:NO];
    row3 = 69;
    
    
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@", [self.arrayForFirstPicker objectAtIndex:row1], [self.arrayForSecondPicker objectAtIndex:row2], [self.arrayForThirdPicker objectAtIndex:row3]];
    titleView.text = str;
}

-(void)initializeFreeTimePicker
{
    // DAYS
    self.arrayForFirstPicker = [[NSMutableArray alloc]initWithArray:@[@"Mon",
                                                                      @"Tue",
                                                                      @"Wed",
                                                                      @"Thu",
                                                                      @"Fri",
                                                                      @"Sat",
                                                                      @"Sun"]];
    
    
    // HOURS
    self.arrayForSecondPicker = [[NSMutableArray alloc] init];
    for (int i=0; i<24; i++) {
        if (i < 10)
            [self.arrayForSecondPicker addObject:[NSString stringWithFormat:@"0%d", i]];
        else
            [self.arrayForSecondPicker addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    
    // MINUTES
    self.arrayForThirdPicker = [[NSMutableArray alloc] init];
    for (int i=0; i<60; i+=15) {
        if (i < 10)
            [self.arrayForThirdPicker addObject:[NSString stringWithFormat:@"0%d", i]];
        else
            [self.arrayForThirdPicker addObject:[NSString stringWithFormat:@"%d", i]];

    }

    
    CGRect rect = CGRectZero;
    // DAYS PICKER
    rect = [[self viewWithTag:2] bounds];

    self.firstPickerView = [[DjuPickerView alloc] initWithFrame:rect];
    self.firstPickerView.delegate = self;
    self.firstPickerView.dataSource = self;
    self.firstPickerView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [[self viewWithTag:2] addSubview:self.firstPickerView];
    
    self.firstPickerView.overlayCell.backgroundColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    
    if (slectedDay!=-1) {
        [self.firstPickerView selectRow:slectedDay animated:NO];
        row1 = slectedDay;
        self.firstPickerView.tableView.scrollEnabled=NO;
        self.firstPickerView.tableView.userInteractionEnabled=NO;
    
    }
    else
    {
        [self.firstPickerView selectRow:0 animated:NO];
        row1 = 0;
        self.firstPickerView.tableView.scrollEnabled=YES;
        self.firstPickerView.tableView.userInteractionEnabled=YES;


    }
    
    // FROM HOUR
    rect = [[self viewWithTag:3] bounds];
    self.secondPickerView = [[DjuPickerView alloc] initWithFrame:rect];
    self.secondPickerView.delegate = self;
    self.secondPickerView.dataSource = self;
    self.secondPickerView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [[self viewWithTag:3] addSubview:self.secondPickerView];
    
    self.secondPickerView.overlayCell.backgroundColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    [self.secondPickerView selectRow:0 animated:NO];
    row2 = 0;
    
    
    // FROM MINUTES
    rect = [[self viewWithTag:4] bounds];
    self.thirdPickerView = [[DjuPickerView alloc] initWithFrame:rect];
    self.thirdPickerView.delegate = self;
    self.thirdPickerView.dataSource = self;
    self.thirdPickerView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [[self viewWithTag:4] addSubview:self.thirdPickerView];
    
    self.thirdPickerView.overlayCell.backgroundColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    [self.thirdPickerView selectRow:0 animated:NO];
    row3 = 0;

    
    // TO HOURS
    rect = [[self viewWithTag:5] bounds];
    self.fourthPickerView = [[DjuPickerView alloc] initWithFrame:rect];
    self.fourthPickerView.delegate = self;
    self.fourthPickerView.dataSource = self;
    self.fourthPickerView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [[self viewWithTag:5] addSubview:self.fourthPickerView];
    
    self.fourthPickerView.overlayCell.backgroundColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    [self.fourthPickerView selectRow:0 animated:NO];
    row4 = 0;

    
    // TO MINUTES
    rect = [[self viewWithTag:6] bounds];
    self.fifthPickerView = [[DjuPickerView alloc] initWithFrame:rect];
    self.fifthPickerView.delegate = self;
    self.fifthPickerView.dataSource = self;
    self.fifthPickerView.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
    [[self viewWithTag:6] addSubview:self.fifthPickerView];
    
    self.fifthPickerView.overlayCell.backgroundColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    [self.fifthPickerView selectRow:0 animated:NO];
    row5 = 0;

    
    NSInteger f_hour    = [[self.arrayForSecondPicker objectAtIndex:row2] integerValue];
    NSInteger t_hour    = [[self.arrayForSecondPicker objectAtIndex:row4] integerValue];
    
//    NSString *from_AM_PM = (f_hour >= 12) ? @"PM" : @"AM";
//    NSString *to_AM_PM = (t_hour >= 12) ? @"PM" : @"AM";
    
//    if (f_hour > 12)
//        f_hour = f_hour - 12;
//    if (t_hour > 12)
//        t_hour = t_hour - 12;
    
    
    
    NSString *str = [NSString stringWithFormat:@"%@ %ld:%@ to %ld:%@", [self.arrayForFirstPicker objectAtIndex:row1], (long)f_hour, [self.arrayForThirdPicker objectAtIndex:row3], (long)t_hour, [self.arrayForThirdPicker objectAtIndex:row5]];
    
    
    
    
    // Check Start time is less than end time
    
 //   if ([from_AM_PM isEqualToString:to_AM_PM] )
 //   {
        int startTimeHr = (int)f_hour;
        int endTimeHr = (int)t_hour;
        
        if (startTimeHr==endTimeHr)
        {
            
            int startTimeMin=[[self.arrayForThirdPicker objectAtIndex:row3]intValue];
            int endTimeMin=[[self.arrayForThirdPicker objectAtIndex:row5]intValue];
            if (startTimeMin==endTimeMin)//||(startTimeMin>endTimeMin)) // start time end time greater than condition
            {
                str=@"";
            }
            else
            {
                titleView.text = str;
                
            }
        }
        
//        else if (startTimeHr<endTimeHr)
//        {
//            str=@"";
//        }
     //   else
        //    titleView.text = str;
  //  }
    
    
    titleView.text = str;

    
}

-(void)filterDaysArrayAccordingToMonth:(NSInteger)month
{
    self.arrayForFirstPicker = nil;
    self.arrayForFirstPicker = [[NSMutableArray alloc] init];
    
    NSInteger maxDays = 31;
    
    if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        
        month==10||
        month == 12) {
        
        maxDays = 31;
    }
    else if (month == 2) {
        maxDays = 28;
    }
    else {
        maxDays = 30;
    }
    
    for (int i=0; i<maxDays; i++) {
        [self.arrayForFirstPicker addObject:[NSString stringWithFormat:@"%d", i+1]];
    }
}


-(void)show
{
    CGFloat Y = CGRectGetHeight(self.parentView.frame);
    CGRect rect = [self bounds];
    rect.origin.y = Y;
    self.frame = rect;
    [self.parentView addSubview:self];
    
    Y = Y - rect.size.height;
    rect.origin.y = Y;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = rect;
    }];
}

-(void)hide
{
    CGFloat Y = CGRectGetHeight(self.parentView.frame);
    CGRect rect = [self bounds];
    rect.origin.y = Y;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

-(IBAction)cancelAction:(id)sender
{
    [self hide];
    
    
    if (self.pickeCancelBlock ) {
        self.pickeCancelBlock ();
    }
}
-(IBAction)doneAction:(id)sender
{
    [self hide];
    
    if (self.pickerDoneBlock) {
        self.pickerDoneBlock (titleView.text);
    }
}

#pragma mark - Picker Delegates
- (NSString *)djuPickerView:(DjuPickerView *)djuPickerView titleForRow:(NSInteger)row {
    
    if (djuPickerView == self.firstPickerView)
        return [self.arrayForFirstPicker objectAtIndex:row];
    else if (djuPickerView == self.secondPickerView)
        return [self.arrayForSecondPicker objectAtIndex:row];
    else if (djuPickerView == self.thirdPickerView)
        return [self.arrayForThirdPicker objectAtIndex:row];
    else if (djuPickerView == self.fourthPickerView)
        return [self.arrayForSecondPicker objectAtIndex:row];
    else
        return [self.arrayForThirdPicker objectAtIndex:row];
    
}

- (void)djuPickerView:(DjuPickerView*)djuPickerView didSelectRow:(NSInteger)row {
    

    
    //    [self.thirdPickerView selectRow:69 animated:NO];
    //row3 = 69;
    if (self.pickerType == PDPickerTypeDate && djuPickerView == self.secondPickerView) {
        
        [self filterDaysArrayAccordingToMonth:row+1];
        [[self.firstPickerView tableView] reloadData];
        
    }
    
    
    CGFloat y = [[self.firstPickerView tableView] contentOffset].y/40.0;
    NSInteger rounded = (NSInteger)(lround(y));
    if (rounded < [self.arrayForFirstPicker count])
        row1 = rounded;

    y = [[self.secondPickerView tableView] contentOffset].y/40.0;
    rounded = (NSInteger)(lround(y));
    if (rounded < [self.arrayForSecondPicker count])
        row2 = rounded;

    y = [[self.thirdPickerView tableView] contentOffset].y/40.0;
    rounded = (NSInteger)(lround(y));
    if (rounded < [self.arrayForThirdPicker count])
        row3 = rounded;
    

    
    if (self.pickingDidFinishBlock) {
        
       
        
        
        if (self.pickerType == PDPickerTypeDate)
        {
            
                          ////// mohit
            if (self.endDate!=nil)
            {


                NSDateFormatter *formatDate=[[NSDateFormatter alloc]init];
                [formatDate setDateFormat:@"MMMM"];
                NSLog(@"DateEnd --------%@",self.endDate);
                NSString *startMonth = [formatDate stringFromDate:self.endDate];
                [formatDate setDateFormat:@"YYYY"];
                int startYear = [[formatDate stringFromDate:self.endDate] intValue];
                [formatDate setDateFormat:@"dd"];
                NSInteger startDay = [[formatDate stringFromDate:self.endDate] integerValue];
                
                
                int monthIndex = [[NSString stringWithFormat:@"%lu",(unsigned long)[self.arrayForSecondPicker indexOfObject:startMonth]]intValue];
                int dateIndex = [[NSString stringWithFormat:@"%lu",(unsigned long)[self.arrayForFirstPicker indexOfObject:[NSString stringWithFormat:@"%ld",(long)startDay]]]intValue];
                int YearIndex = [[NSString stringWithFormat:@"%lu",(unsigned long)[self.arrayForThirdPicker indexOfObject:[NSString stringWithFormat:@"%d",startYear]]]intValue];

                
                


                
                if ([[self.arrayForThirdPicker objectAtIndex:row3] intValue]>=startYear)
                {
                [self.thirdPickerView selectRow:YearIndex animated:YES];
                row3 = YearIndex;
                    
                     y = [[self.thirdPickerView tableView] contentOffset].y/40.0;
                    rounded = (NSInteger)(lround(y));
                    if (rounded < [self.arrayForThirdPicker count])
                        row3 = rounded;
                 
                  
                      [formatDate setDateFormat:@"MM"];
                    NSDate *dateMonthtemp=[formatDate dateFromString:[self.arrayForSecondPicker objectAtIndex:row2]];
                  
                    
                    
                    NSLog(@"%@",[self.arrayForSecondPicker objectAtIndex:row2]);
                    NSLog(@"%d",[[formatDate stringFromDate:dateMonthtemp]intValue]);

                    if ( [[formatDate stringFromDate:dateMonthtemp]intValue]>=monthIndex+1)
                    {
                        [self.secondPickerView selectRow:monthIndex animated:YES];
                        row2 = monthIndex;
                        
                        y = [[self.secondPickerView tableView] contentOffset].y/40.0;
                       rounded = (NSInteger)(lround(y));
                       if (rounded < [self.arrayForSecondPicker count])
                         row2 = rounded;
                        
                        
                        NSLog(@"%d",[[self.arrayForFirstPicker  objectAtIndex:row1] intValue]);
                        if ( [[self.arrayForFirstPicker  objectAtIndex:row1] intValue]>=dateIndex+1)
                        {
                            
                            [self.firstPickerView selectRow:dateIndex animated:YES];
                            row1 = dateIndex;
                           CGFloat y = [[self.firstPickerView tableView] contentOffset].y/40.0;
                            NSInteger rounded = (NSInteger)(lround(y));
                            if (rounded < [self.arrayForFirstPicker count])
                                row1 = rounded;
                        }
  
                    }
                

                }

            }
            
            if (self.startDate!=nil)
            {
                NSDateFormatter *formatDate=[[NSDateFormatter alloc]init];
                [formatDate setDateFormat:@"MMMM"];
                NSString *startMonth = [formatDate stringFromDate:self.startDate];
                [formatDate setDateFormat:@"YYYY"];
                int startYear = [[formatDate stringFromDate:self.startDate] intValue];
                [formatDate setDateFormat:@"dd"];
                NSInteger startDay = [[formatDate stringFromDate:self.startDate] integerValue];
                
                
       
                int monthIndex = [[NSString stringWithFormat:@"%lu",(unsigned long)[self.arrayForSecondPicker indexOfObject:startMonth]]intValue];
                int dateIndex = [[NSString stringWithFormat:@"%lu",(unsigned long)[self.arrayForFirstPicker indexOfObject:[NSString stringWithFormat:@"%ld",(long)startDay]]]intValue];
                int YearIndex = [[NSString stringWithFormat:@"%lu",(unsigned long)[self.arrayForThirdPicker indexOfObject:[NSString stringWithFormat:@"%d",startYear]]]intValue];
                
                
                if ([[self.arrayForThirdPicker objectAtIndex:row3] intValue]<=startYear)
                {
                    [self.thirdPickerView selectRow:YearIndex animated:YES];
                    row3 = YearIndex;
                    
                    y = [[self.thirdPickerView tableView] contentOffset].y/40.0;
                    rounded = (NSInteger)(lround(y));
                    if (rounded < [self.arrayForThirdPicker count])
                        row3 = rounded;
                    
                    
                    [formatDate setDateFormat:@"MM"];
                    NSDate *dateMonthtemp=[formatDate dateFromString:[self.arrayForSecondPicker objectAtIndex:row2]];
                    
                    
                    
                    
                    if ( [[formatDate stringFromDate:dateMonthtemp]intValue]<=monthIndex+1)
                    {
                        [self.secondPickerView selectRow:monthIndex animated:YES];
                        row2 = monthIndex;
                        
                        y = [[self.secondPickerView tableView] contentOffset].y/40.0;
                        rounded = (NSInteger)(lround(y));
                        if (rounded < [self.arrayForSecondPicker count])
                            row2 = rounded;
                        
                        if ( [[self.arrayForFirstPicker  objectAtIndex:row1] intValue]<=dateIndex+1)
                        {
                            
                            [self.firstPickerView selectRow:dateIndex animated:YES];
                            row1 = dateIndex;
                            CGFloat y = [[self.firstPickerView tableView] contentOffset].y/40.0;
                            NSInteger rounded = (NSInteger)(lround(y));
                            if (rounded < [self.arrayForFirstPicker count])
                                row1 = rounded;
                        }
                        
                    }
                    
                    
                }

            }
      //////////////
            NSString *str = [NSString stringWithFormat:@"%@-%@-%@", [self.arrayForFirstPicker objectAtIndex:row1], [self.arrayForSecondPicker objectAtIndex:row2], [self.arrayForThirdPicker objectAtIndex:row3]];
            titleView.text = str;
            self.pickingDidFinishBlock (str);
        }
        else
        {
            y = [[self.fourthPickerView tableView] contentOffset].y/40.0;
            rounded = (NSInteger)(lround(y));
            if (rounded < [self.arrayForSecondPicker count])
                row4 = rounded;

            
            y = [[self.fifthPickerView tableView] contentOffset].y/40.0;
            rounded = (NSInteger)(lround(y));
            if (rounded < [self.arrayForThirdPicker count])
                row5 = rounded;
            
            
            // FORMAT
            // Sunday 12:12PM to 3:45PM

            NSInteger f_hour    = [[self.arrayForSecondPicker objectAtIndex:row2] integerValue];
            NSInteger t_hour    = [[self.arrayForSecondPicker objectAtIndex:row4] integerValue];
            
//            NSString *from_AM_PM = (f_hour >= 12) ? @"PM" : @"AM";
//            NSString *to_AM_PM = (t_hour >= 12) ? @"PM" : @"AM";
            
//            if (f_hour > 12)
//                f_hour = f_hour - 12;
//            if (t_hour > 12)
//                t_hour = t_hour - 12;
            
            
            NSString *str = [NSString stringWithFormat:@"%@ %ld:%@ to %ld:%@", [self.arrayForFirstPicker objectAtIndex:row1], (long)f_hour, [self.arrayForThirdPicker objectAtIndex:row3], (long)t_hour, [self.arrayForThirdPicker objectAtIndex:row5]];
            
            // Check Start time is less than end time
//
//            if ([from_AM_PM isEqualToString:to_AM_PM] )
//            {
                int startTimeHr = (int)f_hour;
                int endTimeHr = (int)t_hour;
                
                if (startTimeHr==endTimeHr)
                {
                    
                    int startTimeMin=[[self.arrayForThirdPicker objectAtIndex:row3]intValue];
                    int endTimeMin=[[self.arrayForThirdPicker objectAtIndex:row5]intValue];
                    if ((startTimeMin==endTimeMin)||(startTimeMin>endTimeMin)) // start time end time greater than condition
                    {
                        str=@"";
                    }
                    else
                    {
                        titleView.text = str;

                    }
                }
                else   if (startTimeHr>endTimeHr)
                {
                                   str=@"";
                }

//                else if (startTimeHr<endTimeHr)
//                {
//                    str=@"";
//                }
              //  else
                    titleView.text = str;
           // }
            

           titleView.text = str;
            
            self.pickingDidFinishBlock (str);

        }
    }

    
}

- (CGFloat)rowHeightForDjuPickerView:(DjuPickerView *)djuPickerView {
    
    return 40.0;
}

- (void)labelStyleForDjuPickerView:(DjuPickerView*)djuPickerView forLabel:(UILabel*)label {
    
    label.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    label.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - DjuPickerViewDataSource functions
- (NSInteger)numberOfRowsInDjuPickerView:(DjuPickerView*)djuPickerView {
    
    if (djuPickerView == self.firstPickerView)
        return [self.arrayForFirstPicker count];
    else if (djuPickerView == self.secondPickerView)
        return [self.arrayForSecondPicker count];
    else if (djuPickerView == self.thirdPickerView)
        return [self.arrayForThirdPicker count];
    else if (djuPickerView == self.fourthPickerView)
        return [self.arrayForSecondPicker count];
    else
        return [self.arrayForThirdPicker count];
    
}


@end
