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

@interface NonsenseView ()
@property (strong) NonsenseSaverController *nonsenseController;
@property (strong) NSMutableArray *nonsenses;
@property (strong) NSTimer *refreshRate;
@end

@implementation NonsenseView
@synthesize showBackground;
@synthesize nonDuration = _nonDuration;

- (void)setNonDuration:(CGFloat)nonDuration
{
	_nonDuration = nonDuration;
	[self setNeedsDisplay:YES];
}

- (void)setShowBackground:(BOOL)_showBackground
{
	if (showBackground != _showBackground) {
		showBackground = _showBackground;
		[self setNeedsDisplay:YES];
	}
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.nonDuration = 2.7;
		self.nonNumber = 5;
		self.showBackground = YES;
		
		srandom(0x7FFFFFFF & time(NULL));
		self.nonsenseController = [[NonsenseSaverController alloc] init];
		self.nonsenses = [NSMutableArray array];
		
		NSFont *theFont = [NSFont systemFontOfSize:kPreviewSize];
		
		for (int i = 0; i < [self nonNumber] ; i++ ) {
			NonsenseObject *non = [[NonsenseObject alloc] initWithString:[self.nonsenseController radomSaying] bounds:[self bounds] font:theFont];
			[self.nonsenses addObject:non];
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
	self.refreshRate = [NSTimer timerWithTimeInterval:self.nonDuration target:self selector:@selector(reloadScreen:) userInfo:nil repeats:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	NSFont *theFont = [NSFont systemFontOfSize:kPreviewSize];
	for (NonsenseObject *obj in self.nonsenses) {
		[obj drawWithBackground:[self showBackground]];
	}
	[self.nonsenses removeObjectAtIndex:0];
	NonsenseObject *non = [[NonsenseObject alloc] initWithString:[self.nonsenseController radomSaying] bounds:[self bounds] font:theFont];
	[self.nonsenses addObject:non];
}

@end
