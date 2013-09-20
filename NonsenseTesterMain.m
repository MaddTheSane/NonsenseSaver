#import <Cocoa/Cocoa.h>
#import "NonsenseSaverController.h"
#import "NONSVerb.h"
#import "ARCBridge.h"

void WriteToStandardOutput(NSString *string)
{
	NSFileHandle *so = [NSFileHandle fileHandleWithStandardOutput];
	[so writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

int main(int argc, char *argv[])
{
	@autoreleasepool {
		srandom( 0x7FFFFFFF & time(NULL));
		NonsenseSaverController *controller = [[NonsenseSaverController alloc] init];
		WriteToStandardOutput([NSString stringWithFormat:@"%@\n", [controller radomSaying]]);
		
		RELEASEOBJ(controller);
		return EXIT_SUCCESS;
	}
}
