//
//  ClassViewController.h
//  texchange
//
//  Created by Peter Spadalik on 2/10/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *classes;
@property (nonatomic, strong) NSMutableArray *classid;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *instructor;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *registration;
@property (nonatomic, strong) NSMutableArray *scheduledisplay;


@end
