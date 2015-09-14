//
//  NonsenseObject.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/16/14.
//
//

import Cocoa
//import ScreenSaver

let kPreviewSize: CGFloat = 12
let kFullSize: CGFloat = 30
let MaxNonsenseWidth: CGFloat = 350

private let kNonsenseBorder: CGFloat = 8

private func RandomFloatBetween(a: CGFloat, _ b: CGFloat) -> CGFloat {
	return a + (b - a) * (CGFloat(arc4random()) / CGFloat(UInt32.max))
}

private func RandomPoint(forSize size: NSSize, withinRect rect: NSRect) -> NSPoint {
	return NSPoint(x: RandomFloatBetween(rect.origin.x, rect.origin.x + rect.size.width - size.width),
		y: RandomFloatBetween(rect.origin.y, rect.origin.y + rect.size.height - size.height))
}

private func CenteredInRect(innerRect: NSRect, outerRect: NSRect) -> NSRect {
	var aInner = innerRect
	aInner.origin.x = floor((outerRect.size.width - innerRect.size.width) / 2.0);
	aInner.origin.y = floor((outerRect.size.height - innerRect.size.height) / 2.0);
	return aInner
}

final class NonsenseObject: CustomStringConvertible, CustomDebugStringConvertible {
	let nonsense: String
	let backgroundColor: NSColor
	let foregroundColor: NSColor
	let fontAttributes: [String: NSObject]
	let placement: NSRect

	var textPosition: NSRect {
		var returnRect = placement;
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

	
	class func randomColors(showBackgroundColor: Bool = true) -> (foreground: NSColor, background: NSColor) {
		let tupleArray: [(foreground: NSColor, background: NSColor)] = [(NSColor.redColor(), NSColor.yellowColor()),
		(NSColor.greenColor(), NSColor.orangeColor()), (NSColor.blueColor(), NSColor.magentaColor()), (NSColor.cyanColor(), NSColor.orangeColor()),
		(NSColor.yellowColor(), NSColor.redColor()), (NSColor.magentaColor(), NSColor.blueColor()), (NSColor.orangeColor(), NSColor.blueColor()),
		(NSColor.purpleColor(), NSColor.orangeColor()), (NSColor.brownColor(), NSColor.purpleColor())]
		return randObject(tupleArray)
/*
		var bgColor: NSColor
		var fgColor: NSColor
		switch (random() % 9) {
			
		case 0:
			bgColor = NSColor.redColor()
			fgColor = NSColor.yellowColor();
			break;
			
		case 1:
			bgColor = NSColor.greenColor();
			fgColor = NSColor.orangeColor();
			break;
			
		case 2:
			bgColor = NSColor.blueColor();
			fgColor = NSColor.magentaColor();
			break;
			
		case 3:
			bgColor = NSColor.cyanColor();
			fgColor = NSColor.orangeColor();
			break;
			
		case 4:
			bgColor = NSColor.yellowColor();
			fgColor = NSColor.redColor()
			break;
			
		case 5:
			bgColor = NSColor.magentaColor();
			fgColor = NSColor.blueColor();
			break;
			
		case 6:
			bgColor = NSColor.orangeColor();
			fgColor = NSColor.blueColor();
			break;
			
		case 7:
			bgColor = NSColor.purpleColor();
			fgColor = NSColor.orangeColor();
			break;
			
		case 8:
			bgColor = NSColor.brownColor();
			fgColor = NSColor.purpleColor();
			break;
			
		default:
			bgColor = NSColor.whiteColor()
			fgColor = NSColor.blackColor()
			break;
		}

		return (fgColor, bgColor)
*/
	}
	
	init(string nonString: String, bounds bound: NSRect, font theFont: NSFont = NSFont.systemFontOfSize(kFullSize)) {
		let maxWidth = min(MaxNonsenseWidth,  (bound.size.width / 3))
		(foregroundColor, backgroundColor) = NonsenseObject.randomColors()
		nonsense = nonString;
		let style = NSMutableParagraphStyle()
		style.alignment = .Center
		style.lineBreakMode = .ByWordWrapping
		fontAttributes = [NSForegroundColorAttributeName: foregroundColor,
			NSFontAttributeName: theFont,
			NSParagraphStyleAttributeName: style];
		
		var tmpPlace = NSRect.zero
		
		let strRect = (nonsense as NSString).boundingRectWithSize(NSSize(width: maxWidth, height: 0), options: [.UsesFontLeading, .UsesDeviceMetrics, .UsesLineFragmentOrigin], attributes: fontAttributes)
		var strSize = strRect.size
		
		strSize.height += kNonsenseBorder;
		strSize.width += kNonsenseBorder;
		tmpPlace.origin = RandomPoint(forSize: strSize, withinRect: bound)
		tmpPlace.size = strSize;
		
		placement = tmpPlace
	}
	
	func draw(background bgDraw: Bool = true) {
		if bgDraw {
			backgroundColor.set()
			NSBezierPath.fillRect(placement)
		}
		(nonsense as NSString).drawInRect(textPosition, withAttributes: fontAttributes)
	}

	var description: String {
		return nonsense
	}
	
	var debugDescription: String {
		return nonsense + ", placement: " + NSStringFromRect(placement)
	}
}
