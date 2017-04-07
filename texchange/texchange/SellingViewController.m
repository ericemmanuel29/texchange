//
//  MaterialsViewController.m
//  texchange
//
//  Created by Peter Spadalik on 3/28/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//


#import "MaterialsViewController.h"
#import "SearchViewController.h"
#import "ClassViewController.h"
#import "SellingViewController.h"
#import "BackpackViewController.h"
@import Firebase;

@interface SellingViewController ()
- (void) getfirebase;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation SellingViewController

@synthesize Mtitle, sellers, sellersRIN, tableView, camefrom, classholder, materialarray;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    sellers = [NSMutableArray array];
    sellersRIN = [NSMutableArray array];
    [self getfirebase];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //resizes table view to be used later
    CGRect scheduleframe = [[UIScreen mainScreen] bounds];
    scheduleframe.origin.y=60;
    scheduleframe.size.height=scheduleframe.size.height-60;
    
    tableView = [[UITableView alloc] initWithFrame:scheduleframe style:UITableViewStylePlain];
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
    NSString *changer = [Mtitle stringByReplacingOccurrencesOfString:@"@" withString:@"/"];
    [title setText:[NSString stringWithFormat:@"%@", changer]];
    title.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:tableView];
    [self.view addSubview:topborder];
    [self.view addSubview:backbutton];
    [self.view addSubview:title];
    
}





- (IBAction)back:(UIButton *)sender
{
    if([camefrom isEqualToString:@"classmaterials"]){
        MaterialsViewController *mvc = [[MaterialsViewController alloc] init];
        mvc.camefrom = @"class";
        mvc.classTitle = classholder;
        mvc.materialarray=materialarray;
        [mvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:mvc animated:true completion:nil];
    }
    if([camefrom isEqualToString:@"searchmaterials"]){
        MaterialsViewController *mvc = [[MaterialsViewController alloc] init];
        mvc.camefrom = @"search";
        mvc.classTitle = classholder;
        mvc.materialarray=materialarray;
        [mvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:mvc animated:true completion:nil];
    }
    if([camefrom isEqualToString:@"search"]){
        SearchViewController *svc = [[SearchViewController alloc] init];
        svc.cameFrom=@"search";
        [svc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:svc animated:true completion:nil];
    }
}


//cell height
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sellers count];
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    cell.textLabel.numberOfLines = 0;
//    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
//    //formats string for view
//    
//    //cell.textLabel.text = materialarray[indexPath.row];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = sellers[indexPath.row][0];
    cell.detailTextLabel.text = sellers[indexPath.row][1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    if([camefrom isEqualToString:@"class"]){
//        //go to people selling
//    }
//    if([camefrom isEqualToString:@"search"]){
//        //go to people selling
//        
//    }
//    if([camefrom isEqualToString:@"backpack"]){
//        //add to backpack
//        
//    }
//    //rowNo = indexPath.row;
}

-(void)getfirebase{
    
    //firebase data creation
    //__block NSDictionary * allusers;
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *allusers = snapshot.value;
        
        NSDictionary *userdata = nil;
        NSDictionary *data = nil;
        for(id key in allusers){
            if([key isEqual:@"TextSale"]){
                userdata=allusers[key];
            }
        }
        if(userdata==nil){
            
        }
        else{
            for(id key in userdata){
                if([key isEqual:Mtitle]){
                    data=userdata[key];
                }
            }
            if(data==nil){
                
            }
            else{
                for(id key in data){
                    [sellers addObject:data[key]];
                    [sellersRIN addObject:key];
                }
            }
        }
        [tableView reloadData];

    }];
    [tableView reloadData];

}


@end
