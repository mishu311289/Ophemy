
#import "OrderListTableViewCell.h"
#import "AppDelegate.h"

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)orderstatus :(NSString*)OrderTime :(NSString*)orderId :(NSString*)itemNames
{
    self.bgImage.layer.borderColor = [UIColor colorWithRed:221.0/255.0f green:221.0/255.0f blue:221.0/255.0f alpha:1].CGColor;
    self.bgImage.layer.borderWidth = 1.0;
    self.bgImage.layer.cornerRadius = 5.0;
    self.orderNumLbl.textColor=[UIColor blackColor];
    self.orderNumLbl.text = [NSString stringWithFormat:@"%@",orderId];
    self.orderStatusLbl.text = [NSString stringWithFormat:@"%@",orderstatus];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"%@",OrderTime];
    self.itemNames.text = [[NSString stringWithFormat:@"%@",itemNames] uppercaseString];
}

-(void)setLabelText1:(NSString*)itemName :(NSString*)quantity :(NSString*)price :(NSString*)itemNames
{

    self.bgImage.layer.borderColor = [UIColor colorWithRed:221.0/255.0f green:221.0/255.0f blue:221.0/255.0f alpha:1].CGColor;
    self.bgImage.layer.borderWidth = 1.0;
    self.bgImage.layer.cornerRadius = 5.0;
    self.orderNumLbl.textColor=[UIColor colorWithRed:131.0/255.0  green:64.0/255.0 blue:52.0/255.0 alpha:1.0f];
    self.orderNumLbl.text = [NSString stringWithFormat:@"%@",itemName];
    self.orderStatusLbl.text = [NSString stringWithFormat:@"QUANTITY: %@",quantity];
    self.orderStatusLbl.textColor = [UIColor blackColor];
    AppDelegate*appdelegate=[[UIApplication sharedApplication]delegate];
    NSString *freeTag = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Is Paid"]];
    if ([freeTag isEqualToString:@"1"]) {
        self.orderTimeLbl.hidden = YES;
    }else{
        self.orderTimeLbl.hidden = NO;
        self.orderTimeLbl.text = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Currency Value"],price];
    }
    
    self.itemNames.text = [[NSString stringWithFormat:@"%@",itemNames]uppercaseString];
}




@end
