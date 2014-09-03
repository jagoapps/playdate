//
//  DjuPickerView.m
//
//  Copyright (c) 2013 Derek Ju. All rights reserved.
//

#import "DjuPickerView.h"

@interface DjuPickerView() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DjuPickerView {
	
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		//_tableView.allowsSelection = NO;
		self.tableView.showsVerticalScrollIndicator = NO;
		self.tableView.showsHorizontalScrollIndicator = NO;
					
		self.overlayCell = [[UIView alloc] initWithFrame:CGRectMake(0.0, 60.0, self.frame.size.width, 40.0)];
		self.overlayCell.backgroundColor = [UIColor blackColor];
		self.overlayCell.userInteractionEnabled = NO;
		self.overlayCell.alpha = 0.25;
			
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
    // Move overlay to center of table view
    CGFloat centerY = (self.frame.size.height - rowHeight) / 2.0;
    self.overlayCell.frame = CGRectMake(0.0, centerY, self.frame.size.width, rowHeight);
    
    // Calculate height of table based on height of cell and height of frame
    // Figure out the number of cells that will fit on the table
    //NSInteger numCells = (NSInteger)(floor(self.frame.size.height / [self.delegate rowHeightForDjuPickerView:self]));
    
    [self addSubview:self.tableView];
    [self addSubview:self.overlayCell];	
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	// Always pass all touches on this view to the table view
	return self.tableView;
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated{
    
    CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    [self.tableView setContentOffset:CGPointMake(0.0, row * rowHeight) animated:animated];

    if (animated)
        [self.delegate djuPickerView:self didSelectRow:row];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.tableView.backgroundColor = backgroundColor;
}

#pragma mark - UITableViewDelegate functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataSource numberOfRowsInDjuPickerView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
	if (cell == nil) {
		// Alloc a new cell
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			
		UIView *contentView = cell.contentView;
				
		UILabel *textLabel;
		if (indexPath.row == 0) {
			textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.overlayCell.frame.origin.y, self.frame.size.width, rowHeight)];
		} else {
			textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, rowHeight)];
		}
		textLabel.tag = -1;
		textLabel.text = [self.delegate djuPickerView:self titleForRow:indexPath.row];
        textLabel.backgroundColor = [UIColor clearColor];
        
        [self.delegate labelStyleForDjuPickerView:self forLabel:textLabel];

		[contentView addSubview:textLabel];
		
	} else {
		// Reuse cell
		UIView *contentView = cell.contentView;
				
		UILabel *textLabel = (UILabel*)[contentView viewWithTag:-1];
		textLabel.text = [self.delegate djuPickerView:self titleForRow:indexPath.row];
		
		if (indexPath.row == 0) {
			textLabel.frame = CGRectMake(0.0, self.overlayCell.frame.origin.y, self.frame.size.width, rowHeight);
		} else {
			textLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, rowHeight);
		}        
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectRow:indexPath.row animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
	// Add front and back padding to make this more closely resemble a picker view
	if (indexPath.row == 0) {
		return (self.overlayCell.frame.origin.y + rowHeight);
	} else if (indexPath.row == [self.dataSource numberOfRowsInDjuPickerView:self] - 1) {
		return (self.overlayCell.frame.origin.y + rowHeight);
	}
	return rowHeight;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
	// Auto scroll to next multiple of rowHeight
	CGFloat floatVal = targetContentOffset->y / rowHeight;
	roundedGlobal = (NSInteger)(lround(floatVal));

	targetContentOffset->y = roundedGlobal * rowHeight;
}


NSInteger roundedGlobal;
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating:");
    
    // Tell delegate where we're landing
    [self.delegate djuPickerView:self didSelectRow:roundedGlobal];
}


@end
