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
	@objc private(set) dynamic var verbs = [Verb]()
	@objc private(set) dynamic var pluralNouns = [String]()
	@objc private(set) dynamic var singularNouns = [String]()
	@objc private(set) dynamic var properNouns = [String]()
	@objc private(set) dynamic var adverbs = [String]()
	@objc private(set) dynamic var adjectives = [String]()
	@objc private(set) dynamic var massiveNouns = [String]()
	
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
		let endNounPos = theNoun.index(before: theNoun.endIndex)
		let endNounChar = theNoun[endNounPos]
		switch endNounChar {
		case "s":
			return theNoun + "'"
			
		default:
			return theNoun + "'s"
		}
	}
	
	func randomVerb() -> Verb {
		return verbs.randomElement()!
	}
	
	func randomPluralNoun() -> String {
		return pluralNouns.randomElement()!
	}
	
	func randomSingularNoun() -> String {
		return singularNouns.randomElement()!
	}
	
	func randomProperNoun() -> String {
		return properNouns.randomElement()!
	}
	
	func randomAdverb() -> String {
		return adverbs.randomElement()!
	}
	
	func randomAdjective() -> String {
		return adjectives.randomElement()!
	}
	
	func randomMassiveNoun() -> String {
		return massiveNouns.randomElement()!
	}
	
	func randomPronoun() -> String {
		return pronouns.randomElement()!
	}
	
	func randomConjugate() -> String {
		return conjugates.randomElement()!
	}
	
	func randomAmount() -> String {
		return amounts.randomElement()!
	}
	
	func randomRelativeAdjective() -> String {
		return relativeAdjectives.randomElement()!
	}
	
	func randomDeterminer() -> String {
		return determiners.randomElement()!
	}
	
	func randomComparative() -> String {
		return comparatives.randomElement()!
	}

	func randomNoun() -> String {
		return Bool.random() ? randomSingularNoun() : randomProperNoun()
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
		return self.nonsenseGenList.randomElement()!()
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
	
	@objc func addVerb(_ verb: Verb) {
		let curIdx = IndexSet(integer: verbs.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "verbs")
		verbs.append(verb)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "verbs")
	}
	
	@objc func addPluralNoun(_ pluralNoun: String) {
		let curIdx = IndexSet(integer: pluralNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "pluralNouns")
		pluralNouns.append(pluralNoun)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "pluralNouns")
	}
	
	@objc func addSingularNoun(_ singularNoun: String) {
		let curIdx = IndexSet(integer: singularNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "singularNouns")
		singularNouns.append(singularNoun)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "singularNouns")
	}
	
	@objc func addProperNoun(_ properNoun: String) {
		let curIdx = IndexSet(integer: properNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "properNouns")
		properNouns.append(properNoun)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "properNouns")
	}
	
	@objc func addAdverb(_ adverb: String) {
		let curIdx = IndexSet(integer: properNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "properNouns")
		adverbs.append(adverb)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "properNouns")
	}
	
	@objc func addAdjective(_ adjective: String) {
		let curIdx = IndexSet(integer: adjectives.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "adjectives")
		adjectives.append(adjective)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "adjectives")
	}
	
	@objc func addMassiveNoun(_ massiveNoun: String) {
		let curIdx = IndexSet(integer: massiveNouns.count)
		self.willChange(.insertion, valuesAt: curIdx, forKey: "massiveNouns")
		massiveNouns.append(massiveNoun)
		self.didChange(.insertion, valuesAt: curIdx, forKey: "massiveNouns")
	}
	
	@objc(removeVerbsAtIndexes:) func removeVerbs(at indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "verbs")
		for i in indexes.reversed() {
			verbs.remove(at: i)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "verbs")
	}
	
	@objc(removePluralNounsAtIndexes:) func removePluralNouns(at indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "pluralNouns")
		for i in indexes.reversed() {
			pluralNouns.remove(at: i)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "pluralNouns")
	}
	
	@objc(removeSingularNounsAtIndexes:) func removeSingularNouns(at indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "singularNouns")
		for i in indexes.reversed() {
			singularNouns.remove(at: i)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "singularNouns")
	}
	
	@objc(removeProperNounsAtIndexes:) func removeProperNouns(at indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "properNouns")
		for i in indexes.reversed() {
			properNouns.remove(at: i)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "properNouns")
	}
	
	@objc(removeAdverbsAtIndexes:) func removeAdverbs(at indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "adverbs")
		for i in indexes.reversed() {
			adverbs.remove(at: i)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "adverbs")
	}
	
	@objc(removeAdjectivesAtIndexes:) func removeAdjectives(at indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "adjectives")
		for i in indexes.reversed() {
			adjectives.remove(at: i)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "adjectives")
	}
	
	@objc(removeMassiveNounsAtIndexes:) func removeMassiveNouns(at indexes: IndexSet) {
		self.willChange(.removal, valuesAt: indexes, forKey: "massiveNouns")
		for i in indexes.reversed() {
			massiveNouns.remove(at: i)
		}
		self.didChange(.removal, valuesAt: indexes, forKey: "massiveNouns")
	}
	
	@objc(removeVerbsInArray:) func removeVerbs(in arrays: [Verb]) {
		var idxSet = IndexSet()
		for aVerb in arrays {
			if let anIdx = verbs.firstIndex(of: aVerb) {
				idxSet.insert(anIdx)
			}
		}
		removeVerbs(at: idxSet)
	}
	
	@objc(removePluralNounsInArray:) func removePluralNouns(in arrays: [String]) {
		var idxSet = IndexSet()
		for aVerb in arrays {
			if let anIdx = pluralNouns.firstIndex(of: aVerb) {
				idxSet.insert(anIdx)
			}
		}
		removePluralNouns(at: idxSet)
	}
	
	@objc(removeSingularNounsInArray:) func removeSingularNouns(in arrays: [String]) {
		var idxSet = IndexSet()
		for aVerb in arrays {
			if let anIdx = singularNouns.firstIndex(of: aVerb) {
				idxSet.insert(anIdx)
			}
		}
		removeSingularNouns(at: idxSet)
	}
	
	@objc(removeProperNounsInArray:) func removeProperNouns(in arrays: [String]) {
		var idxSet = IndexSet()
		for aVerb in arrays {
			if let anIdx = properNouns.firstIndex(of: aVerb) {
				idxSet.insert(anIdx)
			}
		}
		removeProperNouns(at: idxSet)
	}
	
	@objc(removeAdverbsInArray:) func removeAdverbs(in arrays: [String]) {
		var idxSet = IndexSet()
		for aVerb in arrays {
			if let anIdx = adverbs.firstIndex(of: aVerb) {
				idxSet.insert(anIdx)
			}
		}
		removeAdverbs(at: idxSet)
	}
	
	@objc(removeAdjectivesInArray:) func removeAdjectives(in arrays: [String]) {
		var idxSet = IndexSet()
		for aVerb in arrays {
			if let anIdx = adjectives.firstIndex(of: aVerb) {
				idxSet.insert(anIdx)
			}
		}
		removeAdjectives(at: idxSet)
	}
	
	@objc(removeMassiveNounsInArray:) func removeMassiveNouns(in arrays: [String]) {
		var idxSet = IndexSet()
		for aVerb in arrays {
			if let anIdx = massiveNouns.firstIndex(of: aVerb) {
				idxSet.insert(anIdx)
			}
		}
		removeMassiveNouns(at: idxSet)
	}
}
