
#import "menuStateViewController.h"
#import "AsyncImageView.h"
#import "homeViewController.h"
#import "appHomeViewController.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "CheckOutViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "eventDetailViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "Base64.h"
#import "NSData+Base64.h"
#import "appHomeViewController.h"
@interface menuStateViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bottomMenuImg;
@property (strong, nonatomic) IBOutlet UIView *bottomMenuView;
@property (strong, nonatomic) IBOutlet UIView *ophemyLogoView;
@property (strong, nonatomic) IBOutlet UIButton *slideMenuBtn;
@property (strong, nonatomic) IBOutlet UIButton *pingBtn;
@end

@implementation menuStateViewController

- (void)viewDidLoad {
    
     [self createMenu];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        toolBar.barTintColor = [UIColor colorWithRed:178/255.0f green:38/255.0f blue:12/255.0f alpha:1.0f];
        toolBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        toolBar.tintColor = [UIColor colorWithRed:178/255.0f green:38/255.0f blue:12/255.0f alpha:1.0f];
    }

    
    
    [super viewDidLoad];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
    }
    else{
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    if (self.isNewOrder) {
        [self.startUpPopUp setFrame:CGRectMake(0, 0, self.startUpPopUp.frame.size.width, self.startUpPopUp.frame.size.height)];
        [self.view addSubview:self.startUpPopUp];
    }
    if (self.isOrderPlaced) {
        [self.orderPlacedSuccessfulView setFrame:CGRectMake(0, 0, self.startUpPopUp.frame.size.width, self.startUpPopUp.frame.size.height)];
        [self.view addSubview:self.orderPlacedSuccessfulView];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int chatCount = [[defaults valueForKey:@"Chat Count"] intValue];
    if (chatCount != 0) {
        self.assisstanceNotificationBadgeImg.hidden = NO;
        self.assisstanceNotificationBadgeLbl.hidden = NO;
        self.assisstanceNotificationBadgeLbl.text = [NSString stringWithFormat:@"%d",chatCount];
    }else{
        self.assisstanceNotificationBadgeImg.hidden = YES;
        self.assisstanceNotificationBadgeLbl.hidden = YES;
    }
    NSString *orderCount = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Order Item Count"]];
    if (![orderCount isEqualToString:@"(null)"])
    {
        if (![orderCount isEqualToString:@"0"]) {
            
            self.batchLbl.hidden = NO;
            self.batchImg.hidden = NO;
            self.otherMenuBatchLbl.hidden = NO;
            self.otheMenuBatchImg.hidden = NO;
            NSLog(@"ordr count..%@",orderCount);
            self.batchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
            self.otherMenuBatchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
            
        }
        else{
            self.batchLbl.hidden = YES;
            self.batchImg.hidden = YES;
            self.otherMenuBatchLbl.hidden = YES;
            self.otheMenuBatchImg.hidden = YES;
        }
        
    }else{
        self.batchLbl.hidden = YES;
        self.batchImg.hidden = YES;
        self.otherMenuBatchLbl.hidden = YES;
        self.otheMenuBatchImg.hidden = YES;
    }
    //self.batchLbl.text = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Order Item Count"]];
    [self placeItems];
    
    NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Chat Support"]];
    
    if ([eventChatSupport isEqualToString:@"False"]) {
        [self.sideMenuWithoutReqAssistance setFrame:CGRectMake(-269, 19, self.sideMenuWithoutReqAssistance.frame.size.width, self.sideMenuWithoutReqAssistance.frame.size.height)];
        [self.sideScroller addSubview:self.sideMenuWithoutReqAssistance];
        
    }else{
        [self.sideMenuWithoutReqAssistance removeFromSuperview];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)placeItems{
    itemNameArray = [[NSMutableArray alloc] init];
    itemImageUrlArray = [[NSMutableArray alloc] init];
    menuCategoryArray = [[NSMutableArray alloc] init];
    drinkMenuItems = [[NSMutableArray alloc] init];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM menu "];
    FMResultSet *queryResults = [database executeQuery:queryString];
    while([queryResults next]) {
        itemName = [queryResults stringForColumn:@"categoryName"];
        NSString *categoryId = [queryResults stringForColumn:@"categoryID"];
        NSString *queryString = [NSString stringWithFormat:@"Select * FROM categoryItems where categoryID = \"%@\"",categoryId];
        FMResultSet *queryResults1 = [database executeQuery:queryString];
        while([queryResults1 next]) {
            itemImageUrl = [queryResults1 stringForColumn:@"itemImage"];
            
        }
        NSString *categoryType = [queryResults stringForColumn:@"type"];
        [itemNameArray addObject:itemName];
        [itemImageUrlArray addObject:itemImageUrl];
        if ([categoryType isEqualToString:@"Food"]) {
            [menuCategoryArray addObject:[queryResults stringForColumn:@"categoryName"]];
        }else{
            [drinkMenuItems addObject:[queryResults stringForColumn:@"categoryName"]];
        }
    }
    [database close];
    
    //    menuItemsObj = [menuItemsDetailsArray objectAtIndex:indexPath.row];
    //    itemName.text = [NSString stringWithFormat:@"%@",menuItemsObj.ItemName];
    //    priceLabel.text =[NSString stringWithFormat:@"$%@",menuItemsObj.Price];
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",menuItemsObj.Image]];
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    //    UIImage *img = [UIImage imageWithData:data];
    //    NSLog(@"Image Name %@",img);
    //    itemImage.image = img;
    [self.view bringSubviewToFront:self.scrollerimage];
    int count = [itemNameArray count];
    if (count%2 != 0) {
        count = (count+ 1)/2;
    }else{
        count = count/2;
    }
    if (IS_IPAD_Pro) {
        self.scrollerimage.contentSize = CGSizeMake(150,(count *  430)+3);
    }else{
        self.scrollerimage.contentSize = CGSizeMake(150,(count *  350)+3);
    }
    
    _scrollerimage.showsHorizontalScrollIndicator = NO;
    _scrollerimage.showsVerticalScrollIndicator = NO;
    
    
    int y= 0;
    
    for (NSUInteger i = 0; i < [itemImageUrlArray count]; ++i) {
        UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        imageTapRecognizer.numberOfTapsRequired = 1;
        if (i %2 == 0 || i == 0) {
            UIImageView *page = [[UIImageView alloc] init];

            NSString *imageName = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[itemImageUrlArray objectAtIndex:i]]];
            page.image = [UIImage imageNamed:imageName];
            
            UILabel *pageName = [[UILabel alloc] init];
            if (IS_IPAD_Pro) {
                page.frame = CGRectMake(0, y, 679, 430);
                pageName.frame = CGRectMake(0,380 ,679, 50);
            }else{
                page.frame = CGRectMake(0, y, 510, 350);
                pageName.frame = CGRectMake(0,300 ,510, 50);
            }
            
            //page.contentMode = UIViewContentModeScaleAspectFill;
            page.tag = i;
            page.userInteractionEnabled = YES;
            page.multipleTouchEnabled = YES;
            [_scrollerimage addSubview:page];
            
            NSString *pageNameString = [NSString stringWithFormat:@"%@",[itemNameArray objectAtIndex:i]];
            pageNameString = [pageNameString uppercaseString];
            pageName.text = pageNameString;
            pageName.textColor = [UIColor whiteColor];
            [pageName setBackgroundColor:[UIColor colorWithRed:36/255.f green:36/255.f blue:36/255.f alpha:0.5]];
            [pageName setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:20]];
            pageName.textAlignment = NSTextAlignmentCenter;
            [page addSubview:pageName];
            [page addGestureRecognizer:imageTapRecognizer];
            
        }else{
            UIImageView *page = [[UIImageView alloc] init];
            NSString *imageName = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[itemImageUrlArray objectAtIndex:i]]];
            page.image = [UIImage imageNamed:imageName];

            UILabel *pageName = [[UILabel alloc] init];
            if (IS_IPAD_Pro) {
                page.frame = CGRectMake(681, y, 679, 430);
                pageName.frame = CGRectMake(0,380 ,679, 50);
                y=y+431;
            }else{
                page.frame = CGRectMake(511, y, 511, 350);
                pageName.frame = CGRectMake(0,300 ,511, 50);
                y=y+351;
            }

           
            page.tag = i;
            page.userInteractionEnabled = YES;
            page.multipleTouchEnabled = YES;
            [_scrollerimage addSubview:page];
            
        
        
            NSString *pageNameString = [NSString stringWithFormat:@"%@",[itemNameArray objectAtIndex:i]];
            pageNameString = [pageNameString uppercaseString];
            pageName.text = pageNameString;
            pageName.textColor = [UIColor whiteColor];
            [pageName setBackgroundColor:[UIColor colorWithRed:36/255.f green:36/255.f blue:36/255.f alpha:0.5]];
            [pageName setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:20]];
            pageName.textAlignment = NSTextAlignmentCenter;
            [page addSubview:pageName];
            [page addGestureRecognizer:imageTapRecognizer];
            
        }
    }
}
- (void)imageTapped:(UITapGestureRecognizer *)sender{
    
    UIView *view = sender.view; //cast pointer to the derived class if needed
    NSLog(@"%ld", (long)view.tag);
    int tagValue = view.tag;
    NSString *itemNamestr = [NSString stringWithFormat:@"%@",[itemNameArray objectAtIndex:tagValue]];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *categorytype;
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM menu where categoryName = \'%@\'",itemNamestr];
    FMResultSet *queryResults = [database executeQuery:queryString];
    while([queryResults next]) {
        categorytype = [queryResults stringForColumn:@"type"];
    }
    [database close];
    homeViewController *homeVC = [[homeViewController alloc] initWithNibName:@"homeViewController_1" bundle:nil];
    homeVC.itemNameStr = itemNamestr;
    if ([categorytype isEqualToString:@"Food"]) {
        homeVC.menuTagValue = 1;
    }else{
        homeVC.menuTagValue = 2;
    }
    homeVC.itemTag = view.tag;
    [self.navigationController pushViewController:homeVC animated:NO];
    
    
}

- (IBAction)popUpContinueBtn:(id)sender {
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
    [database executeUpdate:queryString1];
    
    [database close];
    [self orderlist];
    [self.startUpPopUp removeFromSuperview];
    [self.orderPlacedSuccessfulView removeFromSuperview];
}

- (IBAction)closeStartUpPopUp:(id)sender {
    [self.startUpPopUp removeFromSuperview];
    [self.orderPlacedSuccessfulView removeFromSuperview];
}

- (IBAction)newOrderAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = YES;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)orderHistoryAction:(id)sender {
    OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
    ordrVc.flagValue = 1;
    [self.navigationController pushViewController:ordrVc animated:YES];
}

- (IBAction)spcornerAction:(id)sender {
    OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
    ordrVc.flagValue = 2;
    [self.navigationController pushViewController:ordrVc animated:YES];
}

- (IBAction)requestAssistanceAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Chat Count"] ;
    self.assisstanceNotificationBadgeImg.hidden = YES;
    self.assisstanceNotificationBadgeLbl.hidden = YES;
    requestAssistanceViewController *requestVC = [[requestAssistanceViewController alloc] initWithNibName:@"requestAssistanceViewController" bundle:nil];
    [self.navigationController pushViewController:requestVC animated:NO];
}

- (IBAction)exitAction:(id)sender {
    if (IS_IPAD_Pro) {
        [self.exitPopUpView setFrame:CGRectMake(0, 0, 1366, 1024)];
    }else{
        [self.exitPopUpView setFrame:CGRectMake(0, 0, self.exitPopUpView.frame.size.width, self.exitPopUpView.frame.size.height)];
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"OFF" forKey:@"bulb"];
    }
    [self.view addSubview:self.exitPopUpView];
}

- (IBAction)menuAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = NO;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)sideMenuAction:(id)sender {
    CGPoint pt;
    CGRect rc = [self.sideScroller bounds];
    rc = [self.sideScroller convertRect:rc toView:self.sideScroller];
    pt = rc.origin;
    if (pt.x == 0) {
        if (IS_IPAD_Pro) {
            pt.x -= 356;
        }else{
            pt.x -= 265;
        }
    }else{
        pt.x = 0;
    }
    
    pt.y =-20;
    [self.sideScroller setContentOffset:pt animated:YES];
}

- (IBAction)viewOrderNtnAction:(id)sender {
    
    CheckOutViewController*checkoutVc=[[CheckOutViewController alloc]initWithNibName:@"CheckOutViewController" bundle:nil];
    [self.navigationController pushViewController:checkoutVc animated:NO];
    
    
}

- (IBAction)eventDetailsAction:(id)sender {
    appHomeViewController*eventDetailsVc=[[appHomeViewController alloc]initWithNibName:@"appHomeViewController" bundle:nil];
    [self.navigationController pushViewController:eventDetailsVc animated:NO];
}

- (IBAction)ophemyAction:(id)sender {
    
}
- (IBAction)Slideshow:(id)sender
{
    eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}
- (IBAction)appHomeAction:(id)sender {
    appHomeViewController *homeVC = [[appHomeViewController alloc] initWithNibName:@"appHomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1 && buttonIndex == 1){
        
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
        [database executeUpdate:queryString1];
        [database close];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults removeObjectForKey:@"Table ID"];
        [defaults removeObjectForKey:@"Table Name"];
        [defaults removeObjectForKey:@"Table image"];
        [defaults removeObjectForKey:@"Role"];
        
        [defaults setObject:@"YES"forKey:@"isLogedOut"];
        loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
-(void)orderlist
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM orderHistory "];
    FMResultSet *results = [database executeQuery:queryString];
    
    orderList = [[NSMutableArray alloc] init];
    while([results next]) {
        NSString *orderItemName=[results stringForColumn:@"orderItemName"];
        
        [orderList addObject:orderItemName];
    }
    NSString *orderCount =[NSString stringWithFormat:@"%lu",(unsigned long)[orderList count]];
    NSLog(@"Order Count .... %@",orderCount);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:orderCount forKey:@"Order Item Count"];
    if (![orderCount isEqualToString:@"(null)"])
    {
        if (![orderCount isEqualToString:@"0"]) {
            
            self.batchLbl.hidden = NO;
            self.batchImg.hidden = NO;
            self.otherMenuBatchLbl.hidden = NO;
            self.otheMenuBatchImg.hidden = NO;
            NSLog(@"ordr count..%@",orderCount);
            self.batchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
            self.otherMenuBatchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
            
        }
        else{
            self.batchLbl.hidden = YES;
            self.batchImg.hidden = YES;
            self.otherMenuBatchLbl.hidden = YES;
            self.otheMenuBatchImg.hidden = YES;
        }
        
    }else{
        self.batchLbl.hidden = YES;
        self.batchImg.hidden = YES;
        self.otherMenuBatchLbl.hidden = YES;
        self.otheMenuBatchImg.hidden = YES;
    }
    
    
    
    [database close];
    
    
    
}
- (IBAction)pingBtnAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"OFF"]) {
        [self sendHelpMessage];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"ON" forKey:@"bulb"];
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        self.pingMessageView.hidden = NO;
        if (IS_IPAD_Pro) {
            [self.pingMessageView setFrame:CGRectMake(88, 825, self.pingMessageView.frame.size.width, self.pingMessageView.frame.size.height)];
        }else{
            [self.pingMessageView setFrame:CGRectMake(52, 585, self.pingMessageView.frame.size.width, self.pingMessageView.frame.size.height)];
        }
        self.pingMessageView.alpha= 1.0;
        [self.sideScroller addSubview:self.pingMessageView];
        [self.sideScroller bringSubviewToFront:self.pingMessageView];
        hideTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(FadeView) userInfo:nil repeats:NO];
    }
    else{
        
        self.pingMessageView.hidden = YES;
        [hideTimer invalidate];
        [[NSUserDefaults standardUserDefaults] setValue:@"OFF" forKey:@"bulb"];
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    
}
-(void) sendHelpMessage
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tableID = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Ipad ID"]];
    NSString *serviceProviderId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"AllotedServiceProviderId"]];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@"(" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@")" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tableName = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table Name"]];
    tableName = [tableName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@")" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *chatMessage;
    NSString *chatTrigger;
    chatTrigger = [NSString stringWithFormat:@"ping"];
    chatMessage = [NSString stringWithFormat:@"%@ is requesting Assistance.",tableName];
    NSString *sender = [NSString stringWithFormat:@"table"];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tableID,@"tableId",serviceProviderId,@"serviceproviderId",chatMessage,@"message",sender, @"sender",[NSString stringWithFormat:@"1"],@"restaurantId",chatTrigger,@"trigger" ,[[NSUserDefaults standardUserDefaults] valueForKey:@"Table Name"],@"sendername", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
   NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SendHelpMessages",Kwebservices]];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =0;
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        
        NSLog(@"server connection made");
    }
    
    else
    {
        NSLog(@"connection is NULL");
    }
    
}
-(void) FadeView
{
    [UIView animateWithDuration:0.9
                     animations:^{self.pingMessageView.alpha = 0.0;}
                     completion:^(BOOL finished){self.pingMessageView.hidden = YES;}];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    webData = nil;
}

#pragma mark -
#pragma mark Process loan data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"Dictionary %@",userDetailDict);
    }

- (IBAction)exitYesAction:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    [appdelegate logout];
}

- (IBAction)exitNoAction:(id)sender {
    [self.exitPopUpView removeFromSuperview];
}

-(void)createMenu
{
    BOOL isEventDetailActive;
    BOOL isPingActive;
    BOOL isSlideShowActive;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *eventStatus =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Status"]];
    NSString *pingAssistanceStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"PingAssistance"]];
    NSString *slideShowStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"SlideShow"]];
    
    if ([eventStatus isEqualToString:@"1"]) {
        isEventDetailActive = YES;
    }else{
        isEventDetailActive = NO;
    }
    
    if ([pingAssistanceStatus isEqualToString:@"1"]) {
        isPingActive = YES;
    }else{
        isPingActive = NO;
    }
    
    if ([slideShowStatus isEqualToString:@"1"]) {
        isSlideShowActive = YES;
    }else{
        isSlideShowActive = NO;
    }
    
    
    // Menu Bar...............
    if (IS_IPAD_Pro) {
        [self.bottomMenuView setFrame:CGRectMake(0, self.sideScroller.frame.size.height - self.bottomMenuView.frame.size.height-12, self.bottomMenuView.frame.size.width, self.bottomMenuView.frame.size.height)];
    }else{
        [self.bottomMenuView setFrame:CGRectMake(0, self.sideScroller.frame.size.height - self.bottomMenuView.frame.size.height-20, self.bottomMenuView.frame.size.width, self.bottomMenuView.frame.size.height)];
    }
    
    [self.sideScroller addSubview:self.bottomMenuView];
    
    if (isPingActive) {
        //Ping Button...............
        [self.pingBtn setFrame:CGRectMake(self.slideMenuBtn.frame.size.width, 2, self.pingBtn.frame.size.width, self.pingBtn.frame.size.height)];
        [self.bottomMenuView addSubview:self.pingBtn];
        
        //Ping Button Image...............
        [self.otherMenuPingBulbImg setFrame:CGRectMake(self.pingBtn.frame.size.width/4, self.pingBtn.frame.size.height/4-4, self.otherMenuPingBulbImg.frame.size.width, self.otherMenuPingBulbImg.frame.size.height)];
        [self.pingBtn addSubview:self.otherMenuPingBulbImg];
        UIImageView *seperatorImg;
        if (IS_IPAD_Pro) {
            seperatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.pingBtn.frame.origin.x+ 105 ,0,2,72)];
        }else{
            seperatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.pingBtn.frame.origin.x+self.pingBtn.frame.size.width+1,0,2,self.bottomMenuView.frame.size.height)];
        }
        seperatorImg.image = [UIImage imageNamed:@"stroke_13.png"];
        [self.bottomMenuView addSubview:seperatorImg];
        
        
        //OphemyLogo View.....
        [self.ophemyLogoView setFrame:CGRectMake(self.pingBtn.frame.origin.x + self.pingBtn.frame.size.width+1, 4, self.ophemyLogoView.frame.size.width, self.ophemyLogoView.frame.size.height)];
        NSLog(@"Left Width = %f", self.slideMenuBtn.frame.size.width);
        [self.bottomMenuView addSubview:self.ophemyLogoView];
    }else{
        self.pingBtn.hidden = YES;
        self.otherMenuPingBulbImg.hidden = YES;
        //OphemyLogo View.....
        [self.ophemyLogoView setFrame:CGRectMake(self.slideMenuBtn.frame.size.width+1, 4, self.ophemyLogoView.frame.size.width, self.ophemyLogoView.frame.size.height)];
        [self.bottomMenuView addSubview:self.ophemyLogoView];
    }
    int leftWidth;
    if (isPingActive) {
        if (IS_IPAD_Pro) {
            leftWidth = 950;
        }else{
            leftWidth = self.bottomMenuView.frame.size.width - (self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width);
        }
    }else{
        if (IS_IPAD_Pro) {
            leftWidth = 1005;
        }else{
            leftWidth = self.bottomMenuView.frame.size.width - (self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width);
        }
    }
    
    NSLog(@"Left Width = %d",leftWidth);
    
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] initWithObjects:@"Slide Show",@"Event Detail",@"Menu",@"View Order", nil];
    if (!isSlideShowActive) {
        [buttonsArray removeObject:@"Slide Show"];
    }
    
    if (!isEventDetailActive) {
        [buttonsArray removeObject:@"Event Detail"];
    }
    //    UIButton *bottomBarBtn;
    for (int j = 0; j < buttonsArray.count; j++) {
        
        NSLog(@"Value of i ...... %d",j);
        UIButton *bottomBarBtn;
        if (isPingActive) {
            if (IS_IPAD_Pro) {
                bottomBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+420+2,2,leftWidth/buttonsArray.count, 72)];
            }else{
                bottomBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+(self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width)+2,2,leftWidth/buttonsArray.count, self.bottomMenuView.frame.size.height)];
            }
        }else{
            if (IS_IPAD_Pro) {
                bottomBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+360+2,2,leftWidth/buttonsArray.count, 72)];
            }else{
                bottomBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+(self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width)+2,2,leftWidth/buttonsArray.count, self.bottomMenuView.frame.size.height)];
            }
        }
        
        NSLog(@"%f,%f,%f,%f",bottomBarBtn.frame.origin.x,bottomBarBtn.frame.origin.y,bottomBarBtn.frame.size.width,bottomBarBtn.frame.size.height);
        NSString * title = [NSString stringWithFormat:@"%@",[buttonsArray objectAtIndex:j]];
        [bottomBarBtn setTitle:[title uppercaseString] forState:UIControlStateNormal];
        [bottomBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [bottomBarBtn setUserInteractionEnabled:YES];
        [bottomBarBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        bottomBarBtn.titleLabel.font =[UIFont fontWithName:@"Helvetica-Condensed" size:20];
        [bottomBarBtn setImageEdgeInsets:UIEdgeInsetsMake(0, bottomBarBtn.titleLabel.bounds.size.width-10, 0, 0)];
        if ([title isEqualToString:@"Menu"]) {
            [bottomBarBtn setBackgroundColor:[UIColor colorWithRed:194/255.0f green:57/255.0f blue:11/255.0f alpha:1.0]];
        }
        if ([title isEqualToString:@"View Order"]) {
            [bottomBarBtn setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
            CGRect frameIcon = bottomBarBtn.imageView.frame;
            NSLog(@"%f , %f , %f ,%f",frameIcon.origin.x,frameIcon.origin.y,frameIcon.size.width,frameIcon.size.height);
            if (IS_IPAD_Pro) {
                [self.otheMenuBatchImg setFrame:CGRectMake(frameIcon.origin.x + frameIcon.size.width/2.5,9, 20, 20)];
            }else{
                [self.otheMenuBatchImg setFrame:CGRectMake(frameIcon.origin.x + frameIcon.size.width/2.5,0, 20, 20)];
            }
            
            [bottomBarBtn addSubview:self.otheMenuBatchImg];
            [bottomBarBtn bringSubviewToFront:self.otheMenuBatchImg];
            
            if (IS_IPAD_Pro) {
                [self.otherMenuBatchLbl setFrame:CGRectMake(frameIcon.origin.x + frameIcon.size.width/2.5,9, 20, 20)];
            }else{
                [self.otherMenuBatchLbl setFrame:CGRectMake(frameIcon.origin.x + frameIcon.size.width/2.5,0, 20, 20)];
            }
            
            [bottomBarBtn addSubview:self.otherMenuBatchLbl];
            [bottomBarBtn bringSubviewToFront:self.otherMenuBatchLbl];
            
        }
        //        [bottomBarBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [bottomBarBtn addTarget:self action:@selector(bottomBarBtns:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomMenuView addSubview:bottomBarBtn];
        
        UIImageView *seperatorImg;
        if (isPingActive) {
            if (IS_IPAD_Pro) {
                seperatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+420,0,2,72)];
            }else{
                seperatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+(self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width),0,2,self.bottomMenuView.frame.size.height)];
            }
        }else{
            if (IS_IPAD_Pro) {
                seperatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+360,0,2,72)];
            }else{
                seperatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+(self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width),0,2,self.bottomMenuView.frame.size.height)];
            }
        }
        seperatorImg.image = [UIImage imageNamed:@"stroke_13.png"];
        [self.bottomMenuView addSubview:seperatorImg];
        
        
    }
    
}

-(IBAction)bottomBarBtns:(UIButton*)sender{
    NSLog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"EVENT DETAIL"]){
        appHomeViewController *homeVC = [[appHomeViewController alloc] initWithNibName:@"appHomeViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
    }else if ([sender.titleLabel.text isEqualToString:@"SLIDE SHOW"]){
        eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
    }else if ([sender.titleLabel.text isEqualToString:@"VIEW ORDER"]){
        CheckOutViewController *homeVC = [[CheckOutViewController alloc] initWithNibName:@"CheckOutViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
    }
    
}

- (void)removeData
{
    NSString *extension = @"png";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory     stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}
@end
