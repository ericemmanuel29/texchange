//
//  SellingViewController.h
//  texchange
//
//  Created by Peter Spadalik on 3/28/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

@interface SellingViewController : UIViewController

@property (nonatomic, retain) NSString *Mtitle;
@property (nonatomic, retain) NSString *classholder;
@property (nonatomic, retain) NSString *camefrom;
@property (nonatomic, retain) NSMutableArray *sellers;
@property (nonatomic, retain) NSMutableArray *sellersRIN;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSArray *materialarray;


@end
