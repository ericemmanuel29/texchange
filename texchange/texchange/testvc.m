//
//  testvc.m
//  texchange
//
//  Created by Peter Spadalik on 3/7/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//


#import "testvc.h"
@import Firebase;

@interface testvc ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation testvc


-(void)viewDidLoad{
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    //NSString *user = @"Ericsgay";
    [[[self.ref child:@"Testing 1"] child:@"test2"]setValue:@"Test"];
}


@end
