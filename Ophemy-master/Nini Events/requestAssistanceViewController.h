
#import <UIKit/UIKit.h>
#import "fetchChatOC.h"
#import "chatOC.h"
#import "UIBubbleTableViewDataSource.h"
#import "FMDatabase.h"
@interface requestAssistanceViewController : UIViewController<UIBubbleTableViewDataSource, UITextFieldDelegate>
{
    NSMutableData *webData;
    NSMutableArray *fetchedChatData, *allChatMessages, *chatArray;
    fetchChatOC *fetchChatObj;
    NSMutableDictionary *chatDictionary;
    chatOC *chatObj;
    CGPoint svos;
    int webServiceCode;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    int bulbFlag;
    NSString *chatTrigger;
    NSTimer *hideTimer, *fetchMsgTimer;
    UIActivityIndicatorView *objactivityindicator;
    IBOutlet UIView *viewNOChat;
    IBOutlet UIView *disableView;
    
    
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
@property (weak, nonatomic) IBOutlet UIBubbleTableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextField *chatMessageTxtView;
- (IBAction)sendMessage:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *chatScroller;
- (IBAction)menuBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *sideScroller;
- (IBAction)newOrderAction:(id)sender;
- (IBAction)orderHistoryAction:(id)sender;
- (IBAction)requestAssistanceAction:(id)sender;
- (IBAction)spcornerAction:(id)sender;
- (IBAction)exitAction:(id)sender;
- (IBAction)menuAction:(id)sender;
- (IBAction)appHomeAction:(id)sender;
- (IBAction)checkOutView:(id)sender;
- (IBAction)ophemyAction:(id)sender;
- (IBAction)Slideshow:(id)sender;
-(void) fetchHelpMessage;
@property (strong, nonatomic) IBOutlet UILabel *batchLbl;
@property (strong, nonatomic) IBOutlet UIView *sideMenuWithoutReqAssistance;
@property (strong, nonatomic) IBOutlet UIView *footerWithoutEventsDetail;
@property (strong, nonatomic) IBOutlet UILabel *otherMenuBatchLbl;
@property (strong, nonatomic) IBOutlet UIImageView *batchImg;
@property (strong, nonatomic) IBOutlet UIImageView *otheMenuBatchImg;
- (IBAction)pingBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *pingBulbImg;
@property (strong, nonatomic) IBOutlet UIImageView *otherMenuPingBulbImg;
-(void) sendHelpMessage;
@property (strong, nonatomic) IBOutlet UIView *pingMessageView;
@property (strong, nonatomic) IBOutlet UIImageView *assisstanceNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *assisstanceNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageBgLbl;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;

@end
