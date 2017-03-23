//
//  SearchViewController.m
//  texchange
//
//  Created by Eric Roque on 3/21/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "SearchViewController.h"
#import "ClassViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize classidbutton, textbooknamebutton, classidsearchbutton, line1view, classidtf, textbooktf, pickerView, dataArray;

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
    
    CGRect line1 = CGRectMake((width/2) - 1, 100, 2, 40);
    line1view = [[UIView alloc] initWithFrame:line1];
    line1view.backgroundColor = [UIColor grayColor];
    
    classidbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [classidbutton addTarget:self action:@selector(classid:) forControlEvents:UIControlEventTouchUpInside];
    classidbutton.frame = CGRectMake(0, 60, (width/2)-1, 40);
    [classidbutton setBackgroundColor:[UIColor redColor]];
    [classidbutton setTitle:@"Class ID" forState:UIControlStateNormal];
    
    classidsearchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [classidsearchbutton addTarget:self action:@selector(classidsearchbutton:) forControlEvents:UIControlEventTouchUpInside];
    classidsearchbutton.frame = CGRectMake(0, 100, (width/2)-1, 40);
    [classidsearchbutton setBackgroundColor:[UIColor redColor]];
    [classidsearchbutton setTitle:@"Choose your Class ID" forState:UIControlStateNormal];

    textbooknamebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textbooknamebutton addTarget:self action:@selector(textbookname:) forControlEvents:UIControlEventTouchUpInside];
    textbooknamebutton.frame = CGRectMake((width/2)+1, 60, (width/2)-1, 40);
    [textbooknamebutton setBackgroundColor:[UIColor redColor]];
    [textbooknamebutton setTitle:@"Textbook Name" forState:UIControlStateNormal];
    
    CGRect tv_rect = CGRectMake((width/2)+10, 100, (width/2)+1, 40);
    classidtf = [[UITextField alloc]initWithFrame:tv_rect];
    
    CGRect tv_rect1 = CGRectMake(13, 100, (width/2)+1, 40);
    textbooktf = [[UITextField alloc]initWithFrame:tv_rect1];
    
    
    
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
    
    dataArray = [[NSMutableArray alloc] init];
    
    [dataArray addObject:@"One"];
    [dataArray addObject:@"Two"];
    [dataArray addObject:@"Three"];
    [dataArray addObject:@"Four"];
    [dataArray addObject:@"Five"];
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float pickerWidth = screenWidth * 3 / 4;
    
    float xPoint = screenWidth / 2 - pickerWidth / 2;
    
    pickerView = [[UIPickerView alloc] init];
    
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    
    [pickerView setFrame: CGRectMake(xPoint, 290, pickerWidth, 200.0f)];
    
    pickerView.showsSelectionIndicator = YES;
    
    [pickerView selectRow:2 inComponent:0 animated:YES];
    

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [dataArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [dataArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this: %@", [dataArray objectAtIndex: row]);
    [classidsearchbutton setTitle:[dataArray objectAtIndex: row] forState:UIControlStateNormal];
    
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
    
    [self.view addSubview:line1view];
    [self.view addSubview:classidsearchbutton];
    [self.view addSubview:classidtf];
    [self.textbooktf removeFromSuperview];
    
}

- (IBAction)classidsearchbutton:(UIButton *)sender
{
    [self.view addSubview: pickerView];
}

- (IBAction)textbookname:(UIButton *)sender
{
    [textbooknamebutton setBackgroundColor:[UIColor whiteColor]];
    [classidbutton setBackgroundColor:[UIColor redColor]];
    [classidbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [textbooknamebutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.view addSubview:textbooktf];
    [self.line1view removeFromSuperview];
    [self.classidsearchbutton removeFromSuperview];
    [self.classidtf removeFromSuperview];
    [self.pickerView removeFromSuperview];


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
