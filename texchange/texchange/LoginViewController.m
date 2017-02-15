//
//  ViewController.m
//  texchange
//
//  Created by Peter Spadalik on 2/3/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "LoginViewController.h"
#import "ClassViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


-(void)viewDidLoad{
    [super viewDidLoad];
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
    password.placeholder = @"Passoword";
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
        UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, width,height)];
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
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('submenulinktext2')[4].click()"];
    }
    else if([page2 isEqual:@"   View Weekly Schedule"] && ifcheck!=1){
        ifcheck=1;
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('submenulinktext2')[29].click()"];
    }
    else if([page3 isEqual:@"Select a Semester or Summer Session"] && ifcheck!=2){
        ifcheck=2;
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagebodydiv')[0].childNodes[3][1].click()"];
    }
    else if([page4 isEqual:@"Weekly Student Schedule"] && ifcheck!=3){
        ifcheck=3;
        NSString *cn = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('datadisplaytable').length"] ;
        int classnum = [cn intValue];
        //runs through each class you have and puts info in classinfo and instructor
        for(int x=0; x<classnum; x=x+2){
            NSString *firstpart = @"document.getElementsByClassName('datadisplaytable')[";
            NSString *secondpart = @"].innerText";
            NSString *strtoint = [NSString stringWithFormat:@"%d",x];
            NSString *fullcommand = [NSString stringWithFormat:@"%@%@%@", firstpart, strtoint, secondpart];
            NSString *class = [webview stringByEvaluatingJavaScriptFromString:fullcommand];
            NSArray *classholder = [class componentsSeparatedByString:@"\n"];
            NSArray *instructorholder = [classholder[4] componentsSeparatedByString:@"\t"];
            classinfo = [classholder[0] componentsSeparatedByString:@" - "];
            instructor = [instructorholder[1] componentsSeparatedByString:@" "];
            [activityIndicator stopAnimating];
            //got the information, move to next view controller
            ClassViewController *cvc = [[ClassViewController alloc] init];
            cvc.classinfocopy = classinfo;
            cvc.instructorcopy = instructor;
            [self presentModalViewController:cvc animated:true];

             
            

        }
        
    }
    else if(errorcheck==7 && ifcheck!=4){
        ifcheck=4;
        [activityIndicator stopAnimating];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Authorization Failure" message:@"Invalid User ID or PIN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            username.text=@"";
            password.text=@"";
            ifcheck=-1;
        }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];

        
    }
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
