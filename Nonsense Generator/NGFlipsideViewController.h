//
//  NGFlipsideViewController.h
//  Nonsense Generator
//
//  Created by C.W. Betts on 3/24/14.
//
//

#import <UIKit/UIKit.h>

@class NGFlipsideViewController;

@protocol NGFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(NGFlipsideViewController *)controller;
@end

@interface NGFlipsideViewController : UIViewController

@property (weak, nonatomic) id <NGFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
