

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface ChatViewController : UIViewController
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITextField *message;
@property (nonatomic, retain) UIView *messageview;
@property (nonatomic, retain) UIButton *sendbutton;

@end
