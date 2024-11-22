
#import "eventImagesSlideViewViewController.h"
#import "AppDelegate.h"
#import "eventDetailViewController.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "appHomeViewController.h"
#import "CheckOutViewController.h"
#import "menuStateViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "NSData+Base64.h"
#import "Base64.h"
#import "appHomeViewController.h"

@interface eventImagesSlideViewViewController ()
{
    NSMutableArray *imgDesc;
}
@property (strong, nonatomic) IBOutlet UIImageView *bottomMenuImg;
@property (strong, nonatomic) IBOutlet UIView *bottomMenuView;
@property (strong, nonatomic) IBOutlet UIImageView *ophemyLogoView;
@property (strong, nonatomic) IBOutlet UIButton *slideMenuBtn;
@property (strong, nonatomic) IBOutlet UIButton *pingBtn;

@end

@implementation eventImagesSlideViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMenu];
    
                    
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
    }
    else{
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    timerFlag = 0;
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
    NSArray *serviceproviderArray = [[NSMutableArray alloc]initWithObjects:[defaults valueForKey:@"Alloted Service Provider"], nil];
    NSLog(@"Tables... %@",serviceproviderArray);
    for (int i =0 ; i <[serviceproviderArray count] ; i++) {
        
        NSString *seriveProviderId = [[serviceproviderArray valueForKey:@"id"] objectAtIndex:i];
        [defaults setValue:seriveProviderId forKey:@"AllotedServiceProviderId"];
        
    }
    
    NSString *orderCount = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Order Item Count"]];
    NSLog(@"ordr count..%@",orderCount);
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
    NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Chat Support"]];
    
    if ([eventChatSupport isEqualToString:@"False"]) {
        [self.sideMenuWithoutReqAssistance setFrame:CGRectMake(-269, 19, self.sideMenuWithoutReqAssistance.frame.size.width, self.sideMenuWithoutReqAssistance.frame.size.height)];
        [self.sideScroller addSubview:self.sideMenuWithoutReqAssistance];
        
    }else{
        [self.sideMenuWithoutReqAssistance removeFromSuperview];
        
    }
 
    [self fetchEventDetails];
    [self addBannerImages];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    if (timerFlag == 0) {
        [slideTimer invalidate];
        timerFlag = 1;
        slideTimer = nil;
    }else if (timerFlag == 1){
        slideTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
        timerFlag = 0;
    }
    NSLog(@"Tap detected on the view");//By tag, you can find out where you had typed.
}
- (void)setupScrollView:(UIScrollView*)scrMain {
    // we have 10 images here.
    // we will add all images into a scrollView & set the appropriate size.
    
    for (int i=0; i<[imageNameStringsArray count]; i++) {
        // create image
        
        NSString *imageName = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[imageNameStringsArray objectAtIndex:i]]];
    
        // create imageView
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((i)*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height)];
        // set scale to fill
        imgV.contentMode=UIViewContentModeScaleToFill;
        // set image
        [imgV setImage:[UIImage imageNamed:imageName]];
        // apply tag to access in future
        imgV.tag=i+1;
        
        
        
        UILabel *lbldesc;
        lbldesc = [[UILabel alloc]initWithFrame:CGRectMake(20,628, scrMain.frame.size.width-40, 135.000000)];
        lbldesc.numberOfLines = 4;
        lbldesc.font = [UIFont fontWithName:@"Helvetica-Condensed" size:23];
        lbldesc.text = [NSString stringWithFormat:@"%@",[imgDesc objectAtIndex:i]];
        lbldesc.textColor = [UIColor whiteColor];
        lbldesc.textAlignment = NSTextAlignmentLeft;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 30.0f;
        paragraphStyle.maximumLineHeight = 30.0f;
        paragraphStyle.minimumLineHeight = 30.0f;
        
        NSString *string = lbldesc.text;
        NSDictionary *ats = @{
                              NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Condensed" size:23.0f],
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        
        lbldesc.attributedText = [[NSAttributedString alloc] initWithString:string attributes:ats];
        lbldesc.backgroundColor = [UIColor clearColor];
        lbldesc.lineBreakMode = NSLineBreakByWordWrapping;
        lbldesc.numberOfLines = 0;
        [lbldesc sizeToFit];
        [lbldesc setFrame:CGRectMake(lbldesc.frame.origin.x, scrMain.frame.size.height - lbldesc.frame.size.height-90, lbldesc.frame.size.width, lbldesc.frame.size.height)];
        if (![string isEqualToString:@""]) {
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, lbldesc.frame.origin.y - 20, scrMain.frame.size.width, lbldesc.frame.size.height+40)];
            paddingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [imgV addSubview:paddingView];
            [imgV addSubview:lbldesc];
            
            UILabel *whiteStrip = [[UILabel alloc] initWithFrame:CGRectMake(0, paddingView.frame.size.height-7, paddingView.frame.size.width, 1)];
            whiteStrip.backgroundColor = [UIColor whiteColor];
            [paddingView addSubview:whiteStrip];
        }
        
//        lbldesc .hidden=YES;
        lbldesc.alpha = 0.0;
        [UIView animateWithDuration:2.0
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             lbldesc.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                         }];
        // add to scrollView
        [scrMain addSubview:imgV];
    }
    // set the content size to 10 image width
    [scrMain setContentSize:CGSizeMake(scrMain.frame.size.width * [imageNameStringsArray count], scrMain.frame.size.height)];
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer {
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    // same way, access pagecontroll access
    UIPageControl *pgCtr1 = (UIPageControl*) [self.view viewWithTag:12];
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = scrMain.contentOffset.x;
    // calculate next page to display
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
    // if page is not 10, display it
    if( nextPage!=[imageNameStringsArray count] )  {
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
      
        
        pgCtr1.currentPage=nextPage;
        // else start sliding form 1 :)
    } else {
        
        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr1.currentPage=0;
    }
    for (id subView in scrMain.subviews){
        
        UIImageView*imgView=subView;
        for (id subLblView in imgView.subviews)
        {
            if ([subLblView isKindOfClass:[UILabel class]])
            {
                
                UILabel*lbldesc=subLblView;
                lbldesc.hidden=NO;
                lbldesc.alpha = 0.0;
                [UIView animateWithDuration:2.0
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     lbldesc.alpha = 1.0;
                                 }
                                 completion:^(BOOL finished){
                                 }];
                
            }
        }
    }

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

- (IBAction)appHomeAction:(id)sender {
    appHomeViewController *homeVC = [[appHomeViewController alloc] initWithNibName:@"appHomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)checkOutView:(id)sender {
    CheckOutViewController*checkoutVc=[[CheckOutViewController alloc]initWithNibName:@"CheckOutViewController" bundle:nil];
    [self.navigationController pushViewController:checkoutVc animated:NO];
}
- (IBAction)ophemyAction:(id)sender {
    
}
- (IBAction)Slideshow:(id)sender
{
    eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
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
    NSString *tableID = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
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
    NSString*Sendername= [[NSUserDefaults standardUserDefaults] valueForKey:@"Table Name"];

    
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tableID,@"tableId",serviceProviderId,@"serviceproviderId",chatMessage,@"message",sender, @"sender",[NSString stringWithFormat:@"1"],@"restaurantId",chatTrigger,@"trigger",Sendername,@"sendername", nil];
    
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
    webServiceCode = 0;
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
    if (webServiceCode == 1) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        NSError *error;
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        int result=[[userDetailDict valueForKey:@"result"]intValue];
        if (result ==1)
        {
            [self.sideMenuWithoutReqAssistance removeFromSuperview];
            [self.footerWithoutEventsDetail removeFromSuperview];
            [self.FooterMenuwithoutPINGandEVENTDETAILS removeFromSuperview];
            [self.FooterMenuwithoutPINGandSLIDSHOW removeFromSuperview];
            [self.FooterMenuwithoutPINGSLIDSHOWandEVENTDETAILS removeFromSuperview];
            [self.FooterMenuwithoutSLIDESHOWandEVENTDETAIL removeFromSuperview];
            [self.footerwithoutEVENTDETAILS removeFromSuperview];
            [self.footerwithoutEVENTDETAILS removeFromSuperview];
            [self.footerwithoutPING removeFromSuperview];
            [self.footerwithoutSLIDESHOW removeFromSuperview];

        }
        else{
            NSString *pdfUrl = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"EventPdfUrl"]];
            NSString *eventStatus = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"EventTabVisiblity"]];
             NSString *PingAssistance = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"PingAssistance"]];
             NSString *SlideShow = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"SlideShow"]];
            
            
            
            
            NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"EventChatSupportAvailability"]];
            [defaults setValue:pdfUrl forKey:@"PDF"];
            
            [defaults setValue:eventStatus forKey:@"Event Status"];
            [defaults setValue:PingAssistance forKey:@"PingAssistance"];
            [defaults setValue:SlideShow forKey:@"SlideShow"];
            [defaults setValue:[userDetailDict valueForKey:@"EventDocuments"] forKey:@"EventDocuments"];
            [defaults setValue:eventChatSupport forKey:@"Event Chat Support"];
            [defaults setValue:[userDetailDict valueForKey:@"EventName"] forKey:@"EventName"];
            [defaults setValue:[userDetailDict valueForKey:@"ListEventDetails"] forKey:@"ListEventDetails"];
            [defaults setValue:[userDetailDict valueForKey:@"IsfreeEvent"] forKey:@"Is Paid"];
            [defaults setValue:[userDetailDict valueForKey:@"EventCurrencySymbol"] forKey:@"EventCurrencySymbol"];
            [defaults setValue:[userDetailDict valueForKey:@"EventEndDate"] forKey:@"EventEndDate"];
            AppDelegate *appdelegate=[[UIApplication sharedApplication]delegate];
            NSString*currencyStr=[userDetailDict valueForKey:@"EventCurrencySymbol"];
            NSString *substring;
             NSLog(@"%@",currencyStr);
            
            if (![currencyStr isEqualToString:@""]) {
                NSRange range = [currencyStr rangeOfString:@"("];
                substring = [[currencyStr substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                substring = [substring substringToIndex:1];
            }else{
                substring = @"";
            }
            
            
            
            appdelegate.currencySymbol=substring;
           [defaults setValue:substring forKey:@"Currency Value"];
//            if ([userDetailDict valueForKey:@"EventPictureUrl"] !=[NSNull null]) {
//                
//                NSString *eventImageStr = [userDetailDict valueForKey:@"EventPictureUrl"];
//                NSString *eventID = [userDetailDict valueForKey:@"EventName"];
//                
//                [self imageDownloading:eventImageStr :eventID];
//                
//                eventImageStr = [NSString stringWithFormat:@"%@.png",eventID];
//                
//                [defaults setValue:eventImageStr forKey:@"EventImage"];
//                
//            }
//            else{
//                [defaults setValue:@"" forKey:@"EventPictureUrl"];
//            }
            
            [defaults setValue:[userDetailDict valueForKey:@"EventFontColor"] forKey:@"EventFontColor"];
            [defaults setValue:[userDetailDict valueForKey:@"EventFontName"] forKey:@"EventFontName"];
            
            if ([eventChatSupport isEqualToString:@"False"]) {
                [self.sideMenuWithoutReqAssistance setFrame:CGRectMake(-269, 19, self.sideMenuWithoutReqAssistance.frame.size.width, self.sideMenuWithoutReqAssistance.frame.size.height)];
                [self.sideScroller addSubview:self.sideMenuWithoutReqAssistance];
                
            }else{
                [self.sideMenuWithoutReqAssistance removeFromSuperview];
                
            }
            
            if (!isTableCoutFetched) {
            [self fetchCounts];
        }
        }
    }else if (webServiceCode == 3){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        
        //[defaults setValue:[userDetailDict valueForKey:@"ordercount"] forKey:@"Order Count"];
        [defaults setValue:[userDetailDict valueForKey:@"chatcount"] forKey:@"Chat Count"];
        int chatCount = [[defaults valueForKey:@"Chat Count"] intValue];
        if (chatCount != 0) {
            self.assisstanceNotificationBadgeImg.hidden = NO;
            self.assisstanceNotificationBadgeLbl.hidden = NO;
            self.assisstanceNotificationBadgeLbl.text = [NSString stringWithFormat:@"%d",chatCount];
        }else{
            self.assisstanceNotificationBadgeImg.hidden = YES;
            self.assisstanceNotificationBadgeLbl.hidden = YES;
        }
        
        //   [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(repeatWebservice) userInfo:nil repeats:YES];
    }else if (webServiceCode == 4)
    {
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSMutableArray *fetchingImages = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"ListBanner"]];
        
        
        
        for (int i = 0; i < [fetchingImages count]; i++) {
            
            NSString *urlStr = [NSString stringWithFormat:@"%@",[[fetchingImages valueForKey:@"URL"] objectAtIndex:i]];
            NSString *BannerId= [NSString stringWithFormat:@"%@",[[fetchingImages valueForKey:@"BannerId"] objectAtIndex:i]];

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlStr]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            
            NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
            NSString *strEncoded = [Base64 encode:imgdata];
            
            urlStr = [NSString stringWithString:strEncoded];
            
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO banner (bannerId, bannerData) VALUES ( \"%@\", \"%@\")",BannerId,urlStr];
            [database executeUpdate:insert];
            
            [database close];

            
          //  [imagesUrlArray addObject:urlStr];
        }
        //[defaults setObject:imagesUrlArray forKey:@"ImageArray"];
        
        
     
      //  imagesUrlArray = [[NSMutableArray alloc] initWithObjects:[defaults valueForKey:@"ImageArray"], nil];
        
        
       
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString = [NSString stringWithFormat:@"Select * FROM banner"];
        FMResultSet *results = [database executeQuery:queryString];
        
        imagesUrlArray = [[NSMutableArray alloc] init];
        imageNameStringsArray= [[NSMutableArray alloc] init];
        while([results next]) {
            
            NSString *orderItem=[results stringForColumn:@"bannerData"];
            
            [imagesUrlArray addObject:orderItem];
        }
        
        if ([imagesUrlArray count] > 0) {
            imageNameStringsArray =[imagesUrlArray mutableCopy];
        }
        
        [database close];
        

        
        
        [scr removeFromSuperview];
        [pgCtr removeFromSuperview];
        
        scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 51, 1024, 650)];
        scr.tag = 1;
        [scr setUserInteractionEnabled:NO];
        scr.autoresizingMask=UIViewAutoresizingNone;
        [self.sideScroller addSubview:scr];
        [self setupScrollView:scr];
        pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 1024, 50)];
        [pgCtr setTag:12];
        [pgCtr setBackgroundColor:[UIColor clearColor]];
        pgCtr.autoresizingMask=UIViewAutoresizingNone;
        pgCtr.numberOfPages=[imageNameStringsArray count];
        [self.sideScroller addSubview:pgCtr];
        
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        letterTapRecognizer.numberOfTapsRequired = 1;
        [self.view addGestureRecognizer:letterTapRecognizer];
        
        [activityIndicator stopAnimating];

        [self fetchEventDetails];
    }
    
    else{
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        
    }
}
-(void) fetchBannerImages
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (IS_IPAD_Pro) {
        activityIndicator.center = CGPointMake(1366/2, 1028/2);
    }else{
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    
    activityIndicator.color=[UIColor grayColor];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NSString *eventId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:eventId,@"EventId", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetBanners",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"Post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode = 4;
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
-(void)fetchEventDetails
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[defaults valueForKey:@"Event ID"],@"EventId", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchBasicEventDetails",Kwebservices]];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    webServiceCode =1;
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
-(void)chatTable
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tablesAllotedArray = [[NSMutableArray alloc]initWithObjects:[defaults valueForKey:@"Alloted Tables"], nil];
    tableAllotedIdsArray = [[NSMutableArray alloc] init];
    assignedTablesArray = [[NSMutableArray alloc] init];
    for (int i =0 ; i <[self.tablesAllotedArray count] ; i++) {
        tableAllotedObj = [[tableAllotedOC alloc]init];
        NSString *tableIdStr = [NSString stringWithFormat:@"%@",[[self.tablesAllotedArray valueForKey:@"ipadId"] objectAtIndex:i]];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"Table ID %@",tableIdStr);
        tableAllotedObj.tableId = [tableIdStr intValue];
        NSLog(@"Table ID %d",tableAllotedObj.tableId);
        NSString *tableNameStr = [NSString stringWithFormat:@"%@",[[self.tablesAllotedArray valueForKey:@"ipadName"] objectAtIndex:i]];
        
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"Table ID %@",tableIdStr);
        NSLog(@"Table Name %@",tableNameStr);
        tableAllotedObj.tableName = [NSString stringWithFormat:@"%@",tableNameStr];
        [tableAllotedIdsArray addObject:tableAllotedObj];
        [assignedTablesArray addObject:[NSString stringWithFormat:@"%d",tableAllotedObj.tableId]];
    }
    
    }
-(void) fetchCounts{
    NSLog(@"Fetch method called");
    
   
        [self fetchMessageCount];
    
    
    
}
-(void) fetchMessageCount
{
    //    [self disabled];
    //    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    assignedTableTimestampsArray = [[NSMutableArray alloc] init];
   
    NSString *timestamp= [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Customer Incoming Chat Timestamp"]];
    NSLog(@"TimeStamp %@",timestamp);
    if ([timestamp isEqualToString:@"(null)"]) {
        timestamp = [NSString stringWithFormat:@""];
    }
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"\\"withString:@""];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"\""withString:@""];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@")"withString:@""];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"("withString:@""];
    timestamp = [timestamp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *orderTimeStamp = [NSString stringWithFormat:@""];
    NSString *ids = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    NSString *user =[NSString stringWithFormat:@"table"];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:timestamp,@"timestampConversation",user, @"trigger",ids, @"id",orderTimeStamp, @"timestampOrder",@"",@"assignedTableList",@"",@"pingTimeStamp", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchPingOrderCount",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode = 3;
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

-(void)repeatWebservice
{
//    [self fetchCounts];
}
- (IBAction)exitYesAction:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    [appdelegate logout];

}
-(void)addBannerImages{
  
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM banner"];
    FMResultSet *results = [database executeQuery:queryString];
    
    imagesUrlArray = [[NSMutableArray alloc] init];
    imageNameStringsArray = [[NSMutableArray alloc] init];
    imgDesc = [[NSMutableArray alloc] init];
    
    while([results next]) {
        
        NSString *orderItem=[results stringForColumn:@"bannerData"];
         NSString *orderItemDescp=[results stringForColumn:@"bannerDescription"];
        [imagesUrlArray addObject:orderItem];
        [imgDesc addObject:orderItemDescp];
    }
    if ([imagesUrlArray count] > 0) {
        imageNameStringsArray =[imagesUrlArray mutableCopy];
    }
    
    [database close];
    
    [scr removeFromSuperview];
    [pgCtr removeFromSuperview];
    double width = [[UIScreen mainScreen] bounds].size.width;
    if (IS_IPAD_Pro) {
        scr=[[UIScrollView alloc] initWithFrame:CGRectMake(2, 0, width-4, 1005)];
    }else{
    scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 21, 1024, 748)];
    }
    scr.tag = 1;
    [scr setUserInteractionEnabled:NO];
    scr.autoresizingMask=UIViewAutoresizingNone;
    [self.sideScroller addSubview:scr];
    
    [self setupScrollView:scr];
    pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 70, 1024, 50)];
    [pgCtr setTag:12];
    [pgCtr setBackgroundColor:[UIColor clearColor]];
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    pgCtr.numberOfPages=[imageNameStringsArray count];
    [self.sideScroller addSubview:pgCtr];
    
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:letterTapRecognizer];
    
    [activityIndicator stopAnimating];
    [self.sideScroller bringSubviewToFront:topHeaderView];
    [self.sideScroller bringSubviewToFront:self.bottomMenuView];
}
- (IBAction)exitNoAction:(id)sender {
    [self.exitPopUpView removeFromSuperview];
}
-(void)createMenu{
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
        if ([title isEqualToString:@"Slide Show"]) {
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
    if ([sender.titleLabel.text isEqualToString:@"MENU"]){
        menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
        homeVC.isNewOrder = NO;
        [self.navigationController pushViewController:homeVC animated:NO];
    }else if ([sender.titleLabel.text isEqualToString:@"EVENT DETAIL"]){
        appHomeViewController *homeVC = [[appHomeViewController alloc] initWithNibName:@"appHomeViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
    }else if ([sender.titleLabel.text isEqualToString:@"VIEW ORDER"]){
        CheckOutViewController *homeVC = [[CheckOutViewController alloc] initWithNibName:@"CheckOutViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
    }
    
}

- (void)imageDownloading:(NSString *) imageUrl : (NSString *) imageName
{
    ASIHTTPRequest *request;
    
    NSLog(@"%@.png",imageName);
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]]];
    
    [request setDownloadDestinationPath:[[NSHomeDirectory()
                                          stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]]];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        
        
    }];
    
    
    
    [request setDelegate:self];
    [request startAsynchronous];
    
}

@end
