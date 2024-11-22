
#import <UIKit/UIKit.h>

#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableViewCell.h"

typedef enum _NSBubbleTypingType
{
    NSBubbleTypingTypeNobody = 0,
    NSBubbleTypingTypeMe = 1,
    NSBubbleTypingTypeSomebody = 2
} NSBubbleTypingType;

@interface UIBubbleTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
{
    UILabel *dateLbl;
    UILabel *nameLbl;
}
@property (nonatomic, strong) NSBubbleData *data;
@property(strong,nonatomic) UILabel *nameLbl;
@property(strong,nonatomic) UILabel *dateLbl;

@property (nonatomic, assign) IBOutlet id<UIBubbleTableViewDataSource> bubbleDataSource;
@property (nonatomic) NSTimeInterval snapInterval;
@property (nonatomic) NSBubbleTypingType typingBubble;
@property (nonatomic) BOOL showAvatars;

- (void) scrollBubbleViewToBottomAnimated:(BOOL)animated;

@end
