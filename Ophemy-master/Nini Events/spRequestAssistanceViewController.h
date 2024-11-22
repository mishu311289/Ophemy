
#import <UIKit/UIKit.h>
#import "tableAllotedOC.h"
#import "fetchChatOC.h"
#import "chatOC.h"
#import "UIBubbleTableViewDataSource.h"
#import "FMDatabase.h"
@interface spRequestAssistanceViewController : UIViewController<UIBubbleTableViewDataSource, UITextViewDelegate>
{
    IBOutlet UIButton *requestAssistance;
    IBOutlet UIButton *pingAssistance;
    IBOutlet UIButton *exit;
    IBOutlet UIButton *orders;
    IBOutlet UILabel *lblliveAssistance;
    IBOutlet UIImageView *imageliveAssistance;
    IBOutlet UIView * viewliveAssistance;
    IBOutlet UIView * viewexit;
    IBOutlet UIView *vieworders;
    IBOutlet UIView *viewRequestAssistance;
    
    NSMutableArray *orderList, *chatArray, *allChatMessages,*orderIdsArray, *tableAllotedIdsArray, *assignedTablesArray, *assignedTableTimestampsArray,*fetchedChatData, *fetchTableIdsArray,*tablesList,*fetchingChat;
    tableAllotedOC *tableAllotedObj;
    NSMutableData *webData;
    NSString *documentsDir, *dbPath,* timeStampKey, *selectedTable;
    int webServiceCode;
    NSString *result, *message, *lastUpdatedCities, *supportEmail, *categoryType, *StatusTag, *tableSelected;
    NSIndexPath *tableIdIndex;
    fetchChatOC *fetchChatObj;
    NSMutableDictionary *chatDictionary;
    chatOC *chatObj;
    CGPoint originalPt;
    UITapGestureRecognizer *letterTapRecognizer;
    NSArray *docPaths;
    FMDatabase *database;
    NSIndexPath *selectedIndex,*orderNumberIndex;
    NSArray *chatCountArray;
     CGPoint svos;
    UIActivityIndicatorView *objactivityindicator;
    IBOutlet UIView *disableView;

    NSTimer  *fetchMsgTimer;
}
- (IBAction)myStatsAction:(id)sender;
@property (strong, nonatomic) NSMutableArray *tablesAllotedArray;
@property (strong, nonatomic) IBOutlet UITableView *allotedTablesTableView;
@property (strong, nonatomic) IBOutlet UILabel *tableNumberChatLbl;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextView *chatMessageTxtView;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *chatView;
@property (weak, nonatomic) IBOutlet UIScrollView *sideScroller;
@property (strong, nonatomic) IBOutlet UILabel *deliveredStatLbl;
@property (strong, nonatomic) IBOutlet UILabel *pendingStatLbl;
@property (strong, nonatomic) IBOutlet UILabel *inProcessStatLbl;
@property (strong, nonatomic) IBOutlet UIView *statsPopUpView;
@property (strong, nonatomic) IBOutlet UILabel *orderDeliveryTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderPendingTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderInProcessTitleLbl;
@property (strong, nonatomic) NSString *triggerValue;
- (IBAction)sendBtnAction:(id)sender;
- (IBAction)menuBtn:(id)sender;
- (IBAction)seeOrderAction:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)pingForAssistanceAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *orderNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *orderNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *pingNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *pingNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;
-(void)chatTable;
@property (strong, nonatomic) IBOutlet UIImageView *chatNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *chatNotificationBageLbl;
@end
