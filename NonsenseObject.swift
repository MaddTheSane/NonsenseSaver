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

private func RandomFloatBetween(a: CGFloat, b: CGFloat) -> CGFloat {
	return a + (b - a) * (CGFloat(random()) / CGFloat(RAND_MAX))
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

final class NonsenseObject: NSObject, Printable, DebugPrintable {
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
		let maxWidth = MaxNonsenseWidth > (bound.size.width / 3) ? bound.size.width / 3 : MaxNonsenseWidth
		let ourColors = NonsenseObject.randomColors()
		foregroundColor = ourColors.foreground
		backgroundColor = ourColors.background
		nonsense = nonString;
		let style = NSMutableParagraphStyle()
		style.alignment = .CenterTextAlignment
		fontAttributes = [NSForegroundColorAttributeName: foregroundColor,
			NSFontAttributeName: theFont,
			NSParagraphStyleAttributeName: style];
		
		var strSize = (nonsense as NSString).sizeWithAttributes(fontAttributes)
		strSize.width = ceil(strSize.width)
		if strSize.width > maxWidth {
			// How much greater is it?
			var greaterBy = strSize.width / maxWidth
			greaterBy = ceil(greaterBy)
			var tmpPlace = NSZeroRect
			strSize.width = maxWidth
			strSize.height *= greaterBy
			
			strSize.height += kNonsenseBorder;
			strSize.width += kNonsenseBorder;
			tmpPlace.origin = RandomPoint(forSize: strSize, withinRect: bound)
			tmpPlace.size = strSize;
			
			placement = tmpPlace
		} else {
			var tmpPlace = NSZeroRect
			strSize.height += kNonsenseBorder;
			strSize.width += kNonsenseBorder;
			tmpPlace.origin = RandomPoint(forSize: strSize, withinRect: bound)
			tmpPlace.size = strSize;
			placement = tmpPlace;
		}
		super.init()
	}
	
	func draw(background bgDraw: Bool = true) {
		if bgDraw {
			backgroundColor.set()
			NSBezierPath.fillRect(placement)
		}
		(nonsense as NSString).drawInRect(textPosition, withAttributes: fontAttributes)
	}

	override var description: String {
		return nonsense
	}
	
	override var debugDescription: String {
		return nonsense + ", placement: " + NSStringFromRect(placement)
	}
}
