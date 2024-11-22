
#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender : (NSString *)editRequest;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
}
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b :(int )flag;
- (id)showDropDown:(UIButton *) b :(CGFloat *) height :(NSArray *) arr :(NSString *)direction;
@end
