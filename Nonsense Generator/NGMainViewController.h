//
//  NGMainViewController.h
//  Nonsense Generator
//
//  Created by C.W. Betts on 3/24/14.
//
//

#import "NGFlipsideViewController.h"

@interface NGMainViewController : UIViewController <NGFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
