//
//  NonsenseObject.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kPreviewSize 15
#define kFullSize 30

@interface NonsenseObject : NSObject {
	NSString *nonsense;
	NSRect placement;
	NSColor *bgColor;
	NSColor *fgColor;
	NSDictionary *fontAttribs;
}
-(id)initWithString:(NSString *)nonString bounds:(NSRect)bound;
-(id)initWithString:(NSString *)nonString bounds:(NSRect)bound font:(NSFont *)theFont;

-(void)draw;
-(void)drawWithBackground:(BOOL)bgDraw;
@end
