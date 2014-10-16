//
//  NonsenseSaverView.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/15/14.
//
//

import Cocoa
import ScreenSaver

let NonsenseDefaultsKey = "com.github.maddthesane.NonsenseSaver"

private let NONSAtATime = "Number at a time"
private let NONSDuration = "Nonsense Duration"
private let NONSBGColor = "Show Background"

private func ourSetDefaults() {
	let defaults = ScreenSaverDefaults.defaultsForModuleWithName(NonsenseDefaultsKey) as NSUserDefaults
	defaults.registerDefaults([NONSAtATime: 3, NONSDuration: 2.7, NONSBGColor: true])
}
	

private var oursreensaverDefaults: dispatch_once_t = 0

class NonsenseSaverView: ScreenSaverView {
	dynamic var maxNonsenses: Int = 3
	dynamic var nonsenseDuration: CGFloat = 2.7
	dynamic var showBackground = true
	let controller = NonsenseSaverController()
	var nonsenses = [NonsenseObject]()
	var nibArray: NSArray? = nil
	@IBOutlet var configSheet: NSWindow! = nil
	@IBOutlet var credits: NSTextView! = nil

	override init(frame: NSRect, isPreview: Bool) {
		srandom(UInt32(time(nil) & 0xFFFFFFFF))
		dispatch_once(&oursreensaverDefaults, ourSetDefaults)

		super.init(frame: frame, isPreview: isPreview)
		
		var theFont: NSFont
		if isPreview {
			if let atheFont = NSFont(name: "Helvetica", size: kPreviewSize) {
				theFont = atheFont
			} else {
				theFont = NSFont.systemFontOfSize(kPreviewSize)
			}
		} else {
			if let atheFont = NSFont(name: "Helvetica", size: kFullSize) {
				theFont = atheFont
			} else {
				theFont = NSFont.systemFontOfSize(kFullSize)
			}
		}

		for i in 0..<maxNonsenses {
			let non = NonsenseObject(string: controller.randomSaying(), bounds: self.bounds, font: theFont)
			nonsenses.append(non)
		}

	}
	
	override func hasConfigureSheet() -> Bool {
		return true
	}
	
	override func configureSheet() -> NSWindow! {
		if let ourconfigsheet = configSheet {
			let ourBundle = NSBundle(forClass: self.dynamicType)
			ourBundle.loadNibNamed("NonsenseSettings", owner: self, topLevelObjects: &nibArray)
			if let creditsPath = ourBundle.pathForResource("Credits", ofType: "rtf") {
				credits.readRTFDFromFile(creditsPath)
			}
		}
		return configSheet
	}
	
	convenience override init(frame: NSRect) {
		self.init(frame: frame, isPreview: false)
	}

	required init?(coder: NSCoder) {
		srandom(UInt32(time(nil) & 0xFFFFFFFF))
		dispatch_once(&oursreensaverDefaults, ourSetDefaults)

		super.init(coder: coder)
	}
	
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
