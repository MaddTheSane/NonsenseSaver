//
//  NONSVerb.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ThirdPersonSinglePresent;
extern NSString * const ThirdPersonPluralPresent;
extern NSString * const ThirdPersonPast;
extern NSString * const ThirdPersonPastPerfect;
extern NSString * const ThirdPersonPresentCont;

@interface NONSVerb : NSObject /*<NSCoding>*/
@property (readonly, copy) NSString *verbThirdPersonSinglePresent;
@property (readonly, copy) NSString *verbThirdPersonPluralPresent;
@property (readonly, copy) NSString *verbThirdPersonPast;
@property (readonly, copy) NSString *verbThirdPersonPastPerfect;
@property (readonly, copy) NSString *verbThirdPersonPresentCont;

- (id)initWithSinglePresent:(NSString *)singlePresent pluralPresent:(NSString *)pluralPresent past:(NSString *)past pastPerfect:(NSString *)pastPerfect presentCont:(NSString *)presentCont;
- (id)initWithArray:(NSArray *)array;
+ (NONSVerb*)verbWithArray:(NSArray*)array;
+ (NONSVerb*)verbWithSinglePresent:(NSString *)singlePresent pluralPresent:(NSString *)pluralPresent past:(NSString *)past pastPerfect:(NSString *)pastPerfect presentCont:(NSString *)presentCont;

@end
