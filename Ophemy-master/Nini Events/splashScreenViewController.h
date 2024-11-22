
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "menuOC.h"
#import "FMDatabase.h"
#import <MediaPlayer/MediaPlayer.h>
#import "menuOC.h"
#import "menuItemsOC.h"
@interface splashScreenViewController : UIViewController
{
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    NSString *result, *message, *lastUpdatedCities, *supportEmail, *categoryType;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    int webServiceCode;
    NSMutableArray *menuDetails, *menuCategoryIdsArray;
    FMDatabase *database;
    menuOC * menuObj;
    menuItemsOC *menuItemsObj;
     NSMutableArray  *menuItemsDetail, *itemsIdsArray;
}
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIImageView *disabledImgView;
@end
