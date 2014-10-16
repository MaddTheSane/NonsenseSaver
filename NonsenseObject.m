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
@synthesize nonsense;

- (NSRect)textPosition
{
	NSRect returnRect = self.placement;
	//returnRect.size.height = returnRect.size.height + kNonsenseBorder;
	//returnRect.size.width = returnRect.size.width + kNonsenseBorder;
	//NSRect insideRect = SSCenteredRectInRect(returnRect,placement);
	//return insideRect;
	//return placement;
	returnRect.size.height -= kNonsenseBorder / 2;
	returnRect.size.width -= kNonsenseBorder / 2;
	returnRect.origin.x += kNonsenseBorder / 2;
	returnRect.origin.y += kNonsenseBorder / 2;
	return returnRect;
}

- (instancetype)initWithString:(NSString *)nonString bounds:(NSRect)bound
{
	return [self initWithString:nonString bounds:bound font:[NSFont systemFontOfSize:kFullSize]];
}

- (instancetype)initWithString:(NSString *)nonString bounds:(NSRect)bound font:(NSFont *)theFont
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
		NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
		[style setAlignment:NSCenterTextAlignment];
		self.fontAttribs = @{NSForegroundColorAttributeName: self.fgColor,
							 NSFontAttributeName: theFont,
							 NSParagraphStyleAttributeName: style};
		style = nil;
		
		NSSize strSize = [nonsense sizeWithAttributes:_fontAttribs];
		if (strSize.width > bound.size.width) {
			NSRect drawRect;
			if (strSize.width > (bound.size.width)*2.0/3.0) {
				drawRect.size.width = strSize.width / 3.0;
				drawRect.size.height = strSize.height * 4.0;
			} else {
				drawRect.size.width = strSize.width * 2.0/3.0;
				drawRect.size.height = strSize.height * 2.0;
			}
			drawRect.size.height += kNonsenseBorder;
			drawRect.size.width += kNonsenseBorder;
			drawRect.origin = SSRandomPointForSizeWithinRect(drawRect.size, bound);
			self.placement = drawRect;
		} else {
			NSRect tmpPlace;
			strSize.height += kNonsenseBorder;
			strSize.width += kNonsenseBorder;
			tmpPlace.origin = SSRandomPointForSizeWithinRect(strSize, bound);
			tmpPlace.size = strSize;
			self.placement = tmpPlace;
		}
	}
	return self;
}

- (void)draw
{
	[self drawWithBackground:YES];
}

- (void)drawWithBackground:(BOOL)bgDraw
{
	if (bgDraw) {
		[self.bgColor set];
		[NSBezierPath fillRect:self.placement];
	}
	[nonsense drawInRect:[self textPosition] withAttributes:self.fontAttribs];
}

- (NSString *)description
{
	return nonsense;
}

@end
