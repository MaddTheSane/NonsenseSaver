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
internal func randObject<X>(_ anArray: [X]) -> X {
	let aRand = Int(arc4random_uniform(UInt32(anArray.count)))
	return anArray[aRand]
}

private func PrepareVerbsForSaving(_ toSave: [Verb]) -> [[String: String]] {
	func PrepareVerbForSaving(_ toSave: Verb) -> [String: String] {
		return [ThirdPersonPastKey: toSave.thirdPersonPast,
			ThirdPersonSinglePresentKey : toSave.thirdPersonSinglePresent,
			ThirdPersonPluralPresentKey : toSave.thirdPersonPluralPresent,
			ThirdPersonPastPerfectKey : toSave.thirdPersonPastPerfect,
			ThirdPersonPresentContKey : toSave.thirdPersonPresentCont]
	}

	let theArray:[[String: String]] = toSave.map {PrepareVerbForSaving($0)}
	
	return theArray
}

private func GetVerbsFromSaved(_ theSaved: [[String: String]]) -> [Verb] {
	func GetVerbFromSaved(_ theSaved1: [String: String]) -> Verb? {
		if let singPres = theSaved1[ThirdPersonSinglePresentKey], let pluralPres = theSaved1[ThirdPersonPluralPresentKey],
			let pas = theSaved1[ThirdPersonPastKey], let pasPerfect = theSaved1[ThirdPersonPastPerfectKey],
			let presCont = theSaved1[ThirdPersonPresentContKey] {
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

internal func defaultsProvider() -> UserDefaults {
#if os(iOS)
	return UserDefaults.standard
#else
	return ScreenSaverDefaults(forModuleWithName: NonsenseDefaultsKey)!
#endif
}

internal class NonsenseSaverController: NSObject {
	private static var __once: () = {
			let ourClass = Bundle(for: type(of: self) as! AnyClass)
			let defaults = defaultsProvider()
			if let defaultsURL = ourClass.url(forResource: "Defaults", withExtension: "plist") {
				if let ourDict = NSDictionary(contentsOf: defaultsURL) {
					defaults.register(defaults: ourDict as! [String : AnyObject])
				}
			}
		}()
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
		
		_ = NonsenseSaverController.__once
		loadSettings()
	}
	
	func loadSettings() {
		let defaults = defaultsProvider()
		//Clear any old values
		verbs.removeAll(keepingCapacity: true)
		pluralNouns.removeAll(keepingCapacity: true)
		singularNouns.removeAll(keepingCapacity: true)
		properNouns.removeAll(keepingCapacity: true)
		adverbs.removeAll(keepingCapacity: true)
		adjectives.removeAll(keepingCapacity: true)
		massiveNouns.removeAll(keepingCapacity: true)
		
		//load values from settings.
		verbs += GetVerbsFromSaved(defaults.array(forKey: NONSVerbList) as! [[String: String]])
		pluralNouns += defaults.array(forKey: NONSPluralNounList) as! [String]
		singularNouns += defaults.array(forKey: NONSSingularNounList) as! [String]
		properNouns += defaults.array(forKey: NONSProperNounList) as! [String]
		adverbs += defaults.array(forKey: NONSAdverbList) as! [String]
		adjectives += defaults.array(forKey: NONSAdjectiveList) as! [String]
		massiveNouns += defaults.array(forKey: NONSMassiveNounList) as! [String]
	}
	
	// Simple test to see if a noun ends with an 's'
	private func nounOwningObject(_ theNoun: String) -> String {
		let endNounPos = theNoun.characters.index(before: theNoun.endIndex)
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
		defaults.set(PrepareVerbsForSaving(verbs), forKey: NONSVerbList)
		defaults.set(pluralNouns, forKey: NONSPluralNounList)
		defaults.set(singularNouns, forKey: NONSSingularNounList)
		defaults.set(properNouns, forKey: NONSProperNounList)
		defaults.set(adverbs, forKey: NONSAdverbList)
		defaults.set(adjectives, forKey: NONSAdjectiveList)
		defaults.set(massiveNouns, forKey: NONSMassiveNounList)
		defaults.synchronize()
	}
	
	func addVerb(_ verb: Verb) {
		let curIdx = IndexSet(integer: verbs.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "verbs")
		verbs.append(verb)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "verbs")
	}
	
	func addPluralNoun(_ pluralNoun: String) {
		let curIdx = IndexSet(integer: pluralNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "pluralNouns")
		pluralNouns.append(pluralNoun)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "pluralNouns")
	}
	
	func addSingularNoun(_ singularNoun: String) {
		let curIdx = IndexSet(integer: singularNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "singularNouns")
		singularNouns.append(singularNoun)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "singularNouns")
	}
	
	func addProperNoun(_ properNoun: String) {
		let curIdx = IndexSet(integer: properNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "properNouns")
		properNouns.append(properNoun)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "properNouns")
	}
	
	func addAdverb(_ adverb: String) {
		let curIdx = IndexSet(integer: properNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "properNouns")
		adverbs.append(adverb)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "properNouns")
	}
	
	func addAdjective(_ adjective: String) {
		let curIdx = IndexSet(integer: adjectives.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "adjectives")
		adjectives.append(adjective)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "adjectives")
	}
	
	func addMassiveNoun(_ massiveNoun: String) {
		let curIdx = IndexSet(integer: massiveNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "massiveNouns")
		massiveNouns.append(massiveNoun)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "massiveNouns")
	}
	
	@objc(removeVerbsAtIndexes:) func removeVerbs(indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "verbs")
		var i = indexes.last
		while i != NSNotFound {
			verbs.remove(at: i!)
			i = indexes.integerLessThan(i!)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "verbs")
	}
	
	@objc(removePluralNounsAtIndexes:) func removePluralNouns(indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "pluralNouns")
		var i = indexes.last
		while i != NSNotFound {
			pluralNouns.remove(at: i!)
			i = indexes.integerLessThan(i!)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "pluralNouns")
	}
	
	@objc(removeSingularNounsAtIndexes:) func removeSingularNouns(indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "singularNouns")
		var i = indexes.last
		while i != NSNotFound {
			singularNouns.remove(at: i!)
			i = indexes.integerLessThan(i!)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "singularNouns")
	}
	
	@objc(removeProperNounsAtIndexes:) func removeProperNouns(indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "properNouns")
		var i = indexes.last
		while i != NSNotFound {
			properNouns.remove(at: i!)
			i = indexes.integerLessThan(i!)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "properNouns")
	}
	
	@objc(removeAdverbsAtIndexes:) func removeAdverbs(indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "adverbs")
		var i = indexes.last
		while i != NSNotFound {
			adverbs.remove(at: i!)
			i = indexes.integerLessThan(i!)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "adverbs")
	}
	
	@objc(removeAdjectivesAtIndexes:) func removeAdjectives(indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "adjectives")
		var i = indexes.last
		while i != NSNotFound {
			adjectives.remove(at: i!)
			i = indexes.integerLessThan(i!)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "adjectives")
	}
	
	@objc(removeMassiveNounsAtIndexes:) func removeMassiveNouns(indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "massiveNouns")
		var i = indexes.last
		while i != NSNotFound {
			massiveNouns.remove(at: i!)
			i = indexes.integerLessThan(i!)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "massiveNouns")
	}
	
	@objc(removeVerbsInArray:) func removeVerbs(array arrays: [Verb]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = verbs.index(of: aVerb) {
				idxSet.add(anIdx)
			}
		}
		removeVerbs(indexes: idxSet as IndexSet)
	}
	
	@objc(removePluralNounsInArray:) func removePluralNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = pluralNouns.index(of: aVerb) {
				idxSet.add(anIdx)
			}
		}
		removePluralNouns(indexes: idxSet as IndexSet)
	}
	
	@objc(removeSingularNounsInArray:) func removeSingularNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = singularNouns.index(of: aVerb) {
				idxSet.add(anIdx)
			}
		}
		removeSingularNouns(indexes: idxSet as IndexSet)
	}
	
	@objc(removeProperNounsInArray:) func removeProperNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = properNouns.index(of: aVerb) {
				idxSet.add(anIdx)
			}
		}
		removeProperNouns(indexes: idxSet as IndexSet)
	}
	
	@objc(removeAdverbsInArray:) func removeAdverbs(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = adverbs.index(of: aVerb) {
				idxSet.add(anIdx)
			}
		}
		removeAdverbs(indexes: idxSet as IndexSet)
	}
	
	@objc(removeAdjectivesInArray:) func removeAdjectives(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = adjectives.index(of: aVerb) {
				idxSet.add(anIdx)
			}
		}
		removeAdjectives(indexes: idxSet as IndexSet)
	}
	
	@objc(removeMassiveNounsInArray:) func removeMassiveNouns(array arrays: [String]) {
		let idxSet = NSMutableIndexSet()
		for aVerb in arrays {
			if let anIdx = massiveNouns.index(of: aVerb) {
				idxSet.add(anIdx)
			}
		}
		removeMassiveNouns(indexes: idxSet as IndexSet)
	}
}
