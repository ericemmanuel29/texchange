//
//  SearchViewController.h
//  texchange
//
//  Created by Eric Roque on 3/21/17.
//  Copyright © 2017 Peter Spadalik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIPickerView *pickerView;
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) UIButton *classidbutton;
@property (nonatomic, strong) UIButton *classidsearchbutton;
@property (nonatomic, strong) UIButton *textbooknamebutton;
@property (nonatomic, strong) NSMutableArray *tablearray;
@property (nonatomic, strong) UITextField *classidtf;
@property (nonatomic, strong) UITextField *textbooktf;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *prefixes;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) NSString *cameFrom;




@end
