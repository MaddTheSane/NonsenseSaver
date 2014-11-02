//
//  AppController.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 11/2/14.
//
//

import Cocoa

@NSApplicationMain
class AppController: NSObject, NSApplicationDelegate {
	@IBOutlet weak var nonsenseView: NonsenseView?
	@IBOutlet weak var userGeneratedNonsense: NSTextField?
	
	@IBAction func generateNonsense(sender: AnyObject?) {
		if let ourStr = nonsenseView?.nonsenseController.randomSaying() {
			userGeneratedNonsense?.stringValue = ourStr
		}
	}
}
