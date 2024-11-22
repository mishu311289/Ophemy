
#import "NSObject+SBJson.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"

@implementation NSObject (NSObject_SBJsonWriting)

- (NSString *)JSONRepresentation {
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];    
    NSString *json = [writer stringWithObject:self];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error is: %@", writer.error);
    return json;
}

@end



@implementation NSString (NSString_SBJsonParsing)

- (id)JSONValue {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id repr = [parser objectWithString:self];
    if (!repr)
        NSLog(@"-JSONValue failed. Error is: %@", parser.error);
    return repr;
}

@end



@implementation NSData (NSData_SBJsonParsing)

- (id)JSONValue {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id repr = [parser objectWithData:self];
    if (!repr)
        NSLog(@"-JSONValue failed. Error is: %@", parser.error);
    return repr;
}

@end
