//
//  NONSVerb.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/15/14.
//
//

import Foundation

let ThirdPersonSinglePresent = "ThirdPersonSinglePresent";
let ThirdPersonPluralPresent = "ThirdPersonPluralPresent";
let ThirdPersonPast = "ThirdPersonPast";
let ThirdPersonPastPerfect = "ThirdPersonPastPerfect";
let ThirdPersonPresentCont = "ThirdPersonPresentCont";

func ==(lhs: Verb, rhs: Verb) -> Bool {
	if lhs.thirdPersonPast != rhs.thirdPersonPast {
		return false
	}
	if lhs.thirdPersonSinglePresent != rhs.thirdPersonSinglePresent {
		return false
	}
	if lhs.thirdPersonPluralPresent != rhs.thirdPersonPluralPresent {
		return false
	}
	if rhs.thirdPersonPastPerfect != lhs.thirdPersonPastPerfect {
		return false
	}
	if lhs.thirdPersonPresentCont != rhs.thirdPersonPresentCont {
		return false
	}
	return true
}

class Verb: Hashable {
	let thirdPersonSinglePresent: String
	let thirdPersonPluralPresent: String
	let thirdPersonPast: String
	let thirdPersonPastPerfect: String
	let thirdPersonPresentCont: String
	
	var hashValue: Int {
		return ThirdPersonPast.hashValue ^ thirdPersonPastPerfect.hashValue ^ thirdPersonPluralPresent.hashValue ^
			thirdPersonPresentCont.hashValue ^ thirdPersonSinglePresent.hashValue
	}
	
	init(singlePresent: String, pluralPresent: String, past: String, pastPerfect: String, presentCont: String) {
		thirdPersonSinglePresent = singlePresent;
		thirdPersonPluralPresent = pluralPresent;
		thirdPersonPast = past;
		thirdPersonPastPerfect = pastPerfect;
		thirdPersonPresentCont = presentCont;
	}

	private init(privateInit: ()) {
		thirdPersonSinglePresent = ""
		thirdPersonPluralPresent = "";
		thirdPersonPast = ""
		thirdPersonPastPerfect = ""
		thirdPersonPresentCont = ""
	}
	
	convenience init?(array: [String]) {
		if (array.count < 5) {
			NSLog("Array is too small! Not initializing!");

			self.init(privateInit: ())
			return nil;
		} else if (array.count > 5) {
			NSLog("Array is too big! Ignoring other values")
		}
		
		self.init(singlePresent: array[0], pluralPresent: array[1], past: array[2], pastPerfect: array[3], presentCont: array[4])
	}
}

