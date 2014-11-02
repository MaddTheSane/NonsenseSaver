//
//  AppController.m
//
//  Created by C.W. Betts on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
//#import "NonsenseView.h"
#import "NONSVisualTester-Swift.h"

int main(int argc, char *argv[])
{
	return NSApplicationMain(argc, (const char**)argv);	
}

@implementation AppController

- (IBAction)generateNonsense:(id)sender {
	NSString *ourStr = [self.nonsenseView.nonsenseController randomSaying];
	[self.userGeneratedNonsense setStringValue:ourStr];
}

@end
