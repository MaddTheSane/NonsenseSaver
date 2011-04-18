//
//  NonsenseView.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NonsenseSaverController;

@interface NonsenseView : NSView {
	NonsenseSaverController *nonsenseController;
	NSMutableArray *nonsenses;
	NSInteger nonNumber;
	CGFloat nonDuration;
	BOOL showBackground;
	NSTimer *refreshRate;
}

@property (readwrite) NSInteger nonNumber;
@property (readwrite) CGFloat nonDuration;
@property (readwrite) BOOL showBackground;

@end
