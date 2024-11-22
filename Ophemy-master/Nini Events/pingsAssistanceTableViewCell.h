
#import <UIKit/UIKit.h>

@interface pingsAssistanceTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *TableNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *pingMessageLbl;
@property (strong, nonatomic) IBOutlet UILabel *pingTimeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
-(void)setLabelText:(NSString*)orderstatus :(NSString*)OrderTime :(NSString*)orderId;
@end
