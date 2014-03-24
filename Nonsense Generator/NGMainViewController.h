//
//  NGMainViewController.h
//  Nonsense Generator
//
//  Created by C.W. Betts on 3/24/14.
//
//

#import "NGFlipsideViewController.h"

@class NonsenseSaverController;

@interface NGMainViewController : UIViewController <NGFlipsideViewControllerDelegate, UIPopoverControllerDelegate>
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong) NonsenseSaverController *nonsenseController;
@property (strong) NSMutableArray *nonsenses;

- (IBAction)generateNonsense:(id)sender;
@end
