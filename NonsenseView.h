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
@property (readwrite) NSInteger nonNumber;
@property (nonatomic) CGFloat nonDuration;
@property (readwrite, nonatomic) BOOL showBackground;
@end
