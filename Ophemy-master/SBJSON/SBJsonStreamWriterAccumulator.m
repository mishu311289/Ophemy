
#import "SBJsonStreamWriterAccumulator.h"


@implementation SBJsonStreamWriterAccumulator

@synthesize data;

- (id)init {
    self = [super init];
    if (self) {
        data = [[NSMutableData alloc] initWithCapacity:8096u];
    }
    return self;
}


#pragma mark SBJsonStreamWriterDelegate

- (void)writer:(SBJsonStreamWriter *)writer appendBytes:(const void *)bytes length:(NSUInteger)length {
    [data appendBytes:bytes length:length];
}

@end
