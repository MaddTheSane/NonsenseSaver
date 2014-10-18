//
//  NonsenseSaverView.h
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright (c) 2010, __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface NonsenseSaverView454 : ScreenSaverView <NSTableViewDataSource>
@property (readwrite) NSInteger nonNumber;
@property (readwrite) CGFloat nonDuration;
@property (readwrite) BOOL showBackground;
@property (weak) IBOutlet NSFormCell *fieldThirdPersonPast;
@property (weak) IBOutlet NSFormCell *fieldThirdPersonPastPerfect;
@property (weak) IBOutlet NSFormCell *fieldThirdPersonPluralPresent;
@property (weak) IBOutlet NSFormCell *fieldThirdPersonPresentCont;
@property (weak) IBOutlet NSFormCell *fieldThirdPersonSinglePresent;

@property (weak, nonatomic) IBOutlet NSWindow *configureSheet;
@property (weak) IBOutlet NSMatrix *vocabSelector;
@property (weak) IBOutlet NSTableView *vocabList;
	
@property (weak) IBOutlet NSWindow *verbWindow;
@property (weak) IBOutlet NSTextField *fieldWord;
@property (weak) IBOutlet NSTextField *wordToAdd;
@property (weak) IBOutlet NSWindow *wordWindow;
@property (unsafe_unretained) IBOutlet NSTextView *credits;


- (IBAction)closeNonsense:(id)sender;

- (IBAction)addNonsense:(id)sender;
- (IBAction)removeNonsense:(id)sender;
- (IBAction)changeVocabView:(id)sender;

- (IBAction)addVerb:(id)sender;
- (IBAction)cancelAddVerb:(id)sender;
- (IBAction)addWord:(id)sender;
- (IBAction)cancelAddWord:(id)sender;

- (NSInteger)vocabSelectorSelected;

@end
