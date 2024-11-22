
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface menuStateViewController : UIViewController
{
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString *itemName, *itemImageUrl;
    NSMutableArray *itemNameArray, *itemImageUrlArray, *menuCategoryArray,*drinkMenuItems,*orderList;
    int bulbFlag, webServiceCode;
     NSMutableData *webData;
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
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollerimage;
@property (strong, nonatomic) IBOutlet UIView *startUpPopUp;
@property (assign, nonatomic) BOOL isNewOrder;
@property (assign, nonatomic) BOOL isOrderPlaced;
- (IBAction)popUpContinueBtn:(id)sender;
- (IBAction)closeStartUpPopUp:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *sideScroller;
- (IBAction)newOrderAction:(id)sender;
- (IBAction)orderHistoryAction:(id)sender;
- (IBAction)requestAssistanceAction:(id)sender;
- (IBAction)spcornerAction:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)menuAction:(id)sender;
- (IBAction)appHomeAction:(id)sender;
- (IBAction)sideMenuAction:(id)sender;
- (IBAction)viewOrderNtnAction:(id)sender;
- (IBAction)eventDetailsAction:(id)sender;
- (IBAction)ophemyAction:(id)sender;
- (IBAction)Slideshow:(id)sender;

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
@property (strong, nonatomic) IBOutlet UIView *orderPlacedSuccessfulView;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;

@end
