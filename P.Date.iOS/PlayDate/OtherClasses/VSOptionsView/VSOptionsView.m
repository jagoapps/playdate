//
//  VSOptionsView.m
//  PhotoStackN
//
//  Created by Vakul on 23/04/14.
//  Copyright (c) 2014 TheTiger. All rights reserved.
//

#import "VSOptionsView.h"

@interface VSOptionsView ()
{
    UIView *superView;
    NSInteger animation;
}

@end

@implementation VSOptionsView


-(id)initWithDelegate:(id<VSOptionsViewDelegate>)delegate andTitles:(NSString *)titles, ...
{
    self = [super init];
    if (self)
    {
        self.delegate  = delegate;

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.lineColor = [UIColor orangeColor];
        self.rowColor = [UIColor whiteColor];
        self.selectedRowColor = [UIColor orangeColor];
        self.titleColor = [UIColor orangeColor];
        self.selectedTitleColor = [UIColor whiteColor];
        self.linePaddingFromLeft = 0.0;
        self.linePaddingFromRight = 0.0;
        
        self.rowHeight = 35.0;
        self.rowWidth  = 200.0;
        
        self.mainTitle = @"";
        self.mainTitleColor = [UIColor orangeColor];
        self.mainTitleLineColor = [UIColor orangeColor];
        self.mainTitleRowColor = [UIColor whiteColor];
        
        self.touchToDismiss = YES;
        
        self.font = [UIFont fontWithName:@"Helvetica" size:(self.rowHeight/3.0)];
        
        self.titles = [[NSMutableArray alloc] init];
        
        // ADDING FIRST OBJECT
        // THIS IS NOT A PART OF va_list
        [self.titles addObject:titles];
        
        // NOW PARSE THE REST TITLES
        va_list args;
        va_start(args, titles);
        
        NSString  *title = nil;
        while ((title = va_arg(args, NSString *))) {
            [self.titles addObject:title];
        }
        
        va_end(args);
    }
    
    return self;
}

#pragma mark - set up all subviews
-(void)setUpSubviews
{
    BOOL isMainTitle = (self.mainTitle.length > 0) ? YES : NO;
    
    superView = [UIApplication sharedApplication].keyWindow;
  //  superView = controller.view;
    CGRect rect = superView.bounds;
    
    self.frame = rect;
    self.alpha = 0.3;
    
    // INTIALIZING SHEET
    
    self.sheet = [[UIScrollView alloc] init];
    self.sheet.bounces = NO;
    self.sheet.scrollEnabled = NO;
    
    // Calculating the width and height
    // behalf on its superview
    CGFloat maxHeight   = CGRectGetHeight(rect) - 40.0;
    CGFloat maxWidth    = CGRectGetWidth(rect) - 40.0;
    
    CGFloat sheetHeight = self.rowHeight * [self.titles count];
    if (isMainTitle) {
        // ADD MAIN TITLE HEIGHT HERE
        // DEFAULT TITLE HEIGHT IS 50.0
        
        sheetHeight += 45.0;
        
        // ADD MAIN TITLE VIEW
        UILabel *titleView = [[UILabel alloc] init];
        [titleView setFrame:CGRectMake(0.0, 0.0, self.rowWidth, 45.0)];
        [titleView setFont:[UIFont fontWithName:self.font.fontName size:self.font.pointSize + 4.0]];
        [titleView setBackgroundColor:self.mainTitleRowColor];
        [titleView setTextAlignment:NSTextAlignmentLeft];
        [titleView setText:self.mainTitle];
        [titleView setTextColor:self.mainTitleColor];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0, 45.0-2.0, self.rowWidth, 2.0);
        bottomBorder.backgroundColor = self.lineColor.CGColor;
        [titleView.layer addSublayer:bottomBorder];
        
        [self.sheet addSubview:titleView];
    }
    
    if (sheetHeight > maxHeight) {
        sheetHeight = maxHeight;
        self.sheet.scrollEnabled = YES;
    }
    
    CGFloat sheetWidth  = self.rowWidth;
    if (sheetWidth > maxWidth) {
        sheetWidth = maxWidth;
        self.rowWidth = maxWidth;
    }
    
    CGFloat xOrigin = 0.0;
    CGFloat yOrigin = (CGRectGetHeight(rect) - sheetHeight)/2.0;
    
    self.sheet.frame = CGRectMake(xOrigin, yOrigin, sheetWidth, sheetHeight);
    
    // GIVE SHADOW TO SHEET
    if (self.sheet.scrollEnabled)
        self.sheet.layer.masksToBounds = YES;
    else
        self.sheet.layer.masksToBounds = NO;
    
    
    
    

    // ADDING ROWS ON SHEET
    NSString *currentTitle = nil;
    xOrigin = 0.0;
    yOrigin = (isMainTitle) ? 45.0: 0.0;
    
    for (NSInteger i=0; i<[self.titles count]; i++)
    {
        currentTitle = [self.titles objectAtIndex:i];
        rect = CGRectMake(xOrigin, yOrigin, self.rowWidth, self.rowHeight);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = rect;
        btn.backgroundColor = self.rowColor;
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.font];
        [btn setTitle:currentTitle forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, (self.linePaddingFromLeft == 0.0) ? 10.0 : self.linePaddingFromLeft, 0.0, self.linePaddingFromRight)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [btn addTarget:self action:@selector(rowAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(touchStart:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(touchEnded:) forControlEvents:UIControlEventTouchDragExit];
        
        if (i < [self.titles count]-1)
        {
            // ADDING SHADOW
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(self.linePaddingFromLeft, self.rowHeight-1.0, self.rowWidth-(self.linePaddingFromLeft + self.linePaddingFromRight), 1.0);
            bottomBorder.backgroundColor = self.lineColor.CGColor;
            [btn.layer addSublayer:bottomBorder];
        }
        
        [self.sheet addSubview:btn];
        yOrigin = yOrigin + self.rowHeight;
    }
    
    [self.sheet setContentSize:CGSizeMake(self.rowWidth, yOrigin)];
    
}

#pragma mark - Show Hide Methods
-(void)showFromLeft
{
    [self setUpSubviews];
    
    animation = 0;
    [superView addSubview:self];
    
    
    /*
     * SHADOW
     */
    
    // self.sheet.layer.cornerRadius = 10.0; // if you like rounded corners
    self.sheet.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    self.sheet.layer.shadowRadius = 5.0;
    self.sheet.layer.shadowOpacity = 0.5;
    
    /*
     *
     */

    
    CGRect sheetFrame = self.sheet.frame;
    sheetFrame.origin.x = -self.rowWidth;
    self.sheet.frame = sheetFrame;
    
    sheetFrame.origin.x = 0.0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        
    }completion:^(BOOL finished) {
        
        [self addSubview:self.sheet];
        [UIView animateWithDuration:0.3 animations:^{
            self.sheet.frame = sheetFrame;
        } completion:^(BOOL finished) {
            
            if ([self.delegate respondsToSelector:@selector(optionViewDidAppear:)])
                [self.delegate optionViewDidAppear:self];
            
        }];
    }];
}

-(void)showFromRight
{
    [self setUpSubviews];
    
    animation = 1;
    [superView addSubview:self];
    
    
    /*
     * SHADOW
     */
    
    // self.sheet.layer.cornerRadius = 10.0; // if you like rounded corners
    self.sheet.layer.shadowOffset = CGSizeMake(-4.0, 4.0);
    self.sheet.layer.shadowRadius = 5.0;
    self.sheet.layer.shadowOpacity = 0.5;
    
    /*
     *
     */

    
    CGRect sheetFrame = self.sheet.frame;
    sheetFrame.origin.x = CGRectGetWidth(superView.frame) + self.rowWidth;
    self.sheet.frame = sheetFrame;
    
    sheetFrame.origin.x = CGRectGetWidth(superView.frame) - self.rowWidth;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        
    }completion:^(BOOL finished) {
        
        [self addSubview:self.sheet];
        [UIView animateWithDuration:0.3 animations:^{
            self.sheet.frame = sheetFrame;
        } completion:^(BOOL finished) {

            if ([self.delegate respondsToSelector:@selector(optionViewDidAppear:)])
                [self.delegate optionViewDidAppear:self];

        }];
    }];
}

-(void)showFromTop
{
    [self setUpSubviews];
    
    animation = 2;
    [superView addSubview:self];
    
  
    /*
     * SHADOW
     */
    
    // self.sheet.layer.cornerRadius = 10.0; // if you like rounded corners
    self.sheet.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    self.sheet.layer.shadowRadius = 5.0;
    self.sheet.layer.shadowOpacity = 0.5;
    
    /*
     *
     */

    
    CGRect sheetFrame = self.sheet.frame;
    sheetFrame.origin.x = (CGRectGetWidth(superView.frame) - self.rowWidth)/2.0;
    sheetFrame.origin.y = -CGRectGetHeight(sheetFrame);
    self.sheet.frame = sheetFrame;
    
    sheetFrame.origin.y = 0.0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        
    }completion:^(BOOL finished) {
        
        [self addSubview:self.sheet];
        [UIView animateWithDuration:0.3 animations:^{
            self.sheet.frame = sheetFrame;
        } completion:^(BOOL finished) {
            
            if ([self.delegate respondsToSelector:@selector(optionViewDidAppear:)])
                [self.delegate optionViewDidAppear:self];
            
        }];
    }];
}

-(void)showFromBottom
{
    [self setUpSubviews];
    
    animation = 3;
    [superView addSubview:self];
    
    
    /*
     * SHADOW
     */
    
    // self.sheet.layer.cornerRadius = 10.0; // if you like rounded corners
    self.sheet.layer.shadowOffset = CGSizeMake(4.0, -4.0);
    self.sheet.layer.shadowRadius = 5.0;
    self.sheet.layer.shadowOpacity = 0.5;
    
    /*
     *
     */

    
    CGRect sheetFrame = self.sheet.frame;
    sheetFrame.origin.x = (CGRectGetWidth(superView.frame) - self.rowWidth)/2.0;
    sheetFrame.origin.y = CGRectGetMaxY(superView.frame) + CGRectGetHeight(sheetFrame);
    self.sheet.frame = sheetFrame;
    
    sheetFrame.origin.y = CGRectGetHeight(superView.frame) - CGRectGetHeight(sheetFrame);
        
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        
    }completion:^(BOOL finished) {
        
        [self addSubview:self.sheet];
        [UIView animateWithDuration:0.3 animations:^{
            self.sheet.frame = sheetFrame;
        } completion:^(BOOL finished) {
            
            if ([self.delegate respondsToSelector:@selector(optionViewDidAppear:)])
                [self.delegate optionViewDidAppear:self];

        }];
    }];
}


-(void)showAtCenter
{
    [self setUpSubviews];
    
    animation = 4;
    [superView addSubview:self];
    
    
    /*
     * SHADOW
     */
    
    // self.sheet.layer.cornerRadius = 10.0; // if you like rounded corners
    self.sheet.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    self.sheet.layer.shadowRadius = 5.0;
    self.sheet.layer.shadowOpacity = 0.5;
    
    /*
     *
     */

    CGRect sheetFrame = self.sheet.frame;
    sheetFrame.origin.x = (CGRectGetWidth(superView.frame) - self.rowWidth)/2.0;
    sheetFrame.origin.y = (CGRectGetHeight(superView.frame) - CGRectGetHeight(self.sheet.frame))/2.0;
    self.sheet.frame = sheetFrame;
    self.sheet.alpha = 0.3;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        
    }completion:^(BOOL finished) {
        
        [self addSubview:self.sheet];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.sheet.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            if ([self.delegate respondsToSelector:@selector(optionViewDidAppear:)])
                [self.delegate optionViewDidAppear:self];
            
        }];
    }];

}



-(void)dismiss
{
    CGRect rect = self.sheet.frame;
    
    switch (animation) {
        case 0:
        {
            rect.origin.x = -self.rowWidth;
        }
            break;
        case 1:
        {
            rect.origin.x = CGRectGetWidth(superView.frame) + self.rowWidth;
        }
            break;
        case 2:
        {
            rect.origin.y = -CGRectGetHeight(self.sheet.frame);
        }
            break;
        case 3:
        {
            rect.origin.y = CGRectGetHeight(superView.frame);
        }
            break;
        case 4:
        {
            
        }
            break;

        default:
            break;
    }
    
    
    if (animation == 4)
    {
        // CENTER ANIMATION
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0;
            
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.sheet.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                [self.sheet removeFromSuperview];
                [self removeFromSuperview];
                
                if ([self.delegate respondsToSelector:@selector(optionViewDidDisappear:)])
                    [self.delegate optionViewDidDisappear:self];
                
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.sheet.frame = rect;
        } completion:^(BOOL finished) {
            
            [self.sheet removeFromSuperview];
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
                if ([self.delegate respondsToSelector:@selector(optionViewDidDisappear:)])
                    [self.delegate optionViewDidDisappear:self];
            }];
            
        }];
    }
}


#pragma mark - Row Methods
-(void)rowAction:(id)sender
{
    [self touchEnded:sender];
    
    if ([self.delegate respondsToSelector:@selector(optionView:clickedAtIndex:)])
    {
        UIButton *btn=(UIButton *)sender;
        [self.delegate optionView:self clickedAtIndex:[btn tag]];
    }
    if (self.dismissAfterAction) {
        [self dismiss];
    }
}

-(void)touchStart:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:self.selectedRowColor];
}

-(void)touchEnded:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:self.rowColor];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchToDismiss)
        [self dismiss];
}


@end
