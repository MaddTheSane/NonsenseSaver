//
//  NONSVerb.m
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NONSVerb.h"

NSString *ThirdPersonSinglePresent = @"ThirdPersonSinglePresent";
NSString *ThirdPersonPluralPresent = @"ThirdPersonPluralPresent";
NSString *ThirdPersonPast = @"ThirdPersonPast";
NSString *ThirdPersonPastPerfect = @"ThirdPersonPastPerfect";
NSString *ThirdPersonPresentCont = @"ThirdPersonPresentCont";

@implementation NONSVerb
-(id)initWithSinglePresent:(NSString *)singlePresent pluralPresent:(NSString *)pluralPresent past:(NSString *)past pastPerfect:(NSString *)pastPerfect presentCont:(NSString *)presentCont
{
	self = [super init];
	if (self) {
		verbThirdPersonSinglePresent = [singlePresent copy];
		verbThirdPersonPluralPresent = [pluralPresent copy];
		verbThirdPersonPast = [past copy];
		verbThirdPersonPastPerfect = [pastPerfect copy];
		verbThirdPersonPresentCont = [presentCont copy];
	}
	return self;
}

-(id)initWithArray:(NSArray *)array
{
	if ([array count] < 5) {
		NSLog(@"Array %@ too small! Not initializing!", array);
		[self autorelease];
		return nil;
	} else if ([array count] > 5) {
		NSLog(@"Array %@ too big! Ignoring other values.", array);
	}
	return [self initWithSinglePresent:[array objectAtIndex:0] pluralPresent:[array objectAtIndex:1] past:[array objectAtIndex:2] pastPerfect:[array objectAtIndex:3] presentCont:[array objectAtIndex:4]];
}

+(NONSVerb*)verbWithSinglePresent:(NSString *)singlePresent pluralPresent:(NSString *)pluralPresent past:(NSString *)past pastPerfect:(NSString *)pastPerfect presentCont:(NSString *)presentCont
{
	NONSVerb *verb = [[NONSVerb alloc] initWithSinglePresent:singlePresent pluralPresent:pluralPresent past:past pastPerfect:pastPerfect presentCont:presentCont];
	return [verb autorelease];
}

+(NONSVerb*)verbWithArray:(NSArray*)array
{
	NONSVerb *verb = [[NONSVerb alloc] initWithArray:array];
	if (!verb) {
		return nil;
	}
	return [verb autorelease];
}

-(void)dealloc
{
	[verbThirdPersonSinglePresent release];
	[verbThirdPersonPluralPresent release];
	[verbThirdPersonPast release];
	[verbThirdPersonPastPerfect release];
	[verbThirdPersonPresentCont release];

	[super dealloc];
}

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
