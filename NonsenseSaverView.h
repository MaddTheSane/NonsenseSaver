//
//  NonsenseSaverView.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright (c) 2010, __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface NonsenseSaverView : ScreenSaverView <NSTableViewDataSource>
{
	IBOutlet NSWindow *configureSheet;
    IBOutlet NSMatrix *vocabSelector;
	IBOutlet NSTableView *vocabList;
	
	IBOutlet NSTextField *fieldThirdPersonPast;
    IBOutlet NSTextField *fieldThirdPersonPastPerfect;
    IBOutlet NSTextField *fieldThirdPersonPluralPresent;
    IBOutlet NSTextField *fieldThirdPersonPresentCont;
    IBOutlet NSTextField *fieldThirdPersonSinglePresent;
    IBOutlet NSWindow *verbWindow;
    IBOutlet NSTextField *fieldWord;
    IBOutlet NSTextField *wordToAdd;
	IBOutlet NSWindow *wordWindow;
	IBOutlet NSTextView *credits;
}

@property (readwrite) NSInteger nonNumber;
@property (readwrite) CGFloat nonDuration;
@property (readwrite) BOOL showBackground;

- (IBAction)addNonsense:(id)sender;
- (IBAction)cancelNonsense:(id)sender;
- (IBAction)okayNonsense:(id)sender;
- (IBAction)removeNonsense:(id)sender;
- (IBAction)changeVocabView:(id)sender;

- (IBAction)addVerb:(id)sender;
- (IBAction)cancelAddVerb:(id)sender;
- (IBAction)addWord:(id)sender;
- (IBAction)cancelAddWord:(id)sender;

- (NSInteger)vocabSelectorSelected;

@end
