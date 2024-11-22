
#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSBubbleData

#pragma mark - Properties

@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    
    self.avatar = nil;

    [super dealloc];
}
#endif

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {-5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {-5,15, 11, 10};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type isDateChanged:(NSString*)dateChanged isCorner:(NSString*) isCorner
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithText:text date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithText:text date:date type:type isDateChanged:dateChanged isCorner:isCorner];
#endif    
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type isDateChanged:(NSString*)dateChanged isCorner:(NSString*) isCorner
{
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:19];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(320, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, size.width+3, size.height+3)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:19];
    label.backgroundColor = [UIColor clearColor];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:text];
    
    NSArray *words=[text componentsSeparatedByString:@":"];
    
    if (words.count>=1)
    {
        NSString *word=[NSString stringWithFormat:@"%@:",[words objectAtIndex:0]];
        NSRange range=[text rangeOfString:word];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:16] range :range];

        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:173.0f/255.0 green:37.0f/255.0 blue:11.0f/255.0 alpha:1.0] range:range];
    }
    
    [label setAttributedText:string];

    
#if !__has_feature(objc_arc)
    [label autorelease];
#endif
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm a"];
    NSString *datetext = [dateFormatter stringFromDate:date];
    _dateStr=datetext;
    _dateChangeStr = dateChanged;
    _isCorner = isCorner;
    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithImage:image date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithImage:image date:date type:type];
#endif    
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
    CGSize size = image.size;
    if (size.width > 440)
    {
        size.height /= (size.width / 440);
        size.width = 440;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    
#if !__has_feature(objc_arc)
    [imageView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];       
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithView:view date:date type:type insets:insets] autorelease];
#else
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets];
#endif    
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets  
{
    self = [super init];
    if (self)
    {
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
#else
        _view = view;
        _date = date;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}

@end
