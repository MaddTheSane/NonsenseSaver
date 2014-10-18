//
//  NonsenseSaverController.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 10/15/14.
//
//

#if os(OSX)
import Cocoa
import ScreenSaver
	#else
	import Foundation
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
	
	private class func prepareVerbsForSaving(toSave: [Verb]) -> [[String: String]] {
		var theArray = [[String: String]]()
		for i in toSave{
			theArray.append(prepareVerbForSaving(i))
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
		//FIXME: this is where it falls short. There needs to be a better way of generating nonsense than the one that I'm using right here.
		let casenum = random() % 12
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
			nonsensestring = "\(randomProperNoun())'s \(randomPluralNoun()) hadn't \(randomVerb().thirdPersonPast)."
			
		default:
			nonsensestring = "The developer's brain farted \(randomAdverb()), producing this error.";
			break;
		}
		return nonsensestring;
	}

	func saveSettings() {
		let defaults = defaultsProvider()
		defaults.setObject(NonsenseSaverController.prepareVerbsForSaving(verbs), forKey: NONSVerbList)
		defaults.setObject(pluralNouns, forKey: NONSPluralNounList)
		defaults.setObject(singularNouns, forKey: NONSSingularNounList)
		defaults.setObject(properNouns, forKey: NONSProperNounList)
		defaults.setObject(adverbs, forKey: NONSAdverbList)
		defaults.setObject(adjectives, forKey: NONSAdjectiveList)
		defaults.setObject(massiveNouns, forKey: NONSMassiveNounList)
		defaults.synchronize()
	}
	
	func addVerb(verb: Verb) {
		self.willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: verbs.count), forKey: "verbs")
		verbs.append(verb)
		self.didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: verbs.count), forKey: "verbs")
	}
	
	func addPluralNoun(pluralNoun: String) {
		self.willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: pluralNouns.count), forKey: "pluralNouns")
		pluralNouns.append(pluralNoun)
		self.didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: pluralNouns.count), forKey: "pluralNouns")
	}
	
	func addSingularNoun(singularNoun: String) {
		self.willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: singularNouns.count), forKey: "singularNouns")
		singularNouns.append(singularNoun)
		self.didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: singularNouns.count), forKey: "singularNouns")
	}
	
	func addProperNoun(properNoun: String) {
		self.willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: properNouns.count), forKey: "properNouns")
		properNouns.append(properNoun)
		self.didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: properNouns.count), forKey: "properNouns")
	}
	
	func addAdverb(adverb: String) {
		self.willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: properNouns.count), forKey: "properNouns")
		adverbs.append(adverb)
		self.didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: properNouns.count), forKey: "properNouns")
	}
	
	func addAdjective(adjective: String) {
		self.willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: adjectives.count), forKey: "adjectives")
		adjectives.append(adjective)
		self.didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: adjectives.count), forKey: "adjectives")
	}
	
	func addMassiveNoun(massiveNoun: String) {
		self.willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: massiveNouns.count), forKey: "massiveNouns")
		massiveNouns.append(massiveNoun)
		self.didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: massiveNouns.count), forKey: "massiveNouns")
	}
	
	@objc(removeVerbsAtIndexes:) func removeVerbs(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "verbs")
		verbs = verbs.filter { (tmpVerb) -> Bool in
			var verbIndex = find(self.verbs, tmpVerb)!
			return !indexes.containsIndex(verbIndex)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "verbs")
	}
	
	@objc(removePluralNounsAtIndexes:) func removePluralNouns(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "pluralNouns")
		pluralNouns = pluralNouns.filter { (tmpVerb) -> Bool in
			var verbIndex = find(self.pluralNouns, tmpVerb)!
			return !indexes.containsIndex(verbIndex)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "pluralNouns")
	}
	
	@objc(removeSingularNounsAtIndexes:) func removeSingularNouns(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "singularNouns")
		singularNouns = singularNouns.filter { (tmpVerb) -> Bool in
			var verbIndex = find(self.singularNouns, tmpVerb)!
			return !indexes.containsIndex(verbIndex)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "singularNouns")
	}
	
	@objc(removeProperNounsAtIndexes:) func removeProperNouns(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "properNouns")
		properNouns = properNouns.filter { (tmpVerb) -> Bool in
			var verbIndex = find(self.properNouns, tmpVerb)!
			return !indexes.containsIndex(verbIndex)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "properNouns")
	}
	
	@objc(removeAdverbsAtIndexes:) func removeAdverbs(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "adverbs")
		adverbs = adverbs.filter { (tmpVerb) -> Bool in
			var verbIndex = find(self.adverbs, tmpVerb)!
			return !indexes.containsIndex(verbIndex)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "adverbs")
	}
	
	@objc(removeAdjectivesAtIndexes:) func removeAdjectives(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "adjectives")
		adjectives = adjectives.filter { (tmpVerb) -> Bool in
			var verbIndex = find(self.adjectives, tmpVerb)!
			return !indexes.containsIndex(verbIndex)
		}
		self.didChange(.Insertion, valuesAtIndexes: indexes, forKey: "adjectives")
	}
	
	@objc(removeMassiveNounsAtIndexes:) func removeMassiveNouns(#indexes: NSIndexSet) {
		self.willChange(.Insertion, valuesAtIndexes: indexes, forKey: "massiveNouns")
		massiveNouns = massiveNouns.filter { (tmpVerb) -> Bool in
			var verbIndex = find(self.massiveNouns, tmpVerb)!
			return !indexes.containsIndex(verbIndex)
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
