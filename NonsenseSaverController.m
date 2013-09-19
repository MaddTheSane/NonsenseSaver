//
//  NonsenseSaverController.m
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NonsenseSaverController.h"
#import "NONSVerb.h"
#if !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
#import <ScreenSaver/ScreenSaverDefaults.h>
#endif

NSString * const NONSDefaults = @"NonsenseSaver";
#define NONSSingularNounList @"Singular Nouns"
#define NONSPluralNounList @"Plural Nouns"
#define NONSAdjectiveList @"Adjectives"
#define NONSVerbList @"Verbs"
#define NONSAdverbList @"Adverb"
#define NONSProperNounList @"Proper Nouns"
#define NONSMassiveNounList @"Massive Nouns"
#define NONSInterjections @"Interjections"

@interface NonsenseSaverController()
@property (retain) NSArray *pronouns;
@property (retain) NSArray *conjugates;
@property (retain) NSArray *amounts;
@property (retain) NSArray *relAdjs;
@property (retain) NSArray *determiners;
@property (retain) NSArray *comparatives;

@end

@implementation NonsenseSaverController

@synthesize pronouns;
@synthesize conjugates;
@synthesize amounts;
@synthesize comparatives;
@synthesize determiners;
@synthesize relAdjs;

+(NSDictionary *)prepareVerbForSaving:(NONSVerb *)toSave {
	return @{ThirdPersonPast: [toSave verbThirdPersonPast],
			 ThirdPersonSinglePresent : [toSave verbThirdPersonSinglePresent],
			 ThirdPersonPluralPresent : [toSave verbThirdPersonPluralPresent],
			 ThirdPersonPastPerfect : [toSave verbThirdPersonPastPerfect],
			 ThirdPersonPresentCont : [toSave verbThirdPersonPresentCont]};
}

+(NSArray *)prepareVerbsForSaving:(NSArray *)toSave {
	NSMutableArray *theArray = [NSMutableArray array];
	for (NONSVerb *i in toSave ){
		[theArray addObject:[self prepareVerbForSaving:i]];
	}
	return [NSArray arrayWithArray:theArray];
}

+(NONSVerb *)getVerbFromSaved:(NSDictionary *)theSaved {
	return [NONSVerb verbWithSinglePresent:theSaved[ThirdPersonSinglePresent] pluralPresent:theSaved[ThirdPersonPluralPresent] past:theSaved[ThirdPersonPast] pastPerfect:theSaved[ThirdPersonPastPerfect] presentCont:theSaved[ThirdPersonPresentCont]];
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
		self.pronouns = @[@"him", @"her", @"it", @"them"];
		self.conjugates = @[@"and", @"but", @"or", @"yet", @"so", @"because"];
		self.amounts = @[@"excruciatingly", @"extremely", @"marginally", @"possibly", @"quite", @"really", @"slightly", @"somewhat", @"totally", @"very"];
		self.relAdjs = @[@"however", @"nevertheless", @"therefore", @"and yet"];
		self.determiners = @[@"a", @"one", @"some", @"that", @"the", @"this"];
		self.comparatives = @[@"more", @"less", @"far more", @"far less", @"much more", @"much less", @"the same"];
#if !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
		ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
#else
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
#endif
		
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
#if !__has_feature(objc_arc)
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
#endif

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
	return (random() %2) ? [self singularNoun] : [self properNoun];
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
			nonsensestring = [NSString stringWithFormat:@"The %@, while %@, %@.", [self pluralNoun], [[self verb] verbThirdPersonPresentCont], [[self verb] verbThirdPersonPast]];
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
			break;
			
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
#if !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
#else
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
#endif
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
		NSArray *defaultSingularNouns = @[@"ape", @"apple", @"armpit", @"astronomer", @"baboon", @"badge", @"balloon",
										  @"banana", @"barn", @"basketball", @"bathtub", @"bed", @"bellybutton", @"bicycle",
										  @"book", @"bottle", @"boy", @"brain", @"bug", @"car", @"carnival", @"cat",
										  @"caterpillar", @"cerebrum", @"cheeseburger", @"church", @"cloud", @"computer",
										  @"crook", @"cucumber", @"deity", @"dinosaur", @"dog", @"dragon", @"elbow",
										  @"eyeball", @"fingernail", @"football", @"geologist", @"genius", @"girl", @"government",
										  @"guitar", @"hacker", @"hand", @"headache", @"hedgehog", @"husband", @"hypotenuse",
										  @"icon", @"idea", @"kid", @"king", @"kitten", @"klutz", @"knight", @"kumquat", @"lawyer",
										  @"lobster", @"logician", @"loony", @"loonies", @"man", @"masterpiece", @"mathematician",
										  @"meteorite", @"moron", @"motorcycle", @"mountain", @"mouse", @"movie", @"nerd",
										  @"nostril", @"omelette", @"onion", @"oyster", @"parrot", @"peanut", @"pecan pie",
										  @"pelican", @"penguin", @"persimmon", @"phaser", @"picture", @"pixel", @"pizza",
										  @"politician", @"polygon", @"potato", @"pretzel", @"primate", @"program", @"puzzle",
										  @"queen", @"rabbit", @"rectangle", @"river", @"robot", @"sandwich", @"shoe", @"sign",
										  @"sprinkler", @"stereo", @"soufflé", @"straightjacket", @"swami", @"sword", @"teenager",
										  @"thought", @"tomato", @"tooth", @"telephone", @"telescope", @"television", @"tennis ball",
										  @"toe", @"toilet", @"tricycle", @"tummy", @"twit", @"viola", @"warthog", @"water pistol",
										  @"wench", @"werewolf", @"wife", @"wimp", @"woman", @"wombat", @"zombie"];
		defaultValues[NONSSingularNounList] = defaultSingularNouns;
	}
	
	{
#pragma mark Plural Nouns
		NSArray *defaultPluralNouns = @[@"apes", @"apples", @"armpits", @"astronomers", @"baboons", @"badges", @"balloons",
										@"bananas", @"barns", @"basketballs", @"bathtubs", @"beds", @"bellybuttons", @"bicycles",
										@"books", @"bottles", @"boys", @"brains", @"bugs", @"cars", @"carnivals", @"cats",
										@"caterpillars", @"cerebrums", @"cheeseburgers", @"churches", @"clouds", @"computers",
										@"crooks", @"cucumbers", @"deities", @"dinosaurs", @"dogs", @"dragons", @"elbows",
										@"eyeballs", @"fingernails", @"footballs", @"geologists", @"geniuses", @"girls",
										@"governments", @"guitars", @"hackers", @"hands", @"headaches", @"hedgehogs",
										@"husbands", @"hypotenuses", @"icons", @"ideas", @"kids", @"kings", @"kittens",
										@"klutzes", @"knights", @"kumquats", @"lawyers", @"lobsters", @"logicians", @"loonies",
										@"men", @"masterpieces", @"mathematicians", @"meteorites", @"morons", @"motorcycles",
										@"mountains", @"mice", @"movies", @"nerds", @"nostrils", @"omelettes", @"onions",
										@"oysters", @"parrots", @"peanuts", @"pecan pies", @"pelicans", @"penguins", @"persimmons",
										@"phasers", @"pictures", @"pixels", @"pizzas", @"politicians", @"polygons", @"potatoes",
										@"pretzels", @"primates", @"programs", @"puzzles", @"queens", @"rabbits", @"rectangles",
										@"rivers", @"robots", @"sandwiches", @"shoes", @"signs", @"sprinklers", @"stereos", @"soufflés",
										@"straightjackets", @"swamis", @"swords", @"teenagers", @"thoughts", @"tomatoes", @"teeth",
										@"telephones", @"telescopes", @"televisions", @"tennis balls", @"toes", @"toilets", @"tricycles",
										@"tummies", @"twits", @"violas", @"warthogs", @"water pistols", @"wenches", @"werewolves",
										@"wives", @"wimps", @"women", @"wombats", @"zombies"];
		defaultValues[NONSPluralNounList] = defaultPluralNouns;
	}
	
	{
#pragma mark Adjectives
		NSArray *defaultAdjectives = @[@"abashed", @"absurd", @"admirable", @"amiable", @"ashamed", @"asynchronous", @"bad", @"bald",
									   @"bitter", @"blasé", @"blissful", @"blue", @"bombastic", @"bouncy", @"brooding",
									   @"buggy", @"canine", @"carnivorous", @"chartreuse", @"cocky", @"common", @"confused",
									   @"contented", @"contrary", @"cranky", @"crazy", @"crunchy", @"dangerous",@"dead",
									   @"deadly", @"delirious", @"demented", @"demure", @"digital", @"disgruntled", @"dismayed",
									   @"distraught", @"disturbed", @"doleful", @"drunk", @"dull", @"elated", @"enraptured", @"evil",
									   @"exponential", @"fast", @"feline", @"flippant", @"fretful", @"friendly", @"frisky", @"frolicsome",
									   @"frustrated", @"furry", @"fuzzy", @"gallant", @"gargantuan", @"giddy", @"glorious", @"glowing",
									   @"glum", @"golden", @"good", @"goofy", @"green", @"grotesque", @"grumpish", @"grumpy", @"grungy",
									   @"hairy", @"happy", @"haughty", @"huffy", @"humiliating", @"hyperbolic", @"hypocritical",
									   @"inconsequential", @"inebriated", @"infuriated", @"innocent", @"innovative", @"insane",
									   @"inscrutable", @"interesting", @"intoxicated", @"itchy", @"itty-bitty", @"jaded", @"jolly",
									   @"jubilant", @"lackadaisical", @"lascivious", @"listless", @"livid", @"lonesome", @"lovelorn",
									   @"lumpy", @"lustful", @"luxurious", @"melancholy", @"metallic", @"mirthless", @"mopy", @"morose",
									   @"motheaten", @"musical", @"naked", @"nasty", @"naughty", @"new", @"nifty", @"nodal", @"nonexistent",
									   @"obese", @"orange", @"overjoyed", @"peevish", @"perforated", @"perky", @"perturbed", @"petite",
									   @"petulant", @"piggish", @"plastic", @"pleased", @"polka-dotted", @"polyester", @"prickly", @"prissy",
									   @"professional", @"pulsating", @"puny", @"purple", @"putrid", @"quadratic", @"quick", @"radioactive",
									   @"rambunctious", @"raving", @"red", @"redundant", @"relativistic", @"reptilian", @"repulsive",
									   @"resentful", @"resonant", @"restless", @"robust", @"rotten", @"ruthless", @"sad", @"sanguine",
									   @"sarcastic", @"sassy", @"seductive", @"seething", @"senile", @"serene", @"silent", @"silly",
									   @"skinny", @"sleepy", @"smug", @"sordid", @"sparkling", @"spunky", @"stoned", @"stupid", @"sulky",
									   @"sullen", @"supercilious", @"surprised", @"testy", @"tingly", @"touchy", @"tubular", @"turgid",
									   @"unexpected", @"unhinged", @"used", @"vacuous", @"vinyl", @"virtuous", @"wanton", @"warlike",
									   @"warped", @"whimsical", @"woeful", @"woolly", @"yearning"];
		defaultValues[NONSAdjectiveList] = defaultAdjectives;
	}

	{
#pragma mark Verbs
		NSArray *defaultVerbs = @[[NONSVerb verbWithArray:@[@"accepts",@"accept",@"accepted",@"accepted",@"accepting"]],
								  [NONSVerb verbWithArray:@[@"writes",@"write",@"wrote",@"written",@"writing"]],
								  [NONSVerb verbWithArray:@[@"farts",@"fart",@"farted",@"farted",@"farting"]],
								  [NONSVerb verbWithArray:@[@"arranges",@"arrange",@"arranged",@"arranged",@"arranging"]],
								  [NONSVerb verbWithArray:@[@"awakes",@"awake",@"awoke",@"awoken",@"awaking"]],
								  [NONSVerb verbWithArray:@[@"babbles",@"babble",@"babbled",@"babbled",@"babbling"]],
								  [NONSVerb verbWithArray:@[@"babbles",@"babble",@"babbled",@"babbled",@"babbling"]],
								  [NONSVerb verbWithArray:@[@"bakes",@"bake",@"baked",@"baked",@"baking"]],
								  [NONSVerb verbWithArray:@[@"barks",@"bark",@"barked",@"barked",@"barking"]],
								  [NONSVerb verbWithArray:@[@"belches",@"belch",@"belched",@"belched",@"belching"]],
								  [NONSVerb verbWithArray:@[@"breaks",@"break",@"broke",@"broken",@"breaking"]],
								  [NONSVerb verbWithArray:@[@"cooks",@"cook",@"cooked",@"cooked",@"cooking"]],
								  [NONSVerb verbWithArray:@[@"crashes",@"crash",@"crashed",@"crashed",@"crashing"]],
								  [NONSVerb verbWithArray:@[@"crawls",@"crawl",@"crawled",@"crawled",@"crawling"]],
								  [NONSVerb verbWithArray:@[@"decides",@"decide",@"decided",@"decided",@"deciding"]],
								  [NONSVerb verbWithArray:@[@"divulges",@"divulge",@"divulged",@"divulged",@"divulging"]],
								  [NONSVerb verbWithArray:@[@"dreams",@"dream",@"dreamed",@"dreamt",@"dreaming"]],
								  [NONSVerb verbWithArray:@[@"drops",@"drop",@"dropped",@"dropped",@"dropping"]],
								  [NONSVerb verbWithArray:@[@"eats",@"eat",@"ate",@"eaten",@"eating"]],
								  [NONSVerb verbWithArray:@[@"explodes",@"explode",@"exploded",@"exploded",@"exploding"]],
								  [NONSVerb verbWithArray:@[@"feels",@"feel",@"felt",@"felt",@"feeling"]],
								  [NONSVerb verbWithArray:@[@"flips",@"flip",@"flipped",@"flipped",@"flipping"]],
								  [NONSVerb verbWithArray:@[@"flies",@"fly",@"flew",@"flown",@"flying"]],
								  [NONSVerb verbWithArray:@[@"forgets",@"forget",@"forgot",@"forgotten",@"forgetting"]],
								  [NONSVerb verbWithArray:@[@"grows",@"grow",@"grew",@"grown",@"growing"]],
								  [NONSVerb verbWithArray:@[@"hacks",@"hack",@"hacked",@"hacked",@"hacking"]],
								  [NONSVerb verbWithArray:@[@"has",@"have",@"had",@"had",@"having"]],
								  [NONSVerb verbWithArray:@[@"hates",@"hate",@"hated",@"hated",@"hating"]],
								  [NONSVerb verbWithArray:@[@"hears",@"hear",@"heard",@"heard",@"hearing"]],
								  [NONSVerb verbWithArray:@[@"hiccups",@"hiccup",@"hiccuped",@"hiccuped",@"hiccuping"]],
								  [NONSVerb verbWithArray:@[@"hums",@"hum",@"hummed",@"hummed",@"humming"]],
								  [NONSVerb verbWithArray:@[@"imagines",@"imagine",@"imagined",@"imagined",@"imagining"]],
								  [NONSVerb verbWithArray:@[@"juggles",@"juggle",@"juggled",@"juggled",@"juggling"]],
								  [NONSVerb verbWithArray:@[@"jumps",@"jump",@"jumped",@"jumped",@"jumping"]],
								  [NONSVerb verbWithArray:@[@"kills",@"kill",@"killed",@"killed",@"killing"]],
								  [NONSVerb verbWithArray:@[@"kisses",@"kiss",@"kissed",@"kissed",@"kissing"]],
								  [NONSVerb verbWithArray:@[@"likes",@"like",@"liked",@"liked",@"liking"]],
								  [NONSVerb verbWithArray:@[@"looks",@"look",@"looked",@"looked",@"looking"]],
								  [NONSVerb verbWithArray:@[@"loves",@"love",@"loved",@"loved",@"loving"]],
								  [NONSVerb verbWithArray:@[@"marries",@"marry",@"married",@"married",@"marrying"]],
								  [NONSVerb verbWithArray:@[@"needs",@"need",@"needed",@"needed",@"needing"]],
								  [NONSVerb verbWithArray:@[@"nibbles",@"nibble",@"nibbled",@"nibbled",@"nibbling"]],
								  [NONSVerb verbWithArray:@[@"ogles",@"ogle",@"ogled",@"ogled",@"ogling"]],
								  [NONSVerb verbWithArray:@[@"plays",@"play",@"played",@"played",@"playing"]],
								  [NONSVerb verbWithArray:@[@"pops",@"pop",@"popped",@"popped",@"popping"]],
								  [NONSVerb verbWithArray:@[@"proves",@"prove",@"proved",@"proven",@"proving"]],
								  [NONSVerb verbWithArray:@[@"pulls",@"pull",@"pulled",@"pulled",@"pulling"]],
								  [NONSVerb verbWithArray:@[@"purrs",@"purr",@"purred",@"purred",@"purring"]],
								  [NONSVerb verbWithArray:@[@"pushes",@"push",@"pushed",@"pushed",@"pushing"]],
								  [NONSVerb verbWithArray:@[@"rotates",@"rotate",@"rotated",@"rotated",@"rotating"]],
								  [NONSVerb verbWithArray:@[@"runs",@"run",@"ran",@"run",@"running"]],
								  [NONSVerb verbWithArray:@[@"says",@"say",@"said",@"said",@"saying"]],
								  [NONSVerb verbWithArray:@[@"seems",@"seem",@"seemed",@"seemed",@"seeming"]],
								  [NONSVerb verbWithArray:@[@"shrinks",@"shrink",@"shrank",@"shrunk",@"shrinking"]],
								  [NONSVerb verbWithArray:@[@"sighs",@"sigh",@"sighed",@"sighed",@"sighing"]],
								  [NONSVerb verbWithArray:@[@"sleeps",@"sleep",@"slept",@"slept",@"sleeping"]],
								  [NONSVerb verbWithArray:@[@"smells",@"smell",@"smelled",@"smelled",@"smelling"]],
								  [NONSVerb verbWithArray:@[@"smiles",@"smile",@"smiled",@"smiled",@"smiling"]],
								  [NONSVerb verbWithArray:@[@"sneezes",@"sneeze",@"sneezed",@"sneezed",@"sneezing"]],
								  [NONSVerb verbWithArray:@[@"sounds",@"sound",@"sounded",@"sounded",@"sounding"]],
								  [NONSVerb verbWithArray:@[@"sprouts",@"sprout",@"sprouted",@"sprouted",@"sprouting"]],
								  [NONSVerb verbWithArray:@[@"stalks",@"stalk",@"stalked",@"stalked",@"stalking"]],
								  [NONSVerb verbWithArray:@[@"stomps",@"stomp",@"stomped",@"stomped",@"stomping"]],
								  [NONSVerb verbWithArray:@[@"sulks",@"sulk",@"sulked",@"sulked",@"sulking"]],
								  [NONSVerb verbWithArray:@[@"swims",@"swim",@"swam",@"swam",@"swimming"]],
								  [NONSVerb verbWithArray:@[@"tastes",@"taste",@"tasted",@"tasted",@"tasting"]],
								  [NONSVerb verbWithArray:@[@"terminates",@"terminate",@"terminated",@"terminated",@"terminating"]],
								  [NONSVerb verbWithArray:@[@"thinks",@"think",@"thought",@"thought",@"thinking"]],
								  [NONSVerb verbWithArray:@[@"tickles",@"tickle",@"tickled",@"tickled",@"tickling"]],
								  [NONSVerb verbWithArray:@[@"tosses",@"toss",@"tossed",@"tossed",@"tossing"]],
								  [NONSVerb verbWithArray:@[@"wants",@"want",@"wanted",@"wanted",@"wanting"]],
								  [NONSVerb verbWithArray:@[@"wobbles",@"wobble",@"wobbled",@"wobbled",@"wobbling"]]];
		defaultValues[NONSVerbList] = [self prepareVerbsForSaving:defaultVerbs];
	}
	
	{
#pragma mark Adverbs
		NSArray *defaultAdverbs = @[@"accidentally", @"automatically", @"awfully", @"carefully", @"carelessly",
									@"drunkenly", @"enthusiastically", @"furiously", @"gloriously", @"hesitantly", @"hopefully",
									@"idiotically", @"inquisitively", @"insanely", @"longingly", @"melodramatically",
									@"occasionally", @"painfully", @"partially", @"perversely", @"playfully", @"psychotically",
									@"quickly", @"repeatedly", @"rudely", @"ruthlessly", @"sarcastically", @"sardonically",
									@"slowly", @"sometimes", @"stupidly", @"typically", @"vehemently", @"voraciously",
									@"intelegently"];
		defaultValues[NONSAdverbList] = defaultAdverbs;
	}
	
	{
#pragma mark Proper Nouns
		NSArray *defaultProperNouns = @[@"Al Gore", @"Arnold Schwarzenegger", @"Ben", @"Bill Clinton", @"Bob",
										@"Boris Yeltsin", @"Carl", @"Carol", @"Charlene", @"Cleopatra",
										@"Dan Quayle", @"Elvis", @"Ernie", @"Fiona", @"George Bush", @"Gina",
										@"God", @"Godzilla", @"Hillary Clinton", @"Houdini", @"J. S. Bach",
										@"James Bond", @"John Wayne", @"Kevin", @"Linda", @"Liz", @"Lora", @"Mark",
										@"Mick Jagger", @"Mike", @"My Dog Bo-bo", @"Prince Charles", @"Robert",
										@"Scott", @"Shayne", @"Syd", @"Tom", @"Warren"];
		defaultValues[NONSProperNounList] = defaultProperNouns;
	}

	{
#pragma mark Massive Nouns
		NSArray *defaultMassiveNouns =  @[@"déjà vu", @"freedom", @"grass", @"hair", @"Kryptonite", @"lard", @"lasagna",
										  @"lava", @"music", @"orange juice", @"peanut butter", @"rice", @"salad", @"sand",
										  @"skin", @"slime", @"smoke", @"software", @"space", @"spaghetti", @"spinach",
										  @"underwear", @"water"];
		defaultValues[NONSMassiveNounList] = defaultMassiveNouns;
	}
	
	{
#pragma mark Interjections
		NSArray *defaultInterjections = @[@"Ah", @"Alas", @"Dear me", @"Goodness", @"Eh", @"Er", @"Hello",
										  @"Hey", @"Hi", @"Hmm", @"Oh", @"Ouch", @"Uh", @"Um", @"Umm",
										  @"Well", @"Gosh", @"Jeez", @"Wow", @"Oh my", @"Crud", @"Jeepers",
										  @"Darn", @"Yikes"];

		defaultValues[NONSInterjections] = defaultInterjections;
	}
#if !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
#else
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
#endif
	[defaults registerDefaults:defaultValues];
}

@end
