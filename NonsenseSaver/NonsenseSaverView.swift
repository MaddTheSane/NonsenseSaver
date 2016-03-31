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

public class NonsenseSaverView: ScreenSaverView, NSTableViewDataSource {
	dynamic var maxNonsenses: Int = 3
	dynamic var nonsenseDuration: NSTimeInterval = 2.7
	dynamic var showBackground = true
	
	@IBOutlet weak var configSheet: NSWindow! = nil
	@IBOutlet weak var creditsScrollView: NSScrollView!
	@IBOutlet weak var vocabList: NSTableView! = nil
	@IBOutlet weak var vocabSelector: NSMatrix!
	var credits: NSTextView! {
		return creditsScrollView.contentView.documentView as? NSTextView
	}

	@IBOutlet weak var wordToAdd: NSTextField!
	@IBOutlet weak var wordWindow: NSWindow!

	
	// MARK: verb IBOutlets
	@IBOutlet weak var fieldThirdPersonPast: NSFormCell!
	@IBOutlet weak var fieldThirdPersonPastPerfect: NSFormCell!
	@IBOutlet weak var fieldThirdPersonPluralPresent: NSFormCell!
	@IBOutlet weak var fieldThirdPersonPresentCont: NSFormCell!
	@IBOutlet weak var fieldThirdPersonSinglePresent: NSFormCell!
	@IBOutlet weak var verbWindow: NSWindow!

	@IBOutlet weak var fieldWord: NSTextField!
	
	let controller = NonsenseSaverController()
	var nonsenses = [NonsenseObject]()
	private var nibArray: NSArray? = nil
	
	public override init?(frame: NSRect, isPreview: Bool) {
		srandom(UInt32(time(nil) & 0x7FFFFFFF))
		dispatch_once(&NonsenseSaverView.oursreensaverDefaults, NonsenseSaverView.ourSetDefaults)

		super.init(frame: frame, isPreview: isPreview)
		
		let defaults = defaultsProvider()
		maxNonsenses = defaults.integerForKey(NONSAtATime)
		nonsenseDuration = defaults.doubleForKey(NONSDuration)
		showBackground = defaults.boolForKey(NONSBGColor)
		animationTimeInterval = nonsenseDuration
		
		var theFont: NSFont
		if isPreview {
			theFont = NSFont.systemFontOfSize(kPreviewFontSize)
		} else {
			theFont = NSFont.systemFontOfSize(kFullFontSize)
		}

		for _ in 0..<maxNonsenses {
			let non = NonsenseObject(string: controller.randomSaying(), bounds: self.bounds, font: theFont)
			nonsenses.append(non)
		}
	}
	
	public override func hasConfigureSheet() -> Bool {
		return true
	}
	
	public override func configureSheet() -> NSWindow? {
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
		dispatch_once(&NonsenseSaverView.oursreensaverDefaults, NonsenseSaverView.ourSetDefaults)

		super.init(coder: coder)
	}
	
    public override func drawRect(dirtyRect: NSRect) {
		//Clear the screen
        super.drawRect(dirtyRect)

		var theFont: NSFont
		if preview {
			theFont = NSFont.systemFontOfSize(kPreviewFontSize)
		} else {
			theFont = NSFont.systemFontOfSize(kFullFontSize)
		}
		for obj in nonsenses {
			obj.draw(background: showBackground)
		}
		nonsenses.removeAtIndex(0)
		let non = NonsenseObject(string: controller.randomSaying(), bounds: bounds, font:theFont)
		nonsenses.append(non)
    }
	
	private func clearVerbWindow() {
		fieldThirdPersonSinglePresent.stringValue = ""
		fieldThirdPersonPluralPresent.stringValue = ""
		fieldThirdPersonPast.stringValue = ""
		fieldThirdPersonPastPerfect.stringValue = ""
		fieldThirdPersonPresentCont.stringValue = ""
	}
	
	private func clearWordWindow() {
		fieldWord.stringValue = ""
	}
	
	@IBAction func okayAddNonsensePart(sender: NSButton?) {
		if sender?.window === wordWindow {
			let tmpFieldWord = fieldWord.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			if tmpFieldWord == "" {
				let noVerb = NSAlert()
				noVerb.messageText = "No Word"
				noVerb.informativeText = "Please enter a word."
				noVerb.beginSheetModalForWindow(wordWindow, completionHandler: nil)
				return
			}
			
			switch vocabSelectorSelected {
			case .SingularNoun:
				controller.addSingularNoun(tmpFieldWord)
				
			case .PluralNoun:
				controller.addPluralNoun(tmpFieldWord)
				
			case .Adjective:
				controller.addAdjective(tmpFieldWord)
				
			case .Adverb:
				controller.addAdverb(tmpFieldWord)
				
			case .MassiveNoun:
				controller.addMassiveNoun(tmpFieldWord)
				
			case .ProperNoun:
				controller.addProperNoun(tmpFieldWord)
				
			default:
				break;
			}
			
			configSheet.endSheet(wordWindow)
			clearWordWindow()
			wordWindow.orderOut(sender)
		} else if sender?.window === verbWindow {
			var i = 0
			let thirdPersSingPres	= fieldThirdPersonSinglePresent.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			let thirdPersPlurPres	= fieldThirdPersonPluralPresent.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			let thirdPersPas		= fieldThirdPersonPast.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			let thirPersPasPer		= fieldThirdPersonPastPerfect.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			let thirPersPresCont	= fieldThirdPersonPresentCont.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			
			if thirdPersSingPres != "" {
				i += 1;
			}
			if thirdPersPlurPres != "" {
				i += 1;
			}
			if thirdPersPas != "" {
				i += 1;
			}
			if thirPersPasPer != "" {
				i += 1;
			}
			if thirPersPresCont != "" {
				i += 1;
			}
			
			if i == 5 {
				let tmpVerb = Verb(singlePresent: thirdPersSingPres, pluralPresent: thirdPersPlurPres, past: thirdPersPas, pastPerfect: thirPersPasPer, presentCont: thirPersPresCont)
				controller.addVerb(tmpVerb)
				configSheet.endSheet(verbWindow)
				clearVerbWindow()
				verbWindow.orderOut(sender)
			} else {
				let noVerb = NSAlert()
				noVerb.messageText = "Incomplete Verb"
				noVerb.informativeText = "The verb doesn't have all members filled. Please fill them out."
				noVerb.beginSheetModalForWindow(verbWindow, completionHandler: nil)
			}
		}
	}
	
	@IBAction func cancelAddNonsensePart(sender: NSButton?) {
		if sender?.window === wordWindow {
			configSheet.endSheet(wordWindow)
			clearWordWindow()
			wordWindow.orderOut(sender)
		} else if sender?.window === verbWindow {
			configSheet.endSheet(verbWindow)
			clearVerbWindow()
			verbWindow.orderOut(sender)
		}
	}
	
	@IBAction func closeNonsense(sender: AnyObject?) {
		let defaults = ScreenSaverDefaults(forModuleWithName: NonsenseDefaultsKey)!
		if let respSender = sender as? NSControl {
			if respSender.tag != 1 {
				controller.saveSettings()
				defaults.setInteger(maxNonsenses, forKey: NONSAtATime)
				defaults.setDouble(nonsenseDuration, forKey: NONSDuration)
				defaults.setBool(showBackground, forKey: NONSBGColor)
				defaults.synchronize()
				animationTimeInterval = nonsenseDuration
				
				nonsenses.removeAll()
				
				for _ in 0..<maxNonsenses {
					let non = NonsenseObject(string: controller.randomSaying(), bounds: bounds, font: NSFont.systemFontOfSize(kPreviewFontSize))
					nonsenses.append(non)
				}
			} else {
				//Clear settings by re-loading them
				controller.loadSettings()
				self.maxNonsenses = defaults.integerForKey(NONSAtATime)
				self.nonsenseDuration = defaults.doubleForKey(NONSDuration)
				self.showBackground = defaults.boolForKey(NONSBGColor)
			}
		} else if let sender = sender {
			let nsSender: NSObject = (sender as? NSObject) ?? NSString(string: "Non-NSObject class (Maybe Swift)")
			NSLog("I just don't know what went wrong!\nObject value: %@, type: %@", nsSender, nsSender.className)
			NSBeep()
		} else {
			NSLog("I just don't know what went wrong!\nGot sent \"nil\".")
		}
		NSApp.endSheet(configSheet) //Ignore warning: Sceen Saver's documentation says we *need* to call NSApp's version!
	}

	@IBAction func okayNonsense(sender: AnyObject?) {
		closeNonsense(sender)
	}
	
	@IBAction func cancelNonsense(sender: NSButton?) {
		closeNonsense(sender)
	}
	
	@IBAction func changeVocabView(sender: AnyObject) {
		vocabList.reloadData()
	}
	
	private var vocabSelectorSelected: VocabType {
		if let selectedCell = vocabSelector.selectedCell() {
			if let selectedConverted = VocabType(rawValue: selectedCell.tag) {
				return selectedConverted
			}
			/*
			if ([vocabSelector cellAtRow:0 column:0] == selectedCell) {
			return 0;
			} else if ([vocabSelector cellAtRow:1 column:0] == selectedCell) {
			return 1;
			} else if ([vocabSelector cellAtRow:2 column:0] == selectedCell) {
			return 2;
			} else if ([vocabSelector cellAtRow:3 column:0] == selectedCell) {
			return 3;
			} else if ([vocabSelector cellAtRow:4 column:0] == selectedCell) {
			return 4;
			} else if ([vocabSelector cellAtRow:5 column:0] == selectedCell) {
			return 5;
			} else if ([vocabSelector cellAtRow:6 column:0] == selectedCell) {
			return 6;
			} else {
			return -1;
			}
*/
		}
		return .None
	}
	
	public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		switch vocabSelectorSelected {
		case .SingularNoun:
			return controller.singularNouns.count
			
		case .PluralNoun:
			return controller.pluralNouns.count
			
		case .Adjective:
			return controller.adjectives.count
			
		case .Verb:
			return controller.verbs.count
			
		case .Adverb:
			return controller.adverbs.count
			
		case .MassiveNoun:
			return controller.massiveNouns.count
			
		case .ProperNoun:
			return controller.properNouns.count
			
		default:
			return 0
		}
	}
	
	public func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
		switch vocabSelectorSelected {
		case .SingularNoun:
			return controller.singularNouns[row]
			
		case .PluralNoun:
			return controller.pluralNouns[row]
			
		case .Adjective:
			return controller.adjectives[row]
			
		case .Verb:
			return controller.verbs[row].description
			
		case .Adverb:
			return controller.adverbs[row]
			
		case .MassiveNoun:
			return controller.massiveNouns[row]
			
		case .ProperNoun:
			return controller.properNouns[row]
			
		default:
			return nil
		}
	}

	@IBAction func removeSelectedWord(sender: AnyObject) {
		let rows = vocabList.selectedRowIndexes
		if rows.count == 0 {
			NSBeep()
			return
		}
		
		switch vocabSelectorSelected {
		case .SingularNoun:
			controller.removeSingularNouns(indexes: rows)
			
		case .PluralNoun:
			controller.removePluralNouns(indexes: rows)
			
		case .Adjective:
			controller.removeAdjectives(indexes: rows)
			
		case .Verb:
			controller.removeVerbs(indexes: rows)
			
		case .Adverb:
			controller.removeAdverbs(indexes: rows)
			
		case .MassiveNoun:
			controller.removeMassiveNouns(indexes: rows)
			
		case .ProperNoun:
			controller.removeProperNouns(indexes: rows)
			
		default:
			NSBeep()
		}
		vocabList.reloadData()
	}

	@IBAction func addWord(sender: AnyObject) {
		func completion(response: NSModalResponse) {
			self.vocabList.reloadData()
		}
		
		switch vocabSelectorSelected {
		case .SingularNoun:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "cat"
			wordToAdd.stringValue = "Singular Noun"
			configSheet.beginSheet(wordWindow, completionHandler: completion)
			
		case .PluralNoun:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "cats"
			wordToAdd.stringValue = "Plural Noun"
			configSheet.beginSheet(wordWindow, completionHandler: completion)

		case .Adjective:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "blue"
			wordToAdd.stringValue = "Adjective"
			configSheet.beginSheet(wordWindow, completionHandler: completion)
			
		case .Verb:
			configSheet.beginSheet(verbWindow, completionHandler: completion)
			
		case .Adverb:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "quickly"
			wordToAdd.stringValue = "Adverb"
			configSheet.beginSheet(wordWindow, completionHandler: completion)

		case .MassiveNoun:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "water"
			wordToAdd.stringValue = "Massive Noun"
			configSheet.beginSheet(wordWindow, completionHandler: completion)

		case .ProperNoun:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "Al Gore"
			wordToAdd.stringValue = "Proper Noun"
			configSheet.beginSheet(wordWindow, completionHandler: completion)
			
		default:
			NSBeep()
		}
	}

	private static var oursreensaverDefaults: dispatch_once_t = 0
	private static func ourSetDefaults() {
		let defaults = defaultsProvider()
		defaults.registerDefaults([NONSAtATime: 3, NONSDuration: 2.7, NONSBGColor: true])
	}
}
