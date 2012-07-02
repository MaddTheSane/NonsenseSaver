//
//  NGAppDelegate.h
//  Nonsense Generator
//
//  Created by Charles Betts on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGViewController;

@interface NGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NGViewController *viewController;

@end
