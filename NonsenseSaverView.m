//
//  NonsenseSaverView.m
//  NonsenseSaver
//
//  Created by C.W. Betts on 8/18/10.
//  Copyright (c) 2010, __MyCompanyName__. All rights reserved.
//

#import "NonsenseSaverView.h"
#import "NonsenseSaverController.h"
#import "NONSVerb.h"
#import "NonsenseObject.h"

static NSString *NONSAtATime =	@"Number at a time";
static NSString *NONSDuration =	@"Nonsense Duration";
static NSString *NONSBGColor =	@"Show Background";
static NSString *NONSDefaults =	@"NonsenseSaver";

@implementation NonsenseSaverView

@synthesize nonNumber;
@synthesize nonDuration;
@synthesize showBackground;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
		srandom(0xFFFFFFFF & time(NULL));
		controller = [[NonsenseSaverController alloc] init];
		nonsenses = [[NSMutableArray alloc] init];
		
		//Set the Defaults
		ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
		[self setNonNumber:[defaults integerForKey:NONSAtATime]];
		[self setNonDuration:[defaults floatForKey:NONSDuration]];
		[self setShowBackground:[defaults boolForKey:NONSBGColor]];
		[self setAnimationTimeInterval:[self nonDuration]];
		
		//Create Nonsense
		short i;
		NSFont *theFont;
		if (isPreview)
		{
			theFont = [NSFont fontWithName:@"Helvetica" size:kPreviewSize];
		} else {
			theFont = [NSFont fontWithName:@"Helvetica" size:kFullSize];
		}
		
		for(i = 0; i < [self nonNumber] ; i++ )
		{
			NonsenseObject *non = [[NonsenseObject alloc] initWithString:[controller radomSaying] bounds:[self bounds] font:theFont];
			[nonsenses addObject:non];
			[non release];
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

- (void)drawRect:(NSRect)rect {
	[super drawRect:rect];
	NSFont *theFont = nil;
	if ([self isPreview]) {
		theFont = [NSFont fontWithName:@"Helvetica" size:kPreviewSize];
	} else {
		theFont = [NSFont fontWithName:@"Helvetica" size:kFullSize];
	}
	for(NonsenseObject *obj in nonsenses) {
		[obj drawWithBackground:[self showBackground]];
	}
	[nonsenses removeObjectAtIndex:0];
	NonsenseObject *non = [[NonsenseObject alloc] initWithString:[controller radomSaying] bounds:[self bounds] font:theFont];
	[nonsenses addObject:non];
	[non release];
}

- (void)animateOneFrame {
    [self setNeedsDisplay:YES];
	return;
}

#pragma mark -
#pragma mark Configure Sheet functions

- (IBAction)addNonsense:(id)sender {
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

- (IBAction)cancelNonsense:(id)sender {
    [NSApp endSheet:configureSheet];
}

- (IBAction)okayNonsense:(id)sender {
	[controller saveSettings];
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
	[defaults setObject:@([self nonNumber]) forKey:NONSAtATime];
	[defaults setObject:@([self nonDuration]) forKey:NONSDuration];
	[defaults setObject:[self showBackground] ? @YES : @NO forKey:NONSBGColor];
	[defaults synchronize];
	[self setAnimationTimeInterval:nonDuration];
	[nonsenses removeAllObjects];
	
	short i;
	for(i = 0; i < [self nonNumber] ; i++ )
	{
		NonsenseObject *non = [[NonsenseObject alloc] initWithString:[controller radomSaying] bounds:[self bounds] font:[NSFont fontWithName:@"Helvetica" size:kPreviewSize]];
		[nonsenses addObject:non];
		[non release];
	}
	
	[NSApp endSheet:configureSheet];
}

- (IBAction)removeNonsense:(id)sender {
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
			tempString = [tempArray objectAtIndex:row];
			[controller removeSingularNoun:tempString];
			break;
		case 1:
			tempArray = [controller pluralNouns];
			tempString = [tempArray objectAtIndex:row];
			[controller removePluralNoun:tempString];			
			break;
		case 2:
			tempArray = [controller adjectives];
			tempString = [tempArray objectAtIndex:row];
			[controller removeAdjective:tempString];
			break;
		case 3:
			tempArray = [controller verbs];
			NONSVerb *tempVerb = [tempArray objectAtIndex:row];
			[controller removeVerb:tempVerb];
			break;
		case 4:
			tempArray = [controller adverbs];
			tempString = [tempArray objectAtIndex:row];
			[controller removeAdverb:tempString];
			break;
		case 5:
			tempArray = [controller massiveNouns];
			tempString = [tempArray objectAtIndex:row];
			[controller removeMassiveNoun:tempString];
			break;
		case 6:
			tempArray = [controller properNouns];
			tempString = [tempArray objectAtIndex:row];
			[controller removeProperNoun:tempString];
			break;
		case 7:
			tempArray = [controller interjections];
			tempString = [tempArray objectAtIndex:row];
			[controller removeInterjection:tempString];
			break;
			
		default:
			NSBeep();
			break;
	};
	[vocabList reloadData];
}

- (IBAction)changeVocabView:(id)sender {
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

+(void)initialize {
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:NONSDefaults];
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSNumber numberWithInt:3] forKey:NONSAtATime];
	[dict setObject:[NSNumber numberWithFloat:2.7] forKey:NONSDuration];
	[dict setObject:[NSNumber numberWithBool:YES] forKey:NONSBGColor];
	[defaults registerDefaults:dict];
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
		case 7:
			return [[controller interjections] count];
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
			return [[controller singularNouns] objectAtIndex:rowIndex];
			break;
		case 1:
			return [[controller pluralNouns] objectAtIndex:rowIndex];
			break;
		case 2:
			return [[controller adjectives] objectAtIndex:rowIndex];
			break;
		case 3:
			return [[controller verbs] objectAtIndex:rowIndex];
			break;
		case 4:
			return [[controller adverbs] objectAtIndex:rowIndex];
			break;
		case 5:
			return [[controller massiveNouns] objectAtIndex:rowIndex];
			break;
		case 6:
			return [[controller properNouns] objectAtIndex:rowIndex];
			break;
		case 7:
			return [[controller interjections] objectAtIndex:rowIndex];
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
	} else if ([vocabSelector cellAtRow:7 column:0] == selectedCell) {
		return 7;
	} else {
		return -1;
	}
}

#pragma mark Adding Windows

- (void)clearVerbWindow {
	[fieldThirdPersonSinglePresent setStringValue:@""];
	[fieldThirdPersonPluralPresent setStringValue:@""];
	[fieldThirdPersonPast setStringValue:@""];
	[fieldThirdPersonPastPerfect setStringValue:@""];
	[fieldThirdPersonPresentCont setStringValue:@""];
}

- (IBAction)addVerb:(id)sender {
	short i = 0;
	if (![[fieldThirdPersonSinglePresent stringValue] isEqualToString:@""]) {
		i++;
	}
	if (![[fieldThirdPersonPluralPresent stringValue] isEqualToString:@""]) {
		i++;
	}
	if (![[fieldThirdPersonPast stringValue] isEqualToString:@""]) {
		i++;
	}
	if (![[fieldThirdPersonPastPerfect stringValue] isEqualToString:@""]) {
		i++;
	}
	if (![[fieldThirdPersonPresentCont stringValue] isEqualToString:@""]) {
		i++;
	}
	
	if (i == 5) {
		[controller addVerb:[NONSVerb verbWithSinglePresent:[fieldThirdPersonSinglePresent stringValue] pluralPresent:[fieldThirdPersonPluralPresent stringValue] past:[fieldThirdPersonPast stringValue] pastPerfect:[fieldThirdPersonPastPerfect stringValue] presentCont:[fieldThirdPersonPresentCont stringValue]]];
		[NSApp endSheet:verbWindow];
		[self clearVerbWindow];
		[verbWindow orderOut:sender];		
	} else {
		NSAlert *noVerb = [NSAlert alertWithMessageText:@"Incomplete Verb" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"The verb doesn't have all members filled. Please fill them out."];
		[noVerb beginSheetModalForWindow:verbWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
	}
}

- (IBAction)cancelAddVerb:(id)sender {
	[NSApp endSheet:verbWindow];
	[self clearVerbWindow];
	[verbWindow orderOut:sender];
}

- (void)clearWordWindow {
	[fieldWord setStringValue:@""];
}

- (IBAction)addWord:(id)sender {
	if ([[fieldWord stringValue] isEqualToString:@""]) {
		NSAlert *noVerb = [NSAlert alertWithMessageText:@"No Word" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please enter a word."];
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
		case 7:
			[controller addInterjection:[fieldWord stringValue]];
			break;

			
		default:
			break;
	};
	
	[NSApp endSheet:wordWindow];
	[self clearWordWindow];
	[wordWindow orderOut:sender];
}

- (IBAction)cancelAddWord:(id)sender {
	[NSApp endSheet:wordWindow];
	[self clearWordWindow];
	[wordWindow orderOut:sender];	
}


@end
