
#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UILabel *itemNames;

-(void)setLabelText:(NSString*)orderstatus :(NSString*)OrderTime :(NSString*)orderId :(NSString*)itemNames;
-(void)setLabelText1:(NSString*)itemName :(NSString*)quantity :(NSString*)price :(NSString*)itemNames;

@end
