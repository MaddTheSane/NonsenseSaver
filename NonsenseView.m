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

@implementation NonsenseView

@synthesize nonNumber;
@synthesize nonDuration;
@synthesize showBackground;


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		srandom(time(NULL));
		nonsenseController = [[NonsenseSaverController alloc] init];
		nonsenses = [[NSMutableArray alloc] init];
		refreshRate = [[NSTimer alloc] init];
		
		short i;
		NSFont *theFont = [NSFont fontWithName:@"Helvetica" size:kPreviewSize];
		
		for(i = 0; i < [self nonNumber] ; i++ )
		{
			NonsenseObject *non = [[NonsenseObject alloc] initWithString:[nonsenseController radomSaying] bounds:[self bounds] font:theFont];
			[nonsenses addObject:non];
			[non release];
		}

    }
    return self;
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
	[non release];
}

@end
