//
//  NonsenseSaverController.m
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NonsenseSaverController.h"
#import "NONSVerb.h"
#import <ScreenSaver/ScreenSaverDefaults.h>

static NSString *NONSSingularNounList = @"Singular Nouns";
static NSString *NONSPluralNounList = @"Plural Nouns";
static NSString *NONSAdjectiveList = @"Adjectives";
static NSString *NONSVerbList = @"Verbs";
static NSString *NONSAdverbList = @"Adverb";
static NSString *NONSProperNounList = @"Proper Nouns";
static NSString *NONSMassiveNounList = @"Massive Nouns";
static NSString *NONSInterjections = @"Interjections";

@implementation NonsenseSaverController

+(NSDictionary *)prepareVerbForSaving:(NONSVerb *)toSave {
	NSMutableDictionary *verb = [NSMutableDictionary dictionaryWithCapacity:5];
	[verb setObject:[toSave verbThirdPersonSinglePresent] forKey:ThirdPersonSinglePresent];
	[verb setObject:[toSave verbThirdPersonPluralPresent] forKey:ThirdPersonPluralPresent];
	[verb setObject:[toSave verbThirdPersonPast] forKey:ThirdPersonPast];
	[verb setObject:[toSave verbThirdPersonPastPerfect] forKey:ThirdPersonPastPerfect];
	[verb setObject:[toSave verbThirdPersonPresentCont] forKey:ThirdPersonPresentCont];

	return [NSDictionary dictionaryWithDictionary:verb];
}

+(NSArray *)prepareVerbsForSaving:(NSArray *)toSave {
	NSMutableArray *theArray = [NSMutableArray array];
	for (NONSVerb *i in toSave ){
		[theArray addObject:[self prepareVerbForSaving:i]];
	}
	return [NSArray arrayWithArray:theArray];
}

+(NONSVerb *)getVerbFromSaved:(NSDictionary *)theSaved {
	return [NONSVerb verbWithSinglePresent:[theSaved objectForKey:ThirdPersonSinglePresent] pluralPresent:[theSaved objectForKey:ThirdPersonPluralPresent] past:[theSaved objectForKey:ThirdPersonPast] pastPerfect:[theSaved objectForKey:ThirdPersonPastPerfect] presentCont:[theSaved objectForKey:ThirdPersonPresentCont]];
}

+(NSArray *)getVerbsFromSaved:(NSArray*)theSaved {
	NSMutableArray *theArray = [NSMutableArray array];
	for (NSDictionary *i in theSaved ) {
		[theArray addObject:[self getVerbFromSaved:i]];
	}
	return [NSArray arrayWithArray:theArray];
}

-(id)init
{
	self = [super init];
	if (self) {
		//we use arrays for objects that won't change, and mutable arrays for those that do
		pronouns = [[NSArray alloc] initWithObjects:@"him", @"her", @"it", @"them", nil];
		conjugates = [[NSArray alloc] initWithObjects:@"and", @"but", @"or", @"yet", @"so", @"because", nil];
		amounts = [[NSArray alloc] initWithObjects:@"excruciatingly", @"extremely", @"marginally", @"possibly", @"quite", @"really", @"slightly", @"somewhat", @"totally", @"very", nil];
		relAdjs = [[NSArray alloc] initWithObjects:@"however", @"nevertheless", @"therefore", @"and yet", nil];
		determiners = [[NSArray alloc] initWithObjects:@"a", @"one", @"some", @"that", @"the", @"this", nil];
		comparatives = [[NSArray alloc] initWithObjects:@"more", @"less", @"far more", @"far less", @"much more", @"much less", @"the same", nil];
		
		ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"Nonsense"];

		
		//Now allocate the mutable arrays
		verbs = [[NSMutableArray alloc] init];
		[verbs addObjectsFromArray:[NonsenseSaverController getVerbsFromSaved:[defaults arrayForKey:NONSVerbList]]];
		pluralNouns = [[NSMutableArray alloc] init];
		[pluralNouns addObjectsFromArray:[defaults arrayForKey:NONSPluralNounList]];
		singularNouns = [[NSMutableArray alloc] init];
		[singularNouns addObjectsFromArray:[defaults arrayForKey:NONSSingularNounList]];
		properNouns = [[NSMutableArray alloc] init];
		[properNouns addObjectsFromArray:[defaults objectForKey:NONSProperNounList]];
		adverbs = [[NSMutableArray alloc] init];
		[adverbs addObjectsFromArray:[defaults arrayForKey:NONSAdverbList]];
		interjections = [[NSMutableArray alloc] init];
		[interjections addObjectsFromArray:[defaults arrayForKey:NONSInterjections]];
		adjectives = [[NSMutableArray alloc] init];
		[adjectives addObjectsFromArray:[defaults arrayForKey:NONSAdjectiveList]];
		massiveNouns = [[NSMutableArray alloc] init];
		[massiveNouns addObjectsFromArray:[defaults arrayForKey:NONSMassiveNounList]];
		
	}
	return self;
}

-(void)dealloc
{
	[verbs release];
	[pluralNouns release];
	[singularNouns release];
	[properNouns release];
	[adverbs release];
	[pronouns release];
	[conjugates release];
	[amounts release];
	[relAdjs release];
	[determiners release];
	[interjections release];
	[comparatives release];
	
	[super dealloc];
}

#define randObject(x) [x objectAtIndex:(random() % [x count])]
-(NONSVerb *)verb
{
	return randObject(verbs);
}

-(NSString *)pluralNoun
{
	return randObject(pluralNouns);
}

-(NSString *)singularNoun
{
	return randObject(singularNouns);
}

-(NSString *)properNoun
{
	return randObject(properNouns);
}

-(NSString *)adverb
{
	return randObject(adverbs);
}

-(NSString *)adjective
{
	return randObject(adjectives);
}

-(NSString *)massiveNoun;
{
	return randObject(massiveNouns);
}

-(NSString *)pronoun
{
	return randObject(pronouns);
}

-(NSString *)conjugate
{
	return randObject(conjugates);
}

-(NSString *)amount
{
	return randObject(amounts);
}

-(NSString *)relAdj
{
	return randObject(relAdjs);
}

-(NSString *)determiner
{
	return randObject(determiners);
}

-(NSString *)interjection
{
	return randObject(interjections);
}

-(NSString *)comparative
{
	return randObject(comparatives);
}

#undef randObject

-(NSString *)noun
{
	return (random() %2) ? [self singularNoun] : [self properNoun] ;
}

-(NSArray *)verbs
{
	return [NSArray arrayWithArray:verbs];
}

-(NSArray *)pluralNouns
{
	return [NSArray arrayWithArray:pluralNouns];
}

-(NSArray *)singularNouns
{
	return [NSArray arrayWithArray:singularNouns];
}

-(NSArray *)properNouns
{
	return [NSArray arrayWithArray:properNouns];
}

-(NSArray *)adverbs
{
	return [NSArray arrayWithArray:adverbs];
}

-(NSArray *)adjectives
{
	return [NSArray arrayWithArray:adjectives];
}

-(NSArray *)massiveNouns
{
	return [NSArray arrayWithArray:massiveNouns];
}

-(NSArray *)interjections
{
	return [NSArray arrayWithArray:interjections];	
}

-(NSString *)radomSaying
{
	//FIXME: this is where it falls short. There needs to be a better way of generating nonsense than the one that I'm using right here.
	unsigned casenum = (random() % 13);
	NSString *nonsensestring;
	switch(casenum)
	{
		case 2:
			nonsensestring = [NSString stringWithFormat:@"The %@, while %@, %@.", [self pluralNoun], [[self verb] verbThirdPersonPresentCont], [[self verb] verbThirdPersonPast], [self adverb]];
			break;
		case 0:
			nonsensestring = [NSString stringWithFormat:@"The %@ %@, while %@, %@ %@.", [self adjective], [self pluralNoun], [[self verb] verbThirdPersonPresentCont], [[self verb] verbThirdPersonPast], [self adverb]];
			break;
		case 1:
			nonsensestring = [NSString stringWithFormat:@"The %@ %@ %@.", [self singularNoun], [[self verb] verbThirdPersonPast], [self adverb]];
			break;
		case 3:
			nonsensestring = [NSString stringWithFormat:@"%@ %@ the %@ %@.", [self properNoun], [[self verb] verbThirdPersonPast], [self singularNoun], [self adverb]];
			break;
		case 4:
			nonsensestring = [NSString stringWithFormat:@"The %@ %@, while %@, %@ %@.", [self adjective], [self pluralNoun], [[self verb] verbThirdPersonPresentCont], [[self verb] verbThirdPersonPast], [self massiveNoun] ];
			break;
		case 5:
			nonsensestring = [NSString stringWithFormat:@"Can't a %@ have %@?", [self singularNoun], [[self verb] verbThirdPersonPastPerfect] ];
			break;
		case 6:
			nonsensestring = [NSString stringWithFormat:@"They %@ %@ %@.", [self adverb], [[self verb] verbThirdPersonPast], [self pronoun] ];
			break;
		case 7:
			nonsensestring = [NSString stringWithFormat:@"Can %@, who musn't have %@, %@ %@?", [self massiveNoun], [[self verb] verbThirdPersonPastPerfect], [[self verb] verbThirdPersonPluralPresent], [self adverb]];
			break;
		case 8:
			nonsensestring = [NSString stringWithFormat:@"The %@ %@, while %@, %@ %@ %@.", [self adjective], [self pluralNoun], [[self verb] verbThirdPersonPresentCont], [[self verb] verbThirdPersonPast], [self massiveNoun], [self adverb] ];
			break;
		case 9:
			nonsensestring = [NSString stringWithFormat:@"Must you %@ %@?", [[self verb] verbThirdPersonPluralPresent], [self adverb] ];
			break;
		case 10:
			nonsensestring = [NSString stringWithFormat:@"The %@ %@ %@ %@ %@.", [self adjective], [self adjective], [self singularNoun], [[self verb] verbThirdPersonSinglePresent], [self adverb]];
			break;
		case 11:
			nonsensestring = [NSString stringWithFormat:@"%@'s %@ hadn't %@.", [self properNoun], [self pluralNoun], [[self verb] verbThirdPersonPast] ] ;
			break;
		//case 13:
		//	nonsensestring = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@.", [self interjection], [self determiner], [self adjective], [self noun], [self adverb], [self verb], [self preposition], [self determiner], [self adjective], [self noun]];
			
		//	break;
			
		case 12:
			nonsensestring = [NSString stringWithFormat:@"%@, %@ %@ is %@ %@ than %@ %@ %@.", [self interjection], [self determiner], [self noun], [self comparative], [self adjective], [self determiner], [self adjective], [self noun]];

			
		default:
			nonsensestring = [NSString stringWithFormat:@"The developer's brain farted %@, producing this error.", [self adverb]];
			break;
	}
	return nonsensestring;
}

#pragma mark Adding words

-(void)addVerb:(NONSVerb *)verb
{
	[verbs addObject:verb];
}

-(void)addPluralNoun:(NSString *)pluralNoun
{
	[pluralNouns addObject:pluralNoun];
}

-(void)addSingularNoun:(NSString *)singularNoun
{
	[singularNouns addObject:singularNoun];
}

-(void)addProperNoun:(NSString *)properNoun
{
	[properNouns addObject:properNoun];
}

-(void)addAdverb:(NSString *)adverb
{
	[adverbs addObject:adverb];
}

-(void)addAdjective:(NSString *)adjective
{
	[adjectives addObject:adjective];
}

-(void)addMassiveNoun:(NSString *)massiveNoun
{
	[massiveNouns addObject:massiveNoun];
}

-(void)addInterjection:(NSString *)interj
{
	[interjections addObject:interj];
}

#pragma mark Removing words

-(void)removeVerb:(NONSVerb *)verb
{
	[verbs removeObject:verb];
}

-(void)removePluralNoun:(NSString *)pluralNoun
{
	[pluralNouns removeObject:pluralNoun];
}

-(void)removeSingularNoun:(NSString *)singularNoun
{
	[singularNouns removeObject:singularNoun];
}

-(void)removeProperNoun:(NSString *)properNoun
{
	[properNouns removeObject:properNoun];
}

-(void)removeAdverb:(NSString *)adverb
{
	[adverbs removeObject:adverb];
}

-(void)removeAdjective:(NSString *)adjective
{
	[adjectives removeObject:adjective];
}

-(void)removeMassiveNoun:(NSString *)massiveNoun
{
	[massiveNouns removeObject:massiveNoun];
}

-(void)removeInterjection:(NSString *)inter
{
	[interjections removeObject:inter];
}


-(void)removeVerbs:(NSArray *)verb
{
	for(NONSVerb *inArray in verb)
	{
		[self removeVerb:inArray];
	}
}

-(void)removePluralNouns:(NSArray *)pluralNoun
{
	for(NSString *inArray in pluralNoun)
	{
		[self removePluralNoun:inArray];
	}	
}

-(void)removeSingularNouns:(NSArray *)singularNoun
{
	for (NSString *inArray in singularNoun)
	{
		[self removeSingularNoun:inArray];
	}
}

-(void)removeProperNouns:(NSArray *)properNoun
{
	for (NSString *inArray in properNoun)
	{
		[self removeProperNoun:inArray];
	}
}

-(void)removeAdverbs:(NSArray *)adverb
{
	for (NSString *inArray in adverb)
	{
		[self removeAdverb:inArray];
	}
}

-(void)removeAdjectives:(NSArray *)adjective
{
	for (NSString *inArray in adjective)
		[self removeAdjective:inArray];
}

-(void)removeMassiveNouns:(NSArray *)massiveNoun
{
	for (NSString *inArray in massiveNoun)
		[self removeMassiveNoun:inArray];
}

-(void)removeInterjections:(NSArray *)inters
{
	for (NSString *inArray in inters)
		[self removeInterjection:inArray];
}


-(void)saveSettings
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"Nonsense"];
	[defaults setObject:[NonsenseSaverController prepareVerbsForSaving:verbs] forKey:NONSVerbList];
	[defaults setObject:pluralNouns forKey:NONSPluralNounList];
	[defaults setObject:singularNouns forKey:NONSSingularNounList];
	[defaults setObject:properNouns forKey:NONSProperNounList];
	[defaults setObject:adverbs forKey:NONSAdverbList];
	[defaults setObject:adjectives forKey:NONSAdjectiveList];
	[defaults setObject:massiveNouns forKey:NONSMassiveNounList];
	[defaults synchronize];
}

+(void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	{
#pragma mark Singular Nouns
		NSMutableArray *defaultSingularNouns = [NSMutableArray array];
		[defaultSingularNouns addObject:@"ape"];
		[defaultSingularNouns addObject:@"apple"];
		[defaultSingularNouns addObject:@"armpit"];
		[defaultSingularNouns addObject:@"astronomer"];
		[defaultSingularNouns addObject:@"baboon"];
		[defaultSingularNouns addObject:@"badge"];
		[defaultSingularNouns addObject:@"balloon"];
		[defaultSingularNouns addObject:@"banana"];
		[defaultSingularNouns addObject:@"barn"];
		[defaultSingularNouns addObject:@"basketball"];
		[defaultSingularNouns addObject:@"bathtub"];
		[defaultSingularNouns addObject:@"bed"];
		[defaultSingularNouns addObject:@"bellybutton"];
		[defaultSingularNouns addObject:@"bicycle"];
		[defaultSingularNouns addObject:@"book"];
		[defaultSingularNouns addObject:@"bottle"];
		[defaultSingularNouns addObject:@"boy"];
		[defaultSingularNouns addObject:@"brain"];
		[defaultSingularNouns addObject:@"bug"];
		[defaultSingularNouns addObject:@"car"];
		[defaultSingularNouns addObject:@"carnival"];
		[defaultSingularNouns addObject:@"cat"];
		[defaultSingularNouns addObject:@"caterpillar"];
		[defaultSingularNouns addObject:@"cerebrum"];
		[defaultSingularNouns addObject:@"cheeseburger"];
		[defaultSingularNouns addObject:@"church"];
		[defaultSingularNouns addObject:@"cloud"];
		[defaultSingularNouns addObject:@"computer"];
		[defaultSingularNouns addObject:@"crook"];
		[defaultSingularNouns addObject:@"cucumber"];
		[defaultSingularNouns addObject:@"deity"];
		[defaultSingularNouns addObject:@"dinosaur"];
		[defaultSingularNouns addObject:@"dog"];
		[defaultSingularNouns addObject:@"dragon"];
		[defaultSingularNouns addObject:@"elbow"];
		[defaultSingularNouns addObject:@"eyeball"];
		[defaultSingularNouns addObject:@"fingernail"];
		[defaultSingularNouns addObject:@"football"];
		[defaultSingularNouns addObject:@"geologist"];
		[defaultSingularNouns addObject:@"genius"];
		[defaultSingularNouns addObject:@"girl"];
		[defaultSingularNouns addObject:@"government"];
		[defaultSingularNouns addObject:@"guitar"];
		[defaultSingularNouns addObject:@"hacker"];
		[defaultSingularNouns addObject:@"hand"];
		[defaultSingularNouns addObject:@"headache"];
		[defaultSingularNouns addObject:@"hedgehog"];
		[defaultSingularNouns addObject:@"husband"];
		[defaultSingularNouns addObject:@"hypotenuse"];
		[defaultSingularNouns addObject:@"icon"];
		[defaultSingularNouns addObject:@"idea"];
		[defaultSingularNouns addObject:@"kid"];
		[defaultSingularNouns addObject:@"king"];
		[defaultSingularNouns addObject:@"kitten"];
		[defaultSingularNouns addObject:@"klutz"];
		[defaultSingularNouns addObject:@"knight"];
		[defaultSingularNouns addObject:@"kumquat"];
		[defaultSingularNouns addObject:@"lawyer"];
		[defaultSingularNouns addObject:@"lobster"];
		[defaultSingularNouns addObject:@"logician"];
		[defaultSingularNouns addObject:@"loony"];
		[defaultSingularNouns addObject:@"loonies"];
		[defaultSingularNouns addObject:@"man"];
		[defaultSingularNouns addObject:@"masterpiece"];
		[defaultSingularNouns addObject:@"mathematician"];
		[defaultSingularNouns addObject:@"meteorite"];
		[defaultSingularNouns addObject:@"moron"];
		[defaultSingularNouns addObject:@"motorcycle"];
		[defaultSingularNouns addObject:@"mountain"];
		[defaultSingularNouns addObject:@"mouse"];
		[defaultSingularNouns addObject:@"movie"];
		[defaultSingularNouns addObject:@"nerd"];
		[defaultSingularNouns addObject:@"nostril"];
		[defaultSingularNouns addObject:@"omelette"];
		[defaultSingularNouns addObject:@"onion"];
		[defaultSingularNouns addObject:@"oyster"];
		[defaultSingularNouns addObject:@"parrot"];
		[defaultSingularNouns addObject:@"peanut"];
		[defaultSingularNouns addObject:@"pecan pie"];
		[defaultSingularNouns addObject:@"pelican"];
		[defaultSingularNouns addObject:@"penguin"];
		[defaultSingularNouns addObject:@"persimmon"];
		[defaultSingularNouns addObject:@"phaser"];
		[defaultSingularNouns addObject:@"picture"];
		[defaultSingularNouns addObject:@"pixel"];
		[defaultSingularNouns addObject:@"pizza"];
		[defaultSingularNouns addObject:@"politician"];
		[defaultSingularNouns addObject:@"polygon"];
		[defaultSingularNouns addObject:@"potato"];
		[defaultSingularNouns addObject:@"pretzel"];
		[defaultSingularNouns addObject:@"primate"];
		[defaultSingularNouns addObject:@"program"];
		[defaultSingularNouns addObject:@"puzzle"];
		[defaultSingularNouns addObject:@"queen"];
		[defaultSingularNouns addObject:@"rabbit"];
		[defaultSingularNouns addObject:@"rectangle"];
		[defaultSingularNouns addObject:@"river"];
		[defaultSingularNouns addObject:@"robot"];
		[defaultSingularNouns addObject:@"sandwich"];
		[defaultSingularNouns addObject:@"shoe"];
		[defaultSingularNouns addObject:@"sign"];
		[defaultSingularNouns addObject:@"sprinkler"];
		[defaultSingularNouns addObject:@"stereo"];
		[defaultSingularNouns addObject:@"soufflé"];
		[defaultSingularNouns addObject:@"straightjacket"];
		[defaultSingularNouns addObject:@"swami"];
		[defaultSingularNouns addObject:@"sword"];
		[defaultSingularNouns addObject:@"teenager"];
		[defaultSingularNouns addObject:@"thought"];
		[defaultSingularNouns addObject:@"tomato"];
		[defaultSingularNouns addObject:@"tooth"];
		[defaultSingularNouns addObject:@"telephone"];
		[defaultSingularNouns addObject:@"telescope"];
		[defaultSingularNouns addObject:@"television"];
		[defaultSingularNouns addObject:@"tennis ball"];
		[defaultSingularNouns addObject:@"toe"];
		[defaultSingularNouns addObject:@"toilet"];
		[defaultSingularNouns addObject:@"tricycle"];
		[defaultSingularNouns addObject:@"tummy"];
		[defaultSingularNouns addObject:@"twit"];
		[defaultSingularNouns addObject:@"viola"];
		[defaultSingularNouns addObject:@"warthog"];
		[defaultSingularNouns addObject:@"water pistol"];
		[defaultSingularNouns addObject:@"wench"];
		[defaultSingularNouns addObject:@"werewolf"];
		[defaultSingularNouns addObject:@"wife"];
		[defaultSingularNouns addObject:@"wimp"];
		[defaultSingularNouns addObject:@"woman"];
		[defaultSingularNouns addObject:@"wombat"];
		[defaultSingularNouns addObject:@"zombie"];
		[defaultValues setObject:defaultSingularNouns forKey:NONSSingularNounList];
	}
	
	{
#pragma mark Plural Nouns
		NSMutableArray *defaultPluralNouns = [NSMutableArray array];
		[defaultPluralNouns addObject:@"apes"];
		[defaultPluralNouns addObject:@"apples"];
		[defaultPluralNouns addObject:@"armpits"];
		[defaultPluralNouns addObject:@"astronomers"];
		[defaultPluralNouns addObject:@"baboons"];
		[defaultPluralNouns addObject:@"badges"];
		[defaultPluralNouns addObject:@"balloons"];
		[defaultPluralNouns addObject:@"bananas"];
		[defaultPluralNouns addObject:@"barns"];
		[defaultPluralNouns addObject:@"basketballs"];
		[defaultPluralNouns addObject:@"bathtubs"];
		[defaultPluralNouns addObject:@"beds"];
		[defaultPluralNouns addObject:@"bellybuttons"];
		[defaultPluralNouns addObject:@"bicycles"];
		[defaultPluralNouns addObject:@"books"];
		[defaultPluralNouns addObject:@"bottles"];
		[defaultPluralNouns addObject:@"boys"];
		[defaultPluralNouns addObject:@"brains"];
		[defaultPluralNouns addObject:@"bugs"];
		[defaultPluralNouns addObject:@"cars"];
		[defaultPluralNouns addObject:@"carnivals"];
		[defaultPluralNouns addObject:@"cats"];
		[defaultPluralNouns addObject:@"caterpillars"];
		[defaultPluralNouns addObject:@"cerebrums"];
		[defaultPluralNouns addObject:@"cheeseburgers"];
		[defaultPluralNouns addObject:@"churches"];
		[defaultPluralNouns addObject:@"clouds"];
		[defaultPluralNouns addObject:@"computers"];
		[defaultPluralNouns addObject:@"crooks"];
		[defaultPluralNouns addObject:@"cucumbers"];
		[defaultPluralNouns addObject:@"deities"];
		[defaultPluralNouns addObject:@"dinosaurs"];
		[defaultPluralNouns addObject:@"dogs"];
		[defaultPluralNouns addObject:@"dragons"];
		[defaultPluralNouns addObject:@"elbows"];
		[defaultPluralNouns addObject:@"eyeballs"];
		[defaultPluralNouns addObject:@"fingernails"];
		[defaultPluralNouns addObject:@"footballs"];
		[defaultPluralNouns addObject:@"geologists"];
		[defaultPluralNouns addObject:@"geniuses"];
		[defaultPluralNouns addObject:@"girls"];
		[defaultPluralNouns addObject:@"governments"];
		[defaultPluralNouns addObject:@"guitars"];
		[defaultPluralNouns addObject:@"hackers"];
		[defaultPluralNouns addObject:@"hands"];
		[defaultPluralNouns addObject:@"headaches"];
		[defaultPluralNouns addObject:@"hedgehogs"];
		[defaultPluralNouns addObject:@"husbands"];
		[defaultPluralNouns addObject:@"hypotenuses"];
		[defaultPluralNouns addObject:@"icons"];
		[defaultPluralNouns addObject:@"ideas"];
		[defaultPluralNouns addObject:@"kids"];
		[defaultPluralNouns addObject:@"kings"];
		[defaultPluralNouns addObject:@"kittens"];
		[defaultPluralNouns addObject:@"klutzes"];
		[defaultPluralNouns addObject:@"knights"];
		[defaultPluralNouns addObject:@"kumquats"];
		[defaultPluralNouns addObject:@"lawyers"];
		[defaultPluralNouns addObject:@"lobsters"];
		[defaultPluralNouns addObject:@"logicians"];
		[defaultPluralNouns addObject:@"loonies"];
		[defaultPluralNouns addObject:@"men"];
		[defaultPluralNouns addObject:@"masterpieces"];
		[defaultPluralNouns addObject:@"mathematicians"];
		[defaultPluralNouns addObject:@"meteorites"];
		[defaultPluralNouns addObject:@"morons"];
		[defaultPluralNouns addObject:@"motorcycles"];
		[defaultPluralNouns addObject:@"mountains"];
		[defaultPluralNouns addObject:@"mice"];
		[defaultPluralNouns addObject:@"movies"];
		[defaultPluralNouns addObject:@"nerds"];
		[defaultPluralNouns addObject:@"nostrils"];
		[defaultPluralNouns addObject:@"omelettes"];
		[defaultPluralNouns addObject:@"onions"];
		[defaultPluralNouns addObject:@"oysters"];
		[defaultPluralNouns addObject:@"parrots"];
		[defaultPluralNouns addObject:@"peanuts"];
		[defaultPluralNouns addObject:@"pecan pies"];
		[defaultPluralNouns addObject:@"pelicans"];
		[defaultPluralNouns addObject:@"penguins"];
		[defaultPluralNouns addObject:@"persimmons"];
		[defaultPluralNouns addObject:@"phasers"];
		[defaultPluralNouns addObject:@"pictures"];
		[defaultPluralNouns addObject:@"pixels"];
		[defaultPluralNouns addObject:@"pizzas"];
		[defaultPluralNouns addObject:@"politicians"];
		[defaultPluralNouns addObject:@"polygons"];
		[defaultPluralNouns addObject:@"potatoes"];
		[defaultPluralNouns addObject:@"pretzels"];
		[defaultPluralNouns addObject:@"primates"];
		[defaultPluralNouns addObject:@"programs"];
		[defaultPluralNouns addObject:@"puzzles"];
		[defaultPluralNouns addObject:@"queens"];
		[defaultPluralNouns addObject:@"rabbits"];
		[defaultPluralNouns addObject:@"rectangles"];
		[defaultPluralNouns addObject:@"rivers"];
		[defaultPluralNouns addObject:@"robots"];
		[defaultPluralNouns addObject:@"sandwiches"];
		[defaultPluralNouns addObject:@"shoes"];
		[defaultPluralNouns addObject:@"signs"];
		[defaultPluralNouns addObject:@"sprinklers"];
		[defaultPluralNouns addObject:@"stereos"];
		[defaultPluralNouns addObject:@"soufflés"];
		[defaultPluralNouns addObject:@"straightjackets"];
		[defaultPluralNouns addObject:@"swamis"];
		[defaultPluralNouns addObject:@"swords"];
		[defaultPluralNouns addObject:@"teenagers"];
		[defaultPluralNouns addObject:@"thoughts"];
		[defaultPluralNouns addObject:@"tomatoes"];
		[defaultPluralNouns addObject:@"teeth"];
		[defaultPluralNouns addObject:@"telephones"];
		[defaultPluralNouns addObject:@"telescopes"];
		[defaultPluralNouns addObject:@"televisions"];
		[defaultPluralNouns addObject:@"tennis balls"];
		[defaultPluralNouns addObject:@"toes"];
		[defaultPluralNouns addObject:@"toilets"];
		[defaultPluralNouns addObject:@"tricycles"];
		[defaultPluralNouns addObject:@"tummies"];
		[defaultPluralNouns addObject:@"twits"];
		[defaultPluralNouns addObject:@"violas"];
		[defaultPluralNouns addObject:@"warthogs"];
		[defaultPluralNouns addObject:@"water pistols"];
		[defaultPluralNouns addObject:@"wenches"];
		[defaultPluralNouns addObject:@"werewolves"];
		[defaultPluralNouns addObject:@"wives"];
		[defaultPluralNouns addObject:@"wimps"];
		[defaultPluralNouns addObject:@"women"];
		[defaultPluralNouns addObject:@"wombats"];
		[defaultPluralNouns addObject:@"zombies"];
		[defaultValues setObject:defaultPluralNouns forKey:NONSPluralNounList];
	}
	
	{
#pragma mark Adjectives
		NSMutableArray *defaultAdjectives = [NSMutableArray array];
		[defaultAdjectives addObject:@"abashed"];
		[defaultAdjectives addObject:@"absurd"];
		[defaultAdjectives addObject:@"admirable"];
		[defaultAdjectives addObject:@"amiable"];
		[defaultAdjectives addObject:@"ashamed"];
		[defaultAdjectives addObject:@"asynchronous"];
		[defaultAdjectives addObject:@"bad"];
		[defaultAdjectives addObject:@"bald"];
		[defaultAdjectives addObject:@"bitter"];
		[defaultAdjectives addObject:@"blasé"];
		[defaultAdjectives addObject:@"blissful"];
		[defaultAdjectives addObject:@"blue"];
		[defaultAdjectives addObject:@"bombastic"];
		[defaultAdjectives addObject:@"bouncy"];
		[defaultAdjectives addObject:@"brooding"];
		[defaultAdjectives addObject:@"buggy"];
		[defaultAdjectives addObject:@"canine"];
		[defaultAdjectives addObject:@"carnivorous"];
		[defaultAdjectives addObject:@"chartreuse"];
		[defaultAdjectives addObject:@"cocky"];
		[defaultAdjectives addObject:@"common"];
		[defaultAdjectives addObject:@"confused"];
		[defaultAdjectives addObject:@"contented"];
		[defaultAdjectives addObject:@"contrary"];
		[defaultAdjectives addObject:@"cranky"];
		[defaultAdjectives addObject:@"crazy"];
		[defaultAdjectives addObject:@"crunchy"];
		[defaultAdjectives addObject:@"dangerous"];
		[defaultAdjectives addObject:@"dead"];
		[defaultAdjectives addObject:@"deadly"];
		[defaultAdjectives addObject:@"delirious"];
		[defaultAdjectives addObject:@"demented"];
		[defaultAdjectives addObject:@"demure"];
		[defaultAdjectives addObject:@"digital"];
		[defaultAdjectives addObject:@"disgruntled"];
		[defaultAdjectives addObject:@"dismayed"];
		[defaultAdjectives addObject:@"distraught"];
		[defaultAdjectives addObject:@"disturbed"];
		[defaultAdjectives addObject:@"doleful"];
		[defaultAdjectives addObject:@"drunk"];
		[defaultAdjectives addObject:@"dull"];
		[defaultAdjectives addObject:@"elated"];
		[defaultAdjectives addObject:@"enraptured"];
		[defaultAdjectives addObject:@"evil"];
		[defaultAdjectives addObject:@"exponential"];
		[defaultAdjectives addObject:@"fast"];
		[defaultAdjectives addObject:@"feline"];
		[defaultAdjectives addObject:@"flippant"];
		[defaultAdjectives addObject:@"fretful"];
		[defaultAdjectives addObject:@"friendly"];
		[defaultAdjectives addObject:@"frisky"];
		[defaultAdjectives addObject:@"frolicsome"];
		[defaultAdjectives addObject:@"frustrated"];
		[defaultAdjectives addObject:@"furry"];
		[defaultAdjectives addObject:@"fuzzy"];
		[defaultAdjectives addObject:@"gallant"];
		[defaultAdjectives addObject:@"gargantuan"];
		[defaultAdjectives addObject:@"giddy"];
		[defaultAdjectives addObject:@"glorious"];
		[defaultAdjectives addObject:@"glowing"];
		[defaultAdjectives addObject:@"glum"];
		[defaultAdjectives addObject:@"golden"];
		[defaultAdjectives addObject:@"good"];
		[defaultAdjectives addObject:@"goofy"];
		[defaultAdjectives addObject:@"green"];
		[defaultAdjectives addObject:@"grotesque"];
		[defaultAdjectives addObject:@"grumpish"];
		[defaultAdjectives addObject:@"grumpy"];
		[defaultAdjectives addObject:@"grungy"];
		[defaultAdjectives addObject:@"hairy"];
		[defaultAdjectives addObject:@"happy"];
		[defaultAdjectives addObject:@"haughty"];
		[defaultAdjectives addObject:@"huffy"];
		[defaultAdjectives addObject:@"humiliating"];
		[defaultAdjectives addObject:@"hyperbolic"];
		[defaultAdjectives addObject:@"hypocritical"];
		[defaultAdjectives addObject:@"inconsequential"];
		[defaultAdjectives addObject:@"inebriated"];
		[defaultAdjectives addObject:@"infuriated"];
		[defaultAdjectives addObject:@"innocent"];
		[defaultAdjectives addObject:@"innovative"];
		[defaultAdjectives addObject:@"insane"];
		[defaultAdjectives addObject:@"inscrutable"];
		[defaultAdjectives addObject:@"interesting"];
		[defaultAdjectives addObject:@"intoxicated"];
		[defaultAdjectives addObject:@"itchy"];
		[defaultAdjectives addObject:@"itty-bitty"];
		[defaultAdjectives addObject:@"jaded"];
		[defaultAdjectives addObject:@"jolly"];
		[defaultAdjectives addObject:@"jubilant"];
		[defaultAdjectives addObject:@"lackadaisical"];
		[defaultAdjectives addObject:@"lascivious"];
		[defaultAdjectives addObject:@"listless"];
		[defaultAdjectives addObject:@"livid"];
		[defaultAdjectives addObject:@"lonesome"];
		[defaultAdjectives addObject:@"lovelorn"];
		[defaultAdjectives addObject:@"lumpy"];
		[defaultAdjectives addObject:@"lustful"];
		[defaultAdjectives addObject:@"luxurious"];
		[defaultAdjectives addObject:@"melancholy"];
		[defaultAdjectives addObject:@"metallic"];
		[defaultAdjectives addObject:@"mirthless"];
		[defaultAdjectives addObject:@"mopy"];
		[defaultAdjectives addObject:@"morose"];
		[defaultAdjectives addObject:@"motheaten"];
		[defaultAdjectives addObject:@"musical"];
		[defaultAdjectives addObject:@"naked"];
		[defaultAdjectives addObject:@"nasty"];
		[defaultAdjectives addObject:@"naughty"];
		[defaultAdjectives addObject:@"new"];
		[defaultAdjectives addObject:@"nifty"];
		[defaultAdjectives addObject:@"nodal"];
		[defaultAdjectives addObject:@"nonexistent"];
		[defaultAdjectives addObject:@"obese"];
		[defaultAdjectives addObject:@"orange"];
		[defaultAdjectives addObject:@"overjoyed"];
		[defaultAdjectives addObject:@"peevish"];
		[defaultAdjectives addObject:@"perforated"];
		[defaultAdjectives addObject:@"perky"];
		[defaultAdjectives addObject:@"perturbed"];
		[defaultAdjectives addObject:@"petite"];
		[defaultAdjectives addObject:@"petulant"];
		[defaultAdjectives addObject:@"piggish"];
		[defaultAdjectives addObject:@"plastic"];
		[defaultAdjectives addObject:@"pleased"];
		[defaultAdjectives addObject:@"polka-dotted"];
		[defaultAdjectives addObject:@"polyester"];
		[defaultAdjectives addObject:@"prickly"];
		[defaultAdjectives addObject:@"prissy"];
		[defaultAdjectives addObject:@"professional"];
		[defaultAdjectives addObject:@"pulsating"];
		[defaultAdjectives addObject:@"puny"];
		[defaultAdjectives addObject:@"purple"];
		[defaultAdjectives addObject:@"putrid"];
		[defaultAdjectives addObject:@"quadratic"];
		[defaultAdjectives addObject:@"quick"];
		[defaultAdjectives addObject:@"radioactive"];
		[defaultAdjectives addObject:@"rambunctious"];
		[defaultAdjectives addObject:@"raving"];
		[defaultAdjectives addObject:@"red"];
		[defaultAdjectives addObject:@"redundant"];
		[defaultAdjectives addObject:@"relativistic"];
		[defaultAdjectives addObject:@"reptilian"];
		[defaultAdjectives addObject:@"repulsive"];
		[defaultAdjectives addObject:@"resentful"];
		[defaultAdjectives addObject:@"resonant"];
		[defaultAdjectives addObject:@"restless"];
		[defaultAdjectives addObject:@"robust"];
		[defaultAdjectives addObject:@"rotten"];
		[defaultAdjectives addObject:@"ruthless"];
		[defaultAdjectives addObject:@"sad"];
		[defaultAdjectives addObject:@"sanguine"];
		[defaultAdjectives addObject:@"sarcastic"];
		[defaultAdjectives addObject:@"sassy"];
		[defaultAdjectives addObject:@"seductive"];
		[defaultAdjectives addObject:@"seething"];
		[defaultAdjectives addObject:@"senile"];
		[defaultAdjectives addObject:@"serene"];
		[defaultAdjectives addObject:@"silent"];
		[defaultAdjectives addObject:@"silly"];
		[defaultAdjectives addObject:@"skinny"];
		[defaultAdjectives addObject:@"sleepy"];
		[defaultAdjectives addObject:@"smug"];
		[defaultAdjectives addObject:@"sordid"];
		[defaultAdjectives addObject:@"sparkling"];
		[defaultAdjectives addObject:@"spunky"];
		[defaultAdjectives addObject:@"stoned"];
		[defaultAdjectives addObject:@"stupid"];
		[defaultAdjectives addObject:@"sulky"];
		[defaultAdjectives addObject:@"sullen"];
		[defaultAdjectives addObject:@"supercilious"];
		[defaultAdjectives addObject:@"surprised"];
		[defaultAdjectives addObject:@"testy"];
		[defaultAdjectives addObject:@"tingly"];
		[defaultAdjectives addObject:@"touchy"];
		[defaultAdjectives addObject:@"tubular"];
		[defaultAdjectives addObject:@"turgid"];
		[defaultAdjectives addObject:@"unexpected"];
		[defaultAdjectives addObject:@"unhinged"];
		[defaultAdjectives addObject:@"used"];
		[defaultAdjectives addObject:@"vacuous"];
		[defaultAdjectives addObject:@"vinyl"];
		[defaultAdjectives addObject:@"virtuous"];
		[defaultAdjectives addObject:@"wanton"];
		[defaultAdjectives addObject:@"warlike"];
		[defaultAdjectives addObject:@"warped"];
		[defaultAdjectives addObject:@"whimsical"];
		[defaultAdjectives addObject:@"woeful"];
		[defaultAdjectives addObject:@"woolly"];
		[defaultAdjectives addObject:@"yearning"];
		[defaultValues setObject:defaultAdjectives forKey:NONSAdjectiveList];
	}

	{
#pragma mark Verbs
		NSMutableArray *defaultVerbs = [NSMutableArray array];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"accepts",@"accept",@"accepted",@"accepted",@"accepting",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"writes",@"write",@"wrote",@"written",@"writing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"farts",@"fart",@"farted",@"farted",@"farting", nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"arranges",@"arrange",@"arranged",@"arranged",@"arranging",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"awakes",@"awake",@"awoke",@"awoken",@"awaking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"babbles",@"babble",@"babbled",@"babbled",@"babbling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"babbles",@"babble",@"babbled",@"babbled",@"babbling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"bakes",@"bake",@"baked",@"baked",@"baking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"barks",@"bark",@"barked",@"barked",@"barking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"belches",@"belch",@"belched",@"belched",@"belching",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"breaks",@"break",@"broke",@"broken",@"breaking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"cooks",@"cook",@"cooked",@"cooked",@"cooking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"crashes",@"crash",@"crashed",@"crashed",@"crashing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"crawls",@"crawl",@"crawled",@"crawled",@"crawling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"decides",@"decide",@"decided",@"decided",@"deciding",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"divulges",@"divulge",@"divulged",@"divulged",@"divulging",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"dreams",@"dream",@"dreamed",@"dreamt",@"dreaming",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"drops",@"drop",@"dropped",@"dropped",@"dropping",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"eats",@"eat",@"ate",@"eaten",@"eating",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"explodes",@"explode",@"exploded",@"exploded",@"exploding",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"feels",@"feel",@"felt",@"felt",@"feeling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"flips",@"flip",@"flipped",@"flipped",@"flipping",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"flies",@"fly",@"flew",@"flown",@"flying",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"forgets",@"forget",@"forgot",@"forgotten",@"forgetting",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"grows",@"grow",@"grew",@"grown",@"growing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"hacks",@"hack",@"hacked",@"hacked",@"hacking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"has",@"have",@"had",@"had",@"having",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"hates",@"hate",@"hated",@"hated",@"hating",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"hears",@"hear",@"heard",@"heard",@"hearing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"hiccups",@"hiccup",@"hiccuped",@"hiccuped",@"hiccuping",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"hums",@"hum",@"hummed",@"hummed",@"humming",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"imagines",@"imagine",@"imagined",@"imagined",@"imagining",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"juggles",@"juggle",@"juggled",@"juggled",@"juggling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"jumps",@"jump",@"jumped",@"jumped",@"jumping",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"kills",@"kill",@"killed",@"killed",@"killing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"kisses",@"kiss",@"kissed",@"kissed",@"kissing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"likes",@"like",@"liked",@"liked",@"liking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"looks",@"look",@"looked",@"looked",@"looking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"loves",@"love",@"loved",@"loved",@"loving",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"marries",@"marry",@"married",@"married",@"marrying",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"needs",@"need",@"needed",@"needed",@"needing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"nibbles",@"nibble",@"nibbled",@"nibbled",@"nibbling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"ogles",@"ogle",@"ogled",@"ogled",@"ogling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"plays",@"play",@"played",@"played",@"playing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"pops",@"pop",@"popped",@"popped",@"popping",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"proves",@"prove",@"proved",@"proven",@"proving",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"pulls",@"pull",@"pulled",@"pulled",@"pulling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"purrs",@"purr",@"purred",@"purred",@"purring",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"pushes",@"push",@"pushed",@"pushed",@"pushing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"rotates",@"rotate",@"rotated",@"rotated",@"rotating",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"runs",@"run",@"ran",@"run",@"running",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"says",@"say",@"said",@"said",@"saying",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"seems",@"seem",@"seemed",@"seemed",@"seeming",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"shrinks",@"shrink",@"shrank",@"shrunk",@"shrinking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"sighs",@"sigh",@"sighed",@"sighed",@"sighing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"sleeps",@"sleep",@"slept",@"slept",@"sleeping",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"smells",@"smell",@"smelled",@"smelled",@"smelling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"smiles",@"smile",@"smiled",@"smiled",@"smiling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"sneezes",@"sneeze",@"sneezed",@"sneezed",@"sneezing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"sounds",@"sound",@"sounded",@"sounded",@"sounding",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"sprouts",@"sprout",@"sprouted",@"sprouted",@"sprouting",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"stalks",@"stalk",@"stalked",@"stalked",@"stalking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"stomps",@"stomp",@"stomped",@"stomped",@"stomping",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"sulks",@"sulk",@"sulked",@"sulked",@"sulking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"swims",@"swim",@"swam",@"swam",@"swimming",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"tastes",@"taste",@"tasted",@"tasted",@"tasting",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"terminates",@"terminate",@"terminated",@"terminated",@"terminating",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"thinks",@"think",@"thought",@"thought",@"thinking",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"tickles",@"tickle",@"tickled",@"tickled",@"tickling",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"tosses",@"toss",@"tossed",@"tossed",@"tossing",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"wants",@"want",@"wanted",@"wanted",@"wanting",nil]]];
		[defaultVerbs addObject:[NONSVerb verbWithArray:[NSArray arrayWithObjects:@"wobbles",@"wobble",@"wobbled",@"wobbled",@"wobbling",nil]]];
		[defaultValues setObject:[self prepareVerbsForSaving:defaultVerbs] forKey:NONSVerbList];
	}
	
	{
#pragma mark Adverbs
		NSMutableArray *defaultAdverbs = [NSMutableArray array];
		[defaultAdverbs addObject:@"accidentally"];
		[defaultAdverbs addObject:@"automatically"];
		[defaultAdverbs addObject:@"awfully"];
		[defaultAdverbs addObject:@"carefully"];
		[defaultAdverbs addObject:@"carelessly"];
		[defaultAdverbs addObject:@"drunkenly"];
		[defaultAdverbs addObject:@"enthusiastically"];
		[defaultAdverbs addObject:@"furiously"];
		[defaultAdverbs addObject:@"gloriously"];
		[defaultAdverbs addObject:@"hesitantly"];
		[defaultAdverbs addObject:@"hopefully"];
		[defaultAdverbs addObject:@"idiotically"];
		[defaultAdverbs addObject:@"inquisitively"];
		[defaultAdverbs addObject:@"insanely"];
		[defaultAdverbs addObject:@"longingly"];
		[defaultAdverbs addObject:@"melodramatically"];
		[defaultAdverbs addObject:@"occasionally"];
		[defaultAdverbs addObject:@"painfully"];
		[defaultAdverbs addObject:@"partially"];
		[defaultAdverbs addObject:@"perversely"];
		[defaultAdverbs addObject:@"playfully"];
		[defaultAdverbs addObject:@"psychotically"];
		[defaultAdverbs addObject:@"quickly"];
		[defaultAdverbs addObject:@"repeatedly"];
		[defaultAdverbs addObject:@"rudely"];
		[defaultAdverbs addObject:@"ruthlessly"];
		[defaultAdverbs addObject:@"sarcastically"];
		[defaultAdverbs addObject:@"sardonically"];
		[defaultAdverbs addObject:@"slowly"];
		[defaultAdverbs addObject:@"sometimes"];
		[defaultAdverbs addObject:@"stupidly"];
		[defaultAdverbs addObject:@"typically"];
		[defaultAdverbs addObject:@"vehemently"];
		[defaultAdverbs addObject:@"voraciously"];
		[defaultAdverbs addObject:@"intelegently"];
		[defaultValues setObject:defaultAdverbs forKey:NONSAdverbList];
	}
	
	{
#pragma mark Proper Nouns
		NSMutableArray *defaultProperNouns = [NSMutableArray array];
		[defaultProperNouns addObject:@"Al Gore"];
		[defaultProperNouns addObject:@"Arnold Schwarzenegger"];
		[defaultProperNouns addObject:@"Ben"];
		[defaultProperNouns addObject:@"Bill Clinton"];
		[defaultProperNouns addObject:@"Bob"];
		[defaultProperNouns addObject:@"Boris Yeltsin"];
		[defaultProperNouns addObject:@"Carl"];
		[defaultProperNouns addObject:@"Carol"];
		[defaultProperNouns addObject:@"Charlene"];
		[defaultProperNouns addObject:@"Cleopatra"];
		[defaultProperNouns addObject:@"Dan Quayle"];
		[defaultProperNouns addObject:@"Elvis"];
		[defaultProperNouns addObject:@"Ernie"];
		[defaultProperNouns addObject:@"Fiona"];
		[defaultProperNouns addObject:@"George Bush"];
		[defaultProperNouns addObject:@"Gina"];
		[defaultProperNouns addObject:@"God"];
		[defaultProperNouns addObject:@"Godzilla"];
		[defaultProperNouns addObject:@"Hillary Clinton"];
		[defaultProperNouns addObject:@"Houdini"];
		[defaultProperNouns addObject:@"J. S. Bach"];
		[defaultProperNouns addObject:@"James Bond"];
		[defaultProperNouns addObject:@"John Wayne"];
		[defaultProperNouns addObject:@"Kevin"];
		[defaultProperNouns addObject:@"Linda"];
		[defaultProperNouns addObject:@"Liz"];
		[defaultProperNouns addObject:@"Lora"];
		[defaultProperNouns addObject:@"Mark"];
		[defaultProperNouns addObject:@"Mick Jagger"];
		[defaultProperNouns addObject:@"Mike"];
		[defaultProperNouns addObject:@"My Dog Bo-bo"];
		[defaultProperNouns addObject:@"Prince Charles"];
		[defaultProperNouns addObject:@"Robert"];
		[defaultProperNouns addObject:@"Scott"];
		[defaultProperNouns addObject:@"Shayne"];
		[defaultProperNouns addObject:@"Syd"];
		[defaultProperNouns addObject:@"Tom"];
		[defaultProperNouns addObject:@"Warren"];
		[defaultValues setObject:defaultProperNouns forKey:NONSProperNounList];
	}

	{
#pragma mark Massive Nouns
		NSMutableArray *defaultMassiveNouns = [NSMutableArray array];
		[defaultMassiveNouns addObject:@"déjà vu"];
		[defaultMassiveNouns addObject:@"freedom"];
		[defaultMassiveNouns addObject:@"grass"];
		[defaultMassiveNouns addObject:@"hair"];
		[defaultMassiveNouns addObject:@"Kryptonite"];
		[defaultMassiveNouns addObject:@"lard"];
		[defaultMassiveNouns addObject:@"lasagna"];
		[defaultMassiveNouns addObject:@"lava"];
		[defaultMassiveNouns addObject:@"music"];
		[defaultMassiveNouns addObject:@"orange juice"];
		[defaultMassiveNouns addObject:@"peanut butter"];
		[defaultMassiveNouns addObject:@"rice"];
		[defaultMassiveNouns addObject:@"salad"];
		[defaultMassiveNouns addObject:@"sand"];
		[defaultMassiveNouns addObject:@"skin"];
		[defaultMassiveNouns addObject:@"slime"];
		[defaultMassiveNouns addObject:@"smoke"];
		[defaultMassiveNouns addObject:@"software"];
		[defaultMassiveNouns addObject:@"space"];
		[defaultMassiveNouns addObject:@"spaghetti"];
		[defaultMassiveNouns addObject:@"spinach"];
		[defaultMassiveNouns addObject:@"underwear"];
		[defaultMassiveNouns addObject:@"water"];
		[defaultValues setObject:defaultMassiveNouns forKey:NONSMassiveNounList];
	}
	
	{
#pragma mark Interjections
		NSMutableArray *defaultInterjections = [NSMutableArray array];
		[defaultInterjections addObjectsFromArray:[NSArray arrayWithObjects:@"Ah", @"Alas", @"Dear me", @"Goodness", @"Eh", @"Er", @"Hello", @"Hey", @"Hi", @"Hmm", @"Oh", @"Ouch", @"Uh", @"Um", @"Umm", @"Well", @"Gosh", @"Jeez", @"Wow", @"Oh my", @"Crud", @"Jeepers", @"Darn", @"Yikes", nil]];

		[defaultValues setObject:defaultInterjections forKey:NONSInterjections];
	}
	
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"Nonsense"];
	[defaults registerDefaults:defaultValues];
}


@end
