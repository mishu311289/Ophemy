
#import "OrderTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)orderName :(int)quantity :(NSString*)price :(NSString*)imageName{
   

    name.text = [[NSString stringWithFormat:@"%@",orderName]uppercaseString];
    NSString *freeTag = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Is Paid"]];
    if ([freeTag isEqualToString:@"1"]) {
        priceLbl.hidden = YES;
    }else{
        priceLbl.hidden = NO;
         priceLbl.text = [NSString stringWithFormat:@"%@ %.2f",[[NSUserDefaults standardUserDefaults] valueForKey:@"Currency Value"],[price floatValue]];
    }
   
    quantityLbl.text = [NSString stringWithFormat:@"%d",quantity];
   // NSData* data = [[NSData alloc] initWithBase64EncodedString:imageUrl options:0];
    // UIImage* img1 = [UIImage imageWithData:data];
    productImageView.image = [UIImage imageNamed:imageName];
    

   // [productImageView setImage:imageUrl];
    
}

@end
