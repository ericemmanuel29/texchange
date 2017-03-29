//
//  ClassViewController.m
//  texchange
//
//  Created by Peter Spadalik on 2/10/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "ClassViewController.h"
#import "MaterialsViewController.h"
#import "BackpackViewController.h"
#import "SearchViewController.h"
@import Firebase;

@interface ClassViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation ClassViewController

@synthesize classes, classid, sections, instructor, name, scheduledisplay, registration;

-(void)viewDidLoad{
    [super viewDidLoad];
    //recover user data
    NSString *RIN = [[NSUserDefaults standardUserDefaults] stringForKey:@"RIN"];
    classes = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"classes"] mutableCopy];
    name = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    classid = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"classid"] mutableCopy];
    sections = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"sections"] mutableCopy];
    instructor = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"instructor"] mutableCopy];
    registration = [[NSUserDefaults standardUserDefaults] stringForKey:@"registration"];


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
    displayname.textAlignment = NSTextAlignmentCenter;
    CGFloat spacing = (width-(40*4)-4)/5;
    CGRect historyframe = CGRectMake(spacing-2, height-65+12, 44, 40);
    CGRect searchframe = CGRectMake(spacing*2+44, height-65+12, 40, 40);
    CGRect packageframe = CGRectMake(spacing*3+40*2+4, height-65+12, 40, 40);
    CGRect messageframe = CGRectMake(spacing*4+40*3+4, height-65+12, 40, 40);
    UIButton *historybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *packagebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *messagebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [historybutton addTarget:self action:@selector(history:) forControlEvents:UIControlEventTouchUpInside];
    [searchbutton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [packagebutton addTarget:self action:@selector(package:) forControlEvents:UIControlEventTouchUpInside];
    [messagebutton addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
    historybutton.frame = historyframe;
    searchbutton.frame = searchframe;
    packagebutton.frame = packageframe;
    messagebutton.frame = messageframe;
    UIImage *historyimage = [UIImage imageNamed:@"history.png"];
    UIImage *searchimage = [UIImage imageNamed:@"search.png"];
    UIImage *packageimage = [UIImage imageNamed:@"package.png"];
    UIImage *messageimage = [UIImage imageNamed:@"messages.png"];
    [historybutton setBackgroundImage:historyimage forState:UIControlStateNormal];
    [searchbutton setBackgroundImage:searchimage forState:UIControlStateNormal];
    [packagebutton setBackgroundImage:packageimage forState:UIControlStateNormal];
    [messagebutton setBackgroundImage:messageimage forState:UIControlStateNormal];


    [self.view addSubview:tableView];
    [self.view addSubview:bottomborder];
    [self.view addSubview:topborder];
    [self.view addSubview:backpackbutton];
    [self.view addSubview:logoutbutton];
    [self.view addSubview:displayname];
    [self.view addSubview:historybutton];
    [self.view addSubview:searchbutton];
    [self.view addSubview:packagebutton];
    [self.view addSubview:messagebutton];
    
    if([classes count]==0){
        UILabel *regi = [[UILabel alloc] initWithFrame:scheduleframe];
        [regi setTextColor:[UIColor blackColor]];
        [regi setBackgroundColor:[UIColor whiteColor]];
        regi.lineBreakMode = NSLineBreakByWordWrapping;
        regi.numberOfLines = 0;
        [regi setText:[NSString stringWithFormat:@"You are not registered\nfor any classes in\n%@", registration]];
        regi.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:regi];
    }


    

}

- (IBAction)backpack:(UIButton *)sender
{
    BackpackViewController *bvc = [[BackpackViewController alloc] init];
    [bvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:bvc animated:true completion:nil];
    
}

- (IBAction)logout:(UIButton *)sender
{
    
}
- (IBAction)history:(UIButton *)sender
{
    
}
- (IBAction)search:(UIButton *)sender
{
    SearchViewController *svc = [[SearchViewController alloc] init];
    svc.cameFrom = @"search";
    [svc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:svc animated:true completion:nil];
    
}
- (IBAction)package:(UIButton *)sender
{
    
}
- (IBAction)message:(UIButton *)sender
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"TextBookInfo" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    NSArray *classSplit = [classid[indexPath.row] componentsSeparatedByString:@" "];
    NSString *materials;
    NSString *cid;
    NSString *cnum;
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    for (int x=0;x<[listArray count];x++){
        NSArray *perclass = [listArray[x] componentsSeparatedByString:@" : "];
        if([perclass[0] isEqual:classSplit[0]] && [perclass[1] isEqual:classSplit[1]]){
            materials=perclass[4];
            cid=perclass[0];
            cnum=perclass[1];
            x=[listArray count];
        }
    }
    MaterialsViewController *mvc = [[MaterialsViewController alloc] init];
    mvc.material = materials;
    mvc.camefrom = @"class";
    NSString *holder1 = cid;
    NSString *holder2 =[holder1 stringByAppendingString:@" "];
    NSString *holder3 =[holder2 stringByAppendingString:cnum];
    mvc.classTitle = holder3;
    [mvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:mvc animated:true completion:nil];
    
}

@end
