
#import "SBJsonStreamWriter.h"

@interface SBJsonStreamWriterAccumulator : NSObject <SBJsonStreamWriterDelegate>

@property (readonly, copy) NSMutableData* data;

@end
