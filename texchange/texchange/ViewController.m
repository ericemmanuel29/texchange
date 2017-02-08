//
//  ViewController.m
//  webviewtest
//
//  Created by Peter Spadalik on 2/3/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1024,768)];
    webview.delegate = self;
    //load sis login webpage
    NSString *url=@"https://sis.rpi.edu/rss/twbkwbis.P_WWWLogin";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];
    
    
    
    
}
//runs every time new load request finishes
-(void)webViewDidFinishLoad:(UIWebView *)webview {
    
    //page determination
    //current page determination
    NSString *page1 = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('submenulinktext2')[4].innerHTML"] ;
    NSString *page2 = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('mpdefault')[17].innerText"] ;
    NSString *page3 = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('plaintable')[3].innerText"] ;
    NSString *page4 = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pldefault')[3].innerText"] ;
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
    if([page1 isEqual:@"Student Menu"]){
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('submenulinktext2')[4].click()"];
    }
    else if([page2 isEqual:@"   View Weekly Schedule"]){
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('submenulinktext2')[29].click()"];
    }
    else if([page3 isEqual:@"Select a Semester or Summer Session"]){
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagebodydiv')[0].childNodes[3][1].click()"];
    }
    else if([page4 isEqual:@"Weekly Student Schedule"]){
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
            NSArray *classinfo = [classholder[0] componentsSeparatedByString:@" - "];
            NSArray *instructor = [instructorholder[1] componentsSeparatedByString:@" "];
            
        }
        
    }
    else{
        NSString *username = @"document.getElementById('UserID').value = 'ENTER RIN'";
        NSString *password = @"document.getElementById('PIN').children[0].value = 'ENTER PASSWORD'";
        
        [webview stringByEvaluatingJavaScriptFromString:username];
        [webview stringByEvaluatingJavaScriptFromString:password];
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('loginform')[0][2].click()"];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
