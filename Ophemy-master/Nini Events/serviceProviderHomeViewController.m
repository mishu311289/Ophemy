
#import "serviceProviderHomeViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "loginViewController.h"
#import "spRequestAssistanceViewController.h"
#import "spPingAssistanceViewController.h"
#import "gettingCountViewController.h"
@interface serviceProviderHomeViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
}
@end

@implementation serviceProviderHomeViewController

- (void)viewDidLoad {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    flag = 0;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CompareDate"];
    orderIdtempArray=[[NSMutableArray alloc]init];
    savDataArray=[[NSMutableArray alloc]init];
    NSLog(@"Name%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"Service Provider Name"]);
    NSLog(@"role%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"Role"]);
    NSString *serviceProviderName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"Service Provider Name"]];
    serviceProviderName = [serviceProviderName uppercaseString];
    NSString *serviceProviderRole = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"Role"]];
    serviceProviderRole = [serviceProviderRole uppercaseString];
    nameLbl.text=serviceProviderName;
    roleLbl.text=serviceProviderRole;
    nameLbl.font = [UIFont fontWithName:@"Helvetica-Condensed" size:18];
    roleLbl.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    NSString*picUrl=[[NSUserDefaults standardUserDefaults ]valueForKey:@"Service Provider image"];
    
    
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

    [defaults setValue:@"0" forKey:@"Order Count"];
    self.orderNotificationBadgeImg.hidden = YES;
    self.orderNotificationBadgeLbl.hidden = YES;
    providerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    providerImageView.layer.borderWidth = 2.5;
    providerImageView.layer.cornerRadius = 10.0;
    [providerImageView setClipsToBounds:YES];
//    
//    self.spDisplayLbl.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.spDisplayLbl.layer.borderWidth = 2.5;
//    self.spDisplayLbl.layer.cornerRadius = 10.0;
//    [self.spDisplayLbl setClipsToBounds:YES];
    
    
    if (picUrl.length==0) {
        providerImageView.image = [UIImage imageNamed:@"dummy_user.png"];
    }
    else{
        
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        objactivityindicator.center = CGPointMake((providerImageView.frame.size.width/2),(providerImageView.frame.size.height/2));
        [providerImageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *imageURL=[NSURL URLWithString:[picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [providerImageView setImage:imgData];
                                   //  [UserImageDict setObject:imgData forKey:UrlString];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                               else
                               {
                                   //[self.imageview setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });
    }
    
    
    originalPt.x = self.chatView.frame.origin.x;
    originalPt.y = self.chatView.frame.origin.y;
    StatusTag =[NSString stringWithFormat:@"Open"];
    NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"isCoutFetched"]];
    if ([str isEqualToString:@"(null)"]) {
        str = [NSString stringWithFormat:@"0"];
    }
//    if ([str isEqualToString:@"1"]) {
//        [self pendingPlacedOrder:[NSString stringWithFormat:@"Open"]];
//    }else{
    
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isCoutFetched"];
        [self chatTableCount];
//    }
    
    chatArray = [[NSMutableArray alloc]init];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if (IS_IPAD_Pro) {
        activityIndicator.center = CGPointMake(1366/2, 1028/2);
    }else{
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    
    activityIndicator.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicator];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Chat Support"]];
     NSString *PingAssistance = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"PingAssistance"]];
    
 if ([eventChatSupport isEqualToString:@"False"]) {
        float viewHeight = self.view.frame.size.height;
        
        self.orders.frame = CGRectMake(self.orders.frame.origin.x, 0, self.orders.frame.size.width, viewHeight/3-2);
        pingAssistance.frame = CGRectMake(pingAssistance.frame.origin.x,viewHeight/3, pingAssistance.frame.size.width, viewHeight/3-2);
        self.exit.frame = CGRectMake(self.exit.frame.origin.x, pingAssistance.frame.origin.y+pingAssistance.frame.size.height+2, self.exit.frame.size.width,viewHeight/3);
    
        requestAssistance.hidden = YES;
        lblliveAssistance.hidden = YES;
        imageliveAssistance.hidden = YES;
    
     self.chatNotificationBadgeImg.hidden = YES;
     self.chatNotificationBageLbl.hidden = YES;
    [pingAssistance addSubview:viewliveAssistance];
    [viewliveAssistance setFrame:CGRectMake(25,pingAssistance.frame.size.height/2-viewliveAssistance.frame.size.height/2,viewliveAssistance.frame.size.width,viewliveAssistance.frame.size.height)];
    
    [self.exit addSubview:viewexit];
    [viewexit setFrame:CGRectMake(25,self.exit.frame.size.height/2-viewexit.frame.size.height/2,viewexit.frame.size.width,viewexit.frame.size.height)];
    
    
    [self.orders addSubview:vieworders];
    [vieworders setFrame:CGRectMake(25,self.orders.frame.size.height/2-vieworders.frame.size.height/2,vieworders.frame.size.width,vieworders.frame.size.height)];
     
      }
    if ([PingAssistance isEqualToString:@"0"]) {
        float viewHeight = self.view.frame.size.height;
        
        self.orders.frame = CGRectMake(self.orders.frame.origin.x, 0, self.orders.frame.size.width, viewHeight/3-2);
        requestAssistance.frame = CGRectMake(requestAssistance.frame.origin.x,viewHeight/3, requestAssistance.frame.size.width, viewHeight/3-2);
        self.exit.frame = CGRectMake(self.exit.frame.origin.x, requestAssistance.frame.origin.y+requestAssistance.frame.size.height+2, self.exit.frame.size.width,viewHeight/3);
        
        pingAssistance.hidden = YES;
        viewliveAssistance.hidden = YES;
        
        self.pingNotificationBadgeImg.hidden = YES;
        self.pingNotificationBadgeLbl.hidden = YES;
        [requestAssistance addSubview:viewRequestAssistance];
        [viewRequestAssistance setFrame:CGRectMake(25,requestAssistance.frame.size.height/2-viewRequestAssistance.frame.size.height/2,viewRequestAssistance.frame.size.width,viewRequestAssistance.frame.size.height)];
        
        [self.exit addSubview:viewexit];
        [viewexit setFrame:CGRectMake(25,self.exit.frame.size.height/2-viewexit.frame.size.height/2,viewexit.frame.size.width,viewexit.frame.size.height)];
        
        [self.orders addSubview:vieworders];
        [vieworders setFrame:CGRectMake(25,self.orders.frame.size.height/2-vieworders.frame.size.height/2,vieworders.frame.size.width,vieworders.frame.size.height)];
    }
    if ([eventChatSupport isEqualToString:@"False"] && [PingAssistance isEqualToString:@"0"]){
        pingAssistance.hidden = YES;
        viewliveAssistance.hidden = YES;
        
        requestAssistance.hidden = YES;
        lblliveAssistance.hidden = YES;
        imageliveAssistance.hidden = YES;
        
        float viewHeight = self.view.frame.size.height;
        
        self.orders.frame = CGRectMake(self.orders.frame.origin.x, 0, self.orders.frame.size.width, viewHeight/2-2);
        self.exit.frame = CGRectMake(self.exit.frame.origin.x, self.orders.frame.origin.y+self.orders.frame.size.height+2, self.exit.frame.size.width,viewHeight/2);
        
        [self.exit addSubview:viewexit];
        [viewexit setFrame:CGRectMake(25,self.exit.frame.size.height/2-viewexit.frame.size.height/2,viewexit.frame.size.width,viewexit.frame.size.height)];
        
        [self.orders addSubview:vieworders];
        [vieworders setFrame:CGRectMake(25,self.orders.frame.size.height/2-vieworders.frame.size.height/2,vieworders.frame.size.width,vieworders.frame.size.height)];
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    // observe keyboard hide and show notifications to resize the text view appropriately
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // start editing the UITextView (makes the keyboard appear when the application launches)
    // [self editAction:self];
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
-(void)chatTableCount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tablesAllotedArray = [[NSMutableArray alloc]initWithObjects:[defaults valueForKey:@"Alloted Tables"], nil];
   
    NSLog(@"Tables... %lu",(unsigned long)self.tablesAllotedArray.count);
    tableAllotedIdsArray = [[NSMutableArray alloc] init];
    assignedTablesArray = [[NSMutableArray alloc] init];
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
    }
    [self.allotedTablesTableView reloadData];
    NSString *assignedTables = [NSString stringWithFormat:@"%@",assignedTablesArray];
    [self fetchMessageCount:assignedTables];
    
    
    
}
-(void)chatTable
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tablesAllotedArray = [[NSMutableArray alloc]initWithObjects:[defaults valueForKey:@"Alloted Tables"], nil];
    NSLog(@"Tables... %lu",(unsigned long)self.tablesAllotedArray.count);
    tableAllotedIdsArray = [[NSMutableArray alloc] init];
    assignedTablesArray = [[NSMutableArray alloc] init];
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
    }
    [self.allotedTablesTableView reloadData];
   
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (IBAction)chatCloseBtn:(id)sender {
    self.chatView.hidden=YES;
}

- (IBAction)menuOrdersBtn:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Order Count"] ;
    self.pingNotificationBadgeImg.hidden = YES;
    self.pingNotificationBadgeImg.hidden = YES;
    serviceProviderHomeViewController *spRequestVC = [[serviceProviderHomeViewController alloc] initWithNibName:@"serviceProviderHomeViewController" bundle:nil];
    
    [self.navigationController pushViewController:spRequestVC animated:NO];
    //    [self.orders setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2]];
    //    [self.pings setBackgroundColor:[UIColor clearColor]];
    //    [self.myStats setBackgroundColor:[UIColor clearColor]];
    //    [self.exit setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)menuPings:(id)sender {
    //    [self.orders setBackgroundColor:[UIColor clearColor]];
    //    [self.pings setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2]];
    //    [self.myStats setBackgroundColor:[UIColor clearColor]];
    //    [self.exit setBackgroundColor:[UIColor clearColor]];
    if(self.chatView.hidden==YES)
    {
        [self.view bringSubviewToFront:self.chatView];
        self.chatView.hidden=NO;
        //[self fetchHelpMessage];
        
    }
}

- (IBAction)myStatsBtn:(id)sender {
    
    self.pingMessageView.hidden = NO;
    if (IS_IPAD_Pro) {
        [self.pingMessageView setFrame:CGRectMake(180, 800, self.pingMessageView.frame.size.width, self.pingMessageView.frame.size.height)];
    }
    letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [self.gestureView addGestureRecognizer:letterTapRecognizer];
    [self.sideScroller bringSubviewToFront:self.gestureView];
}


- (IBAction)menuExit:(id)sender {
    if (IS_IPAD_Pro) {
        [self.exitPopUpView setFrame:CGRectMake(0, 0, 1366, 1024)];
    }else{
    [self.exitPopUpView setFrame:CGRectMake(0, 0, self.exitPopUpView.frame.size.width, self.exitPopUpView.frame.size.height)];
    }
    [self.view addSubview:self.exitPopUpView];
    
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





#pragma mark -Menu Button
- (IBAction)menuBtn:(id)sender {
    if (self.pingMessageView.hidden==NO)
    {
        self.pingMessageView.hidden = YES;
        [self.sideScroller sendSubviewToBack:self.gestureView];
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
        int pingCount =[[[NSUserDefaults standardUserDefaults ]valueForKey:@"Ping Count"]intValue];
        if (pingCount != 0) {
            self.pingNotificationBadgeImg.hidden = NO;
            self.pingNotificationBadgeLbl.hidden = NO;
            self.pingNotificationBadgeLbl.text = [NSString stringWithFormat:@"%d",pingCount];
        }else{
            self.pingNotificationBadgeImg.hidden = YES;
            self.pingNotificationBadgeLbl.hidden = YES;
        }
        
    }else{
        pt.x = 0;
        
    }
    
    pt.y =0;
    [self.sideScroller setContentOffset:pt animated:YES];
}
#pragma mark -Fetch Open Orders List
- (IBAction)openOrdersBtn:(id)sender {
    [self.view endEditing:YES];
    if (searchOrdrTxt.text.length == 0) {
        flag = 0;
    }
    [self.openBtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
    [self.deliveredbtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [self.processingBtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [btnRequest setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [self.requestCancellation setTitle:@"EDIT ORDER" forState:UIControlStateNormal];
    self.requestCancellation.hidden = NO;
    self.requestModification.hidden = NO;
    self.orderDeliveredTick.hidden = YES;
    self.arrow1.hidden = NO;
    self.arrow2.hidden = NO;
    [self pendingPlacedOrder:[NSString stringWithFormat:@"Open"]];
    StatusTag =[NSString stringWithFormat:@"Open"];
    self.orderStatus.hidden = NO;
    self.arrow3.hidden = NO;
    editOrderImage.hidden = NO;
}

#pragma mark -Fetch Delivered Orders List
- (IBAction)deliveredOrderBtn:(id)sender {
    [self.view endEditing:YES];
    if (searchOrdrTxt.text.length == 0) {
        flag = 0;
    }
    [dropDown hideDropDown:self.requestCancellation :0];
    [editOrderImage setFrame:CGRectMake(editOrderImage.frame.origin.x, 338, 9, 15)];
    editOrderImage.image = [UIImage imageNamed:@"dropdown-right.png"];
    [self rel];
    [self.openBtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [self.deliveredbtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
    [self.processingBtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [btnRequest setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    self.requestCancellation.hidden = YES;
    self.requestModification.hidden = YES;
    self.arrow1.hidden = YES;
    self.arrow2.hidden = YES;
    [self pendingPlacedOrder:[NSString stringWithFormat:@"delivered"]];
    
    StatusTag =[NSString stringWithFormat:@"delivered"];
    self.orderStatus.hidden = YES;
    self.arrow3.hidden = YES;
    editOrderImage.hidden = YES;
}

#pragma mark -Fetch Processing Orders List
- (IBAction)processingOrderBtn:(id)sender {
    [self.view endEditing:YES];
    if (searchOrdrTxt.text.length == 0) {
        flag = 0;
    }
    [dropDown hideDropDown:self.requestCancellation :0];
    [editOrderImage setFrame:CGRectMake(editOrderImage.frame.origin.x, 338, 9, 15)];
    editOrderImage.image = [UIImage imageNamed:@"dropdown-right.png"];
    [self rel];
    [self.openBtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [self.deliveredbtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [self.processingBtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
    [btnRequest setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    self.requestCancellation.hidden = YES;
    self.requestModification.hidden = YES;
    self.orderDeliveredTick.hidden = YES;
    self.arrow1.hidden = NO;
    self.arrow2.hidden = NO;
    [self pendingPlacedOrder:[NSString stringWithFormat:@"processing"]];
    StatusTag =[NSString stringWithFormat:@"processing"];
    self.orderStatus.hidden = YES;
    self.arrow3.hidden = YES;
    editOrderImage.hidden = YES;
    
}
#pragma mark -Fetch Requests

- (IBAction)btnRequest:(id)sender {
    [self.view endEditing:YES];
    if (searchOrdrTxt.text.length == 0) {
        flag = 0;
    }
    [dropDown hideDropDown:self.requestCancellation :0];
    [editOrderImage setFrame:CGRectMake(editOrderImage.frame.origin.x, 338, 9, 15)];
    editOrderImage.image = [UIImage imageNamed:@"dropdown-right.png"];
    [self rel];
    [self.openBtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [self.deliveredbtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [self.processingBtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
    [btnRequest setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
    self.requestCancellation.hidden = YES;
    self.requestModification.hidden = YES;
    self.orderDeliveredTick.hidden = YES;
    self.arrow1.hidden = NO;
    self.arrow2.hidden = NO;
    editOrderImage.hidden = YES;
    [self pendingPlacedOrder:[NSString stringWithFormat:@"request"]];
    StatusTag =[NSString stringWithFormat:@"request"];
    self.orderStatus.hidden = YES;
//    self.orderTime.hidden = YES;
//    self.orderStatusLbl.hidden = YES;
//    self.orderNumberLbl.hidden = YES;
    self.arrow3.hidden = YES;
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.orderListPopUpTableView){
        return [pendingOrderItemNameArray count];
    }else if (tableView == self.allotedTablesTableView)
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
    headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.orderTableView.frame.size.width, 80)];
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
    if (tableView == self.orderListPopUpTableView){
        return 68;
    }else if(tableView == self.allotedTablesTableView)
    {
        return 40;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == self.orderTableView)
    {
        
        if (IS_IPAD_Pro) {
            timeLbl= [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 180, 50)];
        }else{
            timeLbl= [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 180, 50)];
        }
        timeLbl.textColor= [UIColor blackColor];
        timeLbl.textAlignment      = NSTextAlignmentLeft;
        timeLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        timeLbl.lineBreakMode = NSLineBreakByCharWrapping;
        [cell.contentView addSubview:timeLbl];
        
        if (IS_IPAD_Pro) {
            tableNoLbl= [[UILabel alloc]initWithFrame:CGRectMake(265, -15, 80, 80)];
        }else{
            tableNoLbl= [[UILabel alloc]initWithFrame:CGRectMake(200, -15, 80, 80)];
        }
        
        tableNoLbl.textColor= [UIColor blackColor];
        tableNoLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        tableNoLbl.lineBreakMode = NSLineBreakByCharWrapping;
        tableNoLbl.numberOfLines = 2;
        [cell.contentView addSubview:tableNoLbl];
        
        if (IS_IPAD_Pro) {
            orderIdLbl= [[UILabel alloc]initWithFrame:CGRectMake(450, -15, 70, 80)];
        }else{
            orderIdLbl= [[UILabel alloc]initWithFrame:CGRectMake(330, -15, 70, 80)];
        }
        
        orderIdLbl.textColor= [UIColor blackColor];
        orderIdLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        orderIdLbl.lineBreakMode = NSLineBreakByCharWrapping;
        orderIdLbl.numberOfLines = 2;
        [cell.contentView addSubview:orderIdLbl];
        
        if (IS_IPAD_Pro) {
            statusLbl= [[UILabel alloc]initWithFrame:CGRectMake(562,-15, 200, 80)];
        }else{
            statusLbl= [[UILabel alloc]initWithFrame:CGRectMake(402,-15, 200, 80)];
        }
        
        statusLbl.textColor= [UIColor blackColor];
        statusLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        statusLbl.textAlignment = NSTextAlignmentCenter;
        statusLbl.lineBreakMode = NSLineBreakByCharWrapping;
        statusLbl.numberOfLines = 2;
        [cell.contentView addSubview:statusLbl];
        
        cell.backgroundColor=[UIColor clearColor];
        
        
        
        
        
        pendingOrderObj = [orderList objectAtIndex:indexPath.row];
        NSString *orderVip = [NSString stringWithFormat:@"%@",pendingOrderObj.tableType];
                if ([orderVip isEqualToString:@"VIP"]) {
                    UIImageView *vipImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.orderTableView.frame.size.width-60, 0, 60, 60)];
                    vipImg.image = [UIImage imageNamed:@"VIP.png"];
                    [cell.contentView addSubview:vipImg];
                }

        NSString *orderNumber = [NSString stringWithFormat:@"%@",self.orderNumberLbl.text];
        NSLog(@"Index path ... %lu",(unsigned long)[orderIdsArray indexOfObject:orderNumber]);
        orderNumberIndex = [NSIndexPath indexPathForRow:[orderIdsArray indexOfObject:orderNumber] inSection:0];
        NSLog(@"Index Path .. %ld",(long)orderNumberIndex.row);
        
        
        if ( indexPath.row == orderNumberIndex.row) {
            
            NSLog(@"INDEX PATH %ld",(long)indexPath.row);
            
            [cell setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2]];
            selectedIndex = indexPath;
            
        }
        if (IS_IPAD_Pro) {
            firstline= [[UILabel alloc]initWithFrame:CGRectMake(174, 0, 2, 50)];
        }else{
            firstline= [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 2, 50)];
        }
        firstline.backgroundColor= [UIColor blackColor];
        firstline.alpha = 0.3;
        [cell.contentView addSubview:firstline];
        
        if (IS_IPAD_Pro) {
            secondLine= [[UILabel alloc]initWithFrame:CGRectMake(400, 0, 2,50)];
        }else{
            secondLine= [[UILabel alloc]initWithFrame:CGRectMake(300, 0, 2,50)];
        }
        secondLine.backgroundColor= [UIColor blackColor];
        secondLine.alpha = 0.3;
        [cell.contentView addSubview:secondLine];
        
        if (IS_IPAD_Pro) {
            thirdLine= [[UILabel alloc]initWithFrame:CGRectMake(534, 0, 2, 50)];
        }else{
            thirdLine= [[UILabel alloc]initWithFrame:CGRectMake(400, 0, 2, 50)];
        }
        thirdLine.backgroundColor= [UIColor blackColor];
        thirdLine.alpha = 0.3;
        [cell.contentView addSubview:thirdLine];
        
        if (IS_IPAD_Pro) {
            bottomLine= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 898, 2)];
        }else{
            bottomLine= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 668, 2)];
        }
        bottomLine.backgroundColor= [UIColor blackColor];
        bottomLine.alpha = 0.3;
        [cell.contentView addSubview:bottomLine];
        
        
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
            if (days > 1) {
                timeStr =[NSString stringWithFormat:@"%ld DAYS AGO",(long)days];
            }else{
                timeStr =[NSString stringWithFormat:@"%ld DAY AGO",(long)days];
            }
            
        }else if (hours > 0){
            if (hours > 1) {
                timeStr =[NSString stringWithFormat:@"%ld HOURS AGO",(long)hours];
            }else{
                timeStr =[NSString stringWithFormat:@"%ld HOUR AGO",(long)hours];
            }
            
        }else{
            if (minutes > 1) {
                timeStr =[NSString stringWithFormat:@"%ld MINS AGO",(long)minutes];
            }else{
                timeStr =[NSString stringWithFormat:@"%ld MIN AGO",(long)minutes];
            }
            
        }
        

        NSString *commentStr = [NSString stringWithFormat:@"%@",[pendingOrderObj.requestData valueForKey:@"RequestType"]];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@", commentStr);
        timeLbl.text =[NSString stringWithFormat:@"%@",timeStr];
        tableNoLbl.text =[NSString stringWithFormat:@"%@",pendingOrderObj.TableName];
        orderIdLbl.text = [NSString stringWithFormat:@"%@",pendingOrderObj.OrderId];
        if (![commentStr isEqualToString:@"<null>"]) {
            if ([commentStr isEqualToString:@"cancellation"]) {
                statusLbl.text = [NSString stringWithFormat:@"Cancelation Requested"];
            }else{
                statusLbl.text = [NSString stringWithFormat:@"Modification Requested"];
            }
        }else{
        statusLbl.text = [NSString stringWithFormat:@"%@",pendingOrderObj.Status];
        }
        NSLog(@"TABLE TYPE..... %@",pendingOrderObj.tableType);
        
        //        [self.orderTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        
    }
    else if (tableView == self.orderListPopUpTableView){
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *cellBackGroundImage = [[UIImageView alloc]init];
        if (IS_IPAD_Pro) {
            cellBackGroundImage.frame = CGRectMake(5, 10, 385, 63);
        }else{
            cellBackGroundImage.frame = CGRectMake(5, 10, 290, 63);
        }
        cellBackGroundImage.backgroundColor = [UIColor whiteColor];
        cellBackGroundImage.layer.cornerRadius = 5.0;
        [cell.contentView addSubview:cellBackGroundImage];
        
        if (IS_IPAD_Pro) {
            pendingorderName= [[UILabel alloc]initWithFrame:CGRectMake(20, -10, 200, 80)];
        }else{
            pendingorderName= [[UILabel alloc]initWithFrame:CGRectMake(20, -10, 200, 80)];
        }
        pendingorderName.textColor= [UIColor blackColor];
        pendingorderName.font = [UIFont fontWithName:@"Helvetica-Condensed" size:18];
        pendingorderName.lineBreakMode = NSLineBreakByCharWrapping;
        pendingorderName.numberOfLines = 2;
        [cell.contentView addSubview:pendingorderName];
        
        if (IS_IPAD_Pro) {
            pendingOrderquantity= [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 80)];
        }else{
        pendingOrderquantity= [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 80)];
        }
        pendingOrderquantity.textColor= [UIColor blackColor];
        pendingOrderquantity.font = [UIFont fontWithName:@"Bebas Neue" size:15];
        pendingOrderquantity.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderquantity.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderquantity];
        if (IS_IPAD_Pro) {
            pendingOrderPrice= [[UILabel alloc]initWithFrame:CGRectMake(340, 0, 250, 80)];
        }else{
            pendingOrderPrice= [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 150, 80)];
        }
        pendingOrderPrice.textColor= [UIColor blackColor];
        pendingOrderPrice.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        pendingOrderPrice.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderPrice.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderPrice];
        
        NSLog(@"OrderList %@",orderList);
        
        
        pendingorderName.text =[[NSString stringWithFormat:@"%@",[pendingOrderItemNameArray objectAtIndex:indexPath.row]] uppercaseString];;
        
        
        NSString *priceStr = [NSString stringWithFormat:@"%@",[pendingOrderItemPriceArray objectAtIndex:indexPath.row]];
        
        AppDelegate*appdelegate=[[UIApplication sharedApplication]delegate];
        int p = [priceStr intValue];
        pendingOrderquantity.text =[NSString stringWithFormat:@"QTY: %@",[pendingOrderItemQuantityArray objectAtIndex:indexPath.row]];
        pendingOrderPrice.text = [NSString stringWithFormat:@"%@ %d",[[NSUserDefaults standardUserDefaults] valueForKey:@"Currency Value"],p];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }else if (tableView == self.allotedTablesTableView)
    {
        tableAllotedObj = [tableAllotedIdsArray objectAtIndex:indexPath.row];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UILabel * TablesID= [[UILabel alloc]initWithFrame:CGRectMake(0, -20, 150, 80)];
        TablesID.textColor= [UIColor blackColor];
        TablesID.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        TablesID.lineBreakMode = NSLineBreakByCharWrapping;
        TablesID.numberOfLines = 2;
        TablesID.textAlignment = NSTextAlignmentCenter;
        TablesID.text = [NSString stringWithFormat:@"%@",tableAllotedObj.tableName];
        [cell.contentView addSubview:TablesID];
        
        if ([tableAllotedObj.tableType isEqualToString:@"VIP"]) {
            UIImageView *vipImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.allotedTablesTableView.frame.size.width-48, 0, 48, 48)];
            vipImg.image = [UIImage imageNamed:@"VIP.png"];
            [cell.contentView addSubview:vipImg];
        }
        
        UILabel* bottomLineAlloted= [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 4, self.allotedTablesTableView.frame.size.width, 2)];
        bottomLineAlloted.backgroundColor= [UIColor blackColor];
        bottomLineAlloted.alpha = 0.3;
        [cell.contentView addSubview:bottomLineAlloted];
        cell.backgroundColor = [UIColor clearColor];
        
        
    }
    
    
    return cell;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView == self.orderTableView) {
        //        [[self.orderListPopUpTableView layer] setBorderColor:[[UIColor grayColor] CGColor]];
        //        [[self.orderListPopUpTableView layer] setBorderWidth:1.0];
        //        [[self.orderListPopUpTableView layer] setCornerRadius:5];
        NSLog(@"INDEX PAth ..... %ld",(long)indexPath.row);
        [self showOrder:indexPath];
        
    }else if (tableView == self.allotedTablesTableView)
    {
        tableAllotedObj = [tableAllotedIdsArray objectAtIndex:indexPath.row];
        
        [self.view bringSubviewToFront:self.chatView];
        self.chatView.hidden=NO;
        self.tableNumberChatLbl.text = [NSString stringWithFormat:@"%@",tableAllotedObj.tableName];
        NSLog(@"Tables Alloted.... %d",tableAllotedObj.tableId);
        if ([assignedTablesArray containsObject:[NSString stringWithFormat:@"%d",tableAllotedObj.tableId]]) {
            tableSelected = [NSString stringWithFormat:@"%d", tableAllotedObj.tableId];
            
            
            
            
        }
    }
    
    
    
    UITableViewCell *cell1;
    if (selectedIndex != Nil) {
        cell1 = [tableView cellForRowAtIndexPath:selectedIndex];
        [cell1 setBackgroundColor:[UIColor clearColor]];
    }
    
    
    if ([cell selectionStyle] == UITableViewCellSelectionStyleNone) {
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2]];
    }
    
    //    UITableViewCell *cell2;
    //    if (orderIndex != Nil) {
    //        cell2 = [tableView cellForRowAtIndexPath:orderIndex];
    //        [cell2 setBackgroundColor:[UIColor clearColor]];
    //    }
    
    selectedIndex = indexPath;
    
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
#pragma mark -Fetch PopUp Orders
-(void)pendingOrderItems:(int)index
{
    pendingOrderObj = [orderList objectAtIndex:index];
    
    pendingOrderItemNameArray = [[NSMutableArray alloc] initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"itemname"]];
    pendingOrderItemPriceArray = [[NSMutableArray alloc] initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"price"]];
    pendingOrderItemQuantityArray = [[NSMutableArray alloc]initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"quantity"]];
    pendingOrderTimeOfDeliveryArray = [[NSMutableArray alloc]initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"TimeOfDelivery"]];
    NSLog(@"Pending Order Items %@",pendingOrderItemNameArray);
    NSLog(@"Pending Order Item Price %@",pendingOrderItemPriceArray);
    NSLog(@"Pending Order Item Quantity %@",pendingOrderItemQuantityArray);
    NSLog(@"Pending Order Total Price %@",pendingOrderObj.TotalBill);
    NSLog(@"Pending Order TimeOfDelivery%@",pendingOrderTimeOfDeliveryArray);
    [self.orderListPopUpTableView reloadData];
    
    
}
#pragma mark -Fetch orders
-(void)pendingPlacedOrder: (NSString *)ordertype
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *staffId;
    NSString *tableId;
    NSString *OrderType;
    NSString *TriggerValue;
    
    if (staffId == nil) {
        staffId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Service Provider ID"]];
    }
    if (tableId == nil) {
        tableId = [NSString stringWithFormat:@""];
    }
    if (OrderType == nil) {
        OrderType = [NSString stringWithFormat:@"%@",ordertype];
    }
    if (TriggerValue == nil) {
        TriggerValue = [NSString stringWithFormat:@"serviceprovider"];
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
#pragma mark - Change Status

-(void) changeStatus:(NSString *) pendingOrdersIDS : (NSString *) changingOrderStatus
{
    [self disabled];
    [activityIndicator startAnimating];
    NSDate *startTime;
    
    startTime = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *curruntTime = [ dateFormat stringFromDate:startTime];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:pendingOrdersIDS,@"OrderId",changingOrderStatus, @"Status",curruntTime,@"Datetime", nil];
    
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
    webServiceCode =2;
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

-(void) fetchStats: (NSString *)spId
{
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:spId,@"serviceproviderid", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetMyStats",Kwebservices]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =5;
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
-(void)requestModification:(NSString*) requestType : (NSString*) commentText
{
    [self disabled];
    [activityIndicator startAnimating];
    NSString *orderid;
    NSString *requesttype;
    NSString *comments;
    
    if (orderid == nil) {
        orderid = [NSString stringWithFormat:@"%@",self.orderNumberLbl.text];
    }
    if (requesttype == nil) {
        requesttype = [NSString stringWithFormat:@"%@",requestType];
    }
    if (comments == nil) {
        comments = [NSString stringWithFormat:@"%@",commentText];
    }
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    
    [dateformate setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:orderid,@"orderid",requesttype, @"requesttype",comments,@"comments",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"],@"EventId",date_String,@"datetimeoforder", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RequestModification",Kwebservices]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =6;
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
    [self enable];
    [activityIndicator stopAnimating];
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
    if (webServiceCode == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        [savDataArray removeAllObjects];
        orderList = [[NSMutableArray alloc]init];
        orderIdsArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *pendingOrdersList;
        pendingOrdersList = [[NSMutableArray alloc]initWithArray:[userDetailDict valueForKey:@"ListPendingOrder"]];
        
        
        if(pendingOrdersList.count != 0){
            NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"maxtimestamp"]];
            [defaults setObject:resultStr forKey:@"fetchOrderTimeStamp"];
            
        for (int i = 0; i < [pendingOrdersList count]; i ++) {
            pendingOrderObj = [[pendingOrdersOC alloc] init];
            pendingOrderObj.DateTimeOfOrder = [[pendingOrdersList valueForKey:@"DateTimeOfOrder"] objectAtIndex:i];
            pendingOrderObj.LastUpdate = [[pendingOrdersList valueForKey:@"LastUpdate"] objectAtIndex:i];
            pendingOrderObj.OrderId = [[pendingOrdersList valueForKey:@"OrderId"]objectAtIndex:i];
            pendingOrderObj.RestaurantId = [[pendingOrdersList valueForKey:@"RestaurantId"] objectAtIndex:i];
            pendingOrderObj.TableName = [[pendingOrdersList valueForKey:@"TableName"] objectAtIndex:i];
            pendingOrderObj.Status = [[pendingOrdersList valueForKey:@"Status"]objectAtIndex:i];
            pendingOrderObj.TableId = [[pendingOrdersList valueForKey:@"TableName"] objectAtIndex:i];
            pendingOrderObj.TimeOfDelivery = [[pendingOrdersList valueForKey:@"TimeOfDelivery"]objectAtIndex:i];
            pendingOrderObj.TotalBill = [[pendingOrdersList valueForKey:@"TotalBill"]objectAtIndex:i];
            pendingOrderObj.pendingOrderDetails = [[pendingOrdersList valueForKey:@"ListOrderDetails"] objectAtIndex:i];
            pendingOrderObj.lastUpdatedTime = [[pendingOrdersList valueForKey:@"LastUpdate"]objectAtIndex:i];
            pendingOrderObj.tableType = [[pendingOrdersList valueForKey:@"TableType"]objectAtIndex:i];
            pendingOrderObj.note = [[pendingOrdersList valueForKey:@"Notes"]objectAtIndex:i];
            pendingOrderObj.requestData = [[pendingOrdersList valueForKey:@"ChangeRequestData"]objectAtIndex:i];
            NSLog(@"TABLE TYPE.... %@",pendingOrderObj.tableType);
            
            [orderList addObject:pendingOrderObj];
            [orderIdsArray addObject:pendingOrderObj.OrderId];
            
            [savDataArray addObject:pendingOrderObj];
        }
            
            
           
            
            
            }
        if ([orderList count] != 0) {
            self.orderNumberLbl.hidden = NO;
            self.spNotesTextView.hidden = NO;
            emptyOrderLbl.hidden = YES;

        }else{
             pendingOrderObj = [[pendingOrdersOC alloc] init];
            self.orderTime.hidden = YES;
            self.orderDeliveredTick.hidden = YES;
            self.orderStatusLbl.hidden = YES;
            self.orderNumberLbl.hidden = YES;
            pendingOrderItemNameArray = [[NSMutableArray alloc] init];
            pendingOrderItemPriceArray = [[NSMutableArray alloc] init];
            pendingOrderItemQuantityArray = [[NSMutableArray alloc]init];
            pendingOrderTimeOfDeliveryArray = [[NSMutableArray alloc]init];
            
             [self.orderListPopUpTableView reloadData];
            requestLbl.text=nil;

                self.orderStatus.hidden = YES;
                self.requestCancellation.hidden = YES;
                self.requestModification.hidden = YES;
            self.spNotesTextView.hidden = YES;
            [self showPopUpLabel];
        }
        [self scrollToTop];
        
        [self chatTable];
        NSLog(@"Order List %@",orderList);
        
         [self.orderTableView reloadData];
        if (searchOrdrTxt.text.length!=0) {
            [self searchAutocompleteEntriesWithSubstring:searchOrdrTxt.text];

        }
        else{
             if ([orderList count] != 0)
             {
                 [self showOrder:0];

             }
        }
        NSString *serviceProviderId = [defaults valueForKey:@"Service Provider ID"];
        [self fetchStats:serviceProviderId];
        //        else if ([StatusTag isEqualToString:@"processing"] || [StatusTag isEqualToString:@"delivered"])
        //        {
        //            orderList = [[[orderList reverseObjectEnumerator] allObjects] mutableCopy];
        //            orderIdsArray = [[[orderIdsArray reverseObjectEnumerator] allObjects] mutableCopy];
        //        }
        
    }else if (webServiceCode == 2){
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
       
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
        
        if ([StatusTag isEqualToString:@"Open"]) {
            [self pendingPlacedOrder:[NSString stringWithFormat:@"processing"]];
            StatusTag =[NSString stringWithFormat:@"processing"];
            [self.openBtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
            [self.deliveredbtn setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
            [self.processingBtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
            self.orderStatus.hidden = YES;
            self.requestCancellation.hidden = NO;
            self.requestModification.hidden = NO;
            self.orderDeliveredTick.hidden = YES;
            self.arrow1.hidden = NO;
            self.arrow2.hidden = NO;
            self.arrow3.hidden = YES;
            self.orderStatusLbl.text = [NSString stringWithFormat:@"ORDER WAS ACCEPTED."];
            self.orderTime.text = [NSString stringWithString:timeStr];
        }
    
//                }else if([StatusTag isEqualToString:@"processing"])
//                {
        //            [self.orderStatus setTitle:@"ReOpen" forState:UIControlStateNormal];
        //            self.requestCancellation.hidden = YES;
        //            self.requestModification.hidden = YES;
        //            self.arrow1.hidden = YES;
        //            self.arrow2.hidden = YES;
        //            self.orderDeliveredTick.hidden = NO;
        //            self.orderStatusLbl.text = [NSString stringWithFormat:@"Order Delivered"];
        //            self.orderTime.text = [NSString stringWithFormat:@"at %@",curruntTime];
        //            [self.orderStatusLbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
        //            [self.orderTime setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
        //            [self.openBtn setBackgroundColor:[UIColor clearColor]];
        //            [self.processingBtn setBackgroundColor:[UIColor clearColor]];
        //            [self.deliveredbtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.1]];
        //            [self pendingPlacedOrder:[NSString stringWithFormat:@"delivered"]];
        //            StatusTag =[NSString stringWithFormat:@"delivered"];
        //
        //        }else if ([StatusTag isEqualToString:@"delivered"])
        //        {
        //            [self.deliveredbtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.1]];
        //            [self pendingPlacedOrder:orderTypeStr];
        //        }
        
    }else if (webServiceCode == 3){
       
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        //        NSString *orderTypeStr =[NSString stringWithFormat:@"%@",StatusTag];
        //        [self pendingPlacedOrder:orderTypeStr];
    }else if (webServiceCode == 4){
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
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
        //        NSString *orderTypeStr =[NSString stringWithFormat:@"%@",StatusTag];
        //        [self pendingPlacedOrder:orderTypeStr];
        NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"maxtimestamp"]];
        [defaults setObject:resultStr forKey:@"Service Provider Incoming Chat Timestamp"];
        fetchingChat = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"MessageList"]];
        NSMutableArray *tablesOfSP = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"TableList"]];
        for (int i = 0; i < [tablesOfSP count]; i ++) {
            tableAllotedObj = [[tableAllotedOC alloc]init];
            tableAllotedObj.tableId = [[tablesOfSP valueForKey:@"TableList"] objectAtIndex:i];
            [tablesList addObject:[NSString stringWithFormat:@"%d",tableAllotedObj.tableId]];
        }
        NSString *serviceProviderId = [defaults valueForKey:@"Service Provider ID"];
        [self fetchStats:serviceProviderId];
    }
    
    else if (webServiceCode == 5){
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        if (self.statsPopUpView.hidden == YES) {
            self.statsPopUpView.hidden = NO;
        }else{
            self.statsPopUpView.hidden = YES;
        }
        
        self.deliveredStatLbl.text = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"orderdeliverd"]];
        self.inProcessStatLbl.text = [NSString stringWithFormat:@"%@", [ userDetailDict valueForKey:@"orderinprocess"]];
        self.pendingStatLbl.text = [NSString stringWithFormat:@"%@", [ userDetailDict valueForKey:@"orderpending"]];
        self.deliveredStatLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        self.inProcessStatLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        self.pendingStatLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        self.orderDeliveryTitleLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        self.orderInProcessTitleLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        self.orderPendingTitleLbl.font = [UIFont fontWithName:@"Bebas Neue" size:18];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"orderdeliverd"]] forKey:@"Delivery Stats"];
        [defaults setValue:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"orderinprocess"]] forKey:@"Process Stats"];
        [defaults setValue:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"orderpending"]] forKey:@"Pending Stats"];
       
        
    }else if (webServiceCode == 6){
        [self.view endEditing:YES];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *successResult = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"result"]];
        if ([successResult isEqualToString:@"0"]) {
            NSString *alertMessage;
           
            if (isCancellation) {
                alertMessage = [NSString stringWithFormat:@"YOUR REQUEST FOR CANCELLATION HAS BEEN SUBMITTED."];
            }else if (isModification){
                alertMessage = [NSString stringWithFormat:@"YOUR REQUEST FOR MODIFICATION HAS BEEN SUBMITTED."];
            }
            self.requestMessage.text = [NSString stringWithString:alertMessage];
            [self.requestPopUpView setFrame:CGRectMake(0, 0, self.requestPopUpView.frame.size.width, self.requestPopUpView.frame.size.height)];
            [self.view addSubview:self.requestPopUpView];
        }
        isCancellation = NO;
        isModification = NO;
        [self.openBtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
        [self.deliveredbtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
        [self.processingBtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
        [btnRequest setBackgroundImage:[UIImage imageNamed:@"checkoutselect.png"] forState:UIControlStateNormal];
        self.requestCancellation.hidden = YES;
        self.requestModification.hidden = YES;
        self.orderDeliveredTick.hidden = YES;
        editOrderImage.hidden = YES;
        self.arrow1.hidden = NO;
        self.arrow2.hidden = NO;
        [self pendingPlacedOrder:[NSString stringWithFormat:@"request"]];
        StatusTag =[NSString stringWithFormat:@"request"];
        self.orderStatus.hidden = YES;
        //    self.orderTime.hidden = YES;
        //    self.orderStatusLbl.hidden = YES;
        //    self.orderNumberLbl.hidden = YES;
        self.arrow3.hidden = YES;
        
    }else if (webServiceCode == 9){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        int chatCount = 0;
        int updatedChatCount = 0;
        [defaults setValue:[userDetailDict valueForKey:@"ordercount"] forKey:@"Order Count"];
        [defaults setValue:[userDetailDict valueForKey:@"pingcount"] forKey:@"Ping Count"];
        [defaults setValue:[userDetailDict valueForKey:@"tableListCount"] forKey:@"SPChat Count"];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"SPChat Count"]);
        NSString *chatCountStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"SPChat Count"]];
        NSArray *chatCountArray = [chatCountStr componentsSeparatedByString:@","];
        for (int k = 0; k < [chatCountArray count]; k++) {
             chatCount= [[chatCountArray objectAtIndex:k] intValue];
            updatedChatCount = updatedChatCount + chatCount;
            
        }
        [defaults setValue:[NSString stringWithFormat:@"%d",updatedChatCount] forKey:@"UpdatedChat Count"];
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
        [self pendingPlacedOrder:[NSString stringWithFormat:@"Open"]];
        [self viewWillAppear:YES];
    }
    if (tableSelected != nil) {
        
    }
    
    [self enable];
    [activityIndicator stopAnimating];
}
- (void)highlightLetter:(UITapGestureRecognizer*)sender
{
    self.pingMessageView.hidden = YES;
    [self.sideScroller sendSubviewToBack:self.gestureView];
    
}

#pragma mark -Process Indicators
- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    self.disabledImgView.hidden = NO;
    [self.view sendSubviewToBack:self.disabledImgView];
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    self.disabledImgView.hidden = YES;
    [self.view bringSubviewToFront:self.disabledImgView];
}
#pragma mark - Confirm Order Button
- (IBAction)confirmOrderBtn:(id)sender {
    NSString *orderIdStr = [NSString stringWithFormat:@"%@",self.orderNumberLbl.text];
    if ([StatusTag isEqualToString:@"Open"]) {
        NSString *orderStatus = [NSString stringWithFormat:@"processing"];
        [self changeStatus:orderIdStr :orderStatus];
    }else if ([StatusTag isEqualToString:@"processing"])
    {
        NSString *orderStatus = [NSString stringWithFormat:@"delivered"];
        [self changeStatus:orderIdStr :orderStatus];
    }
    
    
    
}
- (IBAction)orderListPopUpcloseBtn:(id)sender {
    self.orderListPopUp.hidden = YES;
}

#pragma mark - Send Button
- (IBAction)sendChatMessage:(id)sender {
    
    [self.chatMessageTxtView resignFirstResponder];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == self.chatMessageTxtView) {
        CGPoint pt;
        
        pt.x = self.chatView.frame.origin.x;
        pt.y = self.chatView.frame.origin.y - 385;
        [self.chatView setFrame:CGRectMake(pt.x, pt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView== self.chatMessageTxtView)
    {
        [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    }
    [textView resignFirstResponder];
    
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    if (textView== self.chatMessageTxtView)
    {
        [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    }
    [textView resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"user editing");
    if([text isEqualToString:@"\n"])
    {
        [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
        [textView resignFirstResponder];
    }
    return YES;
}
- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    
}

- (IBAction)minimizeBtn:(id)sender {
    if (isMinimized) {
        isMinimized = NO;
        [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    }else{
        CGPoint pt;
        isMinimized = YES;
        NSLog(@"Height of View .... %f", self.chatView.frame.size.height);
        pt.x = self.chatView.frame.origin.x;
        pt.y = self.chatView.frame.origin.y + self.chatView.frame.size.height - 33;
        [self.chatView setFrame:CGRectMake(pt.x, pt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    }
}

- (IBAction)doneBtn:(id)sender {
    self.statsPopUpView.hidden = YES;
}
#pragma mark - Text field Delegates


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    [textField resignFirstResponder];
    
    return  YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    // orderList=[savDataArray mutableCopy];
    NSString *substring;
    substring = [NSString stringWithString:searchOrdrTxt.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    
    if (substring.length==0)
    {
        orderList=[savDataArray mutableCopy];
    }
    
    [self searchAutocompleteEntriesWithSubstring:substring];
    
    
    
    return  YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    
    [orderIdtempArray removeAllObjects];
    
    for(pendingOrderObj in savDataArray)
    {
        
        NSString *orderIdStr = pendingOrderObj.OrderId ;
        NSString *tableIdStr = pendingOrderObj.TableId ;
        NSArray *itemPlacedArray = [pendingOrderObj.pendingOrderDetails  valueForKey:@"itemname"];
        NSMutableArray *tableItemArray = [[NSMutableArray alloc] init];
        NSRange tableItemRange;
        for (int i = 0; i < itemPlacedArray.count; i++) {
            NSString *tableItem =[NSString stringWithFormat:@"%@",[itemPlacedArray objectAtIndex:i]] ;
            tableItemRange = [[tableItem lowercaseString] rangeOfString:[substring lowercaseString]];
            if (tableItemRange.location==0) {
                [tableItemArray addObject:tableItem];
            }
            
        }
        NSLog(@" OrderIds = %@, TableIds = %@", orderIdStr,tableIdStr);
        NSRange orderIdStringRange = [orderIdStr rangeOfString:substring];
        NSRange tableIdStringRange = [tableIdStr rangeOfString:substring];
      
        
        if (orderIdStringRange.location == 0 ||  tableIdStringRange.location==0 || tableItemArray.count > 0)
        {
            
            [orderIdtempArray addObject:pendingOrderObj];
        }
    }
    
    if (substring.length>0) {
        [orderList removeAllObjects];
        orderList =[orderIdtempArray mutableCopy];
    }
   
    
    
    flag = 1;
    if (orderList.count == 0) {
        [self showPopUpLabel];
    }else{
        emptyOrderLbl.hidden = YES;
    }
    [self.orderTableView reloadData];
    if (orderList.count>0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.orderTableView cellForRowAtIndexPath:path];
        [cell setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2]];
        selectedIndex = 0;
        self.orderNumberLbl.hidden = NO;
        [self showOrder:0];
    } else{
        pendingOrderObj = [[pendingOrdersOC alloc] init];
        self.orderTime.hidden = YES;
        self.orderDeliveredTick.hidden = YES;
        self.orderStatusLbl.hidden = YES;
        self.orderNumberLbl.hidden = YES;
        pendingOrderItemNameArray = [[NSMutableArray alloc] init];
        pendingOrderItemPriceArray = [[NSMutableArray alloc] init];
        pendingOrderItemQuantityArray = [[NSMutableArray alloc]init];
        pendingOrderTimeOfDeliveryArray = [[NSMutableArray alloc]init];
        
        [self.orderListPopUpTableView reloadData];
        requestLbl.text=nil;
        self.orderStatus.hidden = YES;
        self.requestCancellation.hidden = YES;
        self.requestModification.hidden = YES;
        self.spNotesTextView.hidden = YES;
        
    }

}
- (IBAction)cancelationBtn:(id)sender
{
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Request Cancelation", @"Request Modification", @"Mark In Process",nil];
    if(dropDown == nil) {
        [editOrderImage setFrame:CGRectMake(editOrderImage.frame.origin.x, editOrderImage.frame.origin.y+5, 15, 9)];
        editOrderImage.image = [UIImage imageNamed:@"dropdown-downWhite.png"];
        CGFloat f = arr.count * 40;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :@"down"];
        dropDown.delegate = self;
    }
    else {
        [editOrderImage setFrame:CGRectMake(editOrderImage.frame.origin.x, editOrderImage.frame.origin.y-5, 9, 15)];
        editOrderImage.image = [UIImage imageNamed:@"dropdown-right.png"];
        [dropDown hideDropDown:sender :1];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender :(NSString *)buttonTitle {
    [editOrderImage setFrame:CGRectMake(editOrderImage.frame.origin.x, editOrderImage.frame.origin.y-5, 9, 15)];
    editOrderImage.image = [UIImage imageNamed:@"dropdown-right.png"];
    NSLog(@"%@",buttonTitle);
    if ([buttonTitle isEqualToString:@"REQUEST MODIFICATION"]||[buttonTitle isEqualToString:@"REQUEST CANCELATION"]) {
        if (self.orderNumberLbl.text == nil) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OPHEMY" message:@"YOU ARE HAVING NO ORDER FOR MODIFICATION" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            if (self.modificationPopUpView.hidden == YES) {
                modificationRequestCloseBtn.layer.borderColor = [UIColor blackColor].CGColor;
                modificationRequestCloseBtn.layer.borderWidth = 1.0;
                modificationRequestCloseBtn.layer.cornerRadius = 12.0;
                self.modificationPopUpView.hidden = NO;
                [self.view bringSubviewToFront:self.modificationPopUpView];
                [self.sideScroller setUserInteractionEnabled:NO];
                [[self.modificationTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
                [[self.modificationTextView layer] setBorderWidth:1.0];
                [[self.modificationTextView layer] setCornerRadius:5];
                
                if ([buttonTitle isEqualToString:@"REQUEST MODIFICATION"]) {
                    isModification = YES;
                    self.modificationPopUpTitle.text = [NSString stringWithFormat:@"Add reason for Modification."];
                    [self.confirmModification setTitle:@"Request Modification" forState:UIControlStateNormal];
                }else{
                    isCancellation = YES;
                    self.modificationPopUpTitle.text = [NSString stringWithFormat:@"Add reason for Cancelation."];
                    [self.confirmModification setTitle:@"Request Cancelation" forState:UIControlStateNormal];
                }
            }else{
                self.modificationPopUpView.hidden = YES;
                [self.view sendSubviewToBack:self.modificationPopUpView];
            }
        }
    }else{
        NSString *orderIdStr = [NSString stringWithFormat:@"%@",self.orderNumberLbl.text];
        if ([StatusTag isEqualToString:@"Open"]) {
            NSString *orderStatus = [NSString stringWithFormat:@"processing"];
            [self changeStatus:orderIdStr :orderStatus];
        }
    }
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (IBAction)confirmModificationBtn:(id)sender {
    [self.view endEditing:YES];
    if ([self.modificationTextView.text isEqualToString:@""]) {
        self.enterReasonLbl.hidden = NO;
    }else{
    if (isCancellation) {
        [self requestModification:[NSString stringWithFormat:@"cancellation"] :[NSString stringWithFormat:@"%@",self.modificationTextView.text]];
        
    }else if (isModification){
        [self requestModification:[NSString stringWithFormat:@"modification"] :[NSString stringWithFormat:@"%@",self.modificationTextView.text]];
    }
        self.enterReasonLbl.hidden = YES;
     self.modificationTextView.text = @"";
    self.modificationPopUpView.hidden = YES;
    [self.view sendSubviewToBack:self.modificationPopUpView];
    }
}
- (IBAction)requestPopUpClose:(id)sender {
    [self enable];
    [activityIndicator stopAnimating];
    self.enterReasonLbl.hidden = YES;
    self.modificationPopUpView.hidden = YES;
    [self.sideScroller setUserInteractionEnabled:YES];
    self.modificationTextView.text = @"";
    [self.modificationTextView resignFirstResponder];
    [self.view sendSubviewToBack:self.modificationPopUpView];
}
- (IBAction)requestAssistance:(id)sender {
    spRequestAssistanceViewController *spRequestVC = [[spRequestAssistanceViewController alloc] initWithNibName:@"spRequestAssistanceViewController" bundle:nil];
    
    [self.navigationController pushViewController:spRequestVC animated:NO];
}
- (IBAction)pingAssistance:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Ping Count"] ;
    self.pingNotificationBadgeImg.hidden = YES;
    self.pingNotificationBadgeImg.hidden = YES;
    spPingAssistanceViewController *spRequestVC = [[spPingAssistanceViewController alloc] initWithNibName:@"spPingAssistanceViewController" bundle:nil];
    
    [self.navigationController pushViewController:spRequestVC animated:NO];
}
-(void)showOrder:(NSIndexPath *)indexPath
{
    NSLog(@"INDEX PAth on show Order ..... %ld",(long)indexPath.row);
    pendingOrderObj = [orderList objectAtIndex:indexPath.row];
    self.orderListPopUp.hidden = NO;
    NSString *totalStr = [NSString stringWithFormat:@"%@",pendingOrderObj.TotalBill];
    int p = [totalStr intValue];
    AppDelegate*appdelegate=[[UIApplication sharedApplication]delegate];

    self.orderPopUpTotalBill.text = [NSString stringWithFormat:@"%@ %d",[[NSUserDefaults standardUserDefaults] valueForKey:@"Currency Value"],p];
    self.orderNumberLbl.text = [NSString stringWithFormat:@"%@",pendingOrderObj.OrderId];
    self.spNotesTextView.text = [NSString stringWithFormat:@"%@",pendingOrderObj.note];
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
        if (days > 1) {
            timeStr =[NSString stringWithFormat:@"%ld DAYS AGO",(long)days];
        }else{
            timeStr =[NSString stringWithFormat:@"%ld DAY AGO",(long)days];
        }
        
    }else if (hours > 0){
        if (hours > 1) {
            timeStr =[NSString stringWithFormat:@"%ld HOURS AGO",(long)hours];
        }else{
            timeStr =[NSString stringWithFormat:@"%ld HOUR AGO",(long)hours];
        }
        
    }else{
        if (minutes > 1) {
            timeStr =[NSString stringWithFormat:@"%ld MINS AGO",(long)minutes];
        }else{
            timeStr =[NSString stringWithFormat:@"%ld MIN AGO",(long)minutes];
        }
        
    }
    
    if ([StatusTag isEqualToString:@"Open"]) {
        [self.orderStatus setTitle:@"EDIT ORDER" forState:UIControlStateNormal];
        self.requestCancellation.hidden = NO;
        self.requestModification.hidden = NO;
        self.orderDeliveredTick.hidden = YES;
        self.arrow1.hidden = NO;
        self.arrow2.hidden = NO;
        requestLbl.hidden = YES;
        self.orderStatusLbl.hidden = NO;
        self.orderTime.hidden = NO;
        editOrderImage.hidden = NO;
        self.orderStatusLbl.text = [NSString stringWithFormat:@"ORDER WAS PLACED."];
        self.orderTime.text = [NSString stringWithString:timeStr];
    }else if([StatusTag isEqualToString:@"processing"])
    {
        [self.orderStatus setTitle:@"Mark As Delivered" forState:UIControlStateNormal];
        self.requestCancellation.hidden = YES;
        self.requestModification.hidden = YES;
        self.orderDeliveredTick.hidden = YES;
        self.arrow1.hidden = NO;
        self.arrow2.hidden = NO;
        requestLbl.hidden = YES;
        self.orderStatusLbl.hidden = NO;
        self.orderTime.hidden = NO;
        editOrderImage.hidden = YES;
        self.orderStatusLbl.text = [NSString stringWithFormat:@"ORDER WAS ACCEPTED."];
        self.orderTime.text = [NSString stringWithString:timeStr];
    }else if ([StatusTag isEqualToString:@"delivered"])
    {
        [self.orderStatus setTitle:@"ReOpen" forState:UIControlStateNormal];
        self.requestCancellation.hidden = YES;
        self.requestModification.hidden = YES;
        self.arrow1.hidden = YES;
        self.arrow2.hidden = YES;
        requestLbl.hidden = YES;
        self.orderDeliveredTick.hidden = NO;
        self.orderStatusLbl.hidden = NO;
        self.orderTime.hidden = NO;
        editOrderImage.hidden = YES;
        self.orderStatusLbl.text = [NSString stringWithFormat:@"ORDER DELIVERED"];
        
        self.orderTime.text = [NSString stringWithFormat:@"%@",timeStr];
        
        
    }
    else if ([StatusTag isEqualToString:@"request"])
    {
        self.orderStatus.hidden = YES;
        self.requestCancellation.hidden = YES;
        self.requestModification.hidden = YES;
        self.arrow1.hidden = YES;
        self.arrow2.hidden = YES;
        self.orderDeliveredTick.hidden = YES;
        self.orderStatusLbl.hidden = YES;
        self.orderTime.hidden = YES;
        self.orderStatusLbl.hidden = YES;
        editOrderImage.hidden = YES;
        NSLog(@"%@",[pendingOrderObj.requestData valueForKey:@"Comments"]);
        NSString *commentStr = [NSString stringWithFormat:@"%@",[pendingOrderObj.requestData valueForKey:@"Comments"]];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        commentStr = [commentStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        requestLbl.hidden = NO;
        NSString *resonTitle = @"Reason";
        NSString *yourString = [NSString stringWithFormat:@"%@ - %@",resonTitle,commentStr];
        //  NSString *yourString = [NSString stringWithFormat:@"%@ by R.R. Kumar",eventName];
        NSMutableAttributedString *yourAttributedString = [[NSMutableAttributedString alloc] initWithString:yourString];
        NSString *boldString = [NSString stringWithFormat:@"%@",resonTitle];
        //    NSString *boldString = [NSString stringWithFormat:@"R.R. Kumar"];
        NSRange boldRange = [yourString rangeOfString:boldString];
        [yourAttributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16] range:boldRange];
        [requestLbl setAttributedText: yourAttributedString];
       
    }
    [self pendingOrderItems:indexPath.row];
    
}
-(void) scrollToTop
{
    if ([self numberOfSectionsInTableView:self.orderTableView] > 0)
    {
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
        [self.orderTableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
-(void) fetchMessageCount:(NSString *) assignedTable
{
    //    [self disabled];
    //    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    assignedTableTimestampsArray = [[NSMutableArray alloc] init];
    NSString *timeStamp;
    for(int i = 0; i < [assignedTablesArray count]; i++){
        timeStampKey = [NSString stringWithFormat:@"%@_TimeStamp",[assignedTablesArray objectAtIndex:i]];
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
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"\\"withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"\""withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@")"withString:@""];
    timeStampList = [timeStampList stringByReplacingOccurrencesOfString:@"("withString:@""];
    timeStampList = [timeStampList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *orderTimeStamp = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"fetchOrderTimeStamp"]];
    if ([orderTimeStamp isEqualToString:@"(null)"]) {
        orderTimeStamp = [NSString stringWithFormat:@""];
    }
    NSString *ids = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Service Provider ID"]];
    NSString *user =[NSString stringWithFormat:@"serviceprovider"];
    NSString *pingTimeStamp = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"pingTimeStamp"]];
    if ([pingTimeStamp isEqualToString:@"(null)"]) {
        pingTimeStamp = [NSString stringWithFormat:@""];
    }
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:assignedTableList,@"assignedTableList",timeStampList,@"timestampConversation",user, @"trigger",ids, @"id",orderTimeStamp, @"timestampOrder",pingTimeStamp,@"pingTimeStamp", nil];
    
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
    webServiceCode = 9;
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
- (IBAction)exitYesAction:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    [appdelegate logout];
   
}

- (IBAction)exitNoAction:(id)sender {
    [self.exitPopUpView removeFromSuperview];
}

- (IBAction)OkAction:(id)sender {
    [self.requestPopUpView removeFromSuperview];
    [self.sideScroller setUserInteractionEnabled:YES];
}
-(void)showPopUpLabel{
  
        emptyOrderLbl.hidden = NO;
        if(flag == 0){
            emptyOrderLbl.text = @"No Result found.";
            NSLog(@"No result found");
        }
        else{
            emptyOrderLbl.text = @"No search result found.";
            NSLog(@"No search result found");
        }

}
@end
