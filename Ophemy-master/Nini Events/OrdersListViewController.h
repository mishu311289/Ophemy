
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "pendingOrdersOC.h"


@interface OrdersListViewController : UIViewController
{
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *pendingOrderItemNameArray,*pendingOrderListArray,*pendingOrderTimeOfDeliveryArray,*processingOrderList,*itemNamesArray;
    
    IBOutlet UIView *viewNoOrders;
    IBOutlet UILabel *headrLbl;
    int webServiceCode;
    pendingOrdersOC *pendingOrderObj;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;    
    IBOutlet UILabel *startNewOrdrLbl;
    IBOutlet UIImageView *strtNewOrdrImag;
    IBOutlet UILabel *ordrHistryLbl;
    IBOutlet UIImageView *disabledImgView;
    IBOutlet UIImageView *ordrhistryImag;
    IBOutlet UIImageView *requstAssistImag;
    IBOutlet UIImageView *spCornrImag;
    IBOutlet UIImageView *exitImag;
    IBOutlet UILabel *requestAssistntLbl;
    IBOutlet UILabel *spCornerLbl;
    IBOutlet UILabel *exitLbl;
     IBOutlet UILabel *lblno1;
     IBOutlet UILabel *lblno2;
    int bulbFlag;
    NSTimer *hideTimer;
    
    
    IBOutlet UIToolbar *toolBar;
    
    IBOutlet UIButton *btnmenufooter;
    IBOutlet UIButton *btnpingfooter;
    
    IBOutlet UIButton *btnlogofooter;
    
    IBOutlet UIButton *btnslideshowfooter;
    IBOutlet UIButton *btneventdetailfooter;
    IBOutlet UIButton *btnmenu1footer;
    IBOutlet UIButton *btnVieworderfooter;
    IBOutlet UIView *viewmenufooter;
    IBOutlet UIView *viewpingfooter;
    IBOutlet UIView *viewlogofooter;
    IBOutlet UIView *viewslideshowfooter;
    IBOutlet UIView *vieweventdetailfooter;
    IBOutlet UIView *viewmenu1footer;
    IBOutlet UIView *viewvieworderfooter;

    IBOutlet UIImageView *orderHistoryImg2;
    IBOutlet UIImageView *spCornerImg2;
    IBOutlet UILabel *spCornerlbl2;
    IBOutlet UILabel *orderHistoryLbl2;
}
@property (strong,nonatomic) NSString* type;
@property (weak, nonatomic) IBOutlet UITableView *pendingOrdersTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *sideScroller;
@property (assign, nonatomic) int flagValue;
- (IBAction)backBtn:(id)sender;
- (IBAction)menuBtn:(id)sender;
- (IBAction)startAnewOrdeActionBtn:(id)sender;
- (IBAction)orderHistoryActionBtn:(id)sender;
- (IBAction)requestAssistntActionBtn:(id)sender;
- (IBAction)spCornerActionBtn:(id)sender;
- (IBAction)ExitBtn:(id)sender;
- (IBAction)apphomeAction:(id)sender;
- (IBAction)menuAction:(id)sender;
- (IBAction)checkOutView:(id)sender;
- (IBAction)ophemyAction:(id)sender;
- (IBAction)Slideshow:(id)sender;
-(void)FetchPendingPlacedOrder:(NSString*)passedOrderType;
@property (strong, nonatomic) IBOutlet UILabel *batchLbl;
@property (strong, nonatomic) IBOutlet UIView *sideMenuWithoutReqAssistance;
@property (strong, nonatomic) IBOutlet UIView *footerWithoutEventsDetail;
@property (strong, nonatomic) IBOutlet UILabel *otherMenuBatchLbl;
@property (strong, nonatomic) IBOutlet UIImageView *batchImg;
@property (strong, nonatomic) IBOutlet UIImageView *otheMenuBatchImg;
- (IBAction)pingBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *pingBulbImg;
@property (strong, nonatomic) IBOutlet UIImageView *otherMenuPingBulbImg;
@property (strong, nonatomic) IBOutlet UIView *pingMessageView;
@property (strong, nonatomic) IBOutlet UIImageView *assisstanceNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *assisstanceNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;
-(void)FetchPendingPlacedOrder:(NSString*)passedOrderType;
@end
