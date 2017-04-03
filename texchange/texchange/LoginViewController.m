//
//  ViewController.m
//  texchange
//
//  Created by Peter Spadalik on 2/3/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "LoginViewController.h"
#import "ClassViewController.h"
@import Firebase;

@interface LoginViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation LoginViewController



-(void)viewDidLoad{
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [UIColor redColor];
    username = [[UITextField alloc] initWithFrame:CGRectMake((width-250)/2,(height/2)-(35/2)-60 ,250, 35)];
    username.borderStyle =UITextBorderStyleNone;
    username.placeholder = @"RIN";
    username.keyboardType = UIKeyboardTypeNumberPad;
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    username.textAlignment = UITextAlignmentCenter;
    username.background=[UIImage imageNamed:@"textfield.png"];
    password = [[UITextField alloc] initWithFrame:CGRectMake((width-250)/2,(height/2)-(35/2),250, 35)];
    password.borderStyle =UITextBorderStyleNone;
    password.placeholder = @"Password";
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.textAlignment = UITextAlignmentCenter;
    password.background=[UIImage imageNamed:@"textfield.png"];
    password.secureTextEntry = YES;
    loginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginbutton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginbutton.frame = CGRectMake((width-250)/2,(height/2)-(35/2)+60, 250, 35);
    UIImage *loginimage = [UIImage imageNamed:@"loginbutton.png"];
    [loginbutton setBackgroundImage:loginimage forState:UIControlStateNormal];
    [self.view addSubview:username];
    [self.view addSubview:password];
    [self.view addSubview:loginbutton];


}

- (void)keyboardWillChange:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat kheight = keyboardRect.origin.y;
    CGRect holderframe = username.frame;
    holderframe.origin.y = (kheight/2)-(35/2)-60;
    username.frame=holderframe;
    holderframe = password.frame;
    holderframe.origin.y = (kheight/2)-(35/2);
    password.frame=holderframe;
    holderframe = username.frame;
    holderframe.origin.y = (kheight/2)-(35/2)+60;
    loginbutton.frame=holderframe;

}

- (IBAction)login:(UIButton *)sender
{
    [self.view endEditing:YES];
    if([username.text isEqual:@""] && [password.text isEqual:@""]){
        UIAlertController * noinputalert = [UIAlertController alertControllerWithTitle:@"Authorization Failure" message:@"No User ID or PIN Entered" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [noinputalert addAction:okay];
        [self presentViewController:noinputalert animated:YES completion:nil];
    }
    else{
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((width/2)-15, 80, 30, 30)];
        [self.view addSubview:activityIndicator];
        [activityIndicator startAnimating];
        UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
        webview.delegate = self;
        //load sis login webpage
        NSString *url=@"https://sis.rpi.edu/rss/twbkwbis.P_WWWLogin";
        NSURL *nsurl=[NSURL URLWithString:url];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [webview loadRequest:nsrequest];
        [self.view addSubview:webview];
    }

}
//check to make sure if statements only run once
int ifcheck=-1;

//runs every time new load request finishes
-(void)webViewDidFinishLoad:(UIWebView *)webview {
    //page determination
    //current page determination
    NSString *page1 = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('submenulinktext2')[4].innerHTML"] ;
    NSString *page2 = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('mpdefault')[17].innerText"] ;
    NSString *page3 = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('plaintable')[3].innerText"] ;
    NSString *page4 = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pldefault')[3].innerText"] ;
    //check to see if username and password was wrong
    NSString *ec = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pldefault').length"] ;
    int errorcheck = [ec intValue];
    //cuts a string to verify, if statement prevents error of cutting a string too short
    if (page3.length>=36){
        page3 = [page3 substringWithRange:NSMakeRange(0, 35)];
    }
    if (page4.length>=24){
        page4 = [page4 substringWithRange:NSMakeRange(0, 23)];
    }
    //print statement for NSString
    //NSLog(@"result=\"%@\"", page4) ;
    //
    //command for each webpage
    if([page1 isEqual:@"Student Menu"] && ifcheck!=0){
        ifcheck=0;
        NSString *namecommand = @"document.getElementsByClassName('pldefault')[7].innerText";
        NSString *holder = [webview stringByEvaluatingJavaScriptFromString:namecommand];
        NSArray *holder2 = [holder componentsSeparatedByString:@", "];
        name=holder2[1];
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('submenulinktext2')[4].click()"];
    }
    else if(([page2 isEqual:@"   View Weekly Schedule"] || [page2 isEqual:@"   View Weekly Schedule Day/Time Grid"]) && ifcheck!=1){
        ifcheck=1;
        NSString *namecommand = @"document.getElementsByClassName('submenulinktext2').length";
        NSString *cn = [webview stringByEvaluatingJavaScriptFromString:namecommand];
        int arraynum = [cn intValue];
        for (int x=25;x<arraynum; x++){
            NSString *firstpart = @"document.getElementsByClassName('submenulinktext2')[";
            NSString *secondpart = @"].outerText";
            NSString *strtoint = [NSString stringWithFormat:@"%d",x];
            NSString *fullcommand = [NSString stringWithFormat:@"%@%@%@", firstpart, strtoint, secondpart];
            NSString *text = [webview stringByEvaluatingJavaScriptFromString:fullcommand];
            if([text isEqualToString:@"View Weekly Schedule"]){
                NSString *fp = @"document.getElementsByClassName('submenulinktext2')[";
                NSString *sp = @"].click()";
                NSString *sti = [NSString stringWithFormat:@"%d",x];
                NSString *fc = [NSString stringWithFormat:@"%@%@%@", fp, sti, sp];
                [webview stringByEvaluatingJavaScriptFromString:fc];
                x=arraynum;
            }

        }
        

    }
    else if([page3 isEqual:@"Select a Semester or Summer Session"] && ifcheck!=2){
        ifcheck=2;
        //steps one semester back due to the summer 2017 registration
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('term_in')[0].selectedIndex = '2'"];
        //should be removed for final product^^^^^^^
        registration = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('term_in')[0][0].innerText"] ;
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagebodydiv')[0].childNodes[3][1].click()"];
    }
    //handles gathering information when on the students schedule
    else if([page4 isEqual:@"Weekly Student Schedule"] && ifcheck!=3){
        ifcheck=3;
        NSString *cn = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('datadisplaytable').length"] ;
        int classnum = [cn intValue];
        //runs through each class you have and puts info in classinfo and instructor
        NSMutableArray *classinfo = [NSMutableArray array];
        NSMutableArray *instructors = [NSMutableArray array];
        for(int x=0; x<classnum; x=x+2){
            NSString *firstpart = @"document.getElementsByClassName('datadisplaytable')[";
            NSString *secondpart = @"].innerText";
            NSString *strtoint = [NSString stringWithFormat:@"%d",x];
            NSString *fullcommand = [NSString stringWithFormat:@"%@%@%@", firstpart, strtoint, secondpart];
            NSString *class = [webview stringByEvaluatingJavaScriptFromString:fullcommand];
            NSArray *classholder = [class componentsSeparatedByString:@"\n"];
            NSArray *instructorholder = [classholder[4] componentsSeparatedByString:@"\t"];
            NSArray *classholder2 =[classholder[0] componentsSeparatedByString:@" - "];
            NSArray *instructorholder2 = [instructorholder[1] componentsSeparatedByString:@" "];
            //all info is now in somewhat of an organized order in these two data structures
            [classinfo addObject:classholder2];
            [instructors addObject:instructorholder2];
        }
        //removes middle names of instructors because everyone doesnr have a middle name and this simplifies it
        for(int x=0; x<[instructors count];x++){
            for(int y=0; y<[instructors[x] count];y++){
                NSString *holder = instructors[x][y];
                if ([holder containsString:@"."]) {
                    [instructors[x] removeObjectAtIndex:y];
                    y=y-1;
                }

            }
        }
        //creates data structures to be passed to the view controller
        NSMutableArray *classes = [NSMutableArray array];
        NSMutableArray *classid = [NSMutableArray array];
        NSMutableArray *sections = [NSMutableArray array];
        NSMutableArray *instructor = [NSMutableArray array];
        for(int x=0; x<[classinfo count]; x++){
            int classcounter = [classinfo[x] count];
            int instructorcounter = [instructors[x] count];
            //some classes are 4 long . ie rcos-texchange-classid-section, fixes repeats
            [classes addObject:classinfo[x][classcounter-3]];
            [classid addObject:classinfo[x][classcounter-2]];
            [sections addObject:classinfo[x][classcounter-1]];
            //accounts for multiple instructors, up to 3
            if (instructorcounter==0){
                [instructor addObject:@""];
            }
            else if(instructorcounter/2==1){
                [instructor addObject:instructors[x][1]];

            }
            else if(instructorcounter/2==2){
                NSString *removecomma = [instructors[x][1] substringToIndex:[instructors[x][1] length]-1];
                NSString *holder1 = [removecomma stringByAppendingString:@" - "];
                NSString *holder2 =[holder1 stringByAppendingString:instructors[x][3]];
                [instructor addObject:holder2];
                
            }
            else{
                NSString *removecomma = [instructors[x][1] substringToIndex:[instructors[x][1] length]-1];
                NSString *removecomma2 = [instructors[x][3] substringToIndex:[instructors[x][3] length]-1];
                NSString *holder1 = [removecomma stringByAppendingString:@" - "];
                NSString *holder2 =[holder1 stringByAppendingString:removecomma2];
                NSString *holder3 =[holder2 stringByAppendingString:@" - "];
                NSString *holder4 =[holder3 stringByAppendingString:instructors[x][5]];
                [instructor addObject:holder4];
                
            }
        
        }
        [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:@"RIN"];
        [[NSUserDefaults standardUserDefaults] setObject:classes forKey:@"classes"];
        [[NSUserDefaults standardUserDefaults] setObject:classid forKey:@"classid"];
        [[NSUserDefaults standardUserDefaults] setObject:sections forKey:@"sections"];
        [[NSUserDefaults standardUserDefaults] setObject:instructor forKey:@"instructor"];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] setObject:registration forKey:@"registration"];


        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //stops animating the loader, moves all information to the next viewcontroller and segues

        //stops animating the loader, moves all information to the next viewcontroller and segues
        [activityIndicator stopAnimating];
        
        //send info to firebase for storage
        [[[[self.ref child:@"Users"] child:username.text] child:@"name"] setValue:name];
        //got the information, move to next view controller
        ClassViewController *cvc = [[ClassViewController alloc] init];
//        cvc.classes = classes;
//        cvc.classid = classid;
//        cvc.sections = sections;
//        cvc.instructor = instructor;
//        cvc.name = name;
//        cvc.registration = registration;
        [cvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:cvc animated:true completion:nil];

        
    }
    //checks to see if username and password is valid, if not throws an error and asks you to try again
    else if(errorcheck==7 && ifcheck!=4){
        ifcheck=4;
        [activityIndicator stopAnimating];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Authorization Failure" message:@"Invalid User ID or PIN\nIf the information is correct, check SIS on a web broswer" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            ifcheck=-1;
        }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        username.text=@"";
        password.text=@"";

        
    }
    //everything is correct and log the user in when on the login screen
    else if(errorcheck==5 && ifcheck!=5){
        ifcheck=5;
        NSString *user = [NSString stringWithFormat:@"%@%@%@", @"document.getElementById('UserID').value = '", username.text,@"'"];
        NSString *pass = [NSString stringWithFormat:@"%@%@%@", @"document.getElementById('PIN').children[0].value = '", password.text,@"'"];
        [webview stringByEvaluatingJavaScriptFromString:user];
        [webview stringByEvaluatingJavaScriptFromString:pass];
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('loginform')[0][2].click()"];
    }
}
@end
