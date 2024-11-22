
#import "pingsAssistanceTableViewCell.h"

@implementation pingsAssistanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setLabelText:(NSString*)tableName :(NSString*)pingTime :(NSString*)pingMessage
{
    self.bgImage.layer.borderColor = [UIColor colorWithRed:221.0/255.0f green:221.0/255.0f blue:221.0/255.0f alpha:1].CGColor;
    self.bgImage.layer.borderWidth = 1.0;
    self.bgImage.layer.cornerRadius = 5.0;
    self.TableNameLbl.text = [NSString stringWithFormat:@"%@",tableName];
    self.pingTimeLbl.text = [NSString stringWithFormat:@"%@",pingTime];
    self.pingMessageLbl.text = [NSString stringWithFormat:@"%@",pingMessage];
}

@end
