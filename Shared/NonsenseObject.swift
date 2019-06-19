//
//  NonsenseObject.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/16/14.
//
//

import Cocoa
//import ScreenSaver

let kPreviewFontSize: CGFloat = 12
let kFullFontSize: CGFloat = 30
let MaxNonsenseWidth: CGFloat = 350

private let kNonsenseBorder: CGFloat = 8

private func RandomFloatBetween(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
	return CGFloat.random(in: a...b)
}

private func RandomPoint(forSize size: NSSize, withinRect rect: NSRect) -> NSPoint {
	return NSPoint(x: RandomFloatBetween(rect.origin.x, rect.origin.x + rect.size.width - size.width),
		y: RandomFloatBetween(rect.origin.y, rect.origin.y + rect.size.height - size.height))
}

final class NonsenseObject: CustomStringConvertible, CustomDebugStringConvertible {
	let nonsense: String
	let backgroundColor: NSColor
	let foregroundColor: NSColor
	let fontAttributes: [NSAttributedString.Key: Any]
	let placement: NSRect

	var textPosition: NSRect {
		var returnRect = placement
		returnRect = returnRect.insetBy(dx: kNonsenseBorder / 2, dy: kNonsenseBorder / 2)
		return returnRect;
	}

	fileprivate static let randomColorArray: [(foreground: NSColor, background: NSColor)] =
		[(NSColor.red, NSColor.yellow), (NSColor.green, NSColor.orange),
		 (NSColor.blue, NSColor.magenta), (NSColor.cyan, NSColor.orange),
		 (NSColor.yellow, NSColor.red), (NSColor.magenta, NSColor.blue),
		 (NSColor.orange, NSColor.blue), (NSColor.purple, NSColor.orange),
		 (NSColor.brown, NSColor.purple)]
	
	class func randomColors(_ showBackgroundColor: Bool = true) -> (foreground: NSColor, background: NSColor) {
		return randomColorArray.randomElement()!
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
	
	init(string nonString: String, bounds bound: NSRect, font theFont: NSFont = NSFont.systemFont(ofSize: kFullFontSize), objectsToAvoid otherNons: [NonsenseObject]? = nil) {
		let maxWidth = min(MaxNonsenseWidth,  (bound.size.width / 3))
		(foregroundColor, backgroundColor) = NonsenseObject.randomColors()
		nonsense = nonString;
		let style = NSMutableParagraphStyle()
		style.alignment = .center
		style.lineBreakMode = .byWordWrapping
		fontAttributes = [.foregroundColor: foregroundColor,
		                  .font: theFont,
		                  .paragraphStyle: style];
		
		var tmpPlace = NSRect.zero
		
		let strRect = nonsense.boundingRect(with: NSSize(width: maxWidth, height: 0), options: [.usesFontLeading, .usesDeviceMetrics, .usesLineFragmentOrigin], attributes: fontAttributes).insetBy(dx: -kNonsenseBorder / 2, dy: -kNonsenseBorder / 2)
		let strSize = strRect.size
		
		tmpPlace.origin = RandomPoint(forSize: strSize, withinRect: bound)
		tmpPlace.size = strSize;
		
		placement = tmpPlace
	}
	
	func draw(background bgDraw: Bool = true) {
		if bgDraw {
			backgroundColor.set()
			NSBezierPath.fill(placement)
		}
		nonsense.draw(in: textPosition, withAttributes: fontAttributes)
	}

	var description: String {
		return nonsense
	}
	
	var debugDescription: String {
		return "\"\(nonsense), placement: \(NSStringFromRect(placement))"
	}
}
