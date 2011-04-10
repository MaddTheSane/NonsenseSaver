//
//  NonsenseObject.m
//  NonsenseSaver
//
//  Created by C.W. Betts on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NonsenseObject.h"
#import <ScreenSaver/ScreenSaverView.h>

#define kNonsenseBorder (8)

@implementation NonsenseObject

-(NSRect)textPosition {
	NSRect returnRect = placement;
	//returnRect.size.height = returnRect.size.height + kNonsenseBorder;
	//returnRect.size.width = returnRect.size.width + kNonsenseBorder;
	//NSRect insideRect = SSCenteredRectInRect(returnRect,placement);
	//return insideRect;
	//return placement;
	returnRect.size.height -= ( kNonsenseBorder / 2);
	returnRect.size.width -= ( kNonsenseBorder / 2);
	returnRect.origin.x += (kNonsenseBorder / 2); 
	returnRect.origin.y += (kNonsenseBorder / 2);
	return returnRect;
}

-(id)initWithString:(NSString *)nonString bounds:(NSRect)bound {
	return [self initWithString:nonString bounds:bound font:[NSFont fontWithName:@"Helvetica" size:kFullSize]];
}

-(id)initWithString:(NSString *)nonString bounds:(NSRect)bound font:(NSFont *)theFont {
	self = [super init];
	if (self) {
		switch (random() % 9) {
			case 0:
				bgColor = [NSColor redColor];
				fgColor = [NSColor yellowColor];
				break;
			case 1:
				bgColor = [NSColor greenColor];
				fgColor = [NSColor orangeColor];
				break;
			case 2:
				bgColor = [NSColor blueColor];
				fgColor = [NSColor magentaColor];
				break;
			case 3:
				bgColor = [NSColor cyanColor];
				fgColor = [NSColor orangeColor];
				break;
			case 4:
				bgColor = [NSColor yellowColor];
				fgColor = [NSColor redColor];
				break;
			case 5:
				bgColor = [NSColor magentaColor];
				fgColor = [NSColor blueColor];
				break;
			case 6:
				bgColor = [NSColor orangeColor];
				fgColor = [NSColor blueColor];
				break;
			case 7:
				bgColor = [NSColor purpleColor];
				fgColor = [NSColor orangeColor];
				break;
			case 8:
				bgColor = [NSColor brownColor];
				fgColor = [NSColor purpleColor];
				break;
				
			default:
				bgColor = [NSColor whiteColor];
				fgColor = [NSColor blackColor];
				break;
		}
		[bgColor retain];
		[fgColor retain];
		nonsense = [nonString copy];
		NSMutableDictionary *mutAttrib = [[NSMutableDictionary alloc] init];
		[mutAttrib setObject:fgColor forKey:NSForegroundColorAttributeName];
		[mutAttrib setObject:theFont forKey:NSFontAttributeName];
		NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init] ;
		[style setAlignment:NSCenterTextAlignment];
		[mutAttrib setObject:style forKey:NSParagraphStyleAttributeName];
		[style release];
		
		fontAttribs = [[NSDictionary alloc] initWithDictionary:mutAttrib];
		[mutAttrib release];
		
		NSSize strSize = [nonsense sizeWithAttributes:fontAttribs];
		if (strSize.width > bound.size.width) {
			NSRect drawRect;
			if (strSize.width > (bound.size.width)*2.0/3.0) {
				drawRect.size.width = strSize.width / 3.0;
				drawRect.size.height = strSize.height * 4.0;
			} else {
				drawRect.size.width = strSize.width * 2.0/3.0;
				drawRect.size.height = strSize.height * 2.0;
			}
			drawRect.size.height = drawRect.size.height + kNonsenseBorder;
			drawRect.size.width = drawRect.size.width + kNonsenseBorder;
			drawRect.origin = SSRandomPointForSizeWithinRect(drawRect.size, bound);
			placement = drawRect;
		} else {
			strSize.height = strSize.height + kNonsenseBorder;
			strSize.width = strSize.width + kNonsenseBorder;
			placement.origin = SSRandomPointForSizeWithinRect(strSize, bound);
			placement.size = strSize;
		}
	}
	return self;
}

-(void)dealloc {
	[nonsense release];
	[bgColor release];
	[fgColor release];
	[fontAttribs release];
	
	[super dealloc];
}

-(void)draw {
	[self drawWithBackground:YES];
}

-(void)drawWithBackground:(BOOL)bgDraw {
	if (bgDraw) {
		[bgColor set];
		[NSBezierPath fillRect:placement];
	}
	[nonsense drawInRect:[self textPosition] withAttributes:fontAttribs];
}

@end
