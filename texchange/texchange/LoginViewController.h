//
//  ViewController.h
//  texchange
//
//  Created by Peter Spadalik on 2/8/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    CGFloat width;
    CGFloat height;
    UITextField* username;
    UITextField* password;
    UIButton *loginbutton;
    UIActivityIndicatorView *activityIndicator;
    NSString *name;
}


@end

