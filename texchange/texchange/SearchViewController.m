//
//  SearchViewController.m
//  texchange
//
//  Created by Eric Roque on 3/21/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "SearchViewController.h"
#import "ClassViewController.h"
#import "MaterialsViewController.h"

@interface SearchViewController ()
- (void) updatetableview;
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation SearchViewController

@synthesize classidbutton, textbooknamebutton, classidsearchbutton, tablearray, classidtf, textbooktf, pickerView, prefixes, toolBar, tableView, cameFrom;

-(void)viewDidLoad{
    [super viewDidLoad];
    tablearray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //resizes table view to be used later
    CGRect scheduleframe = [[UIScreen mainScreen] bounds];
    scheduleframe.origin.y=140;
    scheduleframe.size.height=scheduleframe.size.height-140;
    tableView = [[UITableView alloc] initWithFrame:scheduleframe style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    //red border top and bottom
    CGRect topframe = CGRectMake(0, 0, width, 100);
    CGRect line = CGRectMake((width/2) - 1, 60, 2, 40);
    UIView *lineview = [[UIView alloc] initWithFrame:line];
    lineview.backgroundColor = [UIColor whiteColor];
    UIView *topborder = [[UIView alloc] initWithFrame:topframe];
    topborder.backgroundColor = [UIColor redColor];
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame = CGRectMake(10, 25, 30, 30);
    UIImage *backimage = [UIImage imageNamed:@"backarrow.png"];
    [backbutton setBackgroundImage:backimage forState:UIControlStateNormal];
    
    CGRect line1 = CGRectMake((width/2)-1, 100, 2, 40);
    
    classidbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [classidbutton addTarget:self action:@selector(classid:) forControlEvents:UIControlEventTouchUpInside];
    classidbutton.frame = CGRectMake(0, 60, (width/2)-1, 40);
    [classidbutton setBackgroundColor:[UIColor redColor]];
    [classidbutton setTitle:@"Class ID" forState:UIControlStateNormal];
    
    classidsearchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [classidsearchbutton addTarget:self action:@selector(classidsearchbutton:) forControlEvents:UIControlEventTouchUpInside];
    classidsearchbutton.frame = CGRectMake(0, 100, (width/2)+1, 40);
    [classidsearchbutton setBackgroundColor:[UIColor whiteColor]];
    [classidsearchbutton setTitle:@"Choose Class ID" forState:UIControlStateNormal];
    [classidsearchbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [[classidsearchbutton layer] setBorderWidth:2.0f];
    [[classidsearchbutton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [classidsearchbutton.titleLabel setTextAlignment:UITextAlignmentCenter];

    
    textbooknamebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textbooknamebutton addTarget:self action:@selector(textbookname:) forControlEvents:UIControlEventTouchUpInside];
    textbooknamebutton.frame = CGRectMake((width/2)+1, 60, (width/2)-1, 40);
    [textbooknamebutton setBackgroundColor:[UIColor redColor]];
    [textbooknamebutton setTitle:@"Textbook Name" forState:UIControlStateNormal];
    
    CGRect tv_rect = CGRectMake((width/2)-1, 100, (width/2)+1, 40);
    classidtf = [[UITextField alloc]initWithFrame:tv_rect];
    [[classidtf layer] setBorderWidth:2.0f];
    [[classidtf layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [classidtf setBackgroundColor:[UIColor whiteColor]];
    classidtf.textAlignment = UITextAlignmentCenter;
    classidtf.placeholder = @"Enter Class #";
    classidtf.keyboardType = UIKeyboardTypeNumberPad;
    classidtf.textColor = [UIColor lightGrayColor];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotificationCenter *notificationCenter1 = [NSNotificationCenter defaultCenter];
    NSNotificationCenter *notificationCenter2 = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector (handle_TextFieldTextChanged:)
                               name:UITextFieldTextDidChangeNotification
                             object:self.classidtf];
    [notificationCenter1 addObserver:self
                           selector:@selector (handle_TextFieldClick:)
                               name:UITextFieldTextDidBeginEditingNotification
                             object:self.classidtf];
    [notificationCenter2 addObserver:self
                           selector:@selector (handle_TextnameTextChanged:)
                               name:UITextFieldTextDidChangeNotification
                             object:self.textbooktf];

    
    CGRect tv_rect1 = CGRectMake(0, 100, width, 40);
    textbooktf = [[UITextField alloc]initWithFrame:tv_rect1];
    [[textbooktf layer] setBorderWidth:2.0f];
    [[textbooktf layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [textbooktf setBackgroundColor:[UIColor whiteColor]];
    textbooktf.textAlignment = UITextAlignmentCenter;
    textbooktf.placeholder = @"Enter material name here";
    
    
    CGRect titleframe = CGRectMake(10+27+25, 9, width-10-30-25-10-27-25, 56);
    UILabel *title = [[UILabel alloc] initWithFrame:titleframe];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:[NSString stringWithFormat:@"Search"]];
    title.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:tableView];
    [self.view addSubview:topborder];
    [self.view addSubview:lineview];
    [self.view addSubview:classidbutton];
    [self.view addSubview:textbooknamebutton];
    [self.view addSubview:backbutton];
    [self.view addSubview:title];
    
    prefixes = @[@"ADMN", @"ARCH", @"ARTS", @"ASTR", @"BCBP", @"BIOL", @"BMED", @"CHEM", @"CIVL", @"COGS", @"COMM", @"CSCI", @"ECON", @"ECSE", @"ENGR", @"ENVE", @"EPOW", @"ERTH", @"ECSI", @"IENV", @"IHSS", @"ISCI", @"ISYE", @"ITWS", @"LANG", @"LGHT", @"LITR", @"MANE", @"MATH", @"MATP", @"MGMT", @"MTLE", @"PHIL", @"PHYS", @"PSYC", @"STSH", @"USAF", @"USAR", @"USNA", @"WRIT"];
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    pickerView = [[UIPickerView alloc] init];
    
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    [pickerView setFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height+44, screenWidth, 200.0f)];
    
    pickerView.showsSelectionIndicator = YES;
    
    [pickerView selectRow:0 inComponent:0 animated:YES];
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, screenWidth, 44)];
    toolBar.barStyle = UIStatusBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    [toolBar setItems:[NSArray arrayWithObjects:flexible, doneButton, nil]];
}

- (void) handle_TextFieldTextChanged:(id)notification {
    
    
    if([classidtf.text length]==4)
    {
        [self.view endEditing:YES];
        [self updatetableview];

    }
    
}
- (void) handle_TextnameTextChanged:(id)notification {
    
    if ([textbooktf.text length] >=1)
    {
        [self updatematerialtableview];
    }
    
}
- (void) handle_TextFieldClick:(id)notification {
    classidtf.text=@"";
    CGRect pickerpos = pickerView.frame;
    CGRect barpos = toolBar.frame;
    pickerpos.origin.y = [UIScreen mainScreen].bounds.size.height+44;
    barpos.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:.05
                     animations:^{
                         pickerView.frame = pickerpos;
                         toolBar.frame = barpos;
                     }];

    
}

-(void)updatetableview
{
    [tablearray removeAllObjects];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"TextBookInfo" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    for (int x=0;x<[listArray count];x++){
        NSArray *perclass = [listArray[x] componentsSeparatedByString:@" : "];
        NSString *pre=classidsearchbutton.currentTitle;
        NSString *pre2=classidtf.text;
        if([perclass[0] isEqual:pre] && [perclass[1] isEqual:pre2]){
            [tablearray addObject:listArray[x]];

        }
    }
    [tableView reloadData];
    

}

-(void)updatematerialtableview
{
    [tablearray removeAllObjects];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"TextBookInfoMaterials" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    for (int x=0; x<[listArray count]; x++)
    {
        NSString *noCaps = [listArray[x] lowercaseString];
        NSString *textbooktfnoCaps = [textbooktf.text lowercaseString];
        if ([noCaps containsString:textbooktfnoCaps])
        {
            NSString *formatted = listArray[x];
            [tablearray addObject:formatted];
        }
    }
    [tableView reloadData];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [prefixes count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [prefixes objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [classidsearchbutton setTitle:[prefixes objectAtIndex: row] forState:UIControlStateNormal];
    
}


- (IBAction)back:(UIButton *)sender
{
    ClassViewController *cvc = [[ClassViewController alloc] init];
    [cvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:cvc animated:true completion:nil];

}

- (IBAction)classid:(UIButton *)sender
{
    [classidbutton setBackgroundColor:[UIColor whiteColor]];
    [textbooknamebutton setBackgroundColor:[UIColor redColor]];
    [classidbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [textbooknamebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:pickerView];
    [self.view addSubview:toolBar];
    [self.view addSubview:classidsearchbutton];
    [self.view addSubview:classidtf];
    [self.textbooktf removeFromSuperview];
    
}

- (IBAction)classidsearchbutton:(UIButton *)sender
{
    [self.view endEditing:YES];

    CGRect pickerpos = pickerView.frame;
    CGRect barpos = toolBar.frame;
    pickerpos.origin.y = [UIScreen mainScreen].bounds.size.height-200.0f;
    barpos.origin.y = [UIScreen mainScreen].bounds.size.height-200.0f-44;
    [UIView animateWithDuration:.6
                     animations:^{
                         pickerView.frame = pickerpos;
                         toolBar.frame = barpos;
                     }];
}
- (IBAction)doneTouched:(UIButton *)sender
{
    CGRect pickerpos = pickerView.frame;
    CGRect barpos = toolBar.frame;
    pickerpos.origin.y = [UIScreen mainScreen].bounds.size.height+44;
    barpos.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:.6
                     animations:^{
                         pickerView.frame = pickerpos;
                         toolBar.frame = barpos;
                     }];
    [self updatetableview];

}

- (IBAction)textbookname:(UIButton *)sender
{
    [textbooknamebutton setBackgroundColor:[UIColor whiteColor]];
    [classidbutton setBackgroundColor:[UIColor redColor]];
    [classidbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [textbooknamebutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.view addSubview:textbooktf];
    [self.classidsearchbutton removeFromSuperview];
    [self.classidtf removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.toolBar removeFromSuperview];




}

//cell height
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   return [tablearray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.numberOfLines = 0;
    //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    //formats string for view
    if(classidbutton.backgroundColor == [UIColor whiteColor]){

        NSArray *final = [tablearray[indexPath.row] componentsSeparatedByString:@" : "];
        NSString *holder1 = final[0];
        NSString *holder2 =[holder1 stringByAppendingString:@" "];
        NSString *holder3 =[holder2 stringByAppendingString:final[1]];
        NSString *holder4 =[holder3 stringByAppendingString:@" - "];
        NSString *holder5 =[holder4 stringByAppendingString:final[2]];
        cell.textLabel.text = holder5;
    }
    else{
        cell.textLabel.text = tablearray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //only occurs if on left tab class id button
    if(classidbutton.backgroundColor== [UIColor whiteColor]){
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"TextBookInfo" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    NSString *materials;
    NSString *classPrefix;
    NSString *classNumber;
    for (int x=0;x<[listArray count];x++){
        NSArray *perclass = [listArray[x] componentsSeparatedByString:@" : "];
        NSString *pre=classidsearchbutton.currentTitle;
        NSString *pre2=classidtf.text;
        if([perclass[0] isEqual:pre] && [perclass[1] isEqual:pre2]){
            materials=perclass[4];
            x=[listArray count];
            classPrefix = perclass[0];
            classNumber = perclass[1];
        }
    }
    MaterialsViewController *mvc = [[MaterialsViewController alloc] init];
    mvc.material = materials;
        if([cameFrom isEqualToString:@"backpack"]){
            mvc.camefrom = @"backpack";

        }
        if([cameFrom isEqualToString:@"search"]){
            mvc.camefrom = @"search";
            
        }
    mvc.classTitle = [NSString stringWithFormat:@"%@ %@", classPrefix, classNumber];
    [mvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:mvc animated:true completion:nil];
    //doesnt search section, only takes from first class it hits
    }
}


@end
