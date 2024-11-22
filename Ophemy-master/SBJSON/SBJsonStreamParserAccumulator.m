
#import "SBJsonStreamParserAccumulator.h"

@implementation SBJsonStreamParserAccumulator

@synthesize value;


#pragma mark SBJsonStreamParserAdapterDelegate

- (void)parser:(SBJsonStreamParser*)parser foundArray:(NSArray *)array {
	value = array;
}

- (void)parser:(SBJsonStreamParser*)parser foundObject:(NSDictionary *)dict {
	value = dict;
}

@end
