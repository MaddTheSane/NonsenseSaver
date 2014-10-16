//
//  NonsenseSaverController.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/15/14.
//
//

import Cocoa
import ScreenSaver

let NONSSingularNounList = "Singular Nouns"
let NONSPluralNounList = "Plural Nouns"
let NONSAdjectiveList = "Adjectives"
let NONSVerbList = "Verbs"
let NONSAdverbList = "Adverb"
let NONSProperNounList = "Proper Nouns"
let NONSMassiveNounList = "Massive Nouns"
let NONSInterjections = "Interjections"

private var singleDefaults: dispatch_once_t = 0

private func randObject<X>(anArray: [X]) -> X {
	return anArray[random() % anArray.count]
}

class NonsenseSaverController: NSObject {
	private(set) dynamic var verbs = [Verb]()
	private(set) dynamic var pluralNouns = [String]()
	private(set) dynamic var singularNouns = [String]()
	private(set) dynamic var properNouns = [String]()
	private(set) dynamic var adverbs = [String]()
	private(set) dynamic var adjectives = [String]()
	private(set) dynamic var massiveNouns = [String]()
	
	private class func prepareVerbForSaving(toSave: Verb) -> [String: String] {
		return [ThirdPersonPast: toSave.thirdPersonPast,
			ThirdPersonSinglePresent : toSave.thirdPersonSinglePresent,
			ThirdPersonPluralPresent : toSave.thirdPersonPluralPresent,
			ThirdPersonPastPerfect : toSave.thirdPersonPastPerfect,
			ThirdPersonPresentCont : toSave.thirdPersonPresentCont]
	}
	
	private class func getVerbFromSaved(theSaved: [String: String]) -> Verb {
		return Verb(singlePresent: theSaved[ThirdPersonSinglePresent]!, pluralPresent: theSaved[ThirdPersonPluralPresent]!, past: theSaved[ThirdPersonPast]!, pastPerfect: theSaved[ThirdPersonPastPerfect]!, presentCont: theSaved[ThirdPersonPresentCont]!)
	}
	
	let pronouns = ["him", "her", "it", "them"]
	let conjugates = ["and", "but", "or", "yet", "so", "because"]
	let amounts = ["excruciatingly", "extremely", "marginally", "possibly", "quite", "really", "slightly", "somewhat", "totally", "very"]
	let relativeAdjectives = ["however", "nevertheless", "therefore", "and yet"]
	let determiners = ["a", "one", "some", "that", "the", "this"];
	let comparatives = ["more", "less", "far more", "far less", "much more", "much less", "the same"]

	override init() {
		super.init()
		
		setDefaults()
		loadSettings()
	}
	
	private class func getVerbsFromSaved(theSaved: [[String: String]]) -> [Verb] {
		var theArray = [Verb]()
		
		for i in theSaved {
			theArray.append(getVerbFromSaved(i))
		}
		
		return theArray
	}
	
	func defaultsProvider() -> NSUserDefaults {
	#if os(iOS)
		return NSUserDefaults.standardUserDefaults()
	#else
		return ScreenSaverDefaults.defaultsForModuleWithName(NonsenseDefaultsKey) as ScreenSaverDefaults
	#endif
	}
	
	private func setDefaults() {
		dispatch_once(&singleDefaults) {
			let ourClass = NSBundle(forClass: self.dynamicType)
			let defaults = self.defaultsProvider()
			let ourDict = NSDictionary(contentsOfURL: ourClass.URLForResource("Defaults", withExtension: "plist")!)!
			
			defaults.registerDefaults(ourDict)
		}
	}
	
	func loadSettings() {
		let defaults = defaultsProvider()
		//Clear any old values
		verbs.removeAll(keepCapacity: true)
		pluralNouns.removeAll(keepCapacity: true)
		singularNouns.removeAll(keepCapacity: true)
		properNouns.removeAll(keepCapacity: true)
		adverbs.removeAll(keepCapacity: true)
		adjectives.removeAll(keepCapacity: true)
		massiveNouns.removeAll(keepCapacity: true)
		
		//load values from settings.
		verbs += NonsenseSaverController.getVerbsFromSaved(defaults.arrayForKey(NONSVerbList) as [[String: String]])
		pluralNouns += defaults.arrayForKey(NONSPluralNounList) as [String]
		singularNouns += defaults.arrayForKey(NONSSingularNounList) as [String]
		properNouns += defaults.arrayForKey(NONSProperNounList) as [String]
		adverbs += defaults.arrayForKey(NONSAdverbList) as [String]
		adjectives += defaults.arrayForKey(NONSAdjectiveList) as [String]
		massiveNouns += defaults.arrayForKey(NONSMassiveNounList) as [String]
	}
	
	func randomVerb() -> Verb {
		return randObject(verbs);
	}
	
	func randomPluralNoun() -> String {
		return randObject(pluralNouns);
	}
	
	func randomSingularNoun() -> String {
		return randObject(singularNouns);
	}
	
	func randomProperNoun() -> String {
		return randObject(properNouns);
	}
	
	func randomAdverb() -> String {
		return randObject(adverbs);
	}
	
	func randomAdjective() -> String {
		return randObject(adjectives);
	}
	
	func randomMassiveNoun() -> String {
		return randObject(massiveNouns);
	}
	
	func randomPronoun() -> String {
		return randObject(pronouns);
	}
	
	func randomConjugate() -> String {
		return randObject(conjugates);
	}
	
	func randomAmount() -> String {
		return randObject(amounts);
	}
	
	func randomRelativeAdjective() -> String {
		return randObject(relativeAdjectives);
	}
	
	func randomDeterminer() -> String {
		return randObject(determiners);
	}
	
	func randomComparative() -> String {
		return randObject(comparatives);
	}

	func randomNoun() -> String {
		return (random() % 2) == 1  ? randomSingularNoun() : randomProperNoun()
	}
	
	func randomSaying() -> String {
		return "The developer's brain farted \(randomAdverb()), causing this error"
	}

	func saveSettings() {

	}

}
