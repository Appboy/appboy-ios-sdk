#import <Foundation/Foundation.h>

/*!
 * Prints the formatted string prefixed with a tag and the calling method's signature.
 *
 * Example:
 * StopwatchDebugMsg(@"Hello %@", @"there");
 * would print out
 * AppName[26248:c07] [STOPWATCH] -[ClassName methodName] Hello there
 */
#define StopwatchDebugMsg(_str, _val...) {\
NSLog(@"[STOPWATCH] %s " _str,  __PRETTY_FUNCTION__, _val);\
}
