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
#import "LoginViewController.h"
@import Firebase;

@interface BackpackViewController ()
- (void) getfirebase;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation BackpackViewController
@synthesize tableView, backpack, textbooks, forsale, RIN, askingpricetf;

-(void)viewDidLoad{
    [super viewDidLoad];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //resizes table view to be used later
    CGRect scheduleframe = [[UIScreen mainScreen] bounds];
    scheduleframe.origin.y=65;
    scheduleframe.size.height=scheduleframe.size.height-65;
    tableView = [[UITableView alloc] initWithFrame:scheduleframe style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    [self getfirebase];
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
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    RIN = [defaults objectForKey:@"RIN"];

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
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [backpack count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSString *changer = [textbooks[indexPath.row] stringByReplacingOccurrencesOfString:@"@" withString:@"/"];
    cell.textLabel.text = changer;
    if([forsale[indexPath.row]  isEqual: @"NO"])
    {
        cell.contentView.superview.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.contentView.superview.backgroundColor = [UIColor redColor];
        cell.detailTextLabel.text = @"For sale";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Put this textbook up for sale?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"Enter an asking price" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert2 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"";
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Asking price %@", [[alert2 textFields][0] text]);
            //compare the current password and do action here
            
        }];
        
        
        [alert2 addAction:confirmAction];
        [self presentViewController:alert2 animated:YES completion:nil];
        
    }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
    
    //rowNo = indexPath.row;
}

-(void)getfirebase{
    
    //firebase data creation
    //__block NSDictionary * allusers;
    self.ref = [[FIRDatabase database] reference];
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *allusers = snapshot.value;
        
        NSDictionary *userdata = nil;
        NSDictionary *thisusersdata = nil;
        
        for(id key in allusers){
            if([key isEqual:@"Users"]){
                userdata=allusers[key];
            }
        }
        if(userdata==nil){
            
        }
        else{
            for(id key in userdata)
            {
                if([key isEqual:RIN])
                {
                    thisusersdata = userdata[key];
                }
            }
            if (thisusersdata == nil)
            {
                
            }
            else
            {
                for(id key in thisusersdata)
                {
                    if([key isEqual:@"Backpack"])
                    {
                        backpack = thisusersdata[key];
                    }
                }
            }
        }
        textbooks = [NSArray arrayWithArray:[backpack allKeys]];
        forsale = [NSArray arrayWithArray:[backpack allValues]];
        [tableView reloadData];
        
    }];
    [tableView reloadData];
    
}


@end
