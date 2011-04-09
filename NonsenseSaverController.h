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
	NSMutableArray *verbs;
	NSMutableArray *pluralNouns;
	NSMutableArray *singularNouns;
	NSMutableArray *properNouns;
	NSMutableArray *adverbs;
	NSMutableArray *adjectives;
	NSMutableArray *massiveNouns;
	NSArray *pronouns;
	NSArray *conjugates;
	NSArray *amounts;
	NSArray *relAdjs;
}
-(NONSVerb *)verb;
-(NSString *)pluralNoun;
-(NSString *)singularNoun;
-(NSString *)properNoun;
-(NSString *)adverb;
-(NSString *)adjective;
-(NSString *)massiveNoun;
-(NSString *)pronoun;
-(NSString *)conjugate;
-(NSString *)amount;
-(NSString *)relAdj;

-(NSString *)radomSaying;

-(NSArray *)verbs;
-(NSArray *)pluralNouns;
-(NSArray *)singularNouns;
-(NSArray *)properNouns;
-(NSArray *)adverbs;
-(NSArray *)adjectives;
-(NSArray *)massiveNouns;

-(void)addVerb:(NONSVerb *)verb;
-(void)addPluralNoun:(NSString *)pluralNoun;
-(void)addSingularNoun:(NSString *)singularNoun;
-(void)addProperNoun:(NSString *)properNoun;
-(void)addAdverb:(NSString *)adverb;
-(void)addAdjective:(NSString *)adjective;
-(void)addMassiveNoun:(NSString *)massiveNoun;

-(void)removeVerb:(NONSVerb *)verb;
-(void)removePluralNoun:(NSString *)pluralNoun;
-(void)removeSingularNoun:(NSString *)singularNoun;
-(void)removeProperNoun:(NSString *)properNoun;
-(void)removeAdverb:(NSString *)adverb;
-(void)removeAdjective:(NSString *)adjective;
-(void)removeMassiveNoun:(NSString *)massiveNoun;

-(void)removeVerbs:(NSArray *)verb;
-(void)removePluralNouns:(NSArray *)pluralNoun;
-(void)removeSingularNouns:(NSArray *)singularNoun;
-(void)removeProperNouns:(NSArray *)properNoun;
-(void)removeAdverbs:(NSArray *)adverb;
-(void)removeAdjectives:(NSArray *)adjective;
-(void)removeMassiveNouns:(NSArray *)massiveNoun;


-(void)saveSettings;


@end
