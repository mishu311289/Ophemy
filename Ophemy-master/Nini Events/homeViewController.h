
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "orderOC.h"
#import "PlaceOrderData.h"
#import "pendingOrdersOC.h"
#import "menuOC.h"
#import "menuItemsOC.h"
#import "UIBubbleTableViewDataSource.h"
#import "chatOC.h"
#import "fetchChatOC.h"
#import "UIView+Animation.h"
#import "AsyncImageView.h"
@interface homeViewController : UIViewController<UIScrollViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate,UIBubbleTableViewDataSource, UITextViewDelegate>
{
    UITapGestureRecognizer *imageTapRecognizer;
    NSTimer *myTimer;
    NSTimer *hideTimer;
    chatOC *chatObj;
    fetchChatOC *fetchChatObj;
    UITapGestureRecognizer *letterTapRecognizer;
    NSMutableArray *menuDisplayItemsArray,*menuItemsArray,*arrayForBool,*content,* menuCategoryArray, * menuListArray,*menuCategoryId, *menuCategoryType, *indexArray,*drinkMenuItems, *menuItemsDetailsArray, *fetchedChatData;
    NSMutableArray *itemList,*itemsIDArray, *itemsNameArray,*cuisineArray,*typeIDArray,*quantityArray, *itemsImageArray, *itemPriceArray,*processingOrderList;
    NSMutableArray *orderList,* placeOrderList, * placeOrderPriceCount,* placeOrderItemName,* pendingOrderListArray,*quantityCounts,*drinksCategoryIds;
    NSMutableArray *pendingOrderItemNameArray,*pendingOrderItemPriceArray,*pendingOrderItemQuantityArray,*pendingOrderTimeOfDeliveryArray,* chatArray, *allChatMessages;
    IBOutlet UILabel *priceTagLbl;
    NSMutableDictionary *menuContentDict,*menuItemContentDict;
    NSArray *categoryFirst,* categorySecond;
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    NSString *result, *message, *lastUpdatedCities, *supportEmail, *categoryType;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    menuItemsOC *menuItemsObj;
    menuOC *menuObj;
    NSIndexPath *menuIndex, *menuItemIndex, *orderIndex, *pendingOrderIndex, *quantityIndex;
    UIImageView *itemImagePage;
    int webServiceCode, itemID, flag, zeroIndex, maximumQty, chatUsed;
    NSString *categoryID,*timeStampKey,* menuTimeStampKey, *processingOrderID;
    UILabel *subItemsLbl,*itemName, * orderItemsName,* orderItemQuantity, *priceLabel, *placedorderName,* placeOrderquantity, *placedOrderPrice, *pendingOrderIDLbl, * pendingOrderStatusLbl, *pendingorderName,* pendingOrderquantity, *pendingOrderPrice, *pendingOrderTime, *menuItems,*menuHeaders;
    UIButton *addBtn,*deleteBtn ;
    UIImageView *itemImage;
    orderOC *orderObj;
    PlaceOrderData *placeOrderObj;
    pendingOrdersOC *pendingOrderObj;
    UIView *maskView;
    UIPickerView *_providerPickerView;
    UIToolbar *_providerToolbar;
    NSArray *menuImages;
    NSNumber *_amount;
    UIView *bgColorView;
    UIButton *previousBtn;
    IBOutlet UIButton *menuBtn;
    NSMutableDictionary *chatDictionary;
    IBOutlet UIButton *orderNowBtn;
    IBOutlet UIButton *notesBtn;
    CGPoint originalPt, notesOriginalPt;
     BOOL *isMinimized;
    IBOutlet UIImageView *tableImageView;
    IBOutlet UILabel *roleLbl;
    IBOutlet UILabel *nameLbl;
    NSString *categoriesType, *headerTitleName, *mainItemName;
    int	selectedCurveIndex, buttonTagColorValue;
    BOOL isViewVisible, foodSelected, drinkSelected;
    UILabel *itemNamebg;
    int  submenuTagValue;
    int bulbFlag;
    UILabel *itemNameToDisplay;
    BOOL drinksButtonTapped;
    
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
    IBOutlet UILabel *lbleventStatus;

}
@property (weak, nonatomic) IBOutlet UIImageView *disabledImgView;
@property (weak, nonatomic) IBOutlet UIButton *selectQuantityBtn;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UITableView *menuItemsTableView;
@property (weak, nonatomic) IBOutlet UITableView *ordersTableView;
@property (weak, nonatomic) IBOutlet UITableView *pendingOrdersTableView;
- (IBAction)orderNow:(id)sender;
- (IBAction)menuBtn:(id)sender;
- (IBAction)selectQuantity:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *placeOrderPopUpLbl;
@property (weak, nonatomic) IBOutlet UILabel *pendingOrderPopUpLbl;
@property (weak, nonatomic) IBOutlet UILabel *quantityPopUpLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *sideScroller;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UIView *quantityPopUp;
@property (weak, nonatomic) IBOutlet UITextField *quantityPopUpTxt;
@property (weak, nonatomic) IBOutlet UIButton *quantityDoneBtn;
@property (weak, nonatomic) IBOutlet UIImageView *quantityTxtImage;
@property (weak, nonatomic) IBOutlet UIView *placeOrderPopUp;
@property (weak, nonatomic) IBOutlet UITableView *placeOrderTableView;
@property (weak, nonatomic) IBOutlet UIButton *placeOrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *quantityPopUpTitle;
@property (weak, nonatomic) IBOutlet UITableView *quantityTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;
@property (weak, nonatomic) IBOutlet UIView *pendingOrderPopUp;
@property (weak, nonatomic) IBOutlet UILabel *pendingOrderTotalLbl;
- (IBAction)pendingOrderDoneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *pendingOrderTableView;
- (IBAction)placedOrderPopUpCloseBtn:(id)sender;
- (IBAction)quantityDoneBtn:(id)sender;
- (IBAction)quantityPopUpCloseBtn:(id)sender;
- (IBAction)pendingOrderPopUpCloseBtn:(id)sender;
- (IBAction)tapGestureOfHideMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *tapGestureBtn;

- (IBAction)placeOrder:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *notesPopUpView;
- (IBAction)insertNoteBtn:(id)sender;
- (IBAction)notesPopUpCloseBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
- (IBAction)notesBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderNoteLbl;
@property (strong, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextField *chatMessageTxtView;
- (IBAction)sendChatMessage:(id)sender;
- (IBAction)chatCloseBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *noteTitle;
@property (strong, nonatomic) IBOutlet UILabel *totalTitle;
@property (strong, nonatomic) IBOutlet UILabel *placeOrderPopupTitle;
@property (strong, nonatomic) IBOutlet UILabel *placeNotePopUpTitle;
@property (strong, nonatomic) IBOutlet UILabel *pendingOrdersPopUpTitle;
@property (strong, nonatomic) IBOutlet UILabel *pendingTotalTitle;
@property (strong, nonatomic) IBOutlet UITextField *quantityTxt;
- (IBAction)decreaseQuantityBtn:(id)sender;
- (IBAction)increaseQuantityBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *decreaseBtn;
@property (strong, nonatomic) IBOutlet UIButton *increaseBtn;
@property (strong, nonatomic) IBOutlet UITableView *deliveryOrderTableView;
- (IBAction)minimizeBtn:(id)sender;
- (IBAction)markDeliverbtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *deliveryOrderView;
@property (strong, nonatomic) IBOutlet UIButton *pendingOrderDoneBtn;
// ~~~~~~~~~~~~~~~~~~ 2nd Xib~~~~~~~~~~~~~~~~~~~//
@property (strong, nonatomic) IBOutlet UIView *menuBgView;
@property (strong, nonatomic) IBOutlet UIView *subMenuBgView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollerimage;
@property (strong, nonatomic) IBOutlet UIView *itemView;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UILabel *priceLbl;
@property (strong, nonatomic) IBOutlet UILabel *quantityLbl;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *headerTitleLbl;
@property (strong, nonatomic) IBOutlet UIButton *viewOrder;
@property (strong, nonatomic) IBOutlet UIImageView *imagepingmessage;
@property (strong, nonatomic) IBOutlet UIView *viewPOPplaceOrder;


- (IBAction)dismissBack:(id)sender;
- (IBAction)viewOrderBtn:(id)sender;
- (IBAction)addToOrder:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *minimizeViewHeader;
@property (strong, nonatomic) IBOutlet UILabel *minimizeViewItemName;
@property (strong, nonatomic) IBOutlet UIView *minimizeAnimatedView;
@property (strong, nonatomic) IBOutlet UIImageView *showMinimizeItemImage;
@property (strong, nonatomic) IBOutlet UILabel *minimizeItemName;
@property (strong, nonatomic) IBOutlet UIButton *foodBtn;
@property (strong, nonatomic) IBOutlet UIButton *drinksbtn;
@property (strong, nonatomic) IBOutlet UILabel *addedOrderLbl;
- (IBAction)menuItems:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *itemTypeName;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *mainMenuFooter;
@property (strong, nonatomic) IBOutlet UIButton *viewOrderBtn;
- (IBAction)requestAssistanceBtn:(id)sender;
- (IBAction)orderHistoryAction:(id)sender;
- (IBAction)spcornerAction:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)appHomeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *drinkMenuImage;
@property (strong, nonatomic) IBOutlet UIImageView *foodMenuImage;
@property (strong, nonatomic) IBOutlet UILabel *addOrderSelectedLbl;
@property (strong, nonatomic) IBOutlet UIView *startUpPopUp;
@property (strong, nonatomic) IBOutlet UILabel *popUpTitleLbl;
@property (assign, nonatomic) BOOL isNewOrder;
@property (assign, nonatomic) int itemTag;
@property (assign, nonatomic) int menuTagValue;
- (IBAction)popUpContinueBtn:(id)sender;
- (IBAction)newOrderAction:(id)sender;
- (IBAction)closeStartUpPopUp:(id)sender;
- (IBAction)ophemyAction:(id)sender;
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
@property (strong, nonatomic) NSString *itemNameStr;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;
- (IBAction)Slideshow:(id)sender;

@end
