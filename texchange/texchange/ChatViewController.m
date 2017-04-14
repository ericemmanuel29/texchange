




#import "ChatViewController.h"
#import "ClassViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "MessagesViewController.h"
@import Firebase;

@interface ChatViewController ()
- (void) getfirebase;
-(void)goToBottom;
-(NSIndexPath *)lastIndexPath;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSArray *test;
@end

@implementation ChatViewController
@synthesize tableView, test, message, messageview, sendbutton, chatinfo, sellerRIN, txtname, activityIndicator, negcheck;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    negcheck=@"NO";
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
    if([chatinfo[1] isEqual:@"BN"] || [chatinfo[1] isEqual:@"SN"]){
        topborder.backgroundColor = [UIColor orangeColor];
        negcheck=@"YES";
    }
    else{
        topborder.backgroundColor = [UIColor redColor];
        
    }
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame = CGRectMake(10, 25, 30, 30);
    UIImage *backimage = [UIImage imageNamed:@"backarrow.png"];
    [backbutton setBackgroundImage:backimage forState:UIControlStateNormal];
    UIButton *soldbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [soldbutton addTarget:self action:@selector(sold:) forControlEvents:UIControlEventTouchUpInside];
    soldbutton.frame = CGRectMake(width-40, 25, 30, 30);
    UIImage *soldimage = [UIImage imageNamed:@"negcart.png"];
    [soldbutton setBackgroundImage:soldimage forState:UIControlStateNormal];
    
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
    if([chatinfo[1] isEqual:@"BN"] || [chatinfo[1] isEqual:@"SN"]){
        messageview.backgroundColor = [UIColor orangeColor];
    }
    else{
        messageview.backgroundColor = [UIColor redColor];
    }
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
    [self.view addSubview:title];
    [self.view addSubview:messageview];
    [self.view addSubview:message];
    [self.view addSubview:sendbutton];
    if([chatinfo[1] isEqual:@"SN"]){
        [self.view addSubview:soldbutton];
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(width-80, 25, 30, 30)];
        [self.view addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
    }
    else{
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(width-40, 25, 30, 30)];
        [self.view addSubview:activityIndicator];
        [activityIndicator startAnimating];

    }
    
}


- (IBAction)sendmessage:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSString *RIN = [[NSUserDefaults standardUserDefaults] stringForKey:@"RIN"];
    NSString *name= [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    NSMutableArray *newinfo = [NSMutableArray array];
    if(![message.text isEqual:@""]){
        if([chatinfo[0] isEqual:@"NEW"]){
            [newinfo addObject:@"OLD"];
            [newinfo addObject:chatinfo[1]];
            [newinfo addObject:chatinfo[2]];
            [newinfo addObject:@[@[message.text,RIN]]];
            //buyer
            [[[[[self.ref child:@"Messages"] child:RIN] child:sellerRIN] child:txtname] setValue:newinfo];
            //seller
            if([newinfo[1] isEqual:@"BS"]){
                newinfo[1]=@"SS";
            }
            if([newinfo[1] isEqual:@"BN"]){
                newinfo[1]=@"SN";
            }
            newinfo[2]= name;
            [[[[[self.ref child:@"Messages"] child:sellerRIN] child:RIN] child:txtname] setValue:newinfo];
            [chatinfo addObject:@""];
            message.text=@"";
            
        }
        else{
            newinfo=chatinfo[3];
            [newinfo addObject:@[message.text,RIN]];
            [[[[[[self.ref child:@"Messages"] child:RIN] child:sellerRIN] child:txtname] child:@"3"] setValue:newinfo];
            [[[[[[self.ref child:@"Messages"] child:sellerRIN] child:RIN] child:txtname] child:@"3"] setValue:newinfo];
            
            message.text=@"";
            
            
        }
        
        
        
    }
    
    [self getfirebase];
    [self goToBottom];
    
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
    if(![chatinfo[0] isEqual:@"NEW"]){
        NSIndexPath *lastIndexPath = [self lastIndexPath];
        [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.tableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.tableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}

- (IBAction)back:(UIButton *)sender
{
    MessagesViewController *mvc = [[MessagesViewController alloc] init];
    [mvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:mvc animated:true completion:nil];
    
}

- (IBAction)sold:(UIButton *)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Was a price agreed on?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"Enter price agreed on" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert2 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            
        }];
        
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Asking price %@", [[alert2 textFields][0] text]);
            
            if ([[[alert2 textFields][0] text]  isEqual: @""])
            {
                UIAlertController * alert3 = [UIAlertController alertControllerWithTitle:@"Please enter a number" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    
                }];
                
                
                [alert3 addAction:yesButton];
                [self presentViewController:alert3 animated:YES completion:nil];
                
            }
            else
            {
                
                NSString *RIN = [[NSUserDefaults standardUserDefaults] stringForKey:@"RIN"];
                //change textbook in seller backpack to sold
                [[[[[self.ref child:@"Users"] child:RIN] child:@"Backpack"] child:txtname] setValue:@[@"SOLD", [[alert2 textFields][0] text]]];
                //removes textbook from textsale
                [[[[self.ref child:@"TextSale"] child:txtname] child:RIN] setValue:nil];
                //update messaging center
                [[[[[[self.ref child:@"Messages"] child:RIN] child:sellerRIN] child:txtname] child:@"1"]setValue:@"SS"];
                [[[[[[self.ref child:@"Messages"] child:sellerRIN] child:RIN] child:txtname] child:@"1"]setValue:@"BS"];
                //***********
                //still hav to remove from all other messages that are negotiating also
                //also have to deal with someone else buying and removing all negotiations
                //**************
                NSString *name= [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
                NSMutableArray *newinfo = [NSMutableArray array];
                if([chatinfo[0] isEqual:@"NEW"]){
                    [newinfo addObject:@"OLD"];
                    [newinfo addObject:@"BS"];
                    [newinfo addObject:chatinfo[2]];
                    NSString *holder1 = @"Congrats you agreed to a price of $";
                    NSString *holder2 =[holder1 stringByAppendingString:[[alert2 textFields][0] text]];
                    [newinfo addObject:@[@[holder2,@"SOLD"]]];
                    //buyer
                    [[[[[self.ref child:@"Messages"] child:RIN] child:sellerRIN] child:txtname] setValue:newinfo];
                    //seller
                    [newinfo addObject:@"SS"];
                    newinfo[2]= name;
                    [[[[[self.ref child:@"Messages"] child:sellerRIN] child:RIN] child:txtname] setValue:newinfo];
                    [chatinfo addObject:@""];
                    ChatViewController *cvc = [[ChatViewController alloc] init];
                    cvc.chatinfo = chatinfo;
                    cvc.sellerRIN = sellerRIN;
                    cvc.txtname = txtname;
                    [self presentViewController:cvc animated:false completion:nil];
                    
                }
                else{
                    newinfo=chatinfo[3];
                    NSString *holder1 = @"Congrats an agreed price was met at $";
                    NSString *holder2 =[holder1 stringByAppendingString:[[alert2 textFields][0] text]];
                    [newinfo addObject:@[holder2,@"SOLD"]];
                    [[[[[[self.ref child:@"Messages"] child:RIN] child:sellerRIN] child:txtname] child:@"3"] setValue:newinfo];
                    [[[[[[self.ref child:@"Messages"] child:RIN] child:sellerRIN] child:txtname] child:@"1"] setValue:@"SS"];
                    [[[[[[self.ref child:@"Messages"] child:sellerRIN] child:RIN] child:txtname] child:@"3"] setValue:newinfo];
                    [[[[[[self.ref child:@"Messages"] child:sellerRIN] child:RIN] child:txtname] child:@"1"] setValue:@"BS"];
                    ChatViewController *cvc = [[ChatViewController alloc] init];
                    cvc.chatinfo = chatinfo;
                    cvc.sellerRIN = sellerRIN;
                    cvc.txtname = txtname;
                    [self presentViewController:cvc animated:false completion:nil];
                }
                
                
                
            }
        }];
        [alert2 addAction:confirmAction];
        [self presentViewController:alert2 animated:YES completion:nil];
        
        
        
    }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//cell height
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([chatinfo[0] isEqual:@"NEW"]){
        return 0;
    }
    else{
        return [chatinfo[3] count];
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    //if the other persons message
    NSString *check =chatinfo[3][indexPath.row][1];
    check;
    NSString *RIN = [[NSUserDefaults standardUserDefaults] stringForKey:@"RIN"];

    if([chatinfo[3][indexPath.row][1] isEqual:@"SOLD"]){
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.text = chatinfo[3][indexPath.row][0];
        cell.detailTextLabel.textColor = [UIColor greenColor];
        if(([chatinfo[1] isEqual:@"BS"] || [chatinfo[1] isEqual:@"SS"]) && [negcheck isEqual:@"YES"]){
             ChatViewController *cvc = [[ChatViewController alloc] init];
             cvc.chatinfo = chatinfo;
             cvc.sellerRIN = sellerRIN;
             cvc.txtname = txtname;
             [self presentViewController:cvc animated:false completion:nil];
         }


    }
    else if(![chatinfo[3][indexPath.row][1] isEqual:RIN]){
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = chatinfo[3][indexPath.row][0];
        cell.detailTextLabel.text = nil;
        cell.textLabel.textColor = [UIColor blackColor];
        
    }
    else{
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = chatinfo[3][indexPath.row][0];
        if([chatinfo[1] isEqual:@"BN"] || [chatinfo[1] isEqual:@"SN"]){
            
            cell.detailTextLabel.textColor = [UIColor orangeColor];
        }
        else{
            cell.detailTextLabel.textColor = [UIColor redColor];
            
        }
        
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
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *allusers = snapshot.value;
        NSString *RIN = [[NSUserDefaults standardUserDefaults] stringForKey:@"RIN"];
        NSDictionary *userdata = nil;
        NSDictionary *thisusersdata = nil;
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
                    for(id key1 in thisusersdata[key]){
                        if([key1 isEqual:txtname]){
                            
                            if(![thisusersdata[key][key1][0] isEqual:@"NEW"]){
                                chatinfo=thisusersdata[key][key1];
                                chatinfo;
                            }
                            
                        }
                    }
                }
            }
        }
        
        [tableView reloadData];
        [activityIndicator stopAnimating];

    }];
    [tableView reloadData];
    

}

@end
