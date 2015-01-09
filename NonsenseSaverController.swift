//
//  NonsenseSaverController.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/15/14.
//
//

import Foundation

#if os(OSX)
import Cocoa
import ScreenSaver
#endif
	
let NonsenseDefaultsKey = "com.github.maddthesane.NonsenseSaver"

let NONSSingularNounList = "Singular Nouns"
let NONSPluralNounList = "Plural Nouns"
let NONSAdjectiveList = "Adjectives"
let NONSVerbList = "Verbs"
let NONSAdverbList = "Adverb"
let NONSProperNounList = "Proper Nouns"
let NONSMassiveNounList = "Massive Nouns"
let NONSInterjections = "Interjections"

private var singleDefaults: dispatch_once_t = 0

internal func randObject<X>(anArray: [X]) -> X {
	let aRand = Int(arc4random_uniform(UInt32(anArray.count)))
	return anArray[aRand]
}

private func PrepareVerbsForSaving(toSave: [Verb]) -> [[String: String]] {
	func PrepareVerbForSaving(toSave: Verb) -> [String: String] {
		return [ThirdPersonPast: toSave.thirdPersonPast,
			ThirdPersonSinglePresent : toSave.thirdPersonSinglePresent,
			ThirdPersonPluralPresent : toSave.thirdPersonPluralPresent,
			ThirdPersonPastPerfect : toSave.thirdPersonPastPerfect,
			ThirdPersonPresentCont : toSave.thirdPersonPresentCont]
	}

	var theArray = [[String: String]]()
	for i in toSave{
		theArray.append(PrepareVerbForSaving(i))
	}
	return theArray
}

private func GetVerbsFromSaved(theSaved: [[String: String]]) -> [Verb] {
	func GetVerbFromSaved(theSaved: [String: String]) -> Verb {
		return Verb(singlePresent: theSaved[ThirdPersonSinglePresent]!, pluralPresent: theSaved[ThirdPersonPluralPresent]!, past: theSaved[ThirdPersonPast]!, pastPerfect: theSaved[ThirdPersonPastPerfect]!, presentCont: theSaved[ThirdPersonPresentCont]!)
	}
	
	var theArray = [Verb]()
	
	for i in theSaved {
		theArray.append(GetVerbFromSaved(i))
	}
	
	return theArray
}

private func defaultsProvider() -> NSUserDefaults {
#if os(iOS)
	return NSUserDefaults.standardUserDefaults()
#else
	return ScreenSaverDefaults.defaultsForModuleWithName(NonsenseDefaultsKey) as ScreenSaverDefaults
#endif
}

class NonsenseSaverController: NSObject {
	private(set) dynamic var verbs = [Verb]()
	private(set) dynamic var pluralNouns = [String]()
	private(set) dynamic var singularNouns = [String]()
	private(set) dynamic var properNouns = [String]()
	private(set) dynamic var adverbs = [String]()
	private(set) dynamic var adjectives = [String]()
	private(set) dynamic var massiveNouns = [String]()
	
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
	
	private func setDefaults() {
		dispatch_once(&singleDefaults) {
			let ourClass = NSBundle(forClass: self.dynamicType)
			let defaults = defaultsProvider()
			if let defaultsURL = ourClass.URLForResource("Defaults", withExtension: "plist") {
				if let ourDict = NSDictionary(contentsOfURL: defaultsURL) {
					defaults.registerDefaults(ourDict)
				}
			}
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
		verbs += GetVerbsFromSaved(defaults.arrayForKey(NONSVerbList) as [[String: String]])
		pluralNouns += defaults.arrayForKey(NONSPluralNounList) as [String]
		singularNouns += defaults.arrayForKey(NONSSingularNounList) as [String]
		properNouns += defaults.arrayForKey(NONSProperNounList) as [String]
		adverbs += defaults.arrayForKey(NONSAdverbList) as [String]
		adjectives += defaults.arrayForKey(NONSAdjectiveList) as [String]
		massiveNouns += defaults.arrayForKey(NONSMassiveNounList) as [String]
	}
	
	// Simple test to see if a noun ends with an 's'
	private func nounOwningObject(theNoun: String) -> String {
		var endNounPos = theNoun.endIndex
		endNounPos--
		let endNounChar = theNoun[endNounPos]
		switch endNounChar {
		case "s":
			return theNoun + "'"
			
		default:
			return theNoun + "'s"
		}
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
		//FIXME: this is where it falls short. There needs to be a better way of generating nonsense than the one that I'm using right here.
		let casenum: UInt32 = arc4random_uniform(12)
		var nonsensestring: String
		switch (casenum) {
		case 0:
			nonsensestring = "The \(randomAdjective()) \(randomPluralNoun()), while \(randomVerb().thirdPersonPresentCont), \(randomVerb().thirdPersonPast) \(randomAdverb())."
			
		case 1:
			nonsensestring = "The \(randomSingularNoun()) \(randomVerb().thirdPersonPast) \(randomAdverb())"
			
		case 2:
			nonsensestring = "The \(randomPluralNoun()), while \(randomVerb().thirdPersonPresentCont), \(randomVerb().thirdPersonPast)."
			
		case 3:
			nonsensestring = "\(randomProperNoun()) \(randomVerb().thirdPersonPast) the \(randomSingularNoun()) \(randomAdverb())."
			
		case 4:
			nonsensestring = "The \(randomAdjective()) \(randomPluralNoun()), while \(randomVerb().thirdPersonPresentCont), \(randomVerb().thirdPersonPast) \(randomMassiveNoun())."
			
		case 5:
			nonsensestring = "Can't a \(randomSingularNoun()) have \(randomVerb().thirdPersonPastPerfect)?"
			
		case 6:
			nonsensestring = "They \(randomAdverb()) \(randomVerb().thirdPersonPast) \(randomPronoun())."
			
		case 7:
			nonsensestring = "Can \(randomMassiveNoun()), who musn't have \(randomVerb().thirdPersonPastPerfect), \(randomVerb().thirdPersonPluralPresent) \(randomAdverb())?"
			
		case 8:
			nonsensestring = "The \(randomAdjective()) \(randomPluralNoun()), while \(randomVerb().thirdPersonPresentCont), \(randomVerb().thirdPersonPast) \(randomMassiveNoun()) \(randomAdverb())."
			
		case 9:
			nonsensestring = "Must you \(randomVerb().thirdPersonPluralPresent) \(randomAdverb())?"
			
		case 10:
			nonsensestring = "The \(randomAdjective()) \(randomAdjective()) \(randomSingularNoun()) \(randomVerb().thirdPersonSinglePresent) \(randomAdverb())."
			
		case 11:
			nonsensestring = "\(nounOwningObject(randomProperNoun())) \(randomPluralNoun()) hadn't \(randomVerb().thirdPersonPast)."
			
		default:
			nonsensestring = "The developer's brain farted \(randomAdverb()), producing this error.";
			break;
		}
		return nonsensestring;
	}

	func saveSettings() {
		let defaults = defaultsProvider()
		defaults.setObject(PrepareVerbsForSaving(verbs), forKey: NONSVerbList)
		defaults.setObject(pluralNouns, forKey: NONSPluralNounList)
		defaults.setObject(singularNouns, forKey: NONSSingularNounList)
		defaults.setObject(properNouns, forKey: NONSProperNounList)
		defaults.setObject(adverbs, forKey: NONSAdverbList)
		defaults.setObject(adjectives, forKey: NONSAdjectiveList)
		defaults.setObject(massiveNouns, forKey: NONSMassiveNounList)
		defaults.synchronize()
	}
	
	func addVerb(verb: Verb) {
		let curIdx = NSIndexSet(index: verbs.count)
		self.willChange(.Insertion, valuesAtIndexes: curIdx, forKey: "verbs")
		verbs.append(verb)
		self.didChange(.Insertion, valuesAtIndexes: curIdx, forKey: "verbs")
	}
	
	func addPluralNoun(pluralNoun: String) {
		let curIdx = NSIndexSet(index: pluralNouns.count)
		self.willChange(.Insertion, valuesAtIndexes: curIdx, forKey: "pluralNouns")
		pluralNouns.append(pluralNoun)
		self.didChange(.Insertion, valuesAtIndexes: curIdx, forKey: "pluralNouns")
	}
	
	func addSingularNoun(singularNoun: String) {
		let curIdx = NSIndexSet(index: singularNouns.count)
		self.willChange(.Insertion, valuesAtIndexes: curIdx, forKey: "singularNouns")
		singularNouns.append(singularNoun)
		self.didChange(.Insertion, valuesAtIndexes: curIdx, forKey: "singularNouns")
	}
	
	func addProperNoun(properNoun: String) {
		let curIdx = NSIndexSet(index: properNouns.count)
		self.willChange(.Insertion, valuesAtIndexes: curIdx, forKey: "properNouns")
		properNouns.append(properNoun)
		self.didChange(.Insertion, valuesAtIndexes: curIdx, forKey: "properNouns")
	}
	
	func addAdverb(adverb: String) {
		let curIdx = NSIndexSet(index: properNouns.count)
		self.willChange(.Insertion, valuesAtIndexes: curIdx, forKey: "properNouns")
		adverbs.append(adverb)
		self.didChange(.Insertion, valuesAtIndexes: curIdx, forKey: "properNouns")
	}
	
	func addAdjective(adjective: String) {
		let curIdx = NSIndexSet(index: adjectives.count)
		self.willChange(.Insertion, valuesAtIndexes: curIdx, forKey: "adjectives")
		adjectives.append(adjective)
		self.didChange(.Insertion, valuesAtIndexes: curIdx, forKey: "adjectives")
	}
	
	func addMassiveNoun(massiveNoun: String) {
		let curIdx = NSIndexSet(index: massiveNouns.count)
		self.willChange(.Insertion, valuesAtIndexes: curIdx, forKey: "massiveNouns")
		massiveNouns.append(massiveNoun)
		self.didChange(.Insertion, valuesAtIndexes: curIdx, forKey: "massiveNouns")
	}
	
	@objc(removeVerbsAtIndexes:) func removeVerbs(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "verbs")
		for var i = indexes.lastIndex; i != NSNotFound; i = indexes.indexLessThanIndex(i) {
			verbs.removeAtIndex(i)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "verbs")
	}
	
	@objc(removePluralNounsAtIndexes:) func removePluralNouns(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "pluralNouns")
		for var i = indexes.lastIndex; i != NSNotFound; i = indexes.indexLessThanIndex(i) {
			pluralNouns.removeAtIndex(i)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "pluralNouns")
	}
	
	@objc(removeSingularNounsAtIndexes:) func removeSingularNouns(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "singularNouns")
		for var i = indexes.lastIndex; i != NSNotFound; i = indexes.indexLessThanIndex(i) {
			singularNouns.removeAtIndex(i)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "singularNouns")
	}
	
	@objc(removeProperNounsAtIndexes:) func removeProperNouns(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "properNouns")
		for var i = indexes.lastIndex; i != NSNotFound; i = indexes.indexLessThanIndex(i) {
			properNouns.removeAtIndex(i)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "properNouns")
	}
	
	@objc(removeAdverbsAtIndexes:) func removeAdverbs(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "adverbs")
		for var i = indexes.lastIndex; i != NSNotFound; i = indexes.indexLessThanIndex(i) {
			adverbs.removeAtIndex(i)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "adverbs")
	}
	
	@objc(removeAdjectivesAtIndexes:) func removeAdjectives(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "adjectives")
		for var i = indexes.lastIndex; i != NSNotFound; i = indexes.indexLessThanIndex(i) {
			adjectives.removeAtIndex(i)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "adjectives")
	}
	
	@objc(removeMassiveNounsAtIndexes:) func removeMassiveNouns(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "massiveNouns")
		for var i = indexes.lastIndex; i != NSNotFound; i = indexes.indexLessThanIndex(i) {
			massiveNouns.removeAtIndex(i)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "massiveNouns")
	}
	
	@objc(removeVerbsInArray:) func removeVerbs(array arrays: [Verb]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = find(verbs, aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeVerbs(indexes: idxSet)
	}
	
	@objc(removePluralNounsInArray:) func removePluralNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = find(pluralNouns, aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removePluralNouns(indexes: idxSet)
	}
	
	@objc(removeSingularNounsInArray:) func removeSingularNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = find(singularNouns, aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeSingularNouns(indexes: idxSet)
	}
	
	@objc(removeProperNounsInArray:) func removeProperNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = find(properNouns, aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeProperNouns(indexes: idxSet)
	}
	
	@objc(removeAdverbsInArray:) func removeAdverbs(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = find(adverbs, aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeAdverbs(indexes: idxSet)
	}
	
	@objc(removeAdjectivesInArray:) func removeAdjectives(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = find(adjectives, aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeAdjectives(indexes: idxSet)
	}
	
	@objc(removeMassiveNounsInArray:) func removeMassiveNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = find(massiveNouns, aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeMassiveNouns(indexes: idxSet)
	}
}
