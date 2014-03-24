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

-(id)initWithString:(NSString *)nonString bounds:(NSRect)bound;
-(id)initWithString:(NSString *)nonString bounds:(NSRect)bound font:(NSFont *)theFont;

-(void)draw;
-(void)drawWithBackground:(BOOL)bgDraw;
@end
