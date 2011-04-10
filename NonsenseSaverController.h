//
//  NonsenseSaverController.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NONSVerb;

@interface NonsenseSaverController : NSObject {
	@private
	NSMutableArray *verbs;
	NSMutableArray *pluralNouns;
	NSMutableArray *singularNouns;
	NSMutableArray *properNouns;
	NSMutableArray *adverbs;
	NSMutableArray *adjectives;
	NSMutableArray *massiveNouns;
	NSMutableArray *interjections;
	NSArray *pronouns;
	NSArray *conjugates;
	NSArray *amounts;
	NSArray *relAdjs;
	NSArray *determiners;
	NSArray *comparatives;
}
-(NONSVerb *)verb;
-(NSString *)pluralNoun;
-(NSString *)singularNoun;
-(NSString *)properNoun;
-(NSString *)noun;
-(NSString *)adverb;
-(NSString *)adjective;
-(NSString *)massiveNoun;
-(NSString *)pronoun;
-(NSString *)conjugate;
-(NSString *)amount;
-(NSString *)relAdj;
-(NSString *)determiner;
-(NSString *)interjection;

-(NSString *)radomSaying;

-(NSArray *)verbs;
-(NSArray *)pluralNouns;
-(NSArray *)singularNouns;
-(NSArray *)properNouns;
-(NSArray *)adverbs;
-(NSArray *)adjectives;
-(NSArray *)massiveNouns;
-(NSArray *)interjections;

-(void)addVerb:(NONSVerb *)verb;
-(void)addPluralNoun:(NSString *)pluralNoun;
-(void)addSingularNoun:(NSString *)singularNoun;
-(void)addProperNoun:(NSString *)properNoun;
-(void)addAdverb:(NSString *)adverb;
-(void)addAdjective:(NSString *)adjective;
-(void)addMassiveNoun:(NSString *)massiveNoun;
-(void)addInterjection:(NSString *)interj;

-(void)removeVerb:(NONSVerb *)verb;
-(void)removePluralNoun:(NSString *)pluralNoun;
-(void)removeSingularNoun:(NSString *)singularNoun;
-(void)removeProperNoun:(NSString *)properNoun;
-(void)removeAdverb:(NSString *)adverb;
-(void)removeAdjective:(NSString *)adjective;
-(void)removeMassiveNoun:(NSString *)massiveNoun;
-(void)removeInterjection:(NSString *)inter;

-(void)removeVerbs:(NSArray *)verb;
-(void)removePluralNouns:(NSArray *)pluralNoun;
-(void)removeSingularNouns:(NSArray *)singularNoun;
-(void)removeProperNouns:(NSArray *)properNoun;
-(void)removeAdverbs:(NSArray *)adverb;
-(void)removeAdjectives:(NSArray *)adjective;
-(void)removeMassiveNouns:(NSArray *)massiveNoun;
-(void)removeInterjections:(NSArray *)inters;


-(void)saveSettings;


@end
