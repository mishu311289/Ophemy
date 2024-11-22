
#import "spRequestAssistanceViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "serviceProviderHomeViewController.h"
#import "loginViewController.h"
#import "Base64.h"
#import "spPingAssistanceViewController.h"
@interface spRequestAssistanceViewController ()

@end

@implementation spRequestAssistanceViewController

- (void)viewDidLoad {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.chatMessageTxtView.layer.borderColor = [UIColor grayColor].CGColor;
    self.chatMessageTxtView.layer.borderWidth = 1;
    originalPt.x = self.chatView.frame.origin.x;
    originalPt.y = self.chatView.frame.origin.y;
    
    self.sendBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.sendBtn.layer.borderWidth = 1;
    NSString *chatCountStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"SPChat Count"]];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"SPChat Count"]);
    NSLog(@"%@",chatCountStr);
    chatCountArray = [chatCountStr componentsSeparatedByString:@","];
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
    self.chatTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.chatTableView.layer.borderWidth = 1;
    tableSelected = [NSString stringWithFormat:@"1"];
    [self showChat:tableSelected];

    [self chatTable];
    
    
    
    [super viewDidLoad];
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
- (void)viewWillDisappear:(BOOL)animated
{
    [fetchMsgTimer invalidate];
    
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)chatTable
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tablesAllotedArray = [[[[NSMutableArray alloc]initWithObjects:[defaults valueForKey:@"Alloted Tables"], nil]objectAtIndex:0] mutableCopy];
    tableAllotedIdsArray = [[NSMutableArray alloc] init];
    assignedTablesArray = [[NSMutableArray alloc] init];

    for (int i =0 ; i <[self.tablesAllotedArray count] ; i++) {
        tableAllotedObj = [[tableAllotedOC alloc]init];
        NSString *tableIdStr = [NSString stringWithFormat:@"%@",[[self.tablesAllotedArray valueForKey:@"id"] objectAtIndex:i]];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        tableIdStr = [tableIdStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"Table ID %@",tableIdStr);
        tableAllotedObj.tableId = [tableIdStr intValue];
        NSLog(@"Table ID %d",tableAllotedObj.tableId);
        NSString *tableNameStr = [NSString stringWithFormat:@"%@",[[self.tablesAllotedArray valueForKey:@"name"] objectAtIndex:i]];
        
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        tableNameStr = [tableNameStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"Table ID %@",tableIdStr);
        NSLog(@"Table Name %@",tableNameStr);
        tableAllotedObj.tableName = [NSString stringWithFormat:@"%@",tableNameStr];
        [tableAllotedIdsArray addObject:tableAllotedObj];
        [assignedTablesArray addObject:[NSString stringWithFormat:@"%d",tableAllotedObj.tableId]];
    }
    for (int j=0; j<assignedTablesArray.count; j++)
    {
        NSString* counts = [NSString stringWithFormat:@"%@_Table",[assignedTablesArray objectAtIndex:j]];
        counts = [NSString stringWithFormat:@"\"%@\"",counts];
        counts = [counts stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        
        [[NSUserDefaults standardUserDefaults ]removeObjectForKey:[NSString stringWithFormat:@"%@",counts ] ];
    }
    if (tableSelected == nil) {
        tableSelected = [assignedTablesArray objectAtIndex:0];
    }
    [self.allotedTablesTableView reloadData];
    NSString *assignedTables = [NSString stringWithFormat:@"%@",assignedTablesArray];
    [self fetchHelpMessage:assignedTables];
    
}
#pragma mark - Fetch Help Message
-(void) fetchHelpMessage: (NSString *)assignedTableListStr
{
    [fetchMsgTimer invalidate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *timeStamp;
    assignedTableTimestampsArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [assignedTablesArray count]; i++){
        timeStampKey = [NSString stringWithFormat:@"%@_TimeStamp",[assignedTablesArray objectAtIndex:i]];
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
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"\\"withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"\""withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@")"withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"("withString:@""];
    timeStampList = [timeStampList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"timestamp",ids, @"id",user, @"user",assignedTableList, @"assignedtablelist",timeStampList, @"timestamplist",@"chat",@"trigger", nil];
    
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
    [objactivityindicator stopAnimating];
    [self.sendBtn setUserInteractionEnabled:YES];
    disableView.hidden=YES;
    
    //    [activityIndicator stopAnimating];
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
    if (webServiceCode == 4){
        [objactivityindicator stopAnimating];
        disableView.hidden=YES;
        [self.sendBtn setUserInteractionEnabled:YES];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        self.chatMessageTxtView.text =@"";
        
        [self chatTable];
        
    }else if (webServiceCode == 13){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        fetchedChatData = [[NSMutableArray alloc]init];
        tablesList = [[NSMutableArray alloc]init];
        tablesList = [[NSMutableArray alloc]init];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);        
        
        NSMutableArray *tablesOfSP = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"TableList"]];
       
        for (int i = 0; i < [tablesOfSP count]; i ++) {
            tableAllotedObj = [[tableAllotedOC alloc]init];
            tableAllotedObj.tableId = [[[tablesOfSP valueForKey:@"TableList"] objectAtIndex:i] intValue];
            [tablesList addObject:[NSString stringWithFormat:@"%d",tableAllotedObj.tableId]];
        }
        
        fetchingChat = [userDetailDict valueForKey:@"MessageList"];
        
        for (int i=0; i<tablesList.count; i++)
        {
           NSString* counts = [NSString stringWithFormat:@"%@_Table",[tablesList objectAtIndex:i]];
            counts = [NSString stringWithFormat:@"\"%@\"",counts];
            counts = [counts stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            
            int table_count=[[[fetchingChat valueForKey:@"listMessage"] objectAtIndex:i]count];
            NSLog(@" table count..%d",table_count);
            [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%d",table_count ] forKey:counts];
        }

        if ([fetchingChat count] != 0) {
            
            NSArray *tableTempArray=[userDetailDict valueForKey:@"MaxTimestammpList"];
            NSMutableArray *tableTimeStampArray =[[NSMutableArray alloc] init];
            tableTimeStampArray=[tableTempArray mutableCopy];
            NSString *tableTimeStamps;
            for (int i= 0; i < [tableTimeStampArray count]; i++) {
                tableTimeStamps = [NSString stringWithFormat:@"%@_TimeStamp",[tablesList objectAtIndex:i]];
                tableTimeStamps = [NSString stringWithFormat:@"\"%@\"",tableTimeStamps];
                tableTimeStamps = [tableTimeStamps stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                [defaults setValue:[[tableTimeStampArray valueForKey:@"Maxtimestamp"]  objectAtIndex:i] forKey:tableTimeStamps];
            }
            
            for (int i =0 ; i < [fetchingChat count]; i++) {
                NSArray *tempList =[[fetchingChat valueForKey:@"listMessage"] objectAtIndex:i];
                NSMutableArray *fetchMessages = [[NSMutableArray alloc] init];
                fetchMessages = [tempList mutableCopy];
                
                for (int i = 0; i < [fetchMessages count]; i++)
                {
                    
                    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    documentsDir = [docPaths objectAtIndex:0];
                    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
                    database = [FMDatabase databaseWithPath:dbPath];
                    [database open];

                    NSString *dateChangedString = @"";
                    
                    NSString *senderImageStr = [[fetchMessages valueForKey:@"image"]objectAtIndex:i];
                    
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", senderImageStr]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [UIImage imageWithData:data];
                    
                    NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
                    NSString *strEncoded = [Base64 encode:imgdata];
                    
                    senderImageStr = [NSString stringWithString:strEncoded];
                    
                    
                    NSString*deleteQuery=[NSString stringWithFormat:@"Delete from serviceProviderChat where tableid =\"%@\"",[[fetchMessages valueForKey:@"tableid"]objectAtIndex:i]];
                   // [database executeUpdate:deleteQuery];
                    
                    NSString *insert = [NSString stringWithFormat:@"INSERT INTO serviceProviderChat (tableid, serviceProviderId, message, time,sender,isDateChanged,senderName,senderImage) VALUES (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",[[fetchMessages valueForKey:@"tableid"] objectAtIndex:i],[[fetchMessages valueForKey:@"serviceproviderid"]objectAtIndex:i],[[fetchMessages valueForKey:@"message"]objectAtIndex:i],[[fetchMessages valueForKey:@"time"]objectAtIndex:i],[[fetchMessages valueForKey:@"sender"]objectAtIndex:i],dateChangedString,[[fetchMessages valueForKey:@"sendername"]objectAtIndex:i],senderImageStr];
                    [database executeUpdate:insert];
                    [self showChat:tableSelected];
                }
            }

        }
        fetchMsgTimer=[NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(chatTable) userInfo:nil repeats:NO];
    }
    
        if (tableSelected != nil) {
        [self showChat:tableSelected];
        [self tableView:self.allotedTablesTableView didSelectRowAtIndexPath:0];
    }
    
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.allotedTablesTableView)
    {
        return [tableAllotedIdsArray count];
    }
    else{
        return [orderList count];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 80)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor clearColor];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"Tabke view name %ld",(long)tableView.tag);
    UIView *headerView;
    //    if (tableView == self.menuTableView) {
    // headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.orderTableView.frame.size.width, 80)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor clearColor];
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.allotedTablesTableView)
    {
        return 80;
    }
    else{
        return 50;
    }
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    if (tableView == self.allotedTablesTableView)
    {
        tableAllotedObj = [tableAllotedIdsArray objectAtIndex:indexPath.row];
        UILabel * TablesID;
        if (IS_IPAD_Pro) {
            TablesID= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 405, 79)];
        }else{
            TablesID= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 305, 79)];
        }
        
        TablesID.textColor= [UIColor whiteColor];
        TablesID.font = [UIFont fontWithName:@"Bebas Neue" size:20];
        TablesID.lineBreakMode = NSLineBreakByCharWrapping;
        TablesID.numberOfLines = 2;
        TablesID.textAlignment = NSTextAlignmentCenter;
        TablesID.text = [NSString stringWithFormat:@"%@",tableAllotedObj.tableName];
        if (indexPath.row == selectedIndex.row) {
            TablesID.backgroundColor = [UIColor colorWithRed:96/255.0f green:10/255.0f blue:5/255.0f alpha:0.8];
        }else{
        TablesID.backgroundColor = [UIColor colorWithRed:96/255.0f green:10/255.0f blue:5/255.0f alpha:0.3];
        }
        [cell.contentView addSubview:TablesID];
        
        UIImageView *badgeImg = [[UIImageView alloc] initWithFrame:CGRectMake(180, 20, 27, 25)];
        badgeImg.image = [UIImage imageNamed:@"notificationcircle.png"];
        
        
        UILabel * CountsLbl= [[UILabel alloc]initWithFrame:CGRectMake(180, 20, 27,25)];
        CountsLbl.textColor= [UIColor colorWithRed:194/255.0f green:57/255.0f blue:9/255.0f alpha:1.0];
        CountsLbl.font = [UIFont fontWithName:@"Bebas Neue" size:12];
        CountsLbl.lineBreakMode = NSLineBreakByCharWrapping;
        CountsLbl.numberOfLines = 14;
        CountsLbl.textAlignment = NSTextAlignmentCenter;
        
        NSString*countValues = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"SPChat Count"]];
       
        NSArray *countArray = [countValues componentsSeparatedByString:@","];
            
            NSLog(@"%ld",(long)indexPath.row);
            NSLog(@"chatCountArray%@",chatCountArray);

        NSString *countValue = [NSString stringWithFormat:@"%@",[countArray objectAtIndex:indexPath.row]];

        
        if ([countValue isEqualToString:@"(null)"]) {
            countValue = [NSString stringWithFormat:@"0"];
        }
        //[assignedTableTimestampsArray addObject:countValue];

        if (![countValue isEqualToString:@"0"]) {
            CountsLbl.text = [NSString stringWithFormat:@"%@",countValue];
            CountsLbl.backgroundColor = [UIColor clearColor];
            if (indexPath.row != 0) {
                [cell.contentView addSubview:badgeImg];
                [cell.contentView addSubview:CountsLbl];
            }else{
                int tableCount = [[chatCountArray objectAtIndex:indexPath.row] intValue];
                int updatedChatCount = [[[NSUserDefaults standardUserDefaults ]valueForKey:@"UpdatedChat Count"]intValue];
                if (updatedChatCount > 0) {
                    updatedChatCount = updatedChatCount - tableCount;
                }
                
                
                [[NSUserDefaults standardUserDefaults ] setValue:[NSString stringWithFormat:@"%d",updatedChatCount] forKey:@"UpdatedChat Count"];
                
                int latestUpdatedChatCount = [[[NSUserDefaults standardUserDefaults ]valueForKey:@"UpdatedChat Count"]intValue];
                if (latestUpdatedChatCount > 0) {
                    self.chatNotificationBadgeImg.hidden = NO;
                    self.chatNotificationBageLbl.hidden = NO;
                    self.chatNotificationBageLbl.text = [NSString stringWithFormat:@"%d",latestUpdatedChatCount];
                }else{
                    self.chatNotificationBadgeImg.hidden = YES;
                    self.chatNotificationBageLbl.hidden = YES;
                }
                NSMutableArray*tagarray=[[NSMutableArray alloc]initWithArray:chatCountArray];
                
                [tagarray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                chatCountArray= [tagarray mutableCopy];
                NSString *chatCountStr = [NSString stringWithFormat:@"%@",chatCountArray];
                chatCountStr = [chatCountStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                chatCountStr = [chatCountStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                chatCountStr = [chatCountStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
                chatCountStr = [chatCountStr stringByReplacingOccurrencesOfString:@")" withString:@""];
                [[NSUserDefaults standardUserDefaults] setValue:chatCountStr forKey:@"SPChat Count"];
                
                

            }
            
        }
        if ([tableAllotedObj.tableType isEqualToString:@"VIP"]) {
            UIImageView *vipImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.allotedTablesTableView.frame.size.width-49, 0, 48, 48)];
            vipImg.image = [UIImage imageNamed:@"VIP.png"];
            [cell.contentView addSubview:vipImg];
            
            NSString *orderNumber = [NSString stringWithFormat:@"%@",self.tableNumberChatLbl.text];
            NSLog(@"Index path ... %lu",(unsigned long)[orderIdsArray indexOfObject:orderNumber]);
            orderNumberIndex = [NSIndexPath indexPathForRow:[orderIdsArray indexOfObject:orderNumber] inSection:0];
            NSLog(@"Index Path .. %ld",(long)orderNumberIndex.row);
            
            
            if ( indexPath.row == orderNumberIndex.row) {
                
                //            [self.orderTableView selectRowAtIndexPath:0 animated:NO scrollPosition:indexPath.row];
                NSLog(@"INDEX PATH %ld",(long)indexPath.row);
                
                [cell setBackgroundColor:[UIColor greenColor]];
                selectedIndex = indexPath;
                
            }
                
            
        }
        
        //        UILabel* bottomLineAlloted= [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 4, self.allotedTablesTableView.frame.size.width, 2)];
        //        bottomLineAlloted.backgroundColor= [UIColor blackColor];
        //        bottomLineAlloted.alpha = 0.3;
        //        [cell.contentView addSubview:bottomLineAlloted];
        
        
        cell.backgroundColor = [UIColor clearColor];
        
        
    }
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [allChatMessages count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
   // NSLog(@"All Mesages %@",allChatMessages);
    return [allChatMessages objectAtIndex:row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath!=nil) {
        selectedIndex = indexPath;

    }
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"CompareDate"];
    
    
    if (tableView == self.allotedTablesTableView)
    {
        if (tableAllotedIdsArray.count>0)
        {
            tableAllotedObj = [tableAllotedIdsArray objectAtIndex:selectedIndex.row];
            self.tableNumberChatLbl.text = [NSString stringWithFormat:@"%@",tableAllotedObj.tableName];
            NSLog(@"Tables Alloted.... %d",tableAllotedObj.tableId);
            if ([assignedTablesArray containsObject:[NSString stringWithFormat:@"%d",tableAllotedObj.tableId]]) {
                
                tableSelected = [NSString stringWithFormat:@"%d", tableAllotedObj.tableId];
                
                int tableCount = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"SPChat Count"] ] intValue];
                
                int updatedChatCount = [[[NSUserDefaults standardUserDefaults ]valueForKey:@"UpdatedChat Count"]intValue];
                if (updatedChatCount > 0) {
                    updatedChatCount = updatedChatCount - tableCount;
                }
                
                
                [[NSUserDefaults standardUserDefaults ] setValue:[NSString stringWithFormat:@"%d",updatedChatCount] forKey:@"UpdatedChat Count"];
                
                int latestUpdatedChatCount = [[[NSUserDefaults standardUserDefaults ]valueForKey:@"UpdatedChat Count"]intValue];
                if (latestUpdatedChatCount > 0) {
                    self.chatNotificationBadgeImg.hidden = NO;
                    self.chatNotificationBageLbl.hidden = NO;
                    self.chatNotificationBageLbl.text = [NSString stringWithFormat:@"%d",latestUpdatedChatCount];
                }else{
                    self.chatNotificationBadgeImg.hidden = YES;
                    self.chatNotificationBageLbl.hidden = YES;
                }
                //            NSMutableArray*tagarray=[[NSMutableArray alloc]initWithArray:chatCountArray];
                //
                //            [tagarray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                //
                //            chatCountArray= [tagarray mutableCopy];
                NSString *chatCountStr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"SPChat Count"]]];
                chatCountStr = [chatCountStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                chatCountStr = [chatCountStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                chatCountStr = [chatCountStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
                chatCountStr = [chatCountStr stringByReplacingOccurrencesOfString:@")" withString:@""];
                [[NSUserDefaults standardUserDefaults] setValue:chatCountStr forKey:@"SPChat Count"];
                [self.allotedTablesTableView reloadData];
                [self showChat:tableSelected];
        }
         
        }
    }
}


-(void) showChat:(NSString *)tableIds {
    NSMutableArray *chatMessages = [[NSMutableArray alloc]init];
    NSMutableArray *chatTime = [[NSMutableArray alloc]init];
    NSMutableArray *chatSender = [[NSMutableArray alloc]init];
    NSMutableArray *chatdateChanged = [[NSMutableArray alloc]init];
    NSMutableArray *senderName = [[NSMutableArray alloc]init];
    NSMutableArray *senderImageArray = [[NSMutableArray alloc]init];

    NSLog(@"Table IDs ... %@",assignedTablesArray);
    
    tableIds = [tableIds stringByReplacingOccurrencesOfString:@"@" withString:@""];
    tableIds = [tableIds stringByReplacingOccurrencesOfString:@"""" withString:@""];
    if ([assignedTablesArray containsObject:tableIds]) {
        
        
        allChatMessages = [[NSMutableArray alloc]init];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
         NSString *serviceProviderIds = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Service Provider ID"]];
        [database open];
        
        NSString *queryString = [NSString stringWithFormat:@"Select * FROM serviceProviderChat where tableid= %@ ORDER BY time ASC",tableIds];
        FMResultSet *results = [database executeQuery:queryString];
        fetchedChatData = [[NSMutableArray alloc]init];
        while([results next]) {
            fetchChatObj = [[fetchChatOC alloc]init];
            
            fetchChatObj.chatMessage = [results stringForColumn:@"message"];
            fetchChatObj.chatTime = [results stringForColumn:@"time"];
            fetchChatObj.chatSender =[results stringForColumn:@"sender"];
            fetchChatObj.TableId = [results stringForColumn:@"tableid"];
            fetchChatObj.senderIamge=[results stringForColumn:@"senderImage"];
            
            NSString *compairStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CompareDate"]];
            NSString *dateStr = [NSString stringWithFormat:@"%@",fetchChatObj.chatTime];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *dateFromStr = [formatter dateFromString:dateStr];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"dd-MM-yyyy"];
            dateStr = [formatter1 stringFromDate:dateFromStr];
            NSString *dateChangedString;
            
            if ([dateStr isEqualToString:compairStr]) {
                    dateChangedString =[NSString stringWithFormat:@"NO"];
                }else{
                    dateChangedString =[NSString stringWithFormat:@"YES"];
                    [[NSUserDefaults standardUserDefaults ]setValue:dateStr forKey:@"CompareDate"];
                }
            
            
            
            fetchChatObj.isDateChanged = dateChangedString;
            
            //fetchChatObj.isDateChanged = [results stringForColumn:@"isDateChanged"];
            
            fetchChatObj.senderName=[results stringForColumn:@"senderName"];
            
            
            [chatMessages addObject:fetchChatObj.chatMessage];
            [chatTime addObject:fetchChatObj.chatTime];
            [chatSender addObject:fetchChatObj.chatSender];
            [chatdateChanged addObject:fetchChatObj.isDateChanged];
            [senderName addObject:fetchChatObj.senderName];
            [senderImageArray addObject:fetchChatObj.senderIamge];
            
            [fetchedChatData addObject:fetchChatObj];
        }
        
        chatDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:chatMessages,@"messages",chatTime,@"time",chatSender,@"sender",chatdateChanged,@"isDateChanged",senderName,@"senderName",senderImageArray,@"senderImages",nil];
        for (int i = 0; i < [chatMessages count]; i++) {
            chatObj = [[chatOC alloc]init];
            chatObj.chatMessage = [[chatDictionary valueForKey:@"messages"] objectAtIndex:i];
            chatObj.chatTime = [[chatDictionary valueForKey:@"time"] objectAtIndex:i];
            chatObj.chatSender = [[chatDictionary valueForKey:@"sender"] objectAtIndex:i];
            chatObj.isDateChanged = [[chatDictionary valueForKey:@"isDateChanged"] objectAtIndex:i];
            chatObj.senderName = [[chatDictionary valueForKey:@"senderName"] objectAtIndex:i];
            chatObj.senderImage = [[chatDictionary valueForKey:@"senderImages"] objectAtIndex:i];

            [chatArray addObject:chatObj];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *dateFromString = [[NSDate alloc] init];
            
            dateFromString = [dateFormatter dateFromString:chatObj.chatTime];
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *datestr = [dateFormatter1 stringFromDate:dateFromString];
            NSDate *messageDate = [dateFormatter1 dateFromString:datestr];
            NSBubbleData *Bubble;
            
            if([chatObj.chatSender isEqualToString:@"serviceprovider"]){
                Bubble = [NSBubbleData dataWithText:[NSString stringWithFormat:@"Me: %@",chatObj.chatMessage] date:messageDate type:BubbleTypeMine isDateChanged:chatObj.isDateChanged isCorner:@"Service Provider"];
                Bubble.avatar = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"userImage"]] ;

              //  Bubble.avatar = [UIImage imageNamed:@"avatar1.png"];
            }
            else
            {
                if ([chatObj.chatSender isEqualToString:@"table"] || [chatObj.chatSender isEqualToString:@"coordinator"])
                {
                     Bubble = [NSBubbleData dataWithText:[NSString stringWithFormat:@"%@: %@",chatObj.senderName,chatObj.chatMessage] date:messageDate type:BubbleTypeSomeoneElse isDateChanged:chatObj.isDateChanged isCorner:@"Service Provider"];
                }
                else{
                    Bubble = [NSBubbleData dataWithText:[NSString stringWithFormat:@"%@: %@",chatObj.chatSender,chatObj.chatMessage] date:messageDate type:BubbleTypeSomeoneElse isDateChanged:chatObj.isDateChanged isCorner:@"Service Provider"];

                }
               // Bubble.avatar = nil;
                if ([chatObj.chatSender isEqualToString:@"table"])
                {
                    Bubble.avatar=[UIImage imageNamed:@"avatar1.png"];
 
                }
                else if (chatObj.senderImage.length==0) {
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
        NSLog(@"CHAT Array %@",fetchChatObj);
        self.chatMessageTxtView.text = @"";
        [self.chatTableView reloadData];
        [self.allotedTablesTableView reloadData];
    }else{
        
        [self.chatTableView reloadData];
        [self.allotedTablesTableView reloadData];
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
- (IBAction)sendBtnAction:(id)sender {
    if (![self.chatMessageTxtView.text isEqualToString:@""]) {
        [self.sendBtn setUserInteractionEnabled:NO];
        [self sendHelpMessage];
        NSLog(@"Message Sent");
    }
    NSLog(@"SENd Button Clicked");
    [self.chatMessageTxtView resignFirstResponder];
}
-(void) sendHelpMessage
{
    
    objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    objactivityindicator.center = CGPointMake((disableView.frame.size.width/2),(disableView.frame.size.height/2));
    [disableView addSubview:objactivityindicator];
    [objactivityindicator startAnimating];
    disableView.hidden=NO;

    
    [fetchMsgTimer invalidate];
    //    [self disabled];
    //    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tableID = [NSString stringWithFormat:@"%@",tableSelected];
    NSString *serviceProviderId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Service Provider ID"]];
    // NSString *message;
    NSString*Sendername= [[NSUserDefaults standardUserDefaults] valueForKey:@"Service Provider Name"];
    NSString *sender = [NSString stringWithFormat:@"serviceprovider"];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tableID,@"tableId",serviceProviderId,@"serviceproviderId",self.chatMessageTxtView.text,@"message",sender, @"sender",[NSString stringWithFormat:@"1"],@"restaurantId",@"chat",@"trigger",Sendername,@"sendername", nil];
    
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
    webServiceCode =4;
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
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect rc1 = [self.sideScroller bounds];
    rc1 = [self.sideScroller convertRect:rc1 toView:self.sideScroller];
    CGPoint pt1 = rc1.origin;
    if (pt1.x != 0) {
        [self menuBtn:nil];
    }
    
    
     [fetchMsgTimer invalidate];
    if (textView == self.chatMessageTxtView) {
        svos = self.chatView.contentOffset;
        
        CGPoint pt;
        CGRect rc = [textView bounds];
        rc = [textView convertRect:rc toView:self.chatView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 200;
        [self.chatView setContentOffset:pt animated:YES];
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView== self.chatMessageTxtView)
    {
        [self.chatView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [textView resignFirstResponder];
    
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    if (textView== self.chatMessageTxtView)
    {
        [self.chatView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [textView resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"user editing");
    if([text isEqualToString:@"\n"])
    {
        [self.chatView setContentOffset:CGPointMake(0, 0) animated:YES];
        [textView resignFirstResponder];
    }
    return YES;
}
- (IBAction)menuBtn:(id)sender {
    if (self.statsPopUpView.hidden ==NO)
    {
        self.statsPopUpView.hidden = YES;
        [self.view sendSubviewToBack:letterTapRecognizer];
    }
    
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
        
    }else{
        pt.x = 0;
        
    }
    
    pt.y =-20;
    [self.sideScroller setContentOffset:pt animated:YES];
}

- (IBAction)seeOrderAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Order Count"] ;
    self.pingNotificationBadgeImg.hidden = YES;
    self.pingNotificationBadgeImg.hidden = YES;
    serviceProviderHomeViewController *spRequestVC = [[serviceProviderHomeViewController alloc] initWithNibName:@"serviceProviderHomeViewController" bundle:nil];
    [fetchMsgTimer invalidate];

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

- (IBAction)pingForAssistanceAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Ping Count"] ;
    self.pingNotificationBadgeImg.hidden = YES;
    self.pingNotificationBadgeImg.hidden = YES;
    spPingAssistanceViewController *spRequestVC = [[spPingAssistanceViewController alloc] initWithNibName:@"spPingAssistanceViewController" bundle:nil];
    [fetchMsgTimer invalidate];

    [self.navigationController pushViewController:spRequestVC animated:NO];
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
        [fetchMsgTimer invalidate];

        [self.navigationController pushViewController:loginVC animated:YES];
    }
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
- (IBAction)exitYesAction:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    [appdelegate logout];
    
}

- (IBAction)exitNoAction:(id)sender {
    [self.exitPopUpView removeFromSuperview];
}
@end
