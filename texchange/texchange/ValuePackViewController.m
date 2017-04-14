//
//  ValuePackViewController.m
//  texchange
//
//  Created by Eric Roque on 4/12/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "ValuePackViewController.h"
#import "MaterialsViewController.h"
#import "ClassViewController.h"
#import "SearchViewController.h"
#import "SellingViewController.h"
#import "BackpackViewController.h"
#import "MessagesViewController.h"

@import Firebase;

@interface ValuePackViewController ()
- (void) getfirebase;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation ValuePackViewController

@synthesize material, materialarray, camefrom, classTitle, tableView, classMaterials, classid, classes, classMaterialsFinal, activityIndicator;


-(void)viewDidLoad{
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    classes = [NSMutableArray array];
    classid = [NSMutableArray array];
    classMaterials = [NSMutableDictionary dictionary];
    classMaterialsFinal = [NSMutableDictionary dictionary];
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
    UIImage *addimage = [UIImage imageNamed:@"cart.png"];
    [addbutton setBackgroundImage:addimage forState:UIControlStateNormal];

    
    CGRect titleframe = CGRectMake(10+27+25, 9, width-10-30-25-10-27-25, 56);
    UILabel *title = [[UILabel alloc] initWithFrame:titleframe];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:[NSString stringWithFormat:@"Buy all your textbooks here!"]];
    title.textAlignment = NSTextAlignmentCenter;
    [self getfirebase];

    
    //read file
    classid = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"classid"] mutableCopy];
    classes = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"classes"] mutableCopy];
    
    for (int y=0;y<[classid count];y++){
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"TextBookInfo" ofType:@"txt"];
        NSError *error;
        NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
        if (error){
            NSLog(@"Error reading file: %@", error.localizedDescription);
        }
        NSArray *classSplit = [classid[y] componentsSeparatedByString:@" "];
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
        
        //     classes[y] :title in string
        //     materials : material for that class in array
        if(materials == nil || [materials  isEqual: @"NTB"]){
            materials=@"There are no textbooks for this course.";
        }
        else
        {
            materials = [materials stringByReplacingOccurrencesOfString:@"/" withString:@"@"];
        }
        [classMaterials setObject:[materials componentsSeparatedByString:@";"] forKey:classes[y]];
        
    }

  

    
    [self.view addSubview:topborder];
    [self.view addSubview:backbutton];
    [self.view addSubview:addbutton];
    [self.view addSubview:title];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(width-80, 25, 30, 30)];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
}


- (IBAction)add:(UIButton *)sender
{
    int boo = 0;
    for (id key in classMaterialsFinal)
    {
        if([[classMaterialsFinal objectForKey:key] count]==3)
        {
            boo += [classMaterialsFinal[key][2] integerValue];
        }
    }
    
    NSString *messageString = [NSString stringWithFormat:@"Package your textbooks for $%d?", boo];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:messageString message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        for (id key in classMaterialsFinal)
        {
            if([[classMaterialsFinal objectForKey:key] count]==3)
            {
                /*
                NSLog(@"I'm like ... %@", key); // book title
                NSLog(@"Hey ... %@", classMaterialsFinal[key][0]); // RIN
                NSLog(@"Whatsup ... %@", classMaterialsFinal[key][1]); // Name
                NSLog(@"Hello ... %@", classMaterialsFinal[key][2]); //price
                */
                
                //changing sellers backpack
                [[[[[self.ref child:@"Users"] child:classMaterialsFinal[key][0]] child:@"Backpack"] child:key] setValue:@[@"SOLD",classMaterialsFinal[key][2]]];
                [[[[self.ref child:@"TextSale"] child:key] child:classMaterialsFinal[key][0]] setValue:nil];
                //add to messages
                NSString *RIN = [[NSUserDefaults standardUserDefaults] stringForKey:@"RIN"];
                NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
                //buyer
                //bs = buyer sold
                [[[[[self.ref child:@"Messages"] child:RIN] child:classMaterialsFinal[key][0]] child:key] setValue:@[@"NEW",@"BS",classMaterialsFinal[key][1]]];
                //seller
                //ss = seller sold
                [[[[[self.ref child:@"Messages"] child:classMaterialsFinal[key][0]] child:RIN] child:key] setValue:@[@"NEW",@"SS", name]];
                
                UIAlertController * alert2 = [UIAlertController alertControllerWithTitle:@"Congratulations" message:@"You have made a purchase! Head over to your Messages so you can figure out where to meet up and how to pay" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okayButton = [UIAlertAction actionWithTitle:@"Go There Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    MessagesViewController *mvc = [[MessagesViewController alloc] init];
                    [mvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [self presentViewController:mvc animated:true completion:nil];
                    
                }];
                [alert2 addAction:okayButton];
                [self presentViewController:alert2 animated:YES completion:nil];
            }
            
        }

    }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];

    
}


- (IBAction)back:(UIButton *)sender
{
    
    ClassViewController *cvc = [[ClassViewController alloc] init];
    [cvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:cvc animated:true completion:nil];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [classes count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [classes objectAtIndex:section];
}

//cell height
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [classes objectAtIndex:section];
    NSArray *sectionAnimals = [classMaterials objectForKey:sectionTitle];
    return [sectionAnimals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    //if the other persons message

    NSString *sectionTitle = [classes objectAtIndex:indexPath.section];
    NSArray *sectionAnimals = [classMaterials objectForKey:sectionTitle];
    NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
    NSArray *p1 = [classMaterialsFinal objectForKey:animal];
    if([p1 count]==1){
        if([animal isEqual:@"There are no textbooks for this course."]){
            cell.textLabel.text = @"There are no textbooks for this course.";

        }
        else{
            cell.textLabel.text = p1[0];
        }
    }
    else{
        NSString *changer = [animal stringByReplacingOccurrencesOfString:@"@" withString:@"/"];
        long len = [changer length];
        if(len>33){
            len=33;
            changer = [[changer substringToIndex:len] stringByAppendingString:@"..."];
        }
        cell.textLabel.text = changer;
        //cell.textLabel.text = animal;
    }
    if([p1 count]==3){
        cell.detailTextLabel.text = p1[2];
      }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)getfirebase{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
    

        NSDictionary *alldata = snapshot.value;
        
        NSDictionary *textsale = nil;
        
        for(id key in alldata){
            if([key isEqual:@"TextSale"]){
                textsale=alldata[key];
            }
        }
        if(textsale==nil){
            
        }
        else
        {
            for (id key in classMaterials)
            {
                NSString *comparator1 = classMaterials[key][0];
                for (id key1 in textsale)
                {
                    //key1 is texts for sale
                    NSString *comparator2 = key1;
                    //comparator 1 is classes with all possible materials
                    if([comparator1 isEqual:comparator2])
                    {
                        NSDictionary *sellersinfo = nil;
                        sellersinfo = textsale[key1];
                        NSUInteger low = 1000;
                        for(id rin in sellersinfo)
                        {
                            if([sellersinfo[rin][1] integerValue]<low)
                            {
                                low = [sellersinfo[rin][1] integerValue];
                            }
                        }

                        for(id rin in sellersinfo)
                        {
                            
                            //fix if 2 people have text for sale
                            if([sellersinfo[rin][1] integerValue] == low)
                            {
                                NSArray *shoppingList = @[rin, sellersinfo[rin][0], sellersinfo[rin][1]];
                                [classMaterialsFinal setObject:shoppingList forKey:comparator1];
                            }
                            

                        }
                    }
                    else
                    {
                        if([[classMaterialsFinal objectForKey:comparator1] count]==3){
                        
                    }
                        else{
                        NSArray *shoppingList = @[@"No one is selling this textbook."];
                        [classMaterialsFinal setObject:shoppingList forKey:comparator1];
                        }
                    }
                }
            }
        }
        [activityIndicator stopAnimating];
        [tableView reloadData];
        
    }];
    [tableView reloadData];
    [self.view addSubview:tableView];

    
}


@end
