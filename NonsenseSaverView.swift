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

class NonsenseSaverView: ScreenSaverView {

	override init(frame: NSRect, isPreview: Bool) {
		srandom(UInt32(time(nil) & 0xFFFFFFFF))

		super.init(frame: frame, isPreview: isPreview)
	}

	required init?(coder: NSCoder) {
		
		super.init(coder: coder)
	}
	
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
