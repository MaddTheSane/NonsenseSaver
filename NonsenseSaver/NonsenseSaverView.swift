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
	case none = 0
	case singularNoun = 1
	case pluralNoun = 2
	case verb = 3
	case properNoun = 4
	case adjective = 5
	case adverb = 6
	case massiveNoun = 7
}

open class NonsenseSaverView: ScreenSaverView, NSTableViewDataSource {
	dynamic var maxNonsenses: Int = 3
	dynamic var nonsenseDuration: TimeInterval = 2.7
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
	fileprivate var nibArray: NSArray? = nil
	
	public override init?(frame: NSRect, isPreview: Bool) {
		_=NonsenseSaverView.ourSetDefaults
		srandom(UInt32(time(nil) & 0x7FFFFFFF))

		super.init(frame: frame, isPreview: isPreview)
		
		let defaults = defaultsProvider()
		maxNonsenses = defaults.integer(forKey: NONSAtATime)
		nonsenseDuration = defaults.double(forKey: NONSDuration)
		showBackground = defaults.bool(forKey: NONSBGColor)
		animationTimeInterval = nonsenseDuration
		
		var theFont: NSFont
		if isPreview {
			theFont = NSFont.systemFont(ofSize: kPreviewFontSize)
		} else {
			theFont = NSFont.systemFont(ofSize: kFullFontSize)
		}

		for _ in 0..<maxNonsenses {
			let non = NonsenseObject(string: controller.randomSaying(), bounds: self.bounds, font: theFont)
			nonsenses.append(non)
		}
	}
	
	open override func hasConfigureSheet() -> Bool {
		return true
	}
	
	open override func configureSheet() -> NSWindow? {
		if configSheet == nil {
			let ourBundle = Bundle(for: type(of: self))
			ourBundle.loadNibNamed("NonsenseSettings", owner: self, topLevelObjects: &nibArray!)
			if let creditsPath = ourBundle.path(forResource: "Credits", ofType: "rtf") {
				credits.readRTFD(fromFile: creditsPath)
			}
		}
		return configSheet
	}
	
	open override func animateOneFrame() {
		needsDisplay = true
	}
	
	public required init?(coder: NSCoder) {
		srandom(UInt32(time(nil) & 0x7FFFFFFF))
		_=NonsenseSaverView.ourSetDefaults

		super.init(coder: coder)
	}
	
    open override func draw(_ dirtyRect: NSRect) {
		//Clear the screen
        super.draw(dirtyRect)

		var theFont: NSFont
		if isPreview {
			theFont = NSFont.systemFont(ofSize: kPreviewFontSize)
		} else {
			theFont = NSFont.systemFont(ofSize: kFullFontSize)
		}
		for obj in nonsenses {
			obj.draw(background: showBackground)
		}
		nonsenses.remove(at: 0)
		let non = NonsenseObject(string: controller.randomSaying(), bounds: bounds, font:theFont)
		nonsenses.append(non)
    }
	
	fileprivate func clearVerbWindow() {
		fieldThirdPersonSinglePresent.stringValue = ""
		fieldThirdPersonPluralPresent.stringValue = ""
		fieldThirdPersonPast.stringValue = ""
		fieldThirdPersonPastPerfect.stringValue = ""
		fieldThirdPersonPresentCont.stringValue = ""
	}
	
	fileprivate func clearWordWindow() {
		fieldWord.stringValue = ""
	}
	
	@IBAction func okayAddNonsensePart(_ sender: NSButton?) {
		if sender?.window === wordWindow {
			let tmpFieldWord = fieldWord.stringValue.trimmingCharacters(in: CharacterSet.whitespaces)
			if tmpFieldWord == "" {
				let noVerb = NSAlert()
				noVerb.messageText = "No Word"
				noVerb.informativeText = "Please enter a word."
				noVerb.beginSheetModal(for: wordWindow, completionHandler: nil)
				return
			}
			
			switch vocabSelectorSelected {
			case .singularNoun:
				controller.addSingularNoun(tmpFieldWord)
				
			case .pluralNoun:
				controller.addPluralNoun(tmpFieldWord)
				
			case .adjective:
				controller.addAdjective(tmpFieldWord)
				
			case .adverb:
				controller.addAdverb(tmpFieldWord)
				
			case .massiveNoun:
				controller.addMassiveNoun(tmpFieldWord)
				
			case .properNoun:
				controller.addProperNoun(tmpFieldWord)
				
			default:
				break;
			}
			
			configSheet.endSheet(wordWindow)
			clearWordWindow()
			wordWindow.orderOut(sender)
		} else if sender?.window === verbWindow {
			var i = 0
			let thirdPersSingPres	= fieldThirdPersonSinglePresent.stringValue.trimmingCharacters(in: CharacterSet.whitespaces)
			let thirdPersPlurPres	= fieldThirdPersonPluralPresent.stringValue.trimmingCharacters(in: CharacterSet.whitespaces)
			let thirdPersPas		= fieldThirdPersonPast.stringValue.trimmingCharacters(in: CharacterSet.whitespaces)
			let thirPersPasPer		= fieldThirdPersonPastPerfect.stringValue.trimmingCharacters(in: CharacterSet.whitespaces)
			let thirPersPresCont	= fieldThirdPersonPresentCont.stringValue.trimmingCharacters(in: CharacterSet.whitespaces)
			
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
				noVerb.beginSheetModal(for: verbWindow, completionHandler: nil)
			}
		}
	}
	
	@IBAction func cancelAddNonsensePart(_ sender: NSButton?) {
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
	
	@IBAction func closeNonsense(_ sender: AnyObject?) {
		let defaults = ScreenSaverDefaults(forModuleWithName: NonsenseDefaultsKey)!
		if let respSender = sender as? NSControl {
			if respSender.tag != 1 {
				controller.saveSettings()
				defaults.set(maxNonsenses, forKey: NONSAtATime)
				defaults.set(nonsenseDuration, forKey: NONSDuration)
				defaults.set(showBackground, forKey: NONSBGColor)
				defaults.synchronize()
				animationTimeInterval = nonsenseDuration
				
				nonsenses.removeAll()
				
				for _ in 0..<maxNonsenses {
					let non = NonsenseObject(string: controller.randomSaying(), bounds: bounds, font: NSFont.systemFont(ofSize: kPreviewFontSize))
					nonsenses.append(non)
				}
			} else {
				//Clear settings by re-loading them
				controller.loadSettings()
				self.maxNonsenses = defaults.integer(forKey: NONSAtATime)
				self.nonsenseDuration = defaults.double(forKey: NONSDuration)
				self.showBackground = defaults.bool(forKey: NONSBGColor)
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

	@IBAction func okayNonsense(_ sender: AnyObject?) {
		closeNonsense(sender)
	}
	
	@IBAction func cancelNonsense(_ sender: NSButton?) {
		closeNonsense(sender)
	}
	
	@IBAction func changeVocabView(_ sender: AnyObject) {
		vocabList.reloadData()
	}
	
	fileprivate var vocabSelectorSelected: VocabType {
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
		return .none
	}
	
	open func numberOfRows(in tableView: NSTableView) -> Int {
		switch vocabSelectorSelected {
		case .singularNoun:
			return controller.singularNouns.count
			
		case .pluralNoun:
			return controller.pluralNouns.count
			
		case .adjective:
			return controller.adjectives.count
			
		case .verb:
			return controller.verbs.count
			
		case .adverb:
			return controller.adverbs.count
			
		case .massiveNoun:
			return controller.massiveNouns.count
			
		case .properNoun:
			return controller.properNouns.count
			
		default:
			return 0
		}
	}
	
	open func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		switch vocabSelectorSelected {
		case .singularNoun:
			return controller.singularNouns[row]
			
		case .pluralNoun:
			return controller.pluralNouns[row]
			
		case .adjective:
			return controller.adjectives[row]
			
		case .verb:
			return controller.verbs[row].description
			
		case .adverb:
			return controller.adverbs[row]
			
		case .massiveNoun:
			return controller.massiveNouns[row]
			
		case .properNoun:
			return controller.properNouns[row]
			
		default:
			return nil
		}
	}

	@IBAction func removeSelectedWord(_ sender: AnyObject) {
		let rows = vocabList.selectedRowIndexes
		if rows.count == 0 {
			NSBeep()
			return
		}
		
		switch vocabSelectorSelected {
		case .singularNoun:
			controller.removeSingularNouns(indexes: rows)
			
		case .pluralNoun:
			controller.removePluralNouns(indexes: rows)
			
		case .adjective:
			controller.removeAdjectives(indexes: rows)
			
		case .verb:
			controller.removeVerbs(indexes: rows)
			
		case .adverb:
			controller.removeAdverbs(indexes: rows)
			
		case .massiveNoun:
			controller.removeMassiveNouns(indexes: rows)
			
		case .properNoun:
			controller.removeProperNouns(indexes: rows)
			
		default:
			NSBeep()
		}
		vocabList.reloadData()
	}

	@IBAction func addWord(_ sender: AnyObject) {
		func completion(_ response: NSModalResponse) {
			self.vocabList.reloadData()
		}
		
		switch vocabSelectorSelected {
		case .singularNoun:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "cat"
			wordToAdd.stringValue = "Singular Noun"
			configSheet.beginSheet(wordWindow, completionHandler: completion)
			
		case .pluralNoun:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "cats"
			wordToAdd.stringValue = "Plural Noun"
			configSheet.beginSheet(wordWindow, completionHandler: completion)

		case .adjective:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "blue"
			wordToAdd.stringValue = "Adjective"
			configSheet.beginSheet(wordWindow, completionHandler: completion)
			
		case .verb:
			configSheet.beginSheet(verbWindow, completionHandler: completion)
			
		case .adverb:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "quickly"
			wordToAdd.stringValue = "Adverb"
			configSheet.beginSheet(wordWindow, completionHandler: completion)

		case .massiveNoun:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "water"
			wordToAdd.stringValue = "Massive Noun"
			configSheet.beginSheet(wordWindow, completionHandler: completion)

		case .properNoun:
			(fieldWord.cell as? NSTextFieldCell)?.placeholderString = "Al Gore"
			wordToAdd.stringValue = "Proper Noun"
			configSheet.beginSheet(wordWindow, completionHandler: completion)
			
		default:
			NSBeep()
		}
	}

	fileprivate static var ourSetDefaults: Void = {
		let defaults = defaultsProvider()
		defaults.register(defaults: [NONSAtATime: 3, NONSDuration: 2.7, NONSBGColor: true])
	}()
}
