//
//  NONSVerb.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *ThirdPersonSinglePresent;
extern NSString *ThirdPersonPluralPresent;
extern NSString *ThirdPersonPast;
extern NSString *ThirdPersonPastPerfect;
extern NSString *ThirdPersonPresentCont;


@interface NONSVerb : NSObject /*<NSCoding>*/ {
	NSString *verbThirdPersonSinglePresent;
	NSString *verbThirdPersonPluralPresent;
	NSString *verbThirdPersonPast;
	NSString *verbThirdPersonPastPerfect;
	NSString *verbThirdPersonPresentCont;
}
-(id)initWithSinglePresent:(NSString *)singlePresent pluralPresent:(NSString *)pluralPresent past:(NSString *)past pastPerfect:(NSString *)pastPerfect presentCont:(NSString *)presentCont;
-(id)initWithArray:(NSArray *)array;
+(NONSVerb*)verbWithArray:(NSArray*)array;
+(NONSVerb*)verbWithSinglePresent:(NSString *)singlePresent pluralPresent:(NSString *)pluralPresent past:(NSString *)past pastPerfect:(NSString *)pastPerfect presentCont:(NSString *)presentCont;


@property (readwrite, copy) NSString *verbThirdPersonSinglePresent;
@property (readwrite, copy) NSString *verbThirdPersonPluralPresent;
@property (readwrite, copy) NSString *verbThirdPersonPast;
@property (readwrite, copy) NSString *verbThirdPersonPastPerfect;
@property (readwrite, copy) NSString *verbThirdPersonPresentCont;
@end
