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
	return false
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
			//NSLog("Array %@ too small! Not initializing!", array);

			self.init(privateInit: ())
			return nil;
		} else if (array.count > 5) {
			NSLog("Array %@ too big! Ignoring other values.", array);
		}
		
		self.init(singlePresent: array[0], pluralPresent: array[1], past: array[2], pastPerfect: array[3], presentCont: array[4])
		//return [self initWithSinglePresent:array[0] pluralPresent:array[1] past:array[2] pastPerfect:array[3] presentCont:array[4]];
	}
}

