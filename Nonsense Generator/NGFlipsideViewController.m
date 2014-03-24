//
//  NGFlipsideViewController.m
//  Nonsense Generator
//
//  Created by C.W. Betts on 3/24/14.
//
//

#import "NGFlipsideViewController.h"

@interface NGFlipsideViewController ()

@end

@implementation NGFlipsideViewController

- (void)awakeFromNib
{
	[super awakeFromNib];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
	[self.delegate flipsideViewControllerDidFinish:self];
}

@end
