//
//  NonsenseObject.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/16/14.
//
//

import Cocoa
import ScreenSaver

let kPreviewSize: CGFloat = 12
let kFullSize: CGFloat = 30

private let kNonsenseBorder: CGFloat = 8

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
		let ourColors = NonsenseObject.randomColors()
		foregroundColor = ourColors.foreground
		backgroundColor = ourColors.background
		nonsense = nonString;
		var style = NSMutableParagraphStyle()
		style.alignment = .CenterTextAlignment
		fontAttributes = [NSForegroundColorAttributeName: foregroundColor,
			NSFontAttributeName: theFont,
			NSParagraphStyleAttributeName: style];
		
		var strSize = (nonsense as NSString).sizeWithAttributes(fontAttributes)
		strSize.width = ceil(strSize.width)
		if (strSize.width > bound.size.width) {
			var drawRect = NSZeroRect
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
			placement = drawRect;
		} else {
			var tmpPlace = NSZeroRect
			strSize.height += kNonsenseBorder;
			strSize.width += kNonsenseBorder;
			tmpPlace.origin = SSRandomPointForSizeWithinRect(strSize, bound);
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
