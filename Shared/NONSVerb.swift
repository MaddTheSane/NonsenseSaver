//
//  NONSVerb.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/15/14.
//
//

import Foundation

let ThirdPersonSinglePresentKey = "ThirdPersonSinglePresent";
let ThirdPersonPluralPresentKey = "ThirdPersonPluralPresent";
let ThirdPersonPastKey = "ThirdPersonPast";
let ThirdPersonPastPerfectKey = "ThirdPersonPastPerfect";
let ThirdPersonPresentContKey = "ThirdPersonPresentCont";

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

final class Verb: NSObject {
	let thirdPersonSinglePresent: String
	let thirdPersonPluralPresent: String
	let thirdPersonPast: String
	let thirdPersonPastPerfect: String
	let thirdPersonPresentCont: String
	
	override var hash: Int {
		var hash = Hasher()
		thirdPersonPast.hash(into: &hash)
		thirdPersonPastPerfect.hash(into: &hash)
		thirdPersonPluralPresent.hash(into: &hash)
		thirdPersonPresentCont.hash(into: &hash)
		thirdPersonSinglePresent.hash(into: &hash)
		return hash.finalize()
	}
	
	override var description: String {
		return thirdPersonPluralPresent
	}
	
	init(singlePresent: String, pluralPresent: String, past: String, pastPerfect: String, presentCont: String) {
		thirdPersonSinglePresent = singlePresent;
		thirdPersonPluralPresent = pluralPresent;
		thirdPersonPast = past;
		thirdPersonPastPerfect = pastPerfect;
		thirdPersonPresentCont = presentCont;
		super.init()
	}

	override func isEqual(_ object: Any?) -> Bool {
		if let objectVerb = object as? Verb {
			return self == objectVerb
		}
		
		return false
	}
	
	private init(privateInit: ()) {
		thirdPersonSinglePresent = ""
		thirdPersonPluralPresent = ""
		thirdPersonPast = ""
		thirdPersonPastPerfect = ""
		thirdPersonPresentCont = ""
		super.init()
	}
	
	convenience init?(array: [String]) {
		if (array.count < 5) {
			print("Array is too small! Not initializing!");

			self.init(privateInit: ())
			return nil;
		} else if (array.count > 5) {
			print("Array is too big! Ignoring other values")
		}
		
		self.init(singlePresent: array[0], pluralPresent: array[1], past: array[2], pastPerfect: array[3], presentCont: array[4])
	}
}

