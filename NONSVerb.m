//
//  NONSVerb.m
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NONSVerb.h"
#import "ARCBridge.h"

NSString * const ThirdPersonSinglePresent = @"ThirdPersonSinglePresent";
NSString * const ThirdPersonPluralPresent = @"ThirdPersonPluralPresent";
NSString * const ThirdPersonPast = @"ThirdPersonPast";
NSString * const ThirdPersonPastPerfect = @"ThirdPersonPastPerfect";
NSString * const ThirdPersonPresentCont = @"ThirdPersonPresentCont";

@implementation NONSVerb
-(id)initWithSinglePresent:(NSString *)singlePresent pluralPresent:(NSString *)pluralPresent past:(NSString *)past pastPerfect:(NSString *)pastPerfect presentCont:(NSString *)presentCont
{
	self = [super init];
	if (self) {
		self.verbThirdPersonSinglePresent = singlePresent;
		self.verbThirdPersonPluralPresent = pluralPresent;
		self.verbThirdPersonPast = past;
		self.verbThirdPersonPastPerfect = pastPerfect;
		self.verbThirdPersonPresentCont = presentCont;
	}
	return self;
}

-(id)initWithArray:(NSArray *)array
{
	if ([array count] < 5) {
		NSLog(@"Array %@ too small! Not initializing!", array);
		AUTORELEASEOBJNORETURN(self);
		return nil;
	} else if ([array count] > 5) {
		NSLog(@"Array %@ too big! Ignoring other values.", array);
	}
	return [self initWithSinglePresent:array[0] pluralPresent:array[1] past:array[2] pastPerfect:array[3] presentCont:array[4]];
}

+(NONSVerb*)verbWithSinglePresent:(NSString *)singlePresent pluralPresent:(NSString *)pluralPresent past:(NSString *)past pastPerfect:(NSString *)pastPerfect presentCont:(NSString *)presentCont
{
	NONSVerb *verb = [[NONSVerb alloc] initWithSinglePresent:singlePresent pluralPresent:pluralPresent past:past pastPerfect:pastPerfect presentCont:presentCont];
	return AUTORELEASEOBJ(verb);
}

+(NONSVerb*)verbWithArray:(NSArray*)array
{
	NONSVerb *verb = [[NONSVerb alloc] initWithArray:array];
	if (!verb) {
		return nil;
	}
	return AUTORELEASEOBJ(verb);
}

#if !__has_feature(objc_arc)
-(void)dealloc
{
	self.verbThirdPersonSinglePresent = nil;
	self.verbThirdPersonPluralPresent = nil;
	self.verbThirdPersonPast = nil;
	self.verbThirdPersonPastPerfect = nil;
	self.verbThirdPersonPresentCont = nil;

	[super dealloc];
}
#endif

-(NSString *)description
{
	return verbThirdPersonPluralPresent;
}

@synthesize verbThirdPersonSinglePresent;
@synthesize verbThirdPersonPluralPresent;
@synthesize verbThirdPersonPast;
@synthesize verbThirdPersonPastPerfect;
@synthesize verbThirdPersonPresentCont;

-(BOOL)isEqual:(id)object
{
	if ([object isKindOfClass:[NONSVerb class]]) {
		int i=0;
		if ([verbThirdPersonPast isEqualToString:[object verbThirdPersonPast]]) {
			i++;
		}
		if ([verbThirdPersonSinglePresent isEqualToString:[object verbThirdPersonSinglePresent]]) {
			i++;
		}
		if ([verbThirdPersonPluralPresent isEqualToString:[object verbThirdPersonPluralPresent]]) {
			i++;
		}
		if ([verbThirdPersonPastPerfect isEqualToString:[object verbThirdPersonPastPerfect]]) {
			i++;
		}
		if ([verbThirdPersonPresentCont isEqualToString:[object verbThirdPersonPresentCont]]) {
			i++;
		}
		if (i) {
			return YES;
		} else {
			return NO;
		}
	} else if ([object isKindOfClass:[NSString class]]) {
		int i=0;
		if ([verbThirdPersonPast isEqualToString:object]) {
			i++;
		}
		if ([verbThirdPersonSinglePresent isEqualToString:object]) {
			i++;
		}
		if ([verbThirdPersonPluralPresent isEqualToString:object]) {
			i++;
		}
		if ([verbThirdPersonPastPerfect isEqualToString:object]) {
			i++;
		}
		if ([verbThirdPersonPresentCont isEqualToString:object]) {
			i++;
		}
		if (i) {
			return YES;
		} else {
			return NO;
		}
	} else {
		return NO;
	}
}
#if 0
#pragma mark Archiving

-(id)initWithCoder:(NSCoder *)decoder {
	
	if ((self = [super init])) 
	{
		if ([decoder allowsKeyedCoding]) {
			verbThirdPersonSinglePresent = [[decoder decodeObjectForKey:ThirdPersonSinglePresent] retain];
			verbThirdPersonPluralPresent = [[decoder decodeObjectForKey:ThirdPersonPluralPresent] retain];
			verbThirdPersonPast = [[decoder decodeObjectForKey:ThirdPersonPast] retain];
			verbThirdPersonPastPerfect = [[decoder decodeObjectForKey:ThirdPersonPastPerfect] retain];
			verbThirdPersonPresentCont = [[decoder decodeObjectForKey:ThirdPersonPresentCont] retain];
		} else {
			NSDictionary *dict = [decoder decodeObject];
			verbThirdPersonSinglePresent = [[dict objectForKey:ThirdPersonSinglePresent] retain];
			verbThirdPersonPluralPresent = [[dict objectForKey:ThirdPersonPluralPresent] retain];
			verbThirdPersonPast = [[dict objectForKey:ThirdPersonPast] retain];
			verbThirdPersonPastPerfect = [[dict objectForKey:ThirdPersonPastPerfect] retain];
			verbThirdPersonPresentCont = [[dict objectForKey:ThirdPersonPresentCont] retain];
		}
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:verbThirdPersonSinglePresent forKey:ThirdPersonSinglePresent];
		[encoder encodeObject:verbThirdPersonPluralPresent forKey:ThirdPersonPluralPresent];
		[encoder encodeObject:verbThirdPersonPast forKey:ThirdPersonPast];
		[encoder encodeObject:verbThirdPersonPastPerfect forKey:ThirdPersonPastPerfect];
		[encoder encodeObject:verbThirdPersonPresentCont forKey:ThirdPersonPresentCont];

	} else {
		NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:verbThirdPersonSinglePresent, verbThirdPersonPluralPresent, verbThirdPersonPast, verbThirdPersonPastPerfect, verbThirdPersonPresentCont, nil] forKeys:[NSArray arrayWithObjects:ThirdPersonSinglePresent, ThirdPersonPluralPresent, ThirdPersonPast, ThirdPersonPastPerfect, ThirdPersonPresentCont, nil]];
		[encoder encodeObject:dict];
	}
}
#endif
@end
