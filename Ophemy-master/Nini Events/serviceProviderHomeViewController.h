
#import <UIKit/UIKit.h>
#import "pendingOrdersOC.h"
#import "chatOC.h"
#import "UIBubbleTableViewDataSource.h"
#import "tableAllotedOC.h"
#import "fetchChatOC.h"
#import "NIDropDown.h"
#import "FMDatabase.h"
@interface serviceProviderHomeViewController : UIViewController<UIBubbleTableViewDataSource, UITextViewDelegate, NIDropDownDelegate>
{
    FMDatabase *database;
     NIDropDown *dropDown;
    NSMutableData *webData;
    tableAllotedOC *tableAllotedObj;
    fetchChatOC *fetchChatObj;
    UIActivityIndicatorView *activityIndicator;
    NSString *result, *message, *lastUpdatedCities, *supportEmail, *categoryType, *StatusTag, *tableSelected;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath,* timeStampKey, *selectedTable;
    int webServiceCode;
    NSIndexPath *tableIdIndex;
    NSMutableDictionary *chatDictionary;
    NSMutableArray *orderList, *chatArray, *allChatMessages,*orderIdsArray, *tableAllotedIdsArray, *assignedTablesArray, *assignedTableTimestampsArray,*fetchedChatData, *fetchTableIdsArray,*tablesList,*fetchingChat;
    pendingOrdersOC *pendingOrderObj;
    UILabel *timeLbl, *tableNoLbl, *orderIdLbl, *statusLbl,*firstline,*secondLine, *thirdLine, *bottomLine, *pendingorderName, *pendingOrderquantity, *pendingOrderPrice, *bottomOrderPopUpLine, *messageLbl;
    NSIndexPath *selectedIndex, *orderNumberIndex;
    NSMutableArray *pendingOrderItemNameArray,*pendingOrderItemPriceArray,*pendingOrderItemQuantityArray,*pendingOrderTimeOfDeliveryArray;
    chatOC *chatObj;
    int bubbleFragment_width, bubbleFragment_height;
    int bubble_width;
    int bubble_x, bubble_y;
    CGPoint originalPt;
    BOOL *isMinimized, *isCancellation, *isModification;
    UITapGestureRecognizer *letterTapRecognizer;
    NSArray *orderListAray;
    NSMutableArray *orderIdtempArray,*savDataArray;
    IBOutlet UILabel *roleLbl;
    IBOutlet UILabel *nameLbl;
    IBOutlet UIImageView *providerImageView;
    int isCoutFetched;
    IBOutlet UIButton *pingAssistance;
    IBOutlet UITextField *searchOrdrTxt;
    //FMDatabase *database;
    IBOutlet UILabel *lblPingAssistance;
    IBOutlet UILabel *requestLbl;
    
    IBOutlet UIImageView *bulb;
    IBOutlet UIButton *requestAssistance;
    
    IBOutlet UIButton *modificationRequestCloseBtn;
    IBOutlet UIImageView *editOrderImage;
    IBOutlet UIButton *btnRequest;
    int flag;
    IBOutlet UILabel *emptyOrderLbl;
    IBOutlet UILabel *lblliveAssistance;
    IBOutlet UIImageView *imageliveAssistance;
    IBOutlet UIView *viewliveAssistance;
    IBOutlet UIView *viewexit;
    IBOutlet UIView *vieworders;
    IBOutlet UIView *viewRequestAssistance;
}
- (IBAction)btnRequest:(id)sender;
- (IBAction)menuOrdersBtn:(id)sender;
- (IBAction)menuPings:(id)sender;
- (IBAction)menuExit:(id)sender;
- (IBAction)menuBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *sideScroller;

@property (strong, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
- (IBAction)openOrdersBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
- (IBAction)deliveredOrderBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deliveredbtn;
@property (weak, nonatomic) IBOutlet UIButton *processingBtn;
- (IBAction)processingOrderBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *orderListPopUp;
@property (weak, nonatomic) IBOutlet UITableView *orderListPopUpTableView;
@property (weak, nonatomic) IBOutlet UILabel *orderPopUpTotalBill;
- (IBAction)confirmOrderBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmOrder;
- (IBAction)orderListPopUpcloseBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLbl;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextView *chatMessageTxtView;
- (IBAction)sendChatMessage:(id)sender;
- (IBAction)cancelationBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *requestCancellation;
@property (strong, nonatomic) IBOutlet UIButton *requestModification;
@property (strong, nonatomic) IBOutlet UILabel *orderTime;
@property (strong, nonatomic) IBOutlet UIButton *orderStatus;
@property (strong, nonatomic) IBOutlet UIImageView *arrow1;
@property (strong, nonatomic) IBOutlet UIImageView *arrow2;
@property (strong, nonatomic) IBOutlet UIImageView *arrow3;
@property (strong, nonatomic) IBOutlet UIImageView *orderDeliveredTick;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLbl;
@property (strong, nonatomic) IBOutlet UIImageView *disabledImgView;
@property (strong, nonatomic) NSMutableArray *tablesAllotedArray;
@property (strong, nonatomic) IBOutlet UITableView *allotedTablesTableView;
@property (strong, nonatomic) IBOutlet UILabel *tableNumberChatLbl;
- (IBAction)minimizeBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *myStats;
- (IBAction)myStatsBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *orders;
@property (strong, nonatomic) IBOutlet UIButton *pings;
@property (strong, nonatomic) IBOutlet UIButton *exit;
@property (strong, nonatomic) NSString *serviceProviderId;
@property (strong, nonatomic) IBOutlet UILabel *deliveredStatLbl;
@property (strong, nonatomic) IBOutlet UILabel *pendingStatLbl;
@property (strong, nonatomic) IBOutlet UILabel *inProcessStatLbl;
@property (strong, nonatomic) IBOutlet UIView *statsPopUpView;
@property (strong, nonatomic) IBOutlet UILabel *orderDeliveryTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderPendingTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderInProcessTitleLbl;
- (IBAction)doneBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *modificationPopUpTitle;
@property (strong, nonatomic) IBOutlet UITextView *modificationComment;
- (IBAction)confirmModificationBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *confirmModification;
- (IBAction)requestPopUpClose:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *modificationPopUpView;
@property (strong, nonatomic) IBOutlet UITextView *modificationTextView;
- (IBAction)requestAssistance:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *spDisplayLbl;
@property (strong, nonatomic) IBOutlet UIView *pingMessageView;
- (IBAction)pingAssistance:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *orderNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *orderNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *pingNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *pingNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *spNotesTextView;
@property (strong, nonatomic) IBOutlet UILabel *requestMessage;
- (IBAction)OkAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *requestPopUpView;
@property (strong, nonatomic) IBOutlet UILabel *enterReasonLbl;
@property (strong, nonatomic) IBOutlet UIImageView *chatNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *chatNotificationBageLbl;
@property (weak, nonatomic) IBOutlet UIView *gestureView;
-(void)pendingPlacedOrder: (NSString *)ordertype;
@end
