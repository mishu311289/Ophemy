
#import "requestAssistanceViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "appHomeViewController.h"
#import "CheckOutViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "menuStateViewController.h"
#import "Base64.h"

@interface requestAssistanceViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bottomMenuImg;
@property (strong, nonatomic) IBOutlet UIView *bottomMenuView;
@property (strong, nonatomic) IBOutlet UIView *ophemyLogoView;
@property (strong, nonatomic) IBOutlet UIButton *slideMenuBtn;
@property (strong, nonatomic) IBOutlet UIButton *pingBtn;
@end

@implementation requestAssistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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
    

    
    
     [self fetchChatFromDB];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
    }
    else{
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

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
    
    NSString *eventStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Status"]];
    NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Chat Support"]];
    NSString *PingAssistance = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"PingAssistance"]];
    
    NSString *SlideShow = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"SlideShow"]];
    

    
    if ([eventChatSupport isEqualToString:@"False"]) {
        [self.sideMenuWithoutReqAssistance setFrame:CGRectMake(-269, 19, self.sideMenuWithoutReqAssistance.frame.size.width, self.sideMenuWithoutReqAssistance.frame.size.height)];
        [self.sideScroller addSubview:self.sideMenuWithoutReqAssistance];
        
    }else{
        [self.sideMenuWithoutReqAssistance removeFromSuperview];
        
    }
//    if ([eventStatus isEqualToString:@"0"]) {
//        [self.footerWithoutEventsDetail setFrame:CGRectMake(0, 704, self.footerWithoutEventsDetail.frame.size.width, self.footerWithoutEventsDetail.frame.size.height)];
//        [self.sideScroller addSubview:self.footerWithoutEventsDetail];
//    }else{
//        [self.footerWithoutEventsDetail removeFromSuperview];
//    }
    if ([eventStatus isEqualToString:@"0"] || [PingAssistance isEqualToString:@"0"] || [SlideShow isEqualToString:@"0"]) {
        
        if( [eventStatus isEqualToString:@"0"])
        {
            
            CGRect frame1 = vieweventdetailfooter.frame;
            frame1.size.width=0;
            vieweventdetailfooter.frame = frame1;
            
            [btneventdetailfooter setTitle:@"" forState:UIControlStateNormal];
        }
        
        if( [PingAssistance isEqualToString:@"0"])
        {
            CGRect frame2 = viewpingfooter.frame;
            frame2.size.width=0;
            viewpingfooter.frame = frame2;
            self.pingBulbImg.hidden = YES;
        }
        
        if([SlideShow isEqualToString:@"0"])
        {
            
            CGRect frame = viewslideshowfooter.frame;
            frame.size.width=0;
            viewslideshowfooter.frame = frame;
                       
            [btnslideshowfooter setTitle:@"" forState:UIControlStateNormal];
            
        }
        
        
        //                [self.footerWithoutEventsDetail setFrame:CGRectMake(0, 704, self.footerWithoutEventsDetail.frame.size.width, self.footerWithoutEventsDetail.frame.size.height)];
        //                [self.sideScroller addSubview:self.footerWithoutEventsDetail];
    }else{
        CGRect frame = viewslideshowfooter.frame;
        
        frame.size.width=180;
        viewslideshowfooter.frame = frame;
        
        frame = viewpingfooter.frame;
        frame.size.width=180;
        viewpingfooter.frame = frame;
        
        frame = vieweventdetailfooter.frame;
        frame.size.width=180;
        vieweventdetailfooter.frame = frame;
        
       
        [btnslideshowfooter setTitle:@"SLIDE SHOW" forState:UIControlStateNormal];
        
        [btneventdetailfooter setTitle:@"EVENT DETAILS" forState:UIControlStateNormal];
        self.pingBulbImg.hidden = NO;
        
    }
    self.messageBgLbl.layer.borderColor = [UIColor grayColor].CGColor;
    self.messageBgLbl.layer.borderWidth = 1.5;
    
    
    self.sendBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.sendBtn.layer.borderWidth = 1.5;
    [self fetchHelpMessage];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [fetchMsgTimer invalidate];
    
    [super viewWillDisappear:animated];
}

-(void)fetchMessageTimer
{
    [self fetchHelpMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Pending PLaced Order Web Services

-(void) fetchHelpMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [fetchMsgTimer invalidate];
    
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
    NSString *ids = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    NSString *user = [NSString stringWithFormat:@"table"];
    NSString *assignedTableList= [NSString stringWithFormat:@""];;
    NSString *timeStampList= [NSString stringWithFormat:@""];;
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:timestamp,@"timestamp",ids, @"id",user, @"user",assignedTableList, @"assignedtablelist",timeStampList, @"timestamplist",@"chat",@"trigger", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchHelpMessages",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    webServiceCode =1;
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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

#pragma mark - Send Help Message
-(void) sendHelpMessage
{
    disableView.hidden=NO;
    
    objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    objactivityindicator.center = CGPointMake((disableView.frame.size.width/2),(disableView.frame.size.height/2));
    [disableView addSubview:objactivityindicator];
    [objactivityindicator startAnimating];
    [self.sendBtn setUserInteractionEnabled:NO];
    
    
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
    NSString *chatMessage = [NSString stringWithFormat:@"%@",self.chatMessageTxtView.text];;
    
    if ([chatMessage isEqualToString:@""]) {
        chatTrigger = [NSString stringWithFormat:@"ping"];
        chatMessage = [NSString stringWithFormat:@"%@ is requesting Assistance.",tableName];
    }else{
        chatTrigger = [NSString stringWithFormat:@"chat"];
        chatMessage = [NSString stringWithFormat:@"%@",self.chatMessageTxtView.text];
    }
    
    NSString *sender = [NSString stringWithFormat:@"table"];
     NSString*Sendername= [[NSUserDefaults standardUserDefaults] valueForKey:@"Table Name"];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tableID,@"tableId",serviceProviderId,@"serviceproviderId",chatMessage,@"message",sender, @"sender",[NSString stringWithFormat:@"1"],@"restaurantId",chatTrigger,@"trigger",Sendername,@"sendername", nil];
    
    NSLog(@"jsonRequest is %@", jsonDict);
    
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

#pragma mark -Json Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [objactivityindicator stopAnimating];
    disableView.hidden=YES;
    [self.sendBtn setUserInteractionEnabled:YES];
    
    
    NSLog(@"ERROR with the Connection ");
    webData =nil;
    [self.view setUserInteractionEnabled:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (webServiceCode == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *newtimestamp;
        
        if ([userDetailDict valueForKey:@"MaxTimestammpList"] !=[NSNull null]) {
              NSMutableArray *timestampArray = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"MaxTimestammpList"]];
              newtimestamp = [NSString stringWithFormat:@"%@",[timestampArray valueForKey:@"Maxtimestamp"]];
        }
        
      
      
//        newtimestamp = [newtimestamp stringByReplacingOccurrencesOfString:@" "withString:@""];
//        newtimestamp = [newtimestamp stringByReplacingOccurrencesOfString:@"\n"withString:@""];
//        newtimestamp = [newtimestamp stringByReplacingOccurrencesOfString:@"("withString:@""];
//        newtimestamp = [newtimestamp stringByReplacingOccurrencesOfString:@")"withString:@""];
        NSMutableArray *fetchingChat;
         if ([userDetailDict valueForKey:@"MessageList"] !=[NSNull null]) {
             fetchingChat = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"MessageList"]];
         }

        if ([fetchingChat count] != 0)
        {
            NSLog(@"MAXIMUM TIME STAMP .... %@",newtimestamp);
            [defaults setObject:newtimestamp forKey:@"Customer Incoming Chat Timestamp"];
            
            NSMutableArray *fetchMessages = [NSMutableArray arrayWithArray:[[fetchingChat valueForKey:@"listMessage"]objectAtIndex:0]];
            
            
            for (int i = 0; i < [fetchMessages count]; i++)
            {
                docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                documentsDir = [docPaths objectAtIndex:0];
                dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
                database = [FMDatabase databaseWithPath:dbPath];
                [database open];
                NSString *senderImageStr = [[fetchMessages valueForKey:@"image"]objectAtIndex:i];

                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", senderImageStr]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [UIImage imageWithData:data];
                
                NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
                NSString *strEncoded = [Base64 encode:imgdata];
                
                senderImageStr = [NSString stringWithString:strEncoded];
                
                
                NSString *compairStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CompareDate"]];
                NSString *dateStr = [NSString stringWithFormat:@"%@",[[fetchMessages valueForKey:@"time"]objectAtIndex:i]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSDate *dateFromStr = [formatter dateFromString:dateStr];
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                [formatter1 setDateFormat:@"dd-MM-yyyy"];
                dateStr = [formatter1 stringFromDate:dateFromStr];
                NSString *dateChangedString;
                if (![dateStr isEqualToString:compairStr]) {
                    dateChangedString =[NSString stringWithFormat:@"YES"];
                }else{
                    dateChangedString =[NSString stringWithFormat:@"NO"];
                }
                
                [[NSUserDefaults standardUserDefaults] setValue:dateStr forKey:@"CompareDate"];
                NSString *insert = [NSString stringWithFormat:@"INSERT INTO tableChat (tableid, serviceProviderId, message, time,sender,isDateChanged,senderName,senderImage) VALUES (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\")",[[fetchMessages valueForKey:@"tableid"] objectAtIndex:i],[[fetchMessages valueForKey:@"serviceproviderid"]objectAtIndex:i],[[fetchMessages valueForKey:@"message"]objectAtIndex:i],[[fetchMessages valueForKey:@"time"]objectAtIndex:i],[[fetchMessages valueForKey:@"sender"]objectAtIndex:i],dateChangedString,[[fetchMessages valueForKey:@"sendername"]objectAtIndex:i],senderImageStr];
                [database executeUpdate:insert];
            }
            
             [self fetchChatFromDB];
        }
       fetchMsgTimer=[NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(fetchMessageTimer) userInfo:nil repeats:NO];
        
    }
    else if(webServiceCode == 0){
        
        [objactivityindicator stopAnimating];
        [self.sendBtn setUserInteractionEnabled:YES];
        disableView.hidden=YES;

        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        self.chatMessageTxtView.text=@"";
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        if ([chatTrigger isEqualToString:@"ping"]) {
            NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
            
            
        }
        [self.view setUserInteractionEnabled:YES];
        [self fetchHelpMessage];
    }
    
}
-(void)goToBottom
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    
    [self.chatTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.chatTableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.chatTableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}


- (IBAction)sendMessage:(id)sender {
    NSString*messageStr=[self.chatMessageTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (messageStr.length>0)
        
    {
        [self.view setUserInteractionEnabled:NO];
        [self sendHelpMessage];
    }
    
    
    [self.chatMessageTxtView resignFirstResponder];
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [allChatMessages count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    NSLog(@"All Mesages %@",allChatMessages);
    return [allChatMessages objectAtIndex:row];
}

#pragma mark - TextView Delegates implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect rc1 = [self.sideScroller bounds];
    rc1 = [self.sideScroller convertRect:rc1 toView:self.sideScroller];
    CGPoint pt1 = rc1.origin;
    if (pt1.x != 0) {
        [self sideMenuAction:nil];
    }
    svos = self.chatScroller.contentOffset;
     [fetchMsgTimer invalidate];
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:self.chatScroller];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 200;
    [self.chatScroller setContentOffset:pt animated:YES];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.chatScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.chatScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)menuBtn:(id)sender {
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
- (IBAction)newOrderAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = YES;
    [fetchMsgTimer invalidate];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)orderHistoryAction:(id)sender {
    OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
    ordrVc.flagValue = 1;
    [fetchMsgTimer invalidate];

    [self.navigationController pushViewController:ordrVc animated:YES];
}

- (IBAction)spcornerAction:(id)sender {
    OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
    ordrVc.flagValue = 2;
    [fetchMsgTimer invalidate];

    [self.navigationController pushViewController:ordrVc animated:YES];
}
- (IBAction)requestAssistanceAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Chat Count"] ;
    self.assisstanceNotificationBadgeImg.hidden = YES;
    self.assisstanceNotificationBadgeLbl.hidden = YES;
    [fetchMsgTimer invalidate];

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
    [fetchMsgTimer invalidate];

    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)sideMenuAction:(id)sender {
    [fetchMsgTimer invalidate];
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
    [fetchMsgTimer invalidate];

    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)checkOutView:(id)sender {
    CheckOutViewController*checkoutVc=[[CheckOutViewController alloc]initWithNibName:@"CheckOutViewController" bundle:nil];
    [fetchMsgTimer invalidate];

    [self.navigationController pushViewController:checkoutVc animated:NO];
}

- (IBAction)ophemyAction:(id)sender {
    
}
- (IBAction)Slideshow:(id)sender
{
    eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
    [fetchMsgTimer invalidate];
    
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
        [fetchMsgTimer invalidate];

        [self.navigationController pushViewController:loginVC animated:YES];
    }
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
-(void) FadeView
{
    [UIView animateWithDuration:0.9
                     animations:^{self.pingMessageView.alpha = 0.0;}
                     completion:^(BOOL finished){self.pingMessageView.hidden = YES;}];
}
-(void) fetchChatFromDB{
    fetchedChatData = [[NSMutableArray alloc]init];
    NSMutableArray *chatMessages = [[NSMutableArray alloc]init];
    NSMutableArray *chatTime = [[NSMutableArray alloc]init];
    NSMutableArray *chatSender = [[NSMutableArray alloc]init];
    NSMutableArray *chatdateChanged = [[NSMutableArray alloc]init];
    NSMutableArray *sendername = [[NSMutableArray alloc]init];
    NSMutableArray *senderImagesArray = [[NSMutableArray alloc]init];

    
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
       NSString *tableID = [NSString stringWithFormat:@"'%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"Table ID"]];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM tableChat where tableId = %@",tableID];
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        fetchChatObj = [[fetchChatOC alloc]init];
        
        fetchChatObj.chatMessage = [results stringForColumn:@"message"];
        fetchChatObj.chatTime = [results stringForColumn:@"time"];
        fetchChatObj.chatSender =[results stringForColumn:@"sender"];
        fetchChatObj.senderName =[results stringForColumn:@"senderName"];
        fetchChatObj.TableId = [results stringForColumn:@"tableid"];
        fetchChatObj.isDateChanged = [results stringForColumn:@"isDateChanged"];
        fetchChatObj.senderIamge =[results stringForColumn:@"senderImage"];

        [chatMessages addObject:fetchChatObj.chatMessage];
        [chatTime addObject:fetchChatObj.chatTime];
        [chatSender addObject:fetchChatObj.chatSender];
        [chatdateChanged addObject:fetchChatObj.isDateChanged];
        [sendername addObject:fetchChatObj.senderName];
        [senderImagesArray addObject:fetchChatObj.senderIamge];
        [fetchedChatData addObject:fetchChatObj];
    }
    
    allChatMessages = [[NSMutableArray alloc]init];
    chatArray=[[NSMutableArray alloc]init];
    chatDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:chatMessages,@"messages",chatTime,@"time",chatSender,@"sender",chatdateChanged,@"isDateChanged",sendername ,@"sendername",senderImagesArray,@"senderImages", nil];
    
    if(chatMessages.count == 0){
        viewNOChat.hidden = NO;
    }else{
        viewNOChat.hidden = YES;
    }
    
    NSLog(@"CHAT OBJECT ... %@",chatDictionary);
    for (int i = 0; i < [chatMessages count]; i++) {
        chatObj = [[chatOC alloc]init];
        chatObj.chatMessage = [[chatDictionary valueForKey:@"messages"] objectAtIndex:i];
        chatObj.chatTime = [[chatDictionary valueForKey:@"time"] objectAtIndex:i];
        chatObj.chatSender = [[chatDictionary valueForKey:@"sender"] objectAtIndex:i];
        chatObj.isDateChanged = [[chatDictionary valueForKey:@"isDateChanged"] objectAtIndex:i];
        chatObj.senderName = [[chatDictionary valueForKey:@"sendername"] objectAtIndex:i];
        chatObj.senderImage=[[chatDictionary valueForKey:@"senderImages"] objectAtIndex:i];
        
        [chatArray addObject:chatObj];
        NSLog(@"CHAT OBJECT ... %@",chatObj.chatSender);
        NSBubbleData *Bubble;
        NSString *senderChat =[NSString stringWithFormat:@"%@",chatObj.chatSender];
        senderChat = [senderChat stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
        senderChat = [senderChat stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        senderChat = [senderChat stringByReplacingOccurrencesOfString:@")" withString:@""];
        senderChat = [senderChat stringByReplacingOccurrencesOfString:@" " withString:@""];
    
        if([senderChat isEqualToString:@"table"]){
            senderChat = @"Me";
        }
        else if ([senderChat isEqualToString:@"coordinator"]||[senderChat isEqualToString:@"serviceprovider"] )
        {
            senderChat=chatObj.senderName;
        }
        
        
        NSString *chatMessage =[NSString stringWithFormat:@"%@",chatObj.chatMessage];
        chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
        chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"\n" withString:@""];
       // chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
        chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        chatMessage = [NSString stringWithFormat:@"%@: %@",senderChat,chatMessage];
        NSLog(@"CHAT Message to show ... %@",chatMessage);
        NSString *dateChanged =[NSString stringWithFormat:@"%@",chatObj.isDateChanged];
        dateChanged = [dateChanged stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
        dateChanged = [dateChanged stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        dateChanged = [dateChanged stringByReplacingOccurrencesOfString:@")" withString:@""];
        dateChanged = [dateChanged stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        NSString *chatTime =[NSString stringWithFormat:@"%@",chatObj.chatTime];
        chatTime = [chatTime stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
        chatTime = [chatTime stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        chatTime = [chatTime stringByReplacingOccurrencesOfString:@")" withString:@""];
        chatTime = [chatTime stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *dateFromString = [[NSDate alloc] init];
       
        dateFromString = [dateFormatter dateFromString:chatTime];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *datestr = [dateFormatter1 stringFromDate:dateFromString];
        NSDate *messageDate = [dateFormatter1 dateFromString:datestr];
        
        if([senderChat isEqualToString:@"Me"]){
            Bubble = [NSBubbleData dataWithText:chatMessage date:messageDate type:BubbleTypeMine isDateChanged:dateChanged isCorner:@"Table"];

            Bubble.avatar = [UIImage imageNamed:@"avatar1.png"];
        }else{
            Bubble = [NSBubbleData dataWithText:chatMessage date:messageDate type:BubbleTypeSomeoneElse isDateChanged:dateChanged isCorner:@"Table"];
            if (chatObj.senderImage.length==0) {
                Bubble.avatar=[UIImage imageNamed:@"dummy_user.png"];
            }
            else{
                NSData* data = [[NSData alloc] initWithBase64EncodedString:chatObj.senderImage options:0];
                // UIImage* img1 = [UIImage imageWithData:data];
                Bubble.avatar = [UIImage imageWithData:data];
            }
        }
        
        [allChatMessages addObject:Bubble];
    }
    
    self.chatTableView.bubbleDataSource = self;
    self.chatTableView.snapInterval = 120;
    self.chatTableView.showAvatars = YES;
    self.chatTableView.typingBubble = NSBubbleTypingTypeSomebody;
    
    [self.chatTableView reloadData];
    
    
    
    self.chatTableView.bubbleDataSource = self;
    
    self.chatTableView.snapInterval = 120;
    
    [self performSelector:@selector(goToBottom) withObject:nil afterDelay:0.001];
    self.chatTableView.typingBubble = NSBubbleTypingTypeSomebody;
    NSLog(@"CHAT Array %@",chatObj);
    self.chatMessageTxtView.text = @"";
    [self.chatTableView reloadData];
}
- (IBAction)exitYesAction:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    [appdelegate logout];
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
    }else if([sender.titleLabel.text isEqualToString:@"MENU"]){
        menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
        homeVC.isNewOrder = NO;
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
