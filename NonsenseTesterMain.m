#import <Cocoa/Cocoa.h>
#import "NonsenseSaverController.h"
#import "NONSVerb.h"

void WriteToStandardOutput(NSString *string)
{
	NSFileHandle *so =[NSFileHandle fileHandleWithStandardOutput];
	[so writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	srandom(time(NULL));
	NonsenseSaverController *controller = [[NonsenseSaverController alloc] init];

	WriteToStandardOutput([controller radomSaying]);
	//Newline
	WriteToStandardOutput(@"\n");
	
	[controller release];
	[pool drain];
	return EXIT_SUCCESS;
}
