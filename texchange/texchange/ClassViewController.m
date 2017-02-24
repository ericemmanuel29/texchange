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

@synthesize classes, classid, sections, instructor, scheduledisplay;

-(void)viewDidLoad{
    [super viewDidLoad];
    //resizes table view to be used later
    CGRect scheduleframe = [[UIScreen mainScreen] bounds];
    scheduleframe.origin.y=50;
    scheduleframe.size.height=scheduleframe.size.height-100;
    UITableView *tableView = [[UITableView alloc] initWithFrame:scheduleframe style:UITableViewStylePlain];
    //tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    [self.view addSubview:tableView];
    

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
