//
//  BackpackViewController.m
//  texchange
//
//  Created by Peter Spadalik on 3/3/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "BackpackViewController.h"
#import "ClassViewController.h"
#import "SearchViewController.h"


@interface BackpackViewController ()
@end

@implementation BackpackViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //resizes table view to be used later
    CGRect scheduleframe = [[UIScreen mainScreen] bounds];
    scheduleframe.origin.y=65;
    scheduleframe.size.height=scheduleframe.size.height-65;
    UITableView *tableView = [[UITableView alloc] initWithFrame:scheduleframe style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    //red border top and bottom
    CGRect topframe = CGRectMake(0, 0, width, 65);
    UIView *topborder = [[UIView alloc] initWithFrame:topframe];
    topborder.backgroundColor = [UIColor redColor];
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame = CGRectMake(10, 25, 30, 30);
    UIImage *backimage = [UIImage imageNamed:@"backarrow.png"];
    [backbutton setBackgroundImage:backimage forState:UIControlStateNormal];
    UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addbutton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    addbutton.frame = CGRectMake(width-40, 25, 30, 30);
    UIImage *addimage = [UIImage imageNamed:@"plus.png"];
    [addbutton setBackgroundImage:addimage forState:UIControlStateNormal];

    CGRect titleframe = CGRectMake(10+27+25, 9, width-10-30-25-10-27-25, 56);
    UILabel *title = [[UILabel alloc] initWithFrame:titleframe];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:[NSString stringWithFormat:@"My Textbooks"]];
    title.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:tableView];
    [self.view addSubview:topborder];
    [self.view addSubview:backbutton];
    [self.view addSubview:addbutton];
    [self.view addSubview:title];
}

- (IBAction)back:(UIButton *)sender
{
    ClassViewController *cvc = [[ClassViewController alloc] init];
    [cvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:cvc animated:true completion:nil];

}

- (IBAction)add:(UIButton *)sender
{
    SearchViewController *svc = [[SearchViewController alloc] init];
    svc.cameFrom = @"backpack";
    [svc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:svc animated:true completion:nil];  
    
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
    return 0;//[classes count];
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
//    NSString *holder1 = [classes[indexPath.row] stringByAppendingString:@"\n"];
//    NSString *holder2 =[holder1 stringByAppendingString:classid[indexPath.row]];
//    NSString *holder3 =[holder2 stringByAppendingString:@" - "];
//    NSString *holder4 =[holder3 stringByAppendingString:sections[indexPath.row]];
//    NSString *holder5 =[holder4 stringByAppendingString:@"\n"];
//    NSString *holder6 =[holder5 stringByAppendingString:instructor[indexPath.row]];
//    cell.textLabel.text = holder6;
    return cell;
}


@end
