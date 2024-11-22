
#import <UIKit/UIKit.h>

@interface cell1TableViewCell : UITableViewCell
{
    IBOutlet UILabel *lblEventname;
    IBOutlet UILabel *lblEventTime;
    
}

-(void)setLabelText:(NSString*)eventName :(NSString*)eventBy : (NSString*)startDate :(NSString*)endDate;

@end
