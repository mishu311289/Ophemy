
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse = 1
} NSBubbleType;

@interface NSBubbleData : NSObject

@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic) NSBubbleType type;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, strong) UIImage *avatar;
@property (strong ,nonatomic) NSString *dateChangeStr;
@property (strong ,nonatomic) NSString *dateStr;
@property (strong ,nonatomic) NSString *isCorner;

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type isDateChanged:(NSString*)dateChanged isCorner:(NSString*) isCorner;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type isDateChanged:(NSString*)dateChanged isCorner:(NSString*) isCorner;
- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;

@end
