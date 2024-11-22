
#import <Foundation/Foundation.h>

#pragma mark JSON Writing

/// Adds JSON generation to NSObject
@interface NSObject (NSObject_SBJsonWriting)

/**
 @brief Encodes the receiver into a JSON string
 
 Although defined as a category on NSObject it is only defined for NSArray and NSDictionary.
 
 @return the receiver encoded in JSON, or nil on error.
 
 @see @ref objc2json
 */
- (NSString *)JSONRepresentation;

@end


#pragma mark JSON Parsing

/// Adds JSON parsing methods to NSString
@interface NSString (NSString_SBJsonParsing)

/**
 @brief Decodes the receiver's JSON text
 
 @return the NSDictionary or NSArray represented by the receiver, or nil on error.
 
 @see @ref json2objc
 */
- (id)JSONValue;

@end

/// Adds JSON parsing methods to NSData
@interface NSData (NSData_SBJsonParsing)

/**
 @brief Decodes the receiver's JSON data
 
 @return the NSDictionary or NSArray represented by the receiver, or nil on error.
 
 @see @ref json2objc
 */
- (id)JSONValue;

@end
