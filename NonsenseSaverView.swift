//
//  NonsenseSaverView.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/15/14.
//
//

import Cocoa
import ScreenSaver

private let NONSAtATime = "Number at a time"
private let NONSDuration = "Nonsense Duration"
private let NONSBGColor = "Show Background"

private func ourSetDefaults() {
	let defaults = ScreenSaverDefaults.defaultsForModuleWithName(NonsenseDefaultsKey) as ScreenSaverDefaults
	defaults.registerDefaults([NONSAtATime: 3, NONSDuration: 2.7, NONSBGColor: true])
}

private var oursreensaverDefaults: dispatch_once_t = 0

class NonsenseSaverView: ScreenSaverView {
	dynamic var maxNonsenses: Int = 3
	dynamic var nonsenseDuration: NSTimeInterval = 2.7
	dynamic var showBackground = true
	
	@IBOutlet var configSheet: NSWindow! = nil
	@IBOutlet var credits: NSTextView! = nil
	
	let controller = NonsenseSaverController()
	var nonsenses = [NonsenseObject]()
	var nibArray: NSArray? = nil
	
	convenience override init(frame: NSRect) {
		self.init(frame: frame, isPreview: false)
	}
	
	override init(frame: NSRect, isPreview: Bool) {
		srandom(UInt32(time(nil) & 0x7FFFFFFF))
		dispatch_once(&oursreensaverDefaults, ourSetDefaults)

		super.init(frame: frame, isPreview: isPreview)
		
		let defaults = ScreenSaverDefaults.defaultsForModuleWithName(NonsenseDefaultsKey) as ScreenSaverDefaults
		maxNonsenses = defaults.integerForKey(NONSAtATime)
		nonsenseDuration = defaults.doubleForKey(NONSDuration)
		showBackground = defaults.boolForKey(NONSBGColor)
		setAnimationTimeInterval(nonsenseDuration)
		
		var theFont: NSFont
		if isPreview {
			theFont = NSFont.systemFontOfSize(kPreviewSize)
		} else {
			theFont = NSFont.systemFontOfSize(kFullSize)
		}

		for i in 0..<maxNonsenses {
			let non = NonsenseObject(string: controller.randomSaying(), bounds: self.bounds, font: theFont)
			nonsenses.append(non)
		}
	}
	
	override func hasConfigureSheet() -> Bool {
		return true
	}
	
	override func configureSheet() -> NSWindow {
		if configSheet == nil {
			let ourBundle = NSBundle(forClass: self.dynamicType)
			ourBundle.loadNibNamed("NonsenseSettings", owner: self, topLevelObjects: &nibArray)
			if let creditsPath = ourBundle.pathForResource("Credits", ofType: "rtf") {
				credits.readRTFDFromFile(creditsPath)
			}
		}
		return configSheet
	}
	
	override func animateOneFrame() {
		needsDisplay = true
	}
	
	required init?(coder: NSCoder) {
		srandom(UInt32(time(nil) & 0x7FFFFFFF))
		dispatch_once(&oursreensaverDefaults, ourSetDefaults)

		super.init(coder: coder)
	}
	
    override func drawRect(dirtyRect: NSRect) {
		//Clear the screen
        super.drawRect(dirtyRect)

		var theFont: NSFont
		if isPreview() {
			theFont = NSFont.systemFontOfSize(kPreviewSize)
		} else {
			theFont = NSFont.systemFontOfSize(kFullSize)
		}
		for obj in nonsenses {
			obj.draw(background: showBackground)
		}
		nonsenses.removeAtIndex(0)
		let non = NonsenseObject(string: controller.randomSaying(), bounds: bounds, font:theFont)
		nonsenses.append(non)
    }
	
	
	@IBAction func closeNonsense(sender: AnyObject?) {
		
	}
	
	@IBAction func changeVocabView(sender: AnyObject) {
		
	}
	
	@IBAction func removeSelectedWord(sender: AnyObject) {
		
	}
	
	@IBAction func addWord(sender: AnyObject) {
		
	}
}
