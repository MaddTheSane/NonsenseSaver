//
//  NonsenseView.m
//  NonsenseSaver
//
//  Created by C.W. Betts on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NonsenseView.h"
#import "NonsenseSaverController.h"
#import "NonsenseObject.h"
#import "ARCBridge.h"

@interface NonsenseView ()
@property (retain) NonsenseSaverController *nonsenseController;
@property (retain) NSMutableArray *nonsenses;
@property (retain) NSTimer *refreshRate;
@end

@implementation NonsenseView
@synthesize nonNumber;
@synthesize nonDuration;
@synthesize showBackground;
- (void)setShowBackground:(BOOL)_showBackground
{
	if (showBackground != _showBackground) {
		showBackground = _showBackground;
		[self setNeedsDisplay:YES];
	}
}

@synthesize nonsenseController;
@synthesize nonsenses;
@synthesize refreshRate;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		srandom(0x7FFFFFFF & time(NULL));
		nonsenseController = [[NonsenseSaverController alloc] init];
		self.nonsenses = [NSMutableArray array];
		
		short i;
		NSFont *theFont = [NSFont fontWithName:@"Helvetica" size:kPreviewSize];
		
		for(i = 0; i < [self nonNumber] ; i++ )
		{
			NonsenseObject *non = [[NonsenseObject alloc] initWithString:[nonsenseController radomSaying] bounds:[self bounds] font:theFont];
			[nonsenses addObject:non];
			RELEASEOBJ(non);
		}

    }
    return self;
}

- (void)reloadScreen:(NSTimer*)thetime
{
	[self setNeedsDisplay:YES];
}

- (void)awakeFromNib
{
	self.nonDuration = 2.7;
	self.nonNumber = 5;
	self.showBackground = YES;

	self.refreshRate = [NSTimer timerWithTimeInterval:self.nonDuration target:self selector:@selector(reloadScreen:) userInfo:nil repeats:YES];
	
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	NSFont *theFont = [NSFont fontWithName:@"Helvetica" size:kPreviewSize];
	for(NonsenseObject *obj in nonsenses) {
		[obj drawWithBackground:[self showBackground]];
	}
	[nonsenses removeObjectAtIndex:0];
	NonsenseObject *non = [[NonsenseObject alloc] initWithString:[nonsenseController radomSaying] bounds:[self bounds] font:theFont];
	[nonsenses addObject:non];
	RELEASEOBJ(non);
}

@end
