
#import "gettingCountViewController.h"
#import "JSON.h"
#import "SBJson.h"
@interface gettingCountViewController ()

@end

@implementation gettingCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    NSString *assignedTables = [NSString stringWithFormat:@"%@",assignedTablesArray];
   
    [self fetchMessageCount:assignedTables];
}
-(void) fetchCounts{
    NSLog(@"Fetch method called");
    [self chatTable];
    
}
-(void) fetchMessageCount:(NSString *) assignedTable
{
    //    [self disabled];
    //    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    assignedTableTimestampsArray = [[NSMutableArray alloc] init];
     NSString *timeStamp;
    for(int i = 0; i < [assignedTablesArray count]; i++){
        timeStampKey = [NSString stringWithFormat:@"%@_pingTimeStamp",[assignedTablesArray objectAtIndex:i]];
        timeStamp = [NSString stringWithFormat:@"%@",[defaults objectForKey:timeStampKey]];
        if ([timeStamp isEqualToString:@"(null)"]) {
            timeStamp = [NSString stringWithFormat:@""];
        }
        [assignedTableTimestampsArray addObject:timeStamp];
    }
    NSString *assignedTableList = [NSString stringWithFormat:@"%@",assignedTable];
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
    
    NSString *orderTimeStamp = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"fetchOrderTimeStamp"]];
    NSString *ids = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Service Provider ID"]];
    NSString *user =[NSString stringWithFormat:@"serviceprovider"];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:assignedTableList,@"assignedTableList",timeStampList,@"timestampConversation",user, @"trigger",ids, @"id",orderTimeStamp, @"timestampOrder", nil];
    
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
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"Dictionary %@",userDetailDict);
  
        [defaults setValue:[userDetailDict valueForKey:@"ordercount"] forKey:@"Order Count"];
        [defaults setValue:[userDetailDict valueForKey:@"pingcount"] forKey:@"Ping Count"];
        
  // [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(repeatWebservice) userInfo:nil repeats:YES];
        
}
- (void)repeatWebservice{
    [self fetchCounts];
}

@end
