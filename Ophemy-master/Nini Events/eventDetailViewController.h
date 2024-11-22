
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface eventDetailViewController : UIViewController<UIWebViewDelegate>
{
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;
    IBOutlet UIImageView *disabledImgView;
}
//@property (strong, nonatomic) IBOutlet UIWebView *eventPdfView;
@property (strong, nonatomic) IBOutlet UIScrollView *sideScroller;
@property (strong, nonatomic) NSString *pdfURL;
- (IBAction)newOrderAction:(id)sender;
- (IBAction)orderHistoryAction:(id)sender;
- (IBAction)requestAssistanceAction:(id)sender;
- (IBAction)spcornerAction:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)menuAction:(id)sender;
- (IBAction)appHomeAction:(id)sender;
- (IBAction)checkOutView:(id)sender;
@end
