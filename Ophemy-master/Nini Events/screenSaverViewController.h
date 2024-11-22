
#import <UIKit/UIKit.h>

@interface screenSaverViewController : UIViewController
{
    UIImageView * mainImageView;
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    int webServiceCode;
    NSMutableArray *imagesUrlArray, *screenSaverImages, *imageNameStringsArray;
    UIScrollView *scr;
    UIPageControl *pgCtr;
}
@property (strong, nonatomic) IBOutlet UIImageView *image1;

@end
