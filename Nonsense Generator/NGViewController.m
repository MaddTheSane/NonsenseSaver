//
//  NGViewController.m
//  Nonsense Generator
//
//  Created by Charles Betts on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NGViewController.h"
#import "NonsenseSaverController.h"


@interface NGViewController ()

@end

@implementation NGViewController
@synthesize nonsenseList;
@synthesize nonsenses;
@synthesize controller;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	controller = [[NonsenseSaverController alloc] init];
	[self GenerateNonsense:nil];
}

- (void)viewDidUnload
{
	[self setNonsenseList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

- (void)dealloc {
	[nonsenseList release];
	[controller release];
	[nonsenses release];
	[super dealloc];
}

- (IBAction)GenerateNonsense:(id)sender {
	if ([nonsenses count] == 5) {
		[nonsenses removeObjectAtIndex:0];
	}
	[nonsenses addObject:[controller radomSaying]];
	
}

@end
