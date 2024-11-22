
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "menuOC.h"
#import "menuItemsOC.h"
#import "FMDatabase.h"

@interface loginViewController : UIViewController<UITextFieldDelegate>
{
    AppDelegate *appdelegate;
    CGPoint svos;
    NSMutableData *webData;
    NSString *result, *message, *lastUpdatedCities, *supportEmail, *categoryType;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    int webServiceCode;
    menuOC * menuObj;
    menuItemsOC *menuItemsObj;
    FMDatabase *database;
    NSMutableArray *menuDetails, *menuCategoryIdsArray, *menuItemsDetail, *itemsIdsArray, *tablesArray,*imagesUrlArray,*iPadIdsArray;
    IBOutlet UILabel *lblbackground;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    BOOL checkbox_Value;
    IBOutlet UIButton *btnRememberMe;
    UIImage *btnImage;
    appHomeViewController *appHomeView;
}
- (IBAction)btnRememberMe:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScroller;
- (IBAction)ForgotPassword:(id)sender;
- (IBAction)Register:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *disabledImgView;
-(void)menuItems;
@end
