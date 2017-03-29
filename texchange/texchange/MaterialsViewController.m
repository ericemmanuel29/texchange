//
//  MaterialsViewController.m
//  texchange
//
//  Created by Peter Spadalik on 3/28/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//


#import "MaterialsViewController.h"
#import "ClassViewController.h"
#import "SearchViewController.h"
#import "SellingViewController.h"
#import "BackpackViewController.h"
@import Firebase;

@interface MaterialsViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation MaterialsViewController

@synthesize material, materialarray, camefrom, classTitle;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //resizes table view to be used later
    CGRect scheduleframe = [[UIScreen mainScreen] bounds];
    scheduleframe.origin.y=60;
    scheduleframe.size.height=scheduleframe.size.height-60;
    //materials
    materialarray = [material componentsSeparatedByString:@";"];
    //materials
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:scheduleframe style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    //red border top and bottom
    CGRect topframe = CGRectMake(0, 0, width, 60);
    UIView *topborder = [[UIView alloc] initWithFrame:topframe];
    topborder.backgroundColor = [UIColor redColor];
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame = CGRectMake(10, 25, 30, 30);
    UIImage *backimage = [UIImage imageNamed:@"backarrow.png"];
    [backbutton setBackgroundImage:backimage forState:UIControlStateNormal];
    
    CGRect titleframe = CGRectMake(10+27+25, 9, width-10-30-25-10-27-25, 56);
    UILabel *title = [[UILabel alloc] initWithFrame:titleframe];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:[NSString stringWithFormat:@"%@", classTitle]];
    title.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:tableView];
    [self.view addSubview:topborder];
    [self.view addSubview:backbutton];
    [self.view addSubview:title];

}





- (IBAction)back:(UIButton *)sender
{
    if([camefrom isEqualToString:@"class"]){
        ClassViewController *cvc = [[ClassViewController alloc] init];
        [cvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:cvc animated:true completion:nil];
    }
    if([camefrom isEqualToString:@"search"]){
        SearchViewController *svc = [[SearchViewController alloc] init];
        [svc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:svc animated:true completion:nil];
    }
    if([camefrom isEqualToString:@"backpack"]){
        BackpackViewController *bvc = [[BackpackViewController alloc] init];
        [bvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:bvc animated:true completion:nil];
    }
}


//cell height
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [materialarray count];

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

    cell.textLabel.text = materialarray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([camefrom isEqualToString:@"class"]){
        //go to people selling
        SellingViewController *svc = [[SellingViewController alloc] init];
        [svc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:svc animated:true completion:nil];
    }
    if([camefrom isEqualToString:@"search"]){
        //go to people selling

    }
    if([camefrom isEqualToString:@"backpack"]){
        //add to backpack
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Add to Backpack?" message:materialarray[indexPath.row] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //add textbook to user profile on firebse
            NSString *RIN = [[NSUserDefaults standardUserDefaults] stringForKey:@"RIN"];
            [[[[[self.ref child:@"Users"] child:RIN] child:@"Backpack"] child:materialarray[indexPath.row]] setValue:@"NO"];
             UIAlertController * alert2 = [UIAlertController alertControllerWithTitle:@"Congratulations" message:@"Material was added to your backpack" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okayButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            [alert2 addAction:okayButton];
            [self presentViewController:alert2 animated:YES completion:nil];

        }];
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        

    }
    //rowNo = indexPath.row;
}


@end
