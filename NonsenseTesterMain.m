#import <Cocoa/Cocoa.h>
#import "NonsenseSaverController.h"
#import "NONSVerb.h"

void WriteToStandardOutput(NSString *string, ...) NS_FORMAT_FUNCTION(1,2);

void WriteToStandardOutput(NSString *string, ...)
{
	va_list theList;
	NSString *stdOutStr;
	NSFileHandle *so = [NSFileHandle fileHandleWithStandardOutput];
	va_start(theList, string);
	stdOutStr = [[NSString alloc] initWithFormat:string arguments:theList];
	va_end(theList);
	[so writeData:[stdOutStr dataUsingEncoding:NSUTF8StringEncoding]];
}

int main(int argc, char *argv[])
{
	@autoreleasepool {
		srandom( 0x7FFFFFFF & time(NULL));
		NonsenseSaverController *controller = [[NonsenseSaverController alloc] init];
		WriteToStandardOutput(@"%@\n", [controller radomSaying]);
		
		return EXIT_SUCCESS;
	}
}
