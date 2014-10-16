//
//  NonsenseObject.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kPreviewSize 12
#define kFullSize 30

@interface NonsenseObject : NSObject
@property (readonly, copy) NSString *nonsense;

-(instancetype)initWithString:(NSString *)nonString bounds:(NSRect)bound;
-(instancetype)initWithString:(NSString *)nonString bounds:(NSRect)bound font:(NSFont *)theFont NS_DESIGNATED_INITIALIZER;

-(void)draw;
-(void)drawWithBackground:(BOOL)bgDraw;
@end
