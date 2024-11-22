
#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface appHomeViewController : UIViewController
{
    UInt32 col;
    NSMutableData *webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSMutableArray *orderList;
    int flag, bulbFlag,webServiceCode;
    UIScrollView *scr;
    UIPageControl *pgCtr;
    NSMutableArray *eventNameArray,*eventDetailArray,*EventDetailsStartTime,*EventDetailsEndTime,*EventDetailsBy,*EventDocumentUrlsArray,*eventArray,*EventDocumentTitleArray;
    IBOutlet UILabel *eventDescriptionLbl;
    IBOutlet UIImageView *eventImageView;
    NSTimer *hideTimer;
    NSMutableArray *fontFamilyNames, *appFonts;
    NSArray *sortedEventArray;
    BOOL isAlreadyInserted;
 
    IBOutlet UILabel *lbleventtimeout;
    IBOutlet UILabel *lblTimerbackground;
    IBOutlet UILabel *lblTimerheaderbackground;
    IBOutlet UILabel *lblTimerHour;
    IBOutlet UILabel *lblTimermin;
    IBOutlet UILabel *lblTimerSec;
    IBOutlet UILabel *lblTimerDays;
    IBOutlet UILabel *dayCountDownHourLbl;
    IBOutlet UILabel *dayCountDownMinLbl;
    IBOutlet UILabel *dayCountDownSecLbl;
    NSTimer *timer;
     NSCalendar *cal;
    NSDate *targetDate;
    NSDateComponents *components;
    NSString *isClicked;
    NSString *selectedIndex;
   
    IBOutlet UITableView *tableView;
    IBOutlet UITableView *tableviewpdf;
    
    IBOutlet UIView *lblEventBackground;
    IBOutlet UIImageView *imageViewDropdownPDF;
    BOOL value;
    IBOutlet UIButton *btnselecteventdetail;
    
    
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
    NSInteger content;
}




- (IBAction)btnselecteventdetail:(id)sender;
- (IBAction)btnViewPDF:(id)sender;

@property (nonatomic) NSIndexPath *expandedIndexPath;
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
- (void)tick;
@property (strong, nonatomic) IBOutlet UILabel *EventNamesLbl;
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

@end
