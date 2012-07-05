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
	nonsenses = [[NSMutableArray alloc] init];
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
	static int maxCount = 0;
	if (maxCount == 0) {
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
			maxCount = 9;
		else {
			maxCount = 23;
		}
	}
	
	if ([nonsenses count] >= maxCount) {
		[nonsenses removeObjectAtIndex:0];
	}
	[nonsenses addObject:[controller radomSaying]];
	[nonsenseList reloadData];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [nonsenses count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// There is only one section.
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *NonsenseIdenfifier = @"NonsenseIdentifier";
	UITableViewCell *returnType = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NonsenseIdenfifier] autorelease];
	returnType.textLabel.text = [nonsenses objectAtIndex:[indexPath row]];
	returnType.textLabel.font = [UIFont systemFontOfSize:17];
	returnType.textLabel.numberOfLines = 0;
	return returnType;
}

/*
 To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSString* labelText = [nonsenses objectAtIndex:[indexPath row]];//[self labelTextForIndexPath:indexPath];
	
	CGSize textSize = [labelText sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake([nonsenseList bounds].size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];

	CGFloat maxTextHeight = textSize.height;
	
	CGFloat rowHeight = maxTextHeight + 5;
	if (rowHeight < self.nonsenseList.rowHeight)
		rowHeight = self.nonsenseList.rowHeight;
	return rowHeight;
}

								 
@end
