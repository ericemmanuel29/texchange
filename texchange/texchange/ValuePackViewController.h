//
//  ValuePackViewController.h
//  texchange
//
//  Created by Eric Roque on 4/12/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ValuePackViewController : UIViewController

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSString *material;
@property (nonatomic, strong) NSString *camefrom;
@property (nonatomic, strong) NSArray *materialarray;
@property (nonatomic, strong) NSString *classTitle;
@property (nonatomic, strong) NSMutableDictionary *classMaterials;
@property (nonatomic, strong) NSMutableDictionary *classMaterialsFinal;
@property (nonatomic, strong) NSArray *classid;
@property (nonatomic, strong) NSArray *classes;

@end


