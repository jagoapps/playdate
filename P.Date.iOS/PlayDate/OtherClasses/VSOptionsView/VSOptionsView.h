//
//  VSOptionsView.h
//  PhotoStackN
//
//  Created by Vakul on 23/04/14.
//  Copyright (c) 2014 TheTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class VSOptionsView, VSOptionsViewDelegate;

@protocol VSOptionsViewDelegate <NSObject>

@optional
-(void)optionViewDidAppear:(VSOptionsView *)optionView;
-(void)optionViewDidDisappear:(VSOptionsView *)optionView;
-(void)optionView:(VSOptionsView *)optionView clickedAtIndex:(NSInteger)index;

@end

@interface VSOptionsView : UIView


@property (strong, nonatomic) id <VSOptionsViewDelegate> delegate;
@property (strong, nonatomic) UIScrollView *sheet;
@property (strong, nonatomic) NSMutableArray *titles;

@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *rowColor;
@property (strong, nonatomic) UIColor *selectedRowColor;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;

@property (strong, nonatomic) UIFont *font;

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat rowWidth;
@property (nonatomic) CGFloat linePaddingFromLeft;
@property (nonatomic) CGFloat linePaddingFromRight;

@property (nonatomic) BOOL dismissAfterAction;
@property (nonatomic) BOOL touchToDismiss;

/********************MAIN TITLE*******************/
@property (strong, nonatomic) NSString *mainTitle;
@property (strong, nonatomic) UIColor  *mainTitleColor;
@property (strong, nonatomic) UIColor  *mainTitleLineColor;
@property (strong, nonatomic) UIColor  *mainTitleRowColor;
/*************************************************/

-(id)initWithDelegate:(id <VSOptionsViewDelegate>)delegate andTitles:(NSString *)titles , ... NS_REQUIRES_NIL_TERMINATION;

-(void)showFromLeft;
-(void)showFromRight;
-(void)showFromTop;
-(void)showFromBottom;
-(void)showAtCenter;

-(void)dismiss;


@end
