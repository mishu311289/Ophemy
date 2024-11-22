
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "tableAllotedOC.h"
@interface eventImagesSlideViewViewController : UIViewController
{
    int webServiceCode;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSMutableArray *imagesUrlArray, *screenSaverImages, *imageNameStringsArray;
    UIScrollView *scr;
    UIPageControl *pgCtr;
    int bulbFlag,timerFlag;
    NSMutableData *webData;
    NSTimer *slideTimer;
    tableAllotedOC *tableAllotedObj;
    NSMutableArray *pingsList, *tableNameArray, *allChatMessages,*orderIdsArray, *tableAllotedIdsArray, *assignedTablesArray, *assignedTableTimestampsArray,*fetchedChatData, *fetchTableIdsArray,*tablesList,*fetchingChat;
    BOOL fetchEventDetails, isTableCoutFetched;
    NSTimer *hideTimer, *fetchTimer;
    UIActivityIndicatorView *activityIndicator;

    IBOutlet UIView *topHeaderView;
    
    IBOutlet UIButton *Slideshow;
    
    IBOutlet UIButton *appHomeAction;
    NSMutableArray *toolbaritems;
    
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



@property (strong, nonatomic) NSMutableArray *tablesAllotedArray;
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


@property (strong, nonatomic) IBOutlet UIView *footerwithoutPING;
@property (strong, nonatomic) IBOutlet UIView *footerwithoutSLIDESHOW;
@property (strong, nonatomic) IBOutlet UIView *footerwithoutEVENTDETAILS;
@property (strong, nonatomic) IBOutlet UIView *FooterMenuwithoutSLIDESHOWandEVENTDETAIL;
@property (strong, nonatomic) IBOutlet UIView *FooterMenuwithoutPINGandEVENTDETAILS;
@property (strong, nonatomic) IBOutlet UIView *FooterMenuwithoutPINGandSLIDSHOW;
@property (strong, nonatomic) IBOutlet UIView *FooterMenuwithoutPINGSLIDSHOWandEVENTDETAILS;
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
@property (strong, nonatomic) IBOutlet UIView *imageAnimationScrollerView;
@property (strong, nonatomic) IBOutlet UIImageView *assisstanceNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *assisstanceNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;

@end
