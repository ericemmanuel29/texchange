




#import "MessagesViewController.h"
#import "ClassViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"


@import Firebase;

@interface MessagesViewController ()
- (void) getfirebase;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation MessagesViewController
@synthesize tableView;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
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
    
    CGRect titleframe = CGRectMake(10+27+25, 9, width-10-30-25-10-27-25, 56);
    UILabel *title = [[UILabel alloc] initWithFrame:titleframe];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:[NSString stringWithFormat:@"Messages"]];
    title.textAlignment = NSTextAlignmentCenter;
    
   // NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //RIN = [defaults objectForKey:@"RIN"];
    
    
    [self.view addSubview:tableView];
    [self.view addSubview:topborder];
    [self.view addSubview:backbutton];
    [self.view addSubview:title];
}

- (IBAction)back:(UIButton *)sender
{
    ClassViewController *cvc = [[ClassViewController alloc] init];
    [cvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:cvc animated:true completion:nil];
    
}


//cell height
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //rowNo = indexPath.row;
}

-(void)getfirebase{
    
    //firebase data creation
    //__block NSDictionary * allusers;
//    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
//        NSDictionary *allusers = snapshot.value;
//        
//        NSDictionary *userdata = nil;
//        NSDictionary *thisusersdata = nil;
//        
//        for(id key in allusers){
//            if([key isEqual:@"Users"]){
//                userdata=allusers[key];
//            }
//        }
//        if(userdata==nil){
//            
//        }
//        else{
//            for(id key in userdata)
//            {
//                if([key isEqual:RIN])
//                {
//                    thisusersdata = userdata[key];
//                }
//            }
//            if (thisusersdata == nil)
//            {
//                
//            }
//            else
//            {
//                for(id key in thisusersdata)
//                {
//                    if([key isEqual:@"Backpack"])
//                    {
//                        backpack = thisusersdata[key];
//                    }
//                }
//            }
//        }
//        textbooks = [NSArray arrayWithArray:[backpack allKeys]];
//        forsale = [NSArray arrayWithArray:[backpack allValues]];
//        [tableView reloadData];
//        
//    }];
//    [tableView reloadData];
//    
}


@end
