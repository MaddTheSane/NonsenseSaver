//
//  NonsenseView.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 11/2/14.
//
//

import Cocoa

class NonsenseView: NSView {
	let nonsenseController = NonsenseSaverController()
	dynamic var nonDuration: CGFloat = 2.7 {
		didSet {
			refreshRate?.invalidate()
			refreshRate = NSTimer(timeInterval: NSTimeInterval(nonDuration), target: self, selector: "reloadScreen:", userInfo:nil, repeats: true)
			NSRunLoop.mainRunLoop().addTimer(refreshRate!, forMode: NSRunLoopCommonModes)
		}
	}
	dynamic var nonNumber: Int = 5 {
		didSet {
			if nonNumber > oldValue {
				
			} else if nonNumber < oldValue {
				
			} else {
				return
			}
			needsDisplay = true
		}
	}
	dynamic var showBackground: Bool = true {
		didSet {
			if oldValue != showBackground {
				needsDisplay = true
			}
		}
	}
	private var nonsenses = [NonsenseObject]()
	private var settingsChanged = false
	private var refreshRate: NSTimer! = nil

    override func drawRect(dirtyRect: NSRect) {
		super.drawRect(dirtyRect)
		let theFont = NSFont.systemFontOfSize(kPreviewSize)
		if settingsChanged {
			settingsChanged = false
		} else {
			nonsenses.removeAtIndex(0)
			let non = NonsenseObject(string: nonsenseController.randomSaying(), bounds: self.bounds, font: theFont)
			nonsenses.append(non)
		}
		for obj in nonsenses {
			obj.draw(background: showBackground)
		}
	}
	
	func populateNonsenses() {
		let theFont = NSFont.systemFontOfSize(kPreviewSize)
		for i in 0 ..< nonNumber {
			let non = NonsenseObject(string: nonsenseController.randomSaying(), bounds: self.bounds, font: theFont)
			nonsenses.append(non)
		}
	}
	
	override init(frame: NSRect) {
		srandom(UInt32(time(nil) & 0x7FFFFFFF))
		
		super.init(frame: frame)
		
		populateNonsenses()
	}
	
	required init?(coder: NSCoder) {
		srandom(UInt32(time(nil) & 0x7FFFFFFF))
		
		super.init(coder: coder)
		
		populateNonsenses()
	}
	
	@objc(reloadScreen:) func reloadScreen(theTime: NSTimer?) {
		self.needsDisplay = true
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		refreshRate = NSTimer(timeInterval: NSTimeInterval(nonDuration), target: self, selector: "reloadScreen:", userInfo:nil, repeats: true)
		NSRunLoop.mainRunLoop().addTimer(refreshRate!, forMode: NSRunLoopCommonModes)
	}
	
}
