




#import "ChatViewController.h"
#import "ClassViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
@import Firebase;

@interface ChatViewController ()
- (void) getfirebase;
-(void)goToBottom;
-(NSIndexPath *)lastIndexPath;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSArray *test;
@end

@implementation ChatViewController
@synthesize tableView, test, message, messageview, sendbutton;

-(void)viewDidLoad{
    [super viewDidLoad];
    test = @[@"ADMN", @"ARCH", @"ARTS", @"ASTR", @"BCBP", @"BIOL", @"BMED", @"CHEM", @"CIVL", @"COGS", @"COMM", @"CSCI", @"ECON", @"ECSE", @"ENGR", @"ENVE", @"EPOW", @"ERTH", @"ECSI", @"IENV", @"IHSS", @"ISCI", @"ISYE", @"ITWS", @"LANG", @"LGHT", @"LITR", @"MANE", @"MATH", @"MATP", @"MGMT", @"MTLE", @"PHIL", @"PHYS", @"PSYC", @"STSH", @"USAF", @"USAR", @"USNA", @"WRIT"];
    
    self.ref = [[FIRDatabase database] reference];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //resizes table view to be used later
    CGRect scheduleframe = [[UIScreen mainScreen] bounds];
    scheduleframe.origin.y=65;
    scheduleframe.size.height=scheduleframe.size.height-65-45;
    tableView = [[UITableView alloc] initWithFrame:scheduleframe style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [title setText:[NSString stringWithFormat:@"Messages"]];
    title.textAlignment = NSTextAlignmentCenter;
    
    // NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //RIN = [defaults objectForKey:@"RIN"];
    
    //keyboard enter area
    CGRect messageframe = CGRectMake(0, height-45, width, 45);
    messageview = [[UIView alloc] initWithFrame:messageframe];
    messageview.backgroundColor = [UIColor redColor];
    CGRect messagefield = CGRectMake(7, height-45+7, width-80, 45-7*2);
    message = [[UITextField alloc]initWithFrame:messagefield];
    message.backgroundColor = [UIColor whiteColor];
    [message.layer setCornerRadius:10.0f];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [message setLeftViewMode:UITextFieldViewModeAlways];
    [message setLeftView:spacerView];
    message.autocorrectionType = UITextAutocorrectionTypeNo;

    sendbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendbutton addTarget:self action:@selector(sendmessage:) forControlEvents:UIControlEventTouchUpInside];
    sendbutton.frame = CGRectMake(width-77, height-45+7, 80, 45-7*2);
    [sendbutton setBackgroundColor:[UIColor clearColor]];
    [sendbutton setTitle:@"Send" forState:UIControlStateNormal];
    [sendbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

    
    [self.view addSubview:tableView];
    [self.view addSubview:topborder];
    [self.view addSubview:backbutton];
    [self.view addSubview:addbutton];
    [self.view addSubview:title];
    [self.view addSubview:messageview];
    [self.view addSubview:message];
    [self.view addSubview:sendbutton];

}


- (IBAction)sendmessage:(UIButton *)sender
{
    [self.view endEditing:YES];

    
}


- (void)keyboardWillChange:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat kheight = keyboardRect.origin.y;
    CGRect holderframe = messageview.frame;
    holderframe.origin.y = kheight-45;
    messageview.frame=holderframe;
    holderframe = message.frame;
    holderframe.origin.y = messageview.frame.origin.y+7;
    message.frame=holderframe;
    holderframe = sendbutton.frame;
    holderframe.origin.y = messageview.frame.origin.y+7;
    sendbutton.frame=holderframe;
    holderframe = tableView.frame;
    holderframe.size.height =messageview.frame.origin.y-65;
    tableView.frame=holderframe;
    [self goToBottom];

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self goToBottom];
}

-(void)goToBottom
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.tableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.tableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
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
    return [test count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if(indexPath.row%2 == 0){
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = test[indexPath.row];
        cell.detailTextLabel.text = nil;
        cell.textLabel.textColor = [UIColor blackColor];
    
    }
    else{
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = nil;
    cell.detailTextLabel.text = test[indexPath.row];
        cell.detailTextLabel.textColor = [UIColor redColor];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
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
