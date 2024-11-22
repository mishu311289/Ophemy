
#import <UIKit/UIKit.h>
#import "screenSaverViewController.h"
#import "appHomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableData *webData;
    int webServiceCode;
     NSDateComponents *components;
     NSTimer *timer;
    appHomeViewController *appHomeView;
    FMDatabase *database;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) bool *startIdleTimmer;
@property (nonatomic, retain) screenSaverViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigator;
@property (strong ,nonatomic) NSString*currencySymbol;
- (void)resetIdleTimer;
- (void)resetEventTimer;
- (void)createCopyOfDatabaseIfNeeded;
- (void)logout;
@end

