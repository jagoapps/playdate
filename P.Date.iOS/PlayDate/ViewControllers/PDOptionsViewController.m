//
//  PDOptionsViewController.m
//  PlayDate
//
//  Created by Vakul on 26/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDOptionsViewController.h"

@interface PDOptionsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIView *navigationView;
    IBOutlet UIView *footerView;
    IBOutlet UILabel *lblTop;
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSMutableArray *selectedIndex;
@property (strong, nonatomic) PDOptionsDidFinishBlock optionsDidFinishBlock;

-(IBAction)doneAction:(id)sender;

@end

@implementation PDOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[PDHelper sharedHelper] applicationBackgroundColor];
  
    // SET UP SUBVIEWS FRAME ACCORING TO iOS-7 & BELOW iOS-7 STATUSBAR
    [self setUpViewContents];

    
    self.tblView.backgroundView = nil;
    self.tblView.backgroundColor = [UIColor whiteColor];
    //self.tblView.separatorColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    
    if (self.selectedIndex == nil)
        self.selectedIndex = [[NSMutableArray alloc] init];
    
    if (self.listType == ListChildAllergies) {
        self.items = [[PDUser currentUser] childAllergies];
          lblTop.text=@"Allergies";
    }
    else if (self.listType == ListChildHobbies) {
        self.items = [[PDUser currentUser] childHobbies];
        lblTop.text=@"Hobbies";

    }
    
    
    // ADD INDEX PATH WHICH ARE ALREADY SELECTED
    for (int i=0; i<[self.items count]; i++)
    {
        NSString *text = self.items[i];
        BOOL isFoundInArray = NO;
        for (NSString *t in self.selectedTexts) {
            if ([t rangeOfString:text].location != NSNotFound) {
                isFoundInArray = YES;
                break;
            }
        }

        if (isFoundInArray)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.selectedIndex addObject:indexPath];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Methods
-(void)setUpViewContents
{
    CGRect rect;
    
    CGFloat totalHeight = [UIScreen mainScreen].bounds.size.height;
    if (![[PDHelper sharedHelper] isIOS7])
    {
        totalHeight -= 20.0;
    }
    else
    {
        for (UIView *subView in self.view.subviews)
        {
            if ([subView isKindOfClass:[UIView class]] && subView != footerView)
            {
                rect = subView.frame;
                rect.origin.y += 20.0;
                subView.frame = rect;
            }
        }
    }
    
    
    rect = self.tblView.frame;
    rect.origin.y = CGRectGetMaxY(navigationView.frame);
    rect.size.height = totalHeight - CGRectGetMaxY(navigationView.frame);
    self.tblView.frame = rect;
}

-(void)openFromController:(UIViewController *)controller withCompletionBlock:(PDOptionsDidFinishBlock)block
{
    self.optionsDidFinishBlock = block;
    [controller.navigationController pushViewController:self animated:YES];
}

-(IBAction)doneAction:(id)sender
{
    if (self.optionsDidFinishBlock){
        
        NSMutableArray *texts = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in self.selectedIndex)
            [texts addObject:[self.items objectAtIndex:indexPath.row]];
        self.optionsDidFinishBlock(texts, self.selectedIndex);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View DataSource & Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count] + 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [[PDHelper sharedHelper] applicationFontWithSize:14.0];
    
    if (indexPath.row < self.items.count)
        cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = @"";
    
    cell.textLabel.textColor = [[PDHelper sharedHelper] applicationThemeBlueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.selectedIndex containsObject:indexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.items.count)
    {
        UITableViewCell *cell = [self.tblView cellForRowAtIndexPath:indexPath];
        
        if ([self.selectedIndex containsObject:indexPath]) {
            
            // Deselect Row
            [self.selectedIndex removeObject:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            // Select Row
            
            [self.selectedIndex addObject:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

@end
