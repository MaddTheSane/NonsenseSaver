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
			refreshRate = Timer(timeInterval: TimeInterval(nonDuration), target: self, selector: #selector(NonsenseView.reloadScreen(_:)), userInfo:nil, repeats: true)
			RunLoop.main.add(refreshRate!, forMode: RunLoopMode.commonModes)
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
	private var refreshRate: Timer! = nil

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		let theFont = NSFont.systemFont(ofSize: kPreviewFontSize)
		if settingsChanged {
			settingsChanged = false
		} else {
			nonsenses.removeFirst()
			let non = NonsenseObject(string: nonsenseController.randomSaying(), bounds: self.bounds, font: theFont)
			nonsenses.append(non)
		}
		for obj in nonsenses {
			obj.draw(background: showBackground)
		}
	}
	
	func populateNonsenses() {
		let theFont = NSFont.systemFont(ofSize: kPreviewFontSize)
		for _ in 0 ..< nonNumber {
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
	
	@objc(reloadScreen:) private func reloadScreen(_ theTime: Timer?) {
		self.needsDisplay = true
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		refreshRate = Timer(timeInterval: TimeInterval(nonDuration), target: self, selector: #selector(NonsenseView.reloadScreen(_:)), userInfo:nil, repeats: true)
		RunLoop.main.add(refreshRate!, forMode: RunLoopMode.commonModes)
	}
	
}
