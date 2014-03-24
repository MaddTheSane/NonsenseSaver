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

@interface NonsenseObject ()
@property (strong) NSColor *bgColor;
@property (strong) NSColor *fgColor;
@property (readwrite, copy) NSString *nonsense;
@property (strong) NSDictionary *fontAttribs;
@property NSRect placement;
@end

@implementation NonsenseObject
@synthesize bgColor;
@synthesize fgColor;
@synthesize nonsense;
@synthesize placement;
@synthesize fontAttribs;

- (NSRect)textPosition
{
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

- (id)initWithString:(NSString *)nonString bounds:(NSRect)bound
{
	return [self initWithString:nonString bounds:bound font:[NSFont systemFontOfSize:kFullSize]];
}

- (id)initWithString:(NSString *)nonString bounds:(NSRect)bound font:(NSFont *)theFont
{
	if (self = [super init]) {
		switch (random() % 9) {
			case 0:
				self.bgColor = [NSColor redColor];
				self.fgColor = [NSColor yellowColor];
				break;
				
			case 1:
				self.bgColor = [NSColor greenColor];
				self.fgColor = [NSColor orangeColor];
				break;
				
			case 2:
				self.bgColor = [NSColor blueColor];
				self.fgColor = [NSColor magentaColor];
				break;
				
			case 3:
				self.bgColor = [NSColor cyanColor];
				self.fgColor = [NSColor orangeColor];
				break;
				
			case 4:
				self.bgColor = [NSColor yellowColor];
				self.fgColor = [NSColor redColor];
				break;
				
			case 5:
				self.bgColor = [NSColor magentaColor];
				self.fgColor = [NSColor blueColor];
				break;
				
			case 6:
				self.bgColor = [NSColor orangeColor];
				self.fgColor = [NSColor blueColor];
				break;
				
			case 7:
				self.bgColor = [NSColor purpleColor];
				self.fgColor = [NSColor orangeColor];
				break;
				
			case 8:
				self.bgColor = [NSColor brownColor];
				self.fgColor = [NSColor purpleColor];
				break;
				
			default:
				self.bgColor = [NSColor whiteColor];
				self.fgColor = [NSColor blackColor];
				break;
		}
		self.nonsense = nonString;
		NSMutableDictionary *mutAttrib = [[NSMutableDictionary alloc] init];
		mutAttrib[NSForegroundColorAttributeName] = fgColor;
		mutAttrib[NSFontAttributeName] = theFont;
		NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
		[style setAlignment:NSCenterTextAlignment];
		mutAttrib[NSParagraphStyleAttributeName] = style;
		style = nil;
		
		self.fontAttribs = [NSDictionary dictionaryWithDictionary:mutAttrib];
		mutAttrib = nil;
		
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

- (void)draw
{
	[self drawWithBackground:YES];
}

- (void)drawWithBackground:(BOOL)bgDraw {
	if (bgDraw) {
		[self.bgColor set];
		[NSBezierPath fillRect:placement];
	}
	[nonsense drawInRect:[self textPosition] withAttributes:fontAttribs];
}

- (NSString *)description
{
	return nonsense;
}

@end
