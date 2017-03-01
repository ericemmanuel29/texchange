//
//  ClassViewController.m
//  texchange
//
//  Created by Peter Spadalik on 2/10/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "ClassViewController.h"

@interface ClassViewController ()
@end

@implementation ClassViewController

@synthesize classes, classid, sections, instructor, name, scheduledisplay;

-(void)viewDidLoad{
    [super viewDidLoad];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //resizes table view to be used later
    CGRect scheduleframe = [[UIScreen mainScreen] bounds];
    scheduleframe.origin.y=65;
    scheduleframe.size.height=scheduleframe.size.height-130;
    UITableView *tableView = [[UITableView alloc] initWithFrame:scheduleframe style:UITableViewStylePlain];
    //tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    //red border top and bottom
    CGRect topframe = CGRectMake(0, 0, width, 65);
    UIView *topborder = [[UIView alloc] initWithFrame:topframe];
    topborder.backgroundColor = [UIColor redColor];
    CGRect bottomframe = CGRectMake(0, height-65, width, 65);
    UIView *bottomborder = [[UIView alloc] initWithFrame:bottomframe];
    topborder.backgroundColor = [UIColor redColor];
    bottomborder.backgroundColor = [UIColor redColor];
    UIButton *backpackbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backpackbutton addTarget:self action:@selector(backpack:) forControlEvents:UIControlEventTouchUpInside];
    backpackbutton.frame = CGRectMake(width-10-30, 20, 30, 40);
    UIImage *backpackimage = [UIImage imageNamed:@"backpack.png"];
    [backpackbutton setBackgroundImage:backpackimage forState:UIControlStateNormal];
    UIButton *logoutbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutbutton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    logoutbutton.frame = CGRectMake(10, 25, 27, 30);
    UIImage *logoutimage = [UIImage imageNamed:@"logout.png"];
    [logoutbutton setBackgroundImage:logoutimage forState:UIControlStateNormal];
    CGRect nameframe = CGRectMake(10+27+25, 9, width-10-30-25-10-27-25, 56);
    UILabel *displayname = [[UILabel alloc] initWithFrame:nameframe];
    [displayname setTextColor:[UIColor whiteColor]];
    [displayname setText:[NSString stringWithFormat:@"%@", name]];
    //[displayname setFont:[UIFont systemFontOfSize:12]];
    //displayname.adjustsFontSizeToFitWidth = YES;
    displayname.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:tableView];
    [self.view addSubview:bottomborder];
    [self.view addSubview:topborder];
    [self.view addSubview:backpackbutton];
    [self.view addSubview:logoutbutton];
    [self.view addSubview:displayname];

    

}

- (IBAction)backpack:(UIButton *)sender
{
    
}

- (IBAction)logout:(UIButton *)sender
{
    
}
//cell height
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [classes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    //formats string for view
    NSString *holder1 = [classes[indexPath.row] stringByAppendingString:@"\n"];
    NSString *holder2 =[holder1 stringByAppendingString:classid[indexPath.row]];
    NSString *holder3 =[holder2 stringByAppendingString:@" - "];
    NSString *holder4 =[holder3 stringByAppendingString:sections[indexPath.row]];
    NSString *holder5 =[holder4 stringByAppendingString:@"\n"];
    NSString *holder6 =[holder5 stringByAppendingString:instructor[indexPath.row]];
    cell.textLabel.text = holder6;
    return cell;
}


@end
