//
//  NonsenseView.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NonsenseSaverController;

@interface NonsenseView : NSView
@property (strong) NonsenseSaverController *nonsenseController;
@property NSInteger nonNumber;
@property CGFloat nonDuration;
@property BOOL showBackground;
@end
