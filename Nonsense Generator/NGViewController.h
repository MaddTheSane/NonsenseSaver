//
//  NGViewController.h
//  Nonsense Generator
//
//  Created by Charles Betts on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NonsenseSaverController;

@interface NGViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *nonsenseList;
@property (retain, nonatomic) NSMutableArray *nonsenses;
@property (readonly, nonatomic) NonsenseSaverController *controller;
- (IBAction)GenerateNonsense:(id)sender;
- (IBAction)showSettings:(id)sender;

@end
