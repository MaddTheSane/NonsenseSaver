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

private enum VocabType: Int {
	case None = 0
	case SingularNoun = 1
	case PluralNoun = 2
	case Verb = 3
	case ProperNoun = 4
	case Adjective = 5
	case Adverb = 6
	case MassiveNoun = 7
}

private var oursreensaverDefaults: dispatch_once_t = 0
private func ourSetDefaults() {
	let defaults = defaultsProvider()
	defaults.registerDefaults([NONSAtATime: 3, NONSDuration: 2.7, NONSBGColor: true])
}

public class NonsenseSaverView: ScreenSaverView {
	dynamic var maxNonsenses: Int = 3
	dynamic var nonsenseDuration: NSTimeInterval = 2.7
	dynamic var showBackground = true
	
	@IBOutlet weak var configSheet: NSWindow! = nil
	@IBOutlet weak var credits: NSTextView! = nil
	@IBOutlet weak var vocabList: NSTableView! = nil
	
	// verb IBOutlets
	@IBOutlet weak var fieldThirdPersonPast: NSFormCell!
	@IBOutlet weak var fieldThirdPersonPastPerfect: NSFormCell!
	@IBOutlet weak var fieldThirdPersonPluralPresent: NSFormCell!
	@IBOutlet weak var fieldThirdPersonPresentCont: NSFormCell!
	@IBOutlet weak var fieldThirdPersonSinglePresent: NSFormCell!
	
	@IBOutlet weak var fieldWord: NSTextField!
	
	let controller = NonsenseSaverController()
	var nonsenses = [NonsenseObject]()
	var nibArray: NSArray? = nil
	
	convenience public init?(frame: NSRect) {
		self.init(frame: frame, isPreview: false)
	}
	
	public override init?(frame: NSRect, isPreview: Bool) {
		srandom(UInt32(time(nil) & 0x7FFFFFFF))
		dispatch_once(&oursreensaverDefaults, ourSetDefaults)

		super.init(frame: frame, isPreview: isPreview)
		
		let defaults = defaultsProvider()
		maxNonsenses = defaults.integerForKey(NONSAtATime)
		nonsenseDuration = defaults.doubleForKey(NONSDuration)
		showBackground = defaults.boolForKey(NONSBGColor)
		animationTimeInterval = nonsenseDuration
		
		var theFont: NSFont
		if isPreview {
			theFont = NSFont.systemFontOfSize(kPreviewSize)
		} else {
			theFont = NSFont.systemFontOfSize(kFullSize)
		}

		for _ in 0..<maxNonsenses {
			let non = NonsenseObject(string: controller.randomSaying(), bounds: self.bounds, font: theFont)
			nonsenses.append(non)
		}
	}
	
	public override func hasConfigureSheet() -> Bool {
		return true
	}
	
	public override func configureSheet() -> NSWindow {
		if configSheet == nil {
			let ourBundle = NSBundle(forClass: self.dynamicType)
			ourBundle.loadNibNamed("NonsenseSettings", owner: self, topLevelObjects: &nibArray)
			if let creditsPath = ourBundle.pathForResource("Credits", ofType: "rtf") {
				credits.readRTFDFromFile(creditsPath)
			}
		}
		return configSheet
	}
	
	public override func animateOneFrame() {
		needsDisplay = true
	}
	
	public required init?(coder: NSCoder) {
		srandom(UInt32(time(nil) & 0x7FFFFFFF))
		dispatch_once(&oursreensaverDefaults, ourSetDefaults)

		super.init(coder: coder)
	}
	
    public override func drawRect(dirtyRect: NSRect) {
		//Clear the screen
        super.drawRect(dirtyRect)

		var theFont: NSFont
		if preview {
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
	
	func clearVerbWindow() {
		fieldThirdPersonSinglePresent.stringValue = ""
		fieldThirdPersonPluralPresent.stringValue = ""
		fieldThirdPersonPast.stringValue = ""
		fieldThirdPersonPastPerfect.stringValue = ""
		fieldThirdPersonPresentCont.stringValue = ""
	}
	
	@IBAction func okayNonsense(sender: AnyObject?) {
		
	}
	
	@IBAction func cancelNonsense(sender: AnyObject?) {
		
	}
	
	@IBAction func changeVocabView(sender: AnyObject) {
		if let aTag = (sender as? NSControl)?.tag {
			if let aVocabType = VocabType(rawValue: aTag) {
				// TODO: implement
			}
		}
	}
	
	@IBAction func removeSelectedWord(sender: AnyObject) {
		
	}
	
	@IBAction func addWord(sender: AnyObject) {
		
	}
}
