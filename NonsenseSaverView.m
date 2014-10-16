//
//  NonsenseSaverView.m
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright (c) 2010, __MyCompanyName__. All rights reserved.
//

#import "NonsenseSaverView.h"
//#import "NonsenseSaverController.h"
#import "NONSVerb.h"
#import "NonsenseObject.h"
#import "Constants.h"
#import "NonsenseSaver-Swift.h"

#define NONSAtATime @"Number at a time"
#define NONSDuration @"Nonsense Duration"
#define NONSBGColor @"Show Background"

@interface NonsenseSaverView ()
@property (strong) NSMutableArray *nonsenses;
@property (strong) NonsenseSaverController *controller;
@end

@implementation NonsenseSaverView
@synthesize nonNumber;
@synthesize nonDuration;
@synthesize showBackground;
@synthesize controller;
@synthesize configureSheet;
@synthesize vocabSelector;
@synthesize vocabList;

@synthesize verbWindow;
@synthesize fieldWord;
@synthesize wordToAdd;
@synthesize wordWindow;
@synthesize credits;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
		NSFont *theFont;
		srandom(0xFFFFFFFF & time(NULL));
		self.controller = [[NonsenseSaverController alloc] init];
		self.nonsenses = [[NSMutableArray alloc] init];
		
		//Set the Defaults
		ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
		self.nonNumber = [defaults integerForKey:NONSAtATime];
		self.nonDuration = [defaults doubleForKey:NONSDuration];
		self.showBackground = [defaults boolForKey:NONSBGColor];
		[self setAnimationTimeInterval:[self nonDuration]];
		
		//Create Nonsense
		if (isPreview)
		{
			theFont = [NSFont fontWithName:@"Helvetica" size:kPreviewSize];
		} else {
			theFont = [NSFont fontWithName:@"Helvetica" size:kFullSize];
		}
		
		for (int i = 0; i < [self nonNumber] ; i++ ) {
			NonsenseObject *non = [[NonsenseObject alloc] initWithString:[controller radomSaying] bounds:[self bounds] font:theFont];
			[_nonsenses addObject:non];
		}
    }
    return self;
}

#if 0
- (void)startAnimation {
    [super startAnimation];
}

- (void)stopAnimation {
    [super stopAnimation];
}
#endif

- (void)drawRect:(NSRect)rect
{
	//Clear the screen
	[super drawRect:rect];
	NSFont *theFont = nil;
	if ([self isPreview]) {
		theFont = [NSFont systemFontOfSize:kPreviewSize];
	} else {
		theFont = [NSFont systemFontOfSize:kFullSize];
	}
	for(NonsenseObject *obj in _nonsenses) {
		[obj drawWithBackground:[self showBackground]];
	}
	[_nonsenses removeObjectAtIndex:0];
	NonsenseObject *non = [[NonsenseObject alloc] initWithString:[controller radomSaying] bounds:[self bounds] font:theFont];
	[_nonsenses addObject:non];
}

- (void)animateOneFrame
{
    [self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Configure Sheet functions

- (IBAction)addNonsense:(id)sender
{
	switch ([self vocabSelectorSelected]) {
		case 0:
			[[fieldWord cell] setPlaceholderString:@"cat"];
			[wordToAdd setStringValue:@"Singluar Noun"];
			[NSApp beginSheet:wordWindow modalForWindow:configureSheet modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			break;
		case 1:
			[[fieldWord cell] setPlaceholderString:@"cats"];
			[wordToAdd setStringValue:@"Plural Noun"];
			[NSApp beginSheet:wordWindow modalForWindow:configureSheet modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			break;
		case 2:
			[[fieldWord cell] setPlaceholderString:@"blue"];
			[wordToAdd setStringValue:@"Adjective"];
			[NSApp beginSheet:wordWindow modalForWindow:configureSheet modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			break;
		case 3:
			[NSApp beginSheet:verbWindow modalForWindow:configureSheet modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			break;
		case 4:
			[[fieldWord cell] setPlaceholderString:@"quickly"];
			[wordToAdd setStringValue:@"Adverb"];
			[NSApp beginSheet:wordWindow modalForWindow:configureSheet modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			break;
		case 5:
			[[fieldWord cell] setPlaceholderString:@"water"];
			[wordToAdd setStringValue:@"Massive Noun"];
			[NSApp beginSheet:wordWindow modalForWindow:configureSheet modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			break;
		case 6:
			[[fieldWord cell] setPlaceholderString:@"Al Gore"];
			[wordToAdd setStringValue:@"Proper Noun"];
			[NSApp beginSheet:wordWindow modalForWindow:configureSheet modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			break;
		case 7:
			[[fieldWord cell] setPlaceholderString:@"Hey"];
			[wordToAdd setStringValue:@"Interjection"];
			[NSApp beginSheet:wordWindow modalForWindow:configureSheet modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
			break;

			
		default:
			break;
	};
	[vocabList reloadData];
}

- (IBAction)closeNonsense:(id)sender
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
	if ([sender tag] != 1) {
		[controller saveSettings];
		[defaults setInteger:self.nonNumber forKey:NONSAtATime];
		[defaults setDouble:self.nonDuration forKey:NONSDuration];
		[defaults setBool:self.showBackground forKey:NONSBGColor];
		[defaults synchronize];
		[self setAnimationTimeInterval:nonDuration];
		
		[_nonsenses removeAllObjects];
		for (int i = 0; i < [self nonNumber] ; i++ ) {
			NonsenseObject *non = [[NonsenseObject alloc] initWithString:[controller radomSaying] bounds:[self bounds] font:[NSFont systemFontOfSize:kPreviewSize]];
			[_nonsenses addObject:non];
		}
	} else {
		[controller loadSettings];
		self.nonNumber = [defaults integerForKey:NONSAtATime];
		self.nonDuration = [defaults doubleForKey:NONSDuration];
		self.showBackground = [defaults boolForKey:NONSBGColor];
	}
	[NSApp endSheet:configureSheet];
}

- (IBAction)removeNonsense:(id)sender
{
    NSInteger row = [vocabList selectedRow];
	if (row == -1) {
		NSBeep();
		return;
	}
	NSArray *tempArray;
	NSString *tempString;
	switch ([self vocabSelectorSelected]) {
		case 0:
			tempArray = [controller singularNouns];
			tempString = tempArray[row];
			[controller removeSingularNoun:tempString];
			break;
		case 1:
			tempArray = [controller pluralNouns];
			tempString = tempArray[row];
			[controller removePluralNoun:tempString];			
			break;
		case 2:
			tempArray = [controller adjectives];
			tempString = tempArray[row];
			[controller removeAdjective:tempString];
			break;
		case 3:
		{
			tempArray = [controller verbs];
			NONSVerb *tempVerb = tempArray[row];
			[controller removeVerb:tempVerb];
		}
			break;
		case 4:
			tempArray = [controller adverbs];
			tempString = tempArray[row];
			[controller removeAdverb:tempString];
			break;
		case 5:
			tempArray = [controller massiveNouns];
			tempString = tempArray[row];
			[controller removeMassiveNoun:tempString];
			break;
		case 6:
			tempArray = [controller properNouns];
			tempString = tempArray[row];
			[controller removeProperNoun:tempString];
			break;
			
		default:
			NSBeep();
			break;
	};
	[vocabList reloadData];
}

- (IBAction)changeVocabView:(id)sender
{
	[vocabList reloadData];
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    if (configureSheet == nil) {
		[NSBundle loadNibNamed:@"NonsenseSettings" owner:self];
		[credits readRTFDFromFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"Credits" ofType:@"rtf"]];
	}
	return configureSheet;
}

+(void)initialize
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
	[defaults registerDefaults:@{NONSAtATime: @3, NONSDuration: @2.7, NONSBGColor: @YES}];
}

#pragma mark Table View delegate methods

- (NSInteger)numberOfRowsInTableView:(NSTableView*)aTableView
{
	switch ([self vocabSelectorSelected]) {
		case 0:
			return [[controller singularNouns] count];
			break;
		case 1:
			return [[controller pluralNouns] count];
			break;
		case 2:
			return [[controller adjectives] count];
			break;
		case 3:
			return [[controller verbs] count];
			break;
		case 4:
			return [[controller adverbs] count];
			break;
		case 5:
			return [[controller massiveNouns] count];
			break;
		case 6:
			return [[controller properNouns] count];
			break;
			
		default:
			return 0;
			break;
	};
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aColumn row:(NSInteger)rowIndex
{
	switch ([self vocabSelectorSelected]) {
		case 0:
			return [controller singularNouns][rowIndex];
			break;
		case 1:
			return [controller pluralNouns][rowIndex];
			break;
		case 2:
			return [controller adjectives][rowIndex];
			break;
		case 3:
			return [controller verbs][rowIndex];
			break;
		case 4:
			return [controller adverbs][rowIndex];
			break;
		case 5:
			return [controller massiveNouns][rowIndex];
			break;
		case 6:
			return [controller properNouns][rowIndex];
			break;
			
		default:
			return nil;
			break;
	};	
}

- (NSInteger)vocabSelectorSelected
{
	id selectedCell = [vocabSelector selectedCell];
	if ([vocabSelector cellAtRow:0 column:0] == selectedCell) {
		return 0;
	} else if ([vocabSelector cellAtRow:1 column:0] == selectedCell) {
		return 1;
	} else if ([vocabSelector cellAtRow:2 column:0] == selectedCell) {
		return 2;
	} else if ([vocabSelector cellAtRow:3 column:0] == selectedCell) {
		return 3;
	} else if ([vocabSelector cellAtRow:4 column:0] == selectedCell) {
		return 4;
	} else if ([vocabSelector cellAtRow:5 column:0] == selectedCell) {
		return 5;
	} else if ([vocabSelector cellAtRow:6 column:0] == selectedCell) {
		return 6;
	} else {
		return -1;
	}
}

#pragma mark Adding Windows

- (void)clearVerbWindow
{
	[self.fieldThirdPersonSinglePresent setStringValue:@""];
	[self.fieldThirdPersonPluralPresent setStringValue:@""];
	[self.fieldThirdPersonPast setStringValue:@""];
	[self.fieldThirdPersonPastPerfect setStringValue:@""];
	[self.fieldThirdPersonPresentCont setStringValue:@""];
}

- (IBAction)addVerb:(id)sender
{
	short i = 0;
	NSString *thirdPersSingPres, *thirdPersPlurPres, *ThirdPersPas, *thirPersPasPer, *thirPersPresCont;
	thirdPersSingPres = [self.fieldThirdPersonSinglePresent stringValue];
	thirdPersPlurPres = [self.fieldThirdPersonPluralPresent stringValue];
	ThirdPersPas = [self.fieldThirdPersonPast stringValue];
	thirPersPasPer = [self.fieldThirdPersonPastPerfect stringValue];
	thirPersPresCont =[self.fieldThirdPersonPresentCont stringValue];
	if (![thirdPersSingPres isEqualToString:@""]) {
		i++;
	}
	if (![thirdPersPlurPres isEqualToString:@""]) {
		i++;
	}
	if (![ThirdPersPas isEqualToString:@""]) {
		i++;
	}
	if (![thirPersPasPer isEqualToString:@""]) {
		i++;
	}
	if (![thirPersPresCont isEqualToString:@""]) {
		i++;
	}
	
	if (i == 5) {
		[controller addVerb:[NONSVerb verbWithSinglePresent:thirdPersSingPres pluralPresent:thirdPersPlurPres past:ThirdPersPas pastPerfect:thirPersPasPer presentCont:thirPersPresCont]];
		[NSApp endSheet:verbWindow];
		[self clearVerbWindow];
		[verbWindow orderOut:sender];		
	} else {
		NSAlert *noVerb = [NSAlert alertWithMessageText:@"Incomplete Verb" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"The verb doesn't have all members filled. Please fill them out."];
		[noVerb beginSheetModalForWindow:verbWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
	}
}

- (IBAction)cancelAddVerb:(id)sender
{
	[NSApp endSheet:verbWindow];
	[self clearVerbWindow];
	[verbWindow orderOut:sender];
}

- (void)clearWordWindow
{
	[fieldWord setStringValue:@""];
}

- (IBAction)addWord:(id)sender
{
	if ([[fieldWord stringValue] isEqualToString:@""]) {
		NSAlert *noVerb = [NSAlert alertWithMessageText:@"No Word" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please enter a word."];
		[noVerb beginSheetModalForWindow:wordWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
		return;
	}
	switch ([self vocabSelectorSelected]) {
		case 0:
			[controller addSingularNoun:[fieldWord stringValue]];
			break;
			
		case 1:
			[controller addPluralNoun:[fieldWord stringValue]];
			break;
			
		case 2:
			[controller addAdjective:[fieldWord stringValue]];
			break;
			
		case 4:
			[controller addAdverb:[fieldWord stringValue]];
			break;
			
		case 5:
			[controller addMassiveNoun:[fieldWord stringValue]];
			break;
			
		case 6:
			[controller addProperNoun:[fieldWord stringValue]];
			break;
			
		default:
			break;
	};
	
	[NSApp endSheet:wordWindow];
	[self clearWordWindow];
	[wordWindow orderOut:sender];
}

- (IBAction)cancelAddWord:(id)sender
{
	[NSApp endSheet:wordWindow];
	[self clearWordWindow];
	[wordWindow orderOut:sender];	
}

@end
