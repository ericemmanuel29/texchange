//
//  BackpackViewController.h
//  texchange
//
//  Created by Peter Spadalik on 3/3/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassViewController.h"

@interface BackpackViewController : UIViewController

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSDictionary *backpack;
@property (nonatomic, strong) NSArray *textbooks;
@property (nonatomic, strong) NSArray *forsale;
@property (nonatomic, strong) NSString *RIN;
@property (nonatomic, strong) UITextField *askingpricetf;


@end
