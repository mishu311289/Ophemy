
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "orderOC.h"
#import "OrderTableViewCell.h"
#import "PlaceOrderData.h"
@interface CheckOutViewController : UIViewController<UITextViewDelegate>
{
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    
    
    NSString * placeholderText;
    BOOL isPlaceholder;
    
    UILabel*emptyCartLabel;
    
    NSMutableArray*orderList;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    orderOC *orderObj;
  //  PlaceOrderData *placeOrderObj;
    float totalPrice;
    IBOutlet UILabel *foodDrinkPriceLbl;
    int bulbFlag, webServiceCode;
    IBOutlet UILabel *orderTotalPriceLbl;
    IBOutlet UILabel *taxesPriceLbl;
    IBOutlet UILabel *deliveryChargPriceLbl;
    UIButton *decreaseItemBtn, *orderSomthing;
    UIButton *increaseItemBtn;
    IBOutlet UIView *checkoutPriceDetailView;
    NSTimer *hideTimer;
    IBOutlet UIView *priceingView;
    
    
    
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
}
@property (weak, nonatomic) IBOutlet UIImageView *disabledImgView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UITableView *orderTableView;
- (IBAction)CheckOutBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *foodDrinkLbl;
@property (strong, nonatomic) IBOutlet UILabel *deliverChargeLbl;
@property (strong, nonatomic) IBOutlet UILabel *taxLbl;
@property (strong, nonatomic) IBOutlet UIScrollView *sideScroller;
- (IBAction)newOrderAction:(id)sender;
- (IBAction)orderHistoryAction:(id)sender;
- (IBAction)requestAssistanceAction:(id)sender;
- (IBAction)spcornerAction:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)menuAction:(id)sender;
- (IBAction)appHomeAction:(id)sender;
- (IBAction)sideMenuAction:(id)sender;
- (IBAction)checkOutView:(id)sender;
- (IBAction)ophemyAction:(id)sender;
- (IBAction)Slideshow:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *checkOutBtn;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
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
@property (strong, nonatomic) IBOutlet UIView *emptyOrderListView;
- (IBAction)startNewOrderAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;

@end
