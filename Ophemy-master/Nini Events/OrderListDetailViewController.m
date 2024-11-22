
#import "OrderListDetailViewController.h"
#import "OrderListTableViewCell.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "OrdersListViewController.h"
#import "AppDelegate.h"

@interface OrderListDetailViewController ()

@end

@implementation OrderListDetailViewController
@synthesize pendingOrderObj,type;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.flag == 1)
    {
        markDelivrdBtn .hidden=YES;
    }
    else{
        markDelivrdBtn.hidden=NO;
    }
    AppDelegate*appdelegate=[[UIApplication sharedApplication]delegate];

    NSString *freeTag = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Is Paid"]];
    if ([freeTag isEqualToString:@"1"]) {
        currencySymbolLbl.hidden = YES;
        self.totalPriceLbl.hidden = YES;
        totalLbl.hidden = YES;
    }else{
        currencySymbolLbl.hidden = NO;
        self.totalPriceLbl.hidden = NO;
        totalLbl.hidden = NO;
        currencySymbolLbl.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"Currency Value"];
        float totalBill=[[NSString stringWithFormat:@"%@",pendingOrderObj.TotalBill ]floatValue];
        self.totalPriceLbl.text=[NSString stringWithFormat: @"%.2f",totalBill];
    }
    
    
    self.headrLbl.text=[NSString stringWithFormat:@"ORDER NUMBER: %@", pendingOrderObj.OrderId ];
    
    NSLog(@"NOTES...... %@",pendingOrderObj.note);
    self.notesTextView.text = [NSString stringWithFormat:@"%@",pendingOrderObj.note];
    orderListArray=[[NSMutableArray alloc]init];
    orderListArray=[pendingOrderObj.pendingOrderDetails mutableCopy];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if (IS_IPAD_Pro) {
        activityIndicator.center = CGPointMake(1366/2, 1028/2);
    }else{
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.orderTableView){
        return [orderListArray count];
    }    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 112;
    return 100;
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
    
    
    if (tableView == self.orderTableView)
    {
        NSString*itemName=[[[orderListArray objectAtIndex:indexPath.row]valueForKey:@"itemname"] uppercaseString];
        NSString*quantity=[[[orderListArray objectAtIndex:indexPath.row]valueForKey:@"quantity"]uppercaseString];
        NSString*price=[[orderListArray objectAtIndex:indexPath.row]valueForKey:@"price"];
        float pric=[price floatValue];
        price=[NSString stringWithFormat:@"%.2f",pric];
        [cell setLabelText1:itemName :quantity :price :@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)markDelievrdBtn:(id)sender {
    
    [self changeStatus:pendingOrderObj.OrderId ];
}

-(void) changeStatus:(NSString *)pendingOrdersIDS
{
    [self disabled];
    [activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *startTime;
    
    startTime = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *curruntTime = [ dateFormat stringFromDate:startTime];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:pendingOrdersIDS,@"OrderId",[NSString stringWithFormat:@"delivered"], @"Status",curruntTime,@"Datetime", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/ChangeOrderStatus",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =11;
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
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   
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
    if (webServiceCode == 11){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        OrdersListViewController *orderVC = [[OrdersListViewController alloc] initWithNibName:@"OrdersListViewController" bundle:nil];
        orderVC.flagValue = self.flag;
        [self.navigationController pushViewController:orderVC animated:NO];
    }
    [self enable];
    [activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];

}
- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    self.disabledImgView.hidden = NO;
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    self.disabledImgView.hidden = YES;
}
@end
