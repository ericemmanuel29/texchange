




#import "MessagesViewController.h"
#import "ClassViewController.h"
#import "ChatViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"


@import Firebase;

@interface MessagesViewController ()
- (void) getfirebase;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation MessagesViewController
@synthesize tableView, MUsers, MUserstexts, tablearray, userarrays;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    MUsers = [NSMutableArray array];
    MUserstexts = [NSMutableArray array];
    tablearray = [NSMutableArray array];
    userarrays = [NSMutableArray array];
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
    return [tablearray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if([tablearray[indexPath.row][2] isEqual:@"BS"] || [tablearray[indexPath.row][2] isEqual:@"BN"]){
    cell.textLabel.text = tablearray[indexPath.row][0];
    cell.detailTextLabel.text = tablearray[indexPath.row][1];
    }
    else{
        cell.textLabel.text = tablearray[indexPath.row][1];
        cell.detailTextLabel.text = tablearray[indexPath.row][0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *cvc = [[ChatViewController alloc] init];
    cvc.chatinfo = userarrays[indexPath.row];
    cvc.sellerRIN = MUsers[indexPath.row];
    cvc.txtname = tablearray[indexPath.row][1];
    
    [cvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:cvc animated:true completion:nil];

    //rowNo = indexPath.row;
}

-(void)getfirebase{
    
    //firebase data creation
    //__block NSDictionary * allusers;
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *allusers = snapshot.value;
        NSString *RIN = [[NSUserDefaults standardUserDefaults] stringForKey:@"RIN"];
        NSDictionary *userdata = nil;
        NSDictionary *thisusersdata = nil;
        NSMutableArray *finalarray = nil;
        for(id key in allusers){
            if([key isEqual:@"Messages"]){
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
                    [MUsers addObject:key];
                    [MUserstexts addObject:thisusersdata[key]];
                }
            }
        }
        
        
        for(int x=0;x<[MUsers count];x++){
            for(id key in MUserstexts[x]){
                //tablearray format [name, textbook, type of transaction]
                [tablearray addObject:@[MUserstexts[x][key][2],key,MUserstexts[x][key][1]]];
                [userarrays addObject:MUserstexts[x][key]];

            }
        }
        [tableView reloadData];
        
    }];
    [tableView reloadData];
    
}

@end
