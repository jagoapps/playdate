//
//  PDMenuBar.m
//  PlayDate
//
//  Created by Vakul on 08/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDMenuBar.h"

@implementation PDMenuBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(PDMenuBar *)menuBar
{
    PDMenuBar *mB = nil;
    NSArray *outlets = [[NSBundle mainBundle] loadNibNamed:@"PDMenuBar" owner:self options:nil];
    for (id outlet in outlets)
    {
        if ([outlet isKindOfClass:[PDMenuBar class]])
        {
            mB = (PDMenuBar *)outlet;
            break;
        }
    }
    
    return mB;
}

-(void)addAction:(SEL)action andTarget:(id)target
{
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
}


@end
