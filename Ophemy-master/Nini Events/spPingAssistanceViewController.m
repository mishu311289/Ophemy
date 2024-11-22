
#import "spPingAssistanceViewController.h"
#import "pingsAssistanceTableViewCell.h"
#import "JSON.h"
#import "SBJson.h"
#import "loginViewController.h"
#import "spRequestAssistanceViewController.h"
#import "serviceProviderHomeViewController.h"
@interface spPingAssistanceViewController ()

@end

@implementation spPingAssistanceViewController

- (void)viewDidLoad {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int updatedChatCount = [[[NSUserDefaults standardUserDefaults ]valueForKey:@"UpdatedChat Count"]intValue];
    if (updatedChatCount != 0) {
        self.chatNotificationBadgeImg.hidden = NO;
        self.chatNotificationBageLbl.hidden = NO;
        self.chatNotificationBageLbl.text = [NSString stringWithFormat:@"%d",updatedChatCount];
    }else{
        self.chatNotificationBadgeImg.hidden = YES;
        self.chatNotificationBageLbl.hidden = YES;
    }
    
    int pingCount =[[[NSUserDefaults standardUserDefaults ]valueForKey:@"Ping Count"]intValue];
    if (pingCount != 0) {
        self.pingNotificationBadgeImg.hidden = NO;
        self.pingNotificationBadgeLbl.hidden = NO;
        self.pingNotificationBadgeLbl.text = [NSString stringWithFormat:@"%d",pingCount];
    }else{
        self.pingNotificationBadgeImg.hidden = YES;
        self.pingNotificationBadgeLbl.hidden = YES;
    }
    int orderCount =[[[NSUserDefaults standardUserDefaults ]valueForKey:@"Order Count"]intValue];
    if (orderCount != 0) {
        self.orderNotificationBadgeImg.hidden = NO;
        self.orderNotificationBadgeLbl.hidden = NO;
        self.orderNotificationBadgeLbl.text = [NSString stringWithFormat:@"%d",orderCount];
    }else{
        self.orderNotificationBadgeImg.hidden = YES;
        self.orderNotificationBadgeLbl.hidden = YES;
    }

    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (IS_IPAD_Pro) {
        activityIndicator.center = CGPointMake(1366/2, 1028/2);
    }else{
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    activityIndicator.hidden = YES;
    activityIndicator.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicator];
    
    [super viewDidLoad];
    [self chatTable];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Chat Support"]];
    NSString *PingAssistance = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"PingAssistance"]];

    
    if ([eventChatSupport isEqualToString:@"False"]) {
        requestAssistance.hidden = YES;
        float viewHeight = self.view.frame.size.height;
        
        orders.frame = CGRectMake(orders.frame.origin.x, 0, orders.frame.size.width, viewHeight/3-2);
        pingAssistance.frame = CGRectMake(pingAssistance.frame.origin.x,viewHeight/3, pingAssistance.frame.size.width, viewHeight/3-2);
        exit.frame = CGRectMake(exit.frame.origin.x, pingAssistance.frame.origin.y+pingAssistance.frame.size.height+2, exit.frame.size.width,viewHeight/3);
        
        lblliveAssistance.hidden = YES;
        imageliveAssistance.hidden = YES;
        
        self.chatNotificationBadgeImg.hidden = YES;
        self.chatNotificationBageLbl.hidden = YES;
        
        [pingAssistance addSubview:viewliveAssistance];
        [viewliveAssistance setFrame:CGRectMake(25,pingAssistance.frame.size.height/2-viewliveAssistance.frame.size.height/2,viewliveAssistance.frame.size.width,viewliveAssistance.frame.size.height)];
    
        [exit addSubview:viewexit];
        [viewexit setFrame:CGRectMake(25,exit.frame.size.height/2-viewexit.frame.size.height/2,viewexit.frame.size.width,viewexit.frame.size.height)];
        [orders addSubview:vieworders];
        [vieworders setFrame:CGRectMake(25,orders.frame.size.height/2-vieworders.frame.size.height/2,vieworders.frame.size.width,vieworders.frame.size.height)];
    
    }
    if ([PingAssistance isEqualToString:@"0"]) {
        float viewHeight = self.view.frame.size.height;
        
        orders.frame = CGRectMake(orders.frame.origin.x, 0, orders.frame.size.width, viewHeight/3-2);
        requestAssistance.frame = CGRectMake(requestAssistance.frame.origin.x,viewHeight/3, requestAssistance.frame.size.width, viewHeight/3-2);
        exit.frame = CGRectMake(exit.frame.origin.x, requestAssistance.frame.origin.y+requestAssistance.frame.size.height+2, exit.frame.size.width,viewHeight/3);
        
        pingAssistance.hidden = YES;
        viewliveAssistance.hidden = YES;
        
        self.pingNotificationBadgeImg.hidden = YES;
        self.pingNotificationBadgeLbl.hidden = YES;
        
        [requestAssistance addSubview:viewRequestAssistance];
        [viewRequestAssistance setFrame:CGRectMake(25,requestAssistance.frame.size.height/2-viewRequestAssistance.frame.size.height/2,viewRequestAssistance.frame.size.width,viewRequestAssistance.frame.size.height)];
        
        [exit addSubview:viewexit];
        [viewexit setFrame:CGRectMake(25,exit.frame.size.height/2-viewexit.frame.size.height/2,viewexit.frame.size.width,viewexit.frame.size.height)];
        
        [orders addSubview:vieworders];
        [vieworders setFrame:CGRectMake(25,orders.frame.size.height/2-vieworders.frame.size.height/2,vieworders.frame.size.width,vieworders.frame.size.height)];
    }
    if ([eventChatSupport isEqualToString:@"False"] && [PingAssistance isEqualToString:@"0"]){
        pingAssistance.hidden = YES;
        viewliveAssistance.hidden = YES;
        
        requestAssistance.hidden = YES;
        lblliveAssistance.hidden = YES;
        imageliveAssistance.hidden = YES;
        
        float viewHeight = self.view.frame.size.height;
        
        orders.frame = CGRectMake(orders.frame.origin.x, 0, orders.frame.size.width, viewHeight/2-2);
        exit.frame = CGRectMake(exit.frame.origin.x, orders.frame.origin.y+orders.frame.size.height+2, exit.frame.size.width,viewHeight/2);
        
        [exit addSubview:viewexit];
        [viewexit setFrame:CGRectMake(25,exit.frame.size.height/2-viewexit.frame.size.height/2,viewexit.frame.size.width,viewexit.frame.size.height)];
        
        [orders addSubview:vieworders];
        [vieworders setFrame:CGRectMake(25,orders.frame.size.height/2-vieworders.frame.size.height/2,vieworders.frame.size.width,vieworders.frame.size.height)];
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)chatTable
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tablesAllotedArray = [[NSMutableArray alloc]initWithObjects:[defaults valueForKey:@"Alloted Tables"], nil];
    tableAllotedIdsArray = [[NSMutableArray alloc] init];
    assignedTablesArray = [[NSMutableArray alloc] init];
    tableNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[self.tablesAllotedArray objectAtIndex:0]];
    for (int i =0 ; i <[tempArray count] ; i++) {
        tableAllotedObj = [[tableAllotedOC alloc]init];
        NSString *tableIdStr = [NSString stringWithFormat:@"%@",[[tempArray valueForKey:@"id"] objectAtIndex:i]];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"Table ID %@",tableIdStr);
        tableAllotedObj.tableId = [tableIdStr intValue];
        NSLog(@"Table ID %d",tableAllotedObj.tableId);
        NSString *tableNameStr = [NSString stringWithFormat:@"%@",[[tempArray valueForKey:@"name"] objectAtIndex:i]];
        
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"Table ID %@",tableIdStr);
        NSLog(@"Table Name %@",tableNameStr);
        tableAllotedObj.tableName = [NSString stringWithFormat:@"%@",tableNameStr];
        [tableAllotedIdsArray addObject:tableAllotedObj];
        [assignedTablesArray addObject:[NSString stringWithFormat:@"%d",tableAllotedObj.tableId]];
        [tableNameArray addObject:[NSString stringWithFormat:@"%@",tableAllotedObj.tableName]];
    }
    NSString *assignedTables = [NSString stringWithFormat:@"%@",assignedTablesArray];
    [self fetchHelpMessage:assignedTables];
    
}
-(void) fetchHelpMessage: (NSString *)assignedTableListStr
{
    //    [self disabled];
        [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self disabled];
    
    NSString *timeStamp;
    assignedTableTimestampsArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [assignedTablesArray count]; i++){
        timeStampKey = [NSString stringWithFormat:@"%@_pingTimeStamp",[assignedTablesArray objectAtIndex:i]];
        timeStamp = [NSString stringWithFormat:@"%@",[defaults objectForKey:timeStampKey]];
        if ([timeStamp isEqualToString:@"(null)"]) {
            timeStamp = [NSString stringWithFormat:@""];
        }
        [assignedTableTimestampsArray addObject:timeStamp];
    }
    
    NSString *ids = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Service Provider ID"]];
    NSString *user =[NSString stringWithFormat:@"serviceprovider"];
    NSString *assignedTableList = [NSString stringWithFormat:@"%@",assignedTableListStr];
    assignedTableList = [assignedTableList stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    assignedTableList = [assignedTableList stringByReplacingOccurrencesOfString:@" " withString:@""];
    assignedTableList = [assignedTableList stringByReplacingOccurrencesOfString:@"(" withString:@""];
    assignedTableList = [assignedTableList stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSString *timeStampList = [NSString stringWithFormat:@"%@",assignedTableTimestampsArray];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@" " withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"(" withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"timestamp",ids, @"id",user, @"user",assignedTableList, @"assignedtablelist",timeStampList, @"timestamplist",@"ping",@"trigger", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchHelpMessages",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =13;
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
    [self.view setUserInteractionEnabled:YES];
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
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    fetchedChatData = [[NSMutableArray alloc]init];
   
    tablesList = [[NSMutableArray alloc]init];
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"Dictionary %@",userDetailDict);
    //        NSString *orderTypeStr =[NSString stringWithFormat:@"%@",StatusTag];
    //        [self pendingPlacedOrder:orderTypeStr];
    NSMutableArray *tablesOfSP = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"TableList"]];
    
    for (int i = 0; i < [tablesOfSP count]; i ++) {
        tableAllotedObj = [[tableAllotedOC alloc]init];
        tableAllotedObj.tableId = [[tablesOfSP valueForKey:@"TableList"] objectAtIndex:i];
        [tablesList addObject:[NSString stringWithFormat:@"%d",tableAllotedObj.tableId]];
    }
    
    for (int i=0; i<tablesList.count; i++)
    {
        NSString* counts = [NSString stringWithFormat:@"%@_Table",[tablesList objectAtIndex:i]];
        counts = [NSString stringWithFormat:@"\"%@\"",counts];
        counts = [counts stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        int table_count = 0;
        table_count=[[[fetchingChat valueForKey:@"listMessage"] objectAtIndex:i]count];
        table_count +=table_count;
        NSLog(@" table count..%d",table_count);
        [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%d",table_count ] forKey:counts];
    }
    NSArray *tableTempArray=[userDetailDict valueForKey:@"MaxTimestammpList"];
    NSMutableArray *tableTimeStampArray =[[NSMutableArray alloc] init];
    tableTimeStampArray=[tableTempArray mutableCopy];
    
    
    int pingTimeStamp=[[defaults valueForKey:@"pingTimeStamp"] intValue];
    if (pingTimeStamp == nil) {
        pingTimeStamp = -1;
    }
    
    NSString *tempTimeStamp;
    
    for (int i= 0; i < [tableTimeStampArray count]; i++) {
//        tableTimeStamps = [NSString stringWithFormat:@"%@_pingTimeStamp",[assignedTablesArray objectAtIndex:i]];
//        tableTimeStamps = [NSString stringWithFormat:@"\"%@\"",tableTimeStamps];
//        tableTimeStamps = [tableTimeStamps stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        tempTimeStamp = [[tableTimeStampArray valueForKey:@"Maxtimestamp"]  objectAtIndex:i];
        
            [defaults setValue:tempTimeStamp forKey:@"pingTimeStamp"];
        
    }
    
    fetchingChat = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"MessageList"]];
    NSLog(@"%@",fetchingChat);
    if ([fetchingChat count] != 0) {
        
        for (int i =0 ; i < [fetchingChat count]; i++) {
            NSArray *tempList =[[fetchingChat valueForKey:@"listMessage"] objectAtIndex:i];
            NSMutableArray *fetchMessages = [[NSMutableArray alloc] init];
            fetchMessages = [tempList mutableCopy];
            
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            NSString*deleteQuery=[NSString stringWithFormat:@"DELETE FROM spPings"];
            [database executeUpdate:deleteQuery];
            [database close];

            if (fetchMessages.count == 0){
                viewNoMessages.hidden = NO;
                
            }else{
                viewNoMessages.hidden = YES;
            }
            for (int i = 0; i < [fetchMessages count]; i++)
            {
                
                docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                documentsDir = [docPaths objectAtIndex:0];
                dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
                database = [FMDatabase databaseWithPath:dbPath];
                [database open];
                
              
                NSString *insert = [NSString stringWithFormat:@"INSERT INTO spPings (tableid, serviceProviderId, message, time,sender) VALUES (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\")",[[fetchMessages valueForKey:@"tableid"] objectAtIndex:i],[[fetchMessages valueForKey:@"serviceproviderid"]objectAtIndex:i],[[fetchMessages valueForKey:@"message"]objectAtIndex:i],[[fetchMessages valueForKey:@"time"]objectAtIndex:i],[[fetchMessages valueForKey:@"sender"]objectAtIndex:i]];
                [database executeUpdate:insert];
            }
        }
        
    }
    [self fetchPingDataFromDB];
    [self enable];
}

-(void) fetchPingDataFromDB
{
    fetchedChatData = [[NSMutableArray alloc]init];
   pingsList = [[NSMutableArray alloc]init];
    NSMutableArray *chatTime = [[NSMutableArray alloc]init];
    NSMutableArray *chatSender = [[NSMutableArray alloc]init];
     NSString *serviceProviderIds = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Service Provider ID"]];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM spPings where serviceProviderId = %@", serviceProviderIds];
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        
        pingsObj = [[pingsOC alloc]init];
        pingsObj.tableId =  [[results stringForColumn:@"tableid"] intValue];
        pingsObj.pingMessage =[results stringForColumn:@"message"];
        pingsObj.pingTime = [results stringForColumn:@"time"];
        [pingsList addObject:pingsObj];
    }
    
    [self.pingTableView reloadData];
    
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (pingsList == nil) {
        return 0;
    }else{
    return [pingsList count];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    pingsAssistanceTableViewCell *cell = (pingsAssistanceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"pingsAssistanceTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        if (pingsList.count > 0)
            [self.pingTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:pingsList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    
    pingsObj = [pingsList objectAtIndex:indexPath.row];
    
    
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
    
    NSString *time = [NSString stringWithFormat:@"%@",pingsObj.pingTime];
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
    int index = [assignedTablesArray indexOfObject:[NSString stringWithFormat:@"%d",pingsObj.tableId]] ;
    
    
    NSString *tableIDStr;
    
    if (self.tablesAllotedArray.count>0)
    {
        NSArray*tempAllotedArray=[self.tablesAllotedArray objectAtIndex:0];
        for (int j=0; j<tempAllotedArray.count; j++)
        {
            NSLog(@"array:%@",[[tempAllotedArray objectAtIndex:j] valueForKey:@"id"]);
            NSLog(@"contain value:%@",[NSString stringWithFormat:@"%d",pingsObj.tableId]);

            
            if ([[[tempAllotedArray objectAtIndex:j] valueForKey:@"id"] isEqualToString:[NSString stringWithFormat:@"%d",pingsObj.tableId]])
            {
                tableIDStr = [NSString stringWithFormat:@"%@",[[tempAllotedArray objectAtIndex:j ] valueForKey:@"name"]];
            }
        }

    }
     tableIDStr = [tableIDStr uppercaseString];
    
    
    
//    NSString *tableIDStr = [NSString stringWithFormat:@"%@",[tableNameArray objectAtIndex:index]];
//    tableIDStr = [tableIDStr uppercaseString];
    
    
    NSString *pingMessageStr = [[NSString stringWithFormat:@"%@",pingsObj.pingMessage]uppercaseString];
    
    [cell setLabelText:[NSString stringWithFormat: @"%@",tableIDStr] :[NSString stringWithString:timeStr] :[NSString stringWithString:pingMessageStr]];
    
    
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
- (IBAction)myStatsAction:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deliveryStr = [defaults valueForKey:@"Delivery Stats"];
    NSString *processStr = [defaults valueForKey:@"Process Stats"];
    NSString *pendingStr = [defaults valueForKey:@"Pending Stats"];
    self.deliveredStatLbl.text = deliveryStr;
    self.inProcessStatLbl.text = processStr;
    self.pendingStatLbl.text = pendingStr;
    self.deliveredStatLbl.font = [UIFont fontWithName:@"Bebas Neue" size:20];
    self.inProcessStatLbl.font = [UIFont fontWithName:@"Bebas Neue" size:20];
    self.pendingStatLbl.font = [UIFont fontWithName:@"Bebas Neue" size:20];
//    self.orderDeliveryTitleLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
//    self.orderInProcessTitleLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
//    self.orderPendingTitleLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
    
    self.statsPopUpView.hidden = NO;
    if (IS_IPAD_Pro) {
        [self.statsPopUpView setFrame:CGRectMake(180, 800, self.statsPopUpView.frame.size.width, self.statsPopUpView.frame.size.height)];
    }
    letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:letterTapRecognizer];
}
- (void)highlightLetter:(UITapGestureRecognizer*)sender
{
    self.statsPopUpView.hidden = YES;
    [self.view sendSubviewToBack:letterTapRecognizer];
    
}
- (IBAction)seeOrderAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Order Count"] ;
    self.pingNotificationBadgeImg.hidden = YES;
    self.pingNotificationBadgeImg.hidden = YES;
    serviceProviderHomeViewController *spRequestVC = [[serviceProviderHomeViewController alloc] initWithNibName:@"serviceProviderHomeViewController" bundle:nil];
    
    [self.navigationController pushViewController:spRequestVC animated:NO];
}

- (IBAction)pingForAssisteance:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Ping Count"] ;
    self.pingNotificationBadgeImg.hidden = YES;
    self.pingNotificationBadgeImg.hidden = YES;
    spPingAssistanceViewController *spRequestVC = [[spPingAssistanceViewController alloc] initWithNibName:@"spPingAssistanceViewController" bundle:nil];
    
    [self.navigationController pushViewController:spRequestVC animated:NO];
}

- (IBAction)exitAction:(id)sender {
    if (IS_IPAD_Pro) {
        [self.exitPopUpView setFrame:CGRectMake(0, 0, 1366, 1024)];
    }else{
    [self.exitPopUpView setFrame:CGRectMake(0, 0, self.exitPopUpView.frame.size.width, self.exitPopUpView.frame.size.height)];
    }
    [self.view addSubview:self.exitPopUpView];
}

- (IBAction)requestAssistanceAction:(id)sender {
    spRequestAssistanceViewController *requestVC = [[spRequestAssistanceViewController alloc] initWithNibName:@"spRequestAssistanceViewController" bundle:nil];
    [self.navigationController pushViewController:requestVC animated:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1000 && buttonIndex == 1)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"Service Provider ID"];
        [defaults removeObjectForKey:@"Service Provider Name"];
        [defaults removeObjectForKey:@"Service Provider image"];
        [defaults removeObjectForKey:@"Role"];
        
        [defaults setObject:@"YES"forKey:@"isLogedOut"];
        loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (IBAction)menuBtn:(id)sender {
  
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    [appdelegate.navigator dismissViewControllerAnimated:NO completion:nil];

    CGPoint pt;
    CGRect rc = [self.sideScroller bounds];
    rc = [self.sideScroller convertRect:rc toView:self.sideScroller];
    pt = rc.origin;
    if (pt.x == 0) {
        if (IS_IPAD_Pro) {
            pt.x -= 356;
        }else{
            pt.x -= 267;
        }
        int orderCount =[[[NSUserDefaults standardUserDefaults ]valueForKey:@"Order Count"]intValue];
        if (orderCount != 0) {
            self.orderNotificationBadgeImg.hidden = NO;
            self.orderNotificationBadgeLbl.hidden = NO;
            self.orderNotificationBadgeLbl.text = [NSString stringWithFormat:@"%d",orderCount];
        }else{
            self.orderNotificationBadgeImg.hidden = YES;
            self.orderNotificationBadgeLbl.hidden = YES;
        }
        
    }else{
        pt.x = 0;
        
    }
    
    pt.y =-20;
    [self.sideScroller setContentOffset:pt animated:YES];
}
-(void) fetchCounts{
    NSLog(@"Fetch method called");
}
- (IBAction)exitYesAction:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    [appdelegate logout];
    
}

- (IBAction)exitNoAction:(id)sender {
    [self.exitPopUpView removeFromSuperview];
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
