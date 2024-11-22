
#import <Foundation/Foundation.h>
#import "SBJsonStreamParserAdapter.h"

@interface SBJsonStreamParserAccumulator : NSObject <SBJsonStreamParserAdapterDelegate>

@property (copy) id value;

@end
