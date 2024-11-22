
#import <Foundation/Foundation.h>


@interface SBJSONScanner : NSObject {
    const char *start;
    const char *c;
    
    unsigned depth;
    unsigned maxDepth;
}

- (id)initWithString:(NSString *)s;

- (BOOL)scanDictionary:(NSDictionary **)o;
- (BOOL)scanArray:(NSArray **)o;

- (BOOL)scanValue:(NSObject **)o;

- (BOOL)isAtEnd;

- (void)setMaxDepth:(unsigned)x;

@end
