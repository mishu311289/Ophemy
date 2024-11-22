
#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
{
    IBOutlet UILabel *priceLbl;
    IBOutlet UILabel *name;
    IBOutlet UIImageView *productImageView;
    IBOutlet UILabel *quantityLbl;
    
}
-(void)setLabelText:(NSString*)name  :(int)quantity :(NSString*)price :(NSString*) imageName;

@end
