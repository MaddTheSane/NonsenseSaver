//
//  AppController.h
//
//  Created by C.W. Betts on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NonsenseView.h"

@interface AppController : NSObject

@property (weak) IBOutlet NonsenseView *nonsenseView;
@property (weak) IBOutlet NSTextField *userGeneratedNonsense;

- (IBAction)generateNonsense:(id)sender;

@end
