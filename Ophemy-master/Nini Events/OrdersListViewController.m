
#import "OrdersListViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "OrderListTableViewCell.h"
#import "OrderListDetailViewController.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "appHomeViewController.h"
#import "CheckOutViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "menuStateViewController.h"
@interface OrdersListViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bottomMenuImg;
@property (strong, nonatomic) IBOutlet UIView *bottomMenuView;
@property (strong, nonatomic) IBOutlet UIView *ophemyLogoView;
@property (strong, nonatomic) IBOutlet UIButton *slideMenuBtn;
@property (strong, nonatomic) IBOutlet UIButton *pingBtn;
@end

@implementation OrdersListViewController
@synthesize type;


- (void)viewDidLoad {
    
    [self createMenu];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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
    type=@"";
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
    
       NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Chat Support"]];
    
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
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (IS_IPAD_Pro) {
        activityIndicator.center = CGPointMake(1366/2, 1028/2);
    }else{
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    activityIndicator.hidden = YES;
    activityIndicator.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicator];
    if (self.flagValue == 1) {
        headrLbl.text=@"ORDER HISTORY";
        startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        ordrHistryLbl.textColor=[UIColor whiteColor];
        orderHistoryLbl2.textColor=[UIColor whiteColor];
        exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        
        ordrhistryImag.image=[UIImage imageNamed:@"orderhistoryselect.png"];
        orderHistoryImg2.image=[UIImage imageNamed:@"orderhistoryselect.png"];
        [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"open"]];
    }else if (self.flagValue == 2){
        startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        spCornerLbl.textColor=[UIColor whiteColor];
        spCornerlbl2.textColor = [UIColor whiteColor];
        spCornrImag.image=[UIImage imageNamed:@"spcornerselect.png"];
        spCornerImg2.image=[UIImage imageNamed:@"spcornerselect.png"];
        headrLbl.text=@"SP CORNER";
        [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"delivered"]];
    }
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)FetchPendingPlacedOrder:(NSString*)passedOrderType
{
    [activityIndicator startAnimating];
    [self disabled];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *staffId;
    NSString *tableId;
    NSString *OrderType;
    NSString *TriggerValue;
    
    if (staffId == nil) {
        staffId = [NSString stringWithFormat:@""];
    }
    if (tableId == nil) {
        tableId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    }
    if (OrderType == nil) {
        OrderType = [NSString stringWithFormat:@"%@",passedOrderType];
    }
    if (TriggerValue == nil) {
        TriggerValue = [NSString stringWithFormat:@"customer"];
    }
    
    NSString *timeStamp = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"fetchOrderTimeStamp"]];
    //    if ([timeStamp isEqualToString:@"(null)"]) {
    timeStamp = [NSString stringWithFormat:@""];
    //    }
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:staffId,@"StaffId",tableId, @"TableId",OrderType,@"OrderType",TriggerValue, @"Trigger",timeStamp,@"timestamp",[defaults valueForKey:@"Event ID"],@"EventId",nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchOrders",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode = 1;
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
    [activityIndicator stopAnimating];
    [self enable];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Please Check the Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(webServiceCode == 1)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        pendingOrderTimeOfDeliveryArray = [[NSMutableArray alloc] init];
        pendingOrderListArray = [[NSMutableArray alloc] init];
        processingOrderList = [[NSMutableArray alloc] init];
        NSMutableArray *pendingOrdersrderList = [[NSMutableArray alloc]initWithArray:[userDetailDict valueForKey:@"ListPendingOrder"]];
       
        for (int i = 0; i < [pendingOrdersrderList count]; i ++) {
            pendingOrderObj = [[pendingOrdersOC alloc] init];
            pendingOrderObj.DateTimeOfOrder = [[pendingOrdersrderList valueForKey:@"DateTimeOfOrder"] objectAtIndex:i];
            pendingOrderObj.LastUpdate = [[pendingOrdersrderList valueForKey:@"LastUpdate"] objectAtIndex:i];
            pendingOrderObj.OrderId = [[pendingOrdersrderList valueForKey:@"OrderId"]objectAtIndex:i];
            pendingOrderObj.RestaurantId = [[pendingOrdersrderList valueForKey:@"RestaurantId"] objectAtIndex:i];
            pendingOrderObj.Status = [[pendingOrdersrderList valueForKey:@"Status"]objectAtIndex:i];
            pendingOrderObj.TableId = [[pendingOrdersrderList valueForKey:@"TableId"] objectAtIndex:i];
            pendingOrderObj.TimeOfDelivery = [[pendingOrdersrderList valueForKey:@"DateTimeOfOrder"]objectAtIndex:i];
            pendingOrderObj.TotalBill = [[pendingOrdersrderList valueForKey:@"TotalBill"]objectAtIndex:i];
            pendingOrderObj.pendingOrderDetails = [[pendingOrdersrderList valueForKey:@"ListOrderDetails"] objectAtIndex:i];
            pendingOrderObj.note = [[pendingOrdersrderList valueForKey:@"Notes"] objectAtIndex:i];
            pendingOrderObj.lastUpdatedTime = [[pendingOrdersrderList valueForKey:@"LastUpdate"]objectAtIndex:i];
            [pendingOrderListArray addObject:pendingOrderObj];
            [pendingOrderTimeOfDeliveryArray addObject:pendingOrderObj.TimeOfDelivery];
            if([pendingOrderObj.Status isEqualToString:@"processing"])
            {
                [processingOrderList addObject:pendingOrderObj];
            }
        }
        pendingOrderListArray=[[[pendingOrderListArray reverseObjectEnumerator] allObjects] mutableCopy];
        NSLog(@"pending Order List %@",pendingOrderObj.pendingOrderDetails);
        [self.pendingOrdersTableView reloadData];
        
        

        if (pendingOrderListArray.count == 0) {
            lblno1.text = @"NO ORDERS!";
            lblno2.text = @"NO ORDERS TO DISPLAY YET.";
            viewNoOrders.hidden = NO;
        }else{
            viewNoOrders.hidden = YES;
        }
        
        if (self.flagValue == 2){
            if (processingOrderList.count == 0) {
                lblno1.text = @"NO ORDERS!";
                lblno2.text = @"NO ORDERS TO DISPLAY YET.";
                viewNoOrders.hidden = NO;
            }else{
                viewNoOrders.hidden = YES;
            }
        }

       
    }else if (webServiceCode == 0) {
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        
    }[activityIndicator stopAnimating];
    [self enable];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.flagValue == 1){
        return [pendingOrderListArray count];
    }else if (self.flagValue == 2){
        return [processingOrderList count];
    }return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    OrderListTableViewCell *cell = (OrderListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (self.flagValue == 1)
    {
        pendingOrderObj = [pendingOrderListArray objectAtIndex:indexPath.row];
    }else if (self.flagValue == 2){
        pendingOrderObj = [processingOrderList objectAtIndex:indexPath.row];
    }
    
    NSDate *startTime;
    NSString *timeZone = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"DaylightName"]];
    NSString *timeZoneOffset = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"BaseUTcOffset"]];
    NSArray *timeZoneOffsetStr = [timeZoneOffset componentsSeparatedByString:@":"];
    
    startTime = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *curruntTime = [ dateFormat stringFromDate:startTime];
    NSDate *convertedTime = [dateFormat dateFromString:curruntTime];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    [offset setHour:[[timeZoneOffsetStr objectAtIndex:0] integerValue]];
    [offset setMinute:[[timeZoneOffsetStr objectAtIndex:1] integerValue]];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:offset toDate:convertedTime options:0];
    
    NSString *time = [NSString stringWithFormat:@"%@",pendingOrderObj.lastUpdatedTime];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormat1 setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormat1 dateFromString:time];
    NSString *dateStr = [dateFormat1 stringFromDate:date];
    NSDate *date1=[dateFormat1 dateFromString:dateStr];
    NSDateComponents *offset1 = [[NSDateComponents alloc] init];
    [offset1 setHour:0];
    [offset1 setMinute:0];
    NSDate *newOrderDate = [[NSCalendar currentCalendar] dateByAddingComponents:offset1 toDate:date1 options:0];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate: newOrderDate toDate: newDate options: 0];
    NSInteger hours, minutes, seconds, days;
    
    days = [components day];
    hours = [components hour];
    minutes = [components minute];
    seconds = [components second];
    
    NSString *timeStr;
    if (days > 0) {
        timeStr =[NSString stringWithFormat:@"%ld DAYS AGO",(long)days];
    }else if (hours > 0){
        timeStr =[NSString stringWithFormat:@"%ld HOUR AGO",(long)hours];
    }else{
        timeStr =[NSString stringWithFormat:@"%ld MINS AGO",(long)minutes];
    }
    
    NSString *statusStr = [NSString stringWithFormat:@"%@",pendingOrderObj.Status];
    statusStr = [statusStr uppercaseString];
    NSLog(@"Order Status %@",pendingOrderObj.OrderId);
    
    NSString *orderNumberStr = [NSString stringWithFormat:@"%@",pendingOrderObj.OrderId];
    orderNumberStr = [orderNumberStr uppercaseString];
    itemNamesArray = [[NSMutableArray alloc]init];
    
    NSString *itemNameStr = [[pendingOrderObj.pendingOrderDetails valueForKey:@"itemname"] componentsJoinedByString:@" , "];
    
    [cell setLabelText:[NSString stringWithString:statusStr] :[NSString stringWithString:timeStr] :[NSString stringWithFormat: @"ORDER NUMBER : %@",orderNumberStr]: [itemNameStr uppercaseString]];
    
    UIButton *showDetailoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showDetailoBtn setTitle: @"VIEW DETAILS" forState: UIControlStateNormal];
    if (IS_IPAD_Pro) {
        showDetailoBtn.frame = CGRectMake(1180.0f, 60.0f, 144.0f,35.0f);
    }else{
        showDetailoBtn.frame = CGRectMake(845.0f, 60.0f, 144.0f,35.0f);
    }
    showDetailoBtn.tag = indexPath.row;
    showDetailoBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    
    [showDetailoBtn setTintColor:[UIColor whiteColor]] ;
    [cell.contentView addSubview:showDetailoBtn];
    
    [showDetailoBtn addTarget:self action:@selector(showDetailoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"checkoutselect"];
    
    [showDetailoBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    
    [cell.contentView addSubview:showDetailoBtn];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    int section = indexPath.section;
    // [self.menuTableView reloadData];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %@", newIndexPath);
    
}

- (IBAction)showDetailoBtnAction:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    pendingOrdersOC *ordr;
    if(self.flagValue == 1){
        ordr = (pendingOrdersOC *)[pendingOrderListArray objectAtIndex:indexPath.row];
    }else if (self.flagValue == 2){
        ordr = (pendingOrdersOC *)[processingOrderList objectAtIndex:indexPath.row];
    }
    OrderListDetailViewController*ordrVc=[[OrderListDetailViewController alloc]initWithNibName:@"OrderListDetailViewController" bundle:nil];
    ordrVc.pendingOrderObj=ordr;
    ordrVc.type=[NSString stringWithString:type];
    ordrVc.flag = self.flagValue;
    [self.navigationController pushViewController:ordrVc animated:YES];
}



- (IBAction)backBtn:(id)sender {
}

- (IBAction)menuBtn:(id)sender {
    
    [self showSlider];
}

- (IBAction)startAnewOrdeActionBtn:(id)sender
{
    startNewOrdrLbl.textColor=[UIColor whiteColor];
    ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    
    strtNewOrdrImag.image=[UIImage imageNamed:@""];
    ordrhistryImag.image=[UIImage imageNamed:@"orderhistory.png"];
    requstAssistImag.image=[UIImage imageNamed:@"requestassistance.png"];
    spCornrImag.image=[UIImage imageNamed:@""];
    exitImag.image=[UIImage imageNamed:@"exit.png"];
    [self showSlider];
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = YES;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)orderHistoryActionBtn:(id)sender {
    type=@"";
    [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"open"]];
    
    startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    ordrHistryLbl.textColor=[UIColor whiteColor];
    exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    
    strtNewOrdrImag.image=[UIImage imageNamed:@"startneworderselect.png"];
    ordrhistryImag.image=[UIImage imageNamed:@"orderhistoryselect.png"];
    requstAssistImag.image=[UIImage imageNamed:@"requestassistance.png"];
    spCornrImag.image=[UIImage imageNamed:@"sporder.png"];
    exitImag.image=[UIImage imageNamed:@"exit.png"];
    [self showSlider];
    OrdersListViewController *orderVC = [[OrdersListViewController alloc] initWithNibName:@"OrdersListViewController" bundle:nil];
    orderVC.flagValue = 1;
    [self.navigationController pushViewController:orderVC animated:NO];
}

- (IBAction)requestAssistntActionBtn:(id)sender {
    startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    requestAssistntLbl.textColor=[UIColor whiteColor];
    spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    
    strtNewOrdrImag.image=[UIImage imageNamed:@"startneworder.png"];
    ordrhistryImag.image=[UIImage imageNamed:@"orderhistory.png"];
    requstAssistImag.image=[UIImage imageNamed:@"requestassistanceselect.png"];
    spCornrImag.image=[UIImage imageNamed:@"sporder.png"];
    exitImag.image=[UIImage imageNamed:@"exit.png"];
    [self showSlider];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Chat Count"] ;
    self.assisstanceNotificationBadgeImg.hidden = YES;
    self.assisstanceNotificationBadgeLbl.hidden = YES;
    requestAssistanceViewController *requestVC = [[requestAssistanceViewController alloc] initWithNibName:@"requestAssistanceViewController" bundle:nil];
    [self.navigationController pushViewController:requestVC animated:NO];
}

- (IBAction)spCornerActionBtn:(id)sender {
    
    
    [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"open"]];
    
    startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    spCornerLbl.textColor=[UIColor whiteColor];
    
    strtNewOrdrImag.image=[UIImage imageNamed:@"startneworder.png"];
    ordrhistryImag.image=[UIImage imageNamed:@"orderhistory.png"];
    requstAssistImag.image=[UIImage imageNamed:@"requestassistance.png"];
    spCornrImag.image=[UIImage imageNamed:@"sporderselect.png"];
    exitImag.image=[UIImage imageNamed:@"exit.png"];
    [self showSlider];
    OrdersListViewController *orderVC = [[OrdersListViewController alloc] initWithNibName:@"OrdersListViewController" bundle:nil];
    orderVC.flagValue = 2;
    [self.navigationController pushViewController:orderVC animated:NO];
}

- (IBAction)ExitBtn:(id)sender {

    [self showSlider];
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

- (IBAction)apphomeAction:(id)sender {
    appHomeViewController *homeVC = [[appHomeViewController alloc] initWithNibName:@"appHomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)menuAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    //homeVC.isNewOrder = NO;
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
    [self.navigationController pushViewController:homeVC animated:NO];}
-(void) showSlider
{
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
- (void) disabled
{
    activityIndicator.hidden = NO;
    self.view.userInteractionEnabled = NO;
    disabledImgView.hidden = NO;
}
- (void) enable
{
    activityIndicator.hidden = YES;
    self.view.userInteractionEnabled = YES;
    disabledImgView.hidden = YES;
}
@end
