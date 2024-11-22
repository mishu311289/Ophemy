
#import <UIKit/UIKit.h>
#import "tableAllotedOC.h"
#import "fetchChatOC.h"
#import "chatOC.h"
#import "pingsOC.h"
#import "FMDatabase.h"
@interface spPingAssistanceViewController : UIViewController
{
    NSMutableArray *pingsList, *tableNameArray, *allChatMessages,*orderIdsArray, *tableAllotedIdsArray, *assignedTablesArray, *assignedTableTimestampsArray,*fetchedChatData, *fetchTableIdsArray,*tablesList,*fetchingChat;
    UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *orders;
    IBOutlet UIButton *requestAssistance;
    IBOutlet UIButton *pingAssistance;
    IBOutlet UIButton *exit;
    IBOutlet UILabel *lblliveAssistance;
    IBOutlet UIImageView *imageliveAssistance;
    IBOutlet UIView *vieworders;
    IBOutlet UIView *viewexit;
    IBOutlet UIView *viewliveAssistance;
    IBOutlet UIImageView *disabledImgView;
    IBOutlet UIView *viewNoMessages;
    IBOutlet UIView *viewRequestAssistance;
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
    pingsOC *pingsObj;
    
    FMDatabase *database;
    NSArray *docPaths;
}
@property (strong, nonatomic) NSMutableArray *tablesAllotedArray;
@property (strong, nonatomic) IBOutlet UITableView *pingTableView;
- (IBAction)myStatsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *sideScroller;
@property (strong, nonatomic) IBOutlet UILabel *deliveredStatLbl;
@property (strong, nonatomic) IBOutlet UILabel *pendingStatLbl;
@property (strong, nonatomic) IBOutlet UILabel *inProcessStatLbl;
@property (strong, nonatomic) IBOutlet UIView *statsPopUpView;
@property (strong, nonatomic) IBOutlet UILabel *orderDeliveryTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderPendingTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderInProcessTitleLbl;
- (IBAction)menuBtn:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)requestAssistanceAction:(id)sender;
- (IBAction)seeOrderAction:(id)sender;
- (IBAction)pingForAssisteance:(id)sender;
-(void)chatTable;
-(void) fetchCounts;
@property (strong, nonatomic) IBOutlet UIImageView *orderNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *orderNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *pingNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *pingNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *chatNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *chatNotificationBageLbl;
@end
