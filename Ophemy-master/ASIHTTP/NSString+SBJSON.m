
#import "NSString+SBJSON.h"
#import "SBJSONScanner.h"


@implementation NSString (NSString_SBJSON)

- (id)JSONValue
{
    return [self JSONValueWithOptions:nil];
}

- (id)JSONValueWithOptions:(NSDictionary *)opts
{
    id o;

    SBJSONScanner *scanner = [[SBJSONScanner alloc] initWithString:self];
    if (opts) {
        id opt = [opts objectForKey:@"MaxDepth"];
        if (opt)
            [scanner setMaxDepth:[opt intValue]];
    }

    BOOL success = ([scanner scanDictionary:&o] || [scanner scanArray:&o]) && [scanner isAtEnd];
    [scanner release];

    if (success)
        return o;

    [NSException raise:@"enojson"
                format:@"Failed to parse '%@' as JSON", self];
  return nil;
}

- (id)JSONFragmentValue
{
    id o;

    SBJSONScanner *scanner = [[SBJSONScanner alloc] initWithString:self];
    BOOL success = [scanner scanValue:&o] && [scanner isAtEnd];
    [scanner release];

    if (success)
        return o;
    
    [NSException raise:@"enofragment"
                format:@"Failed to parse '%@' as a JSON fragment", self];
  return nil;
}

@end
