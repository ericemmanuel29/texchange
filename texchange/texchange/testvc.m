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
//    self.ref = [[FIRDatabase database] reference];
//    [[[self.ref child:@"Testing 1"] child:@"test2"]setValue:@"Test"];
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"TextBookInfo" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    // maybe for debugging...
    NSLog(@"contents: %@", fileContents);
    
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"items = %lu", (unsigned long)[listArray count]);
}


@end
