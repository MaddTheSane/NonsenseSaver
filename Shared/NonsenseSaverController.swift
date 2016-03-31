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

/// Get a random object in an array
internal func randObject<X>(anArray: [X]) -> X {
	let aRand = Int(arc4random_uniform(UInt32(anArray.count)))
	return anArray[aRand]
}

private func PrepareVerbsForSaving(toSave: [Verb]) -> [[String: String]] {
	func PrepareVerbForSaving(toSave: Verb) -> [String: String] {
		return [ThirdPersonPastKey: toSave.thirdPersonPast,
			ThirdPersonSinglePresentKey : toSave.thirdPersonSinglePresent,
			ThirdPersonPluralPresentKey : toSave.thirdPersonPluralPresent,
			ThirdPersonPastPerfectKey : toSave.thirdPersonPastPerfect,
			ThirdPersonPresentContKey : toSave.thirdPersonPresentCont]
	}

	let theArray:[[String: String]] = toSave.map {PrepareVerbForSaving($0)}
	
	return theArray
}

private func GetVerbsFromSaved(theSaved: [[String: String]]) -> [Verb] {
	func GetVerbFromSaved(theSaved1: [String: String]) -> Verb? {
		if let singPres = theSaved1[ThirdPersonSinglePresentKey], pluralPres = theSaved1[ThirdPersonPluralPresentKey],
			pas = theSaved1[ThirdPersonPastKey], pasPerfect = theSaved1[ThirdPersonPastPerfectKey],
			presCont = theSaved1[ThirdPersonPresentContKey] {
				return Verb(singlePresent: singPres, pluralPresent: pluralPres, past: pas, pastPerfect: pasPerfect, presentCont: presCont)
		}
		return nil
	}
	
	var theArray = [Verb]()
	theArray.reserveCapacity(theSaved.count)
	
	for i in theSaved {
		if let aVerb = GetVerbFromSaved(i) {
			theArray.append(aVerb)
		}
	}
	
	return theArray
}

internal func defaultsProvider() -> NSUserDefaults {
#if os(iOS)
	return NSUserDefaults.standardUserDefaults()
#else
	return ScreenSaverDefaults(forModuleWithName: NonsenseDefaultsKey)!
#endif
}

internal class NonsenseSaverController: NSObject {
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

	private static var singleDefaults: dispatch_once_t = 0

	
	override init() {
		super.init()
		
		dispatch_once(&NonsenseSaverController.singleDefaults) {
			let ourClass = NSBundle(forClass: self.dynamicType)
			let defaults = defaultsProvider()
			if let defaultsURL = ourClass.URLForResource("Defaults", withExtension: "plist") {
				if let ourDict = NSDictionary(contentsOfURL: defaultsURL) {
					defaults.registerDefaults(ourDict as! [String : AnyObject])
				}
			}
		}
		loadSettings()
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
		verbs += GetVerbsFromSaved(defaults.arrayForKey(NONSVerbList) as! [[String: String]])
		pluralNouns += defaults.arrayForKey(NONSPluralNounList) as! [String]
		singularNouns += defaults.arrayForKey(NONSSingularNounList) as! [String]
		properNouns += defaults.arrayForKey(NONSProperNounList) as! [String]
		adverbs += defaults.arrayForKey(NONSAdverbList) as! [String]
		adjectives += defaults.arrayForKey(NONSAdjectiveList) as! [String]
		massiveNouns += defaults.arrayForKey(NONSMassiveNounList) as! [String]
	}
	
	// Simple test to see if a noun ends with an 's'
	private func nounOwningObject(theNoun: String) -> String {
		let endNounPos = theNoun.endIndex.predecessor()
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
		return (arc4random_uniform(2)) == 1 ? randomSingularNoun() : randomProperNoun()
	}
	
	private lazy var nonsenseGenList: Array<() -> String> = {
		var nonsenseCaller = Array<() -> String>()

		nonsenseCaller.append({
			return "The \(self.randomAdjective()) \(self.randomPluralNoun()), while \(self.randomVerb().thirdPersonPresentCont), \(self.randomVerb().thirdPersonPast) \(self.randomAdverb())."
		})
		
		nonsenseCaller.append({
			return "The \(self.randomSingularNoun()) \(self.randomVerb().thirdPersonPast) \(self.randomAdverb())"
		})
		
		nonsenseCaller.append({
			return "The \(self.randomPluralNoun()), while \(self.randomVerb().thirdPersonPresentCont), \(self.randomVerb().thirdPersonPast)."
		})
		nonsenseCaller.append({
			return "\(self.randomProperNoun()) \(self.randomVerb().thirdPersonPast) the \(self.randomSingularNoun()) \(self.randomAdverb())."
		})
		
		nonsenseCaller.append({
			return "The \(self.randomAdjective()) \(self.randomPluralNoun()), while \(self.randomVerb().thirdPersonPresentCont), \(self.randomVerb().thirdPersonPast) \(self.randomMassiveNoun())."
		})
		
		nonsenseCaller.append({
			return "Can't a \(self.randomSingularNoun()) have \(self.randomVerb().thirdPersonPastPerfect)?"
		})
		
		nonsenseCaller.append({
			return "They \(self.randomAdverb()) \(self.randomVerb().thirdPersonPast) \(self.randomPronoun())."
		})
		
		nonsenseCaller.append({
			return "Can \(self.randomMassiveNoun()), who musn't have \(self.randomVerb().thirdPersonPastPerfect), \(self.randomVerb().thirdPersonPluralPresent) \(self.randomAdverb())?"
		})
		
		nonsenseCaller.append({
			return "The \(self.randomAdjective()) \(self.randomPluralNoun()), while \(self.randomVerb().thirdPersonPresentCont), \(self.randomVerb().thirdPersonPast) \(self.randomMassiveNoun()) \(self.randomAdverb())."
		})
		
		nonsenseCaller.append({
			return "Must you \(self.randomVerb().thirdPersonPluralPresent) \(self.randomAdverb())?"
		})
		
		nonsenseCaller.append({
			return "The \(self.randomAdjective()) \(self.randomAdjective()) \(self.randomSingularNoun()) \(self.randomVerb().thirdPersonSinglePresent) \(self.randomAdverb())."
		})
		
		nonsenseCaller.append({
			return "\(self.nounOwningObject(self.randomProperNoun())) \(self.randomPluralNoun()) hadn't \(self.randomVerb().thirdPersonPast)."
		})

		return nonsenseCaller
	}()
	
	func randomSaying() -> String {
		//FIXME: this is where it falls short. There needs to be a better way of generating nonsense than the one that I'm using right here.
		return randObject(self.nonsenseGenList)()
			//nonsensestring = "The developer's brain farted \(randomAdverb()), producing this error.";
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
	
	@objc(removeVerbsAtIndexes:) func removeVerbs(indexes indexes: NSIndexSet) {
		self.willChange(.Removal, valuesAtIndexes: indexes, forKey: "verbs")
		var i = indexes.lastIndex
		while i != NSNotFound {
			verbs.removeAtIndex(i)
			i = indexes.indexLessThanIndex(i)
		}
		self.didChange(.Removal, valuesAtIndexes: indexes, forKey: "verbs")
	}
	
	@objc(removePluralNounsAtIndexes:) func removePluralNouns(indexes indexes: NSIndexSet) {
		self.willChange(.Removal, valuesAtIndexes: indexes, forKey: "pluralNouns")
		var i = indexes.lastIndex
		while i != NSNotFound {
			pluralNouns.removeAtIndex(i)
			i = indexes.indexLessThanIndex(i)
		}
		self.didChange(.Removal, valuesAtIndexes: indexes, forKey: "pluralNouns")
	}
	
	@objc(removeSingularNounsAtIndexes:) func removeSingularNouns(indexes indexes: NSIndexSet) {
		self.willChange(.Removal, valuesAtIndexes: indexes, forKey: "singularNouns")
		var i = indexes.lastIndex
		while i != NSNotFound {
			singularNouns.removeAtIndex(i)
			i = indexes.indexLessThanIndex(i)
		}
		self.didChange(.Removal, valuesAtIndexes: indexes, forKey: "singularNouns")
	}
	
	@objc(removeProperNounsAtIndexes:) func removeProperNouns(indexes indexes: NSIndexSet) {
		self.willChange(.Removal, valuesAtIndexes: indexes, forKey: "properNouns")
		var i = indexes.lastIndex
		while i != NSNotFound {
			properNouns.removeAtIndex(i)
			i = indexes.indexLessThanIndex(i)
		}
		self.didChange(.Removal, valuesAtIndexes: indexes, forKey: "properNouns")
	}
	
	@objc(removeAdverbsAtIndexes:) func removeAdverbs(indexes indexes: NSIndexSet) {
		self.willChange(.Removal, valuesAtIndexes: indexes, forKey: "adverbs")
		var i = indexes.lastIndex
		while i != NSNotFound {
			adverbs.removeAtIndex(i)
			i = indexes.indexLessThanIndex(i)
		}
		self.didChange(.Removal, valuesAtIndexes: indexes, forKey: "adverbs")
	}
	
	@objc(removeAdjectivesAtIndexes:) func removeAdjectives(indexes indexes: NSIndexSet) {
		self.willChange(.Removal, valuesAtIndexes: indexes, forKey: "adjectives")
		var i = indexes.lastIndex
		while i != NSNotFound {
			adjectives.removeAtIndex(i)
			i = indexes.indexLessThanIndex(i)
		}
		self.didChange(.Removal, valuesAtIndexes: indexes, forKey: "adjectives")
	}
	
	@objc(removeMassiveNounsAtIndexes:) func removeMassiveNouns(indexes indexes: NSIndexSet) {
		self.willChange(.Removal, valuesAtIndexes: indexes, forKey: "massiveNouns")
		var i = indexes.lastIndex
		while i != NSNotFound {
			massiveNouns.removeAtIndex(i)
			i = indexes.indexLessThanIndex(i)
		}
		self.didChange(.Removal, valuesAtIndexes: indexes, forKey: "massiveNouns")
	}
	
	@objc(removeVerbsInArray:) func removeVerbs(array arrays: [Verb]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = verbs.indexOf(aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeVerbs(indexes: idxSet)
	}
	
	@objc(removePluralNounsInArray:) func removePluralNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = pluralNouns.indexOf(aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removePluralNouns(indexes: idxSet)
	}
	
	@objc(removeSingularNounsInArray:) func removeSingularNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = singularNouns.indexOf(aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeSingularNouns(indexes: idxSet)
	}
	
	@objc(removeProperNounsInArray:) func removeProperNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = properNouns.indexOf(aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeProperNouns(indexes: idxSet)
	}
	
	@objc(removeAdverbsInArray:) func removeAdverbs(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = adverbs.indexOf(aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeAdverbs(indexes: idxSet)
	}
	
	@objc(removeAdjectivesInArray:) func removeAdjectives(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = adjectives.indexOf(aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeAdjectives(indexes: idxSet)
	}
	
	@objc(removeMassiveNounsInArray:) func removeMassiveNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = massiveNouns.indexOf(aVerb) {
				idxSet.addIndex(anIdx)
			}
		}
		removeMassiveNouns(indexes: idxSet)
	}
}
