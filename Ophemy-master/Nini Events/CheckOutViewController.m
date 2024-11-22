
#import "CheckOutViewController.h"
#import "orderOC.h"
#import "OrderTableViewCell.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "appHomeViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "menuStateViewController.h"
#import "NSData+Base64.h"
@interface CheckOutViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bottomMenuImg;
@property (strong, nonatomic) IBOutlet UIView *bottomMenuView;
@property (strong, nonatomic) IBOutlet UIView *ophemyLogoView;
@property (strong, nonatomic) IBOutlet UIButton *slideMenuBtn;
@property (strong, nonatomic) IBOutlet UIButton *pingBtn;
@end

@implementation CheckOutViewController

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
    

    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
    }
    else{
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    self.notesTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.notesTextView.layer.borderWidth = 1.0;
    self.notesTextView.layer.cornerRadius = 5.0;
    [self.notesTextView setClipsToBounds:YES];
    orderList=[[NSMutableArray alloc]init];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (IS_IPAD_Pro) {
        activityIndicator.center = CGPointMake(1366/2, 1028/2);
    }else{
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
   
    
    activityIndicator.color=[UIColor grayColor];
    [self.view addSubview:activityIndicator];
    
    self.orderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    NSString *freeTag = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Is Paid"]];
    if ([freeTag isEqualToString:@"1"]) {
        priceingView.hidden = YES;
        [self.checkOutBtn setFrame:CGRectMake(self.checkOutBtn.frame.origin.x, self.checkOutBtn.frame.origin.y - 160, self.checkOutBtn.frame.size.width, self.checkOutBtn.frame.size.height)];
        [checkoutPriceDetailView addSubview:self.checkOutBtn];
        
    }else{
        priceingView.hidden = NO;
    }
    [self fetchOrders];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    placeholderText = @"Please describe yourself for easy identification by your server example: lady in black dress & pearls. Also include any instructions for your order you’d like us to follow";
    isPlaceholder = YES;
    self.notesTextView.text = placeholderText;
    self.notesTextView.textColor = [UIColor lightGrayColor];
    [self.notesTextView setSelectedRange:NSMakeRange(0, 0)];
    
    // assign UITextViewDelegate
    self.notesTextView.delegate = self;
}
//- (void) textViewDidChange:(UITextView *)textView{
//    
//    if (textView.text.length == 0){
//        textView.textColor = [UIColor lightGrayColor];
//        textView.text = placeholderText;
//        [textView setSelectedRange:NSMakeRange(0, 0)];
//        isPlaceholder = YES;
//        
//    } else if (isPlaceholder && ![textView.text isEqualToString:placeholderText]) {
//        textView.text = [textView.text substringToIndex:1];
//        textView.textColor = [UIColor blackColor];
//        isPlaceholder = NO;
//    }
//    
//}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = [textView.text substringToIndex:0];
    textView.textColor = [UIColor blackColor];
    isPlaceholder = NO;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if(self.notesTextView.text.length==0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = placeholderText;
        [textView setSelectedRange:NSMakeRange(0, 0)];
        isPlaceholder = YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self.notesTextView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)fetchOrders
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM orderHistory "];
    FMResultSet *results = [database executeQuery:queryString];
    
    orderList = [[NSMutableArray alloc] init];
    int k = 0 ;
    
    while([results next]) {
        orderObj = [[orderOC alloc]init];
        orderObj.orderItemName=[results stringForColumn:@"orderItemName"];
        orderObj.orderQuantity = [results intForColumn:@"orderQuantity"];
        orderObj.orderItemID = [results intForColumn:@"orderItemID"];
        orderObj.orderPrice = [results intForColumn:@"orderPrice"];
        orderObj.orderImage = [results stringForColumn:@"orderItemImage"];
        [orderList addObject:orderObj];
        
        int j = orderObj.orderPrice ;
        j=j+k;
        k= j;
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
    
    self.batchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
    float delievrycharg=0.00;
    float taxes=0.00;
    
    
    taxesPriceLbl.text=[NSString stringWithFormat:@"%@ %.2f",[defaults valueForKey:@"Currency Value"],taxes];
    deliveryChargPriceLbl.text=[NSString stringWithFormat:@"%@ %.2f",[defaults valueForKey:@"Currency Value"],delievrycharg];
    foodDrinkPriceLbl.text = [NSString stringWithFormat:@"%@ %d.00",[defaults valueForKey:@"Currency Value"],k];
    totalPrice=k+taxes+delievrycharg;
    orderTotalPriceLbl.text=[NSString stringWithFormat:@"%@ %.2f",[defaults valueForKey:@"Currency Value"],k+taxes+delievrycharg];
    [database close];
    
    [self.orderTableView reloadData];
    [foodDrinkPriceLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [deliveryChargPriceLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [taxesPriceLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [self.foodDrinkLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [self.deliverChargeLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [self.taxLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
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
    
    [emptyCartLabel removeFromSuperview];
    if (orderList.count==0)
    {
        self.emptyOrderListView.hidden = NO;
//        checkoutPriceDetailView.hidden=YES;
//        self.orderTableView .hidden=YES;
//        emptyCartLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 80, 1024, 500)];
//        emptyCartLabel.text=@"YOUR CART IS EMPTY.";
//        emptyCartLabel.textAlignment = NSTextAlignmentCenter;
//        [emptyCartLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:60]];
//        
//        [emptyCartLabel setUserInteractionEnabled:YES];
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyCartLabelTappedAction:)];
//        [tapGestureRecognizer setNumberOfTapsRequired:1];
//        [emptyCartLabel addGestureRecognizer:tapGestureRecognizer];
//        
//        [self.view addSubview:emptyCartLabel];
//        
//        orderSomthing = [[UIButton alloc]initWithFrame:CGRectMake(415, 450, 200, 60)];
//        [orderSomthing setTitle:[NSString stringWithFormat:@"START A NEW ORDER"] forState:UIControlStateNormal];
//        UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"viewdetail"];
//        
//        [orderSomthing setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
//        [orderSomthing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
//        [orderSomthing setUserInteractionEnabled:YES];
//        orderSomthing.titleLabel.font =[UIFont fontWithName:@"Helvetica-Condensed" size:20];
//        
//        [orderSomthing addTarget:self action:@selector(orderSomthingAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:orderSomthing];
        
        
    }
    else {
        self.emptyOrderListView.hidden = YES;
    }
    return [orderList count];
    
    
    
}
-(void)orderSomthingAction
{
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = NO;
    [self.navigationController pushViewController:homeVC animated:NO];
}
-(IBAction)emptyCartLabelTappedAction:(id)sender
{
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = NO;
    [self.navigationController pushViewController:homeVC animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    OrderTableViewCell *cell = (OrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    orderOC *ordrobject = (orderOC *)[orderList objectAtIndex:indexPath.row];
    
    
    NSString *imageName = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",ordrobject.orderImage]];
    
    [cell setLabelText:ordrobject.orderItemName :ordrobject.orderQuantity :[NSString stringWithFormat:@"%d",ordrobject.orderPrice] :imageName];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (IS_IPAD_Pro) {
        deleteBtn.frame = CGRectMake(205.0f, 97.50f, 35.0f, 35.0f);
    }else{
        deleteBtn.frame = CGRectMake(155.0f, 97.5f, 35.0f, 35.0f);
    }
    
    deleteBtn.tag = indexPath.row;
    
    [deleteBtn setTintColor:[UIColor colorWithRed:159.0f/255.0 green:14.0f/255.0 blue:14.0f/255.0 alpha:1.0]] ;
    
    
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    increaseItemBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (IS_IPAD_Pro) {
        increaseItemBtn.frame = CGRectMake(886, 97.5f, 35.0f, 35.0f);
    }else{
        increaseItemBtn.frame = CGRectMake(665, 97.5f, 35.0f, 35.0f);
    }
    
    increaseItemBtn.tag = indexPath.row;
    [increaseItemBtn setTintColor:[UIColor colorWithRed:159.0f/255.0 green:14.0f/255.0 blue:14.0f/255.0 alpha:1.0]] ;
    [cell.contentView addSubview:increaseItemBtn];
    
    decreaseItemBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (IS_IPAD_Pro) {
        decreaseItemBtn.frame = CGRectMake(788.0f, 97.5f, 35.0f, 35.0f);
    }else{
        decreaseItemBtn.frame = CGRectMake(581.0f, 97.5f, 35.0f, 35.0f);
    }
    
    decreaseItemBtn.tag = indexPath.row;
    [decreaseItemBtn setTintColor:[UIColor colorWithRed:159.0f/255.0 green:14.0f/255.0 blue:14.0f/255.0 alpha:1.0]] ;
    [cell.contentView addSubview:decreaseItemBtn];
    
    //    [decreaseItemBtn addTarget:self action:@selector(decreaseItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackgroundDelete= [UIImage imageNamed:@"delete.png"];
    UIImage *buttonBackgroundincrease= [UIImage imageNamed:@"increaseselect.png"];
    UIImage *buttonBackgroundDecrease= [UIImage imageNamed:@"decreaseselect.png"];
   
    [deleteBtn setBackgroundImage:buttonBackgroundDelete forState:UIControlStateNormal];
    [increaseItemBtn setBackgroundImage:buttonBackgroundincrease forState:UIControlStateNormal];
    [decreaseItemBtn setBackgroundImage:buttonBackgroundDecrease forState:UIControlStateNormal];
    [cell.contentView addSubview:deleteBtn];
    NSMutableArray* quantityCounts = [[NSMutableArray alloc] init];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM categoryItems where itemID = %d", ordrobject.orderItemID];
    FMResultSet *results = [database executeQuery:queryString];
    
    int  maxQty=0;
    while([results next])
    {
        maxQty =[[results stringForColumn:@"quantity"]intValue];
        NSLog(@"Max Value %d",maxQty);
    }
    int k = 0;
    for (int j =1; j <= k; j++)
    {
        [quantityCounts addObject:[NSString stringWithFormat:@"%d",j]];
    }
    
    if (ordrobject.orderQuantity ==maxQty)
    {
        [increaseItemBtn setBackgroundImage:[UIImage imageNamed:@"increase.png"] forState:UIControlStateNormal];
        // [increaseItemBtn setUserInteractionEnabled:NO];
    }
    else{
        [increaseItemBtn addTarget:self action:@selector(increaseItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (ordrobject.orderQuantity ==1)
    {
        [decreaseItemBtn setBackgroundImage:[UIImage imageNamed:@"decrease.png"] forState:UIControlStateNormal];
        // [decreaseItemBtn setUserInteractionEnabled:NO];
    }
    else{
        [decreaseItemBtn addTarget:self action:@selector(decreaseItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [database close];
    
    return cell;
}


- (IBAction)deleteBtnAction:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    orderOC *ordr = (orderOC *)[orderList objectAtIndex:indexPath.row];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Delete FROM orderHistory WHERE orderItemID = %d ",ordr.orderItemID];
    [database executeUpdate:queryString];
    [database close];
    [self fetchOrders];
    [self.orderTableView reloadData];
    
}

- (IBAction)increaseItemBtnAction:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    orderOC *ordr = (orderOC *)[orderList objectAtIndex:indexPath.row];
    
    NSString *currentValue = [NSString stringWithFormat:@"%d",ordr.orderQuantity];
    int quantity = [currentValue integerValue];
    quantity += 1;
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM categoryItems where categoryID = \"%d\"", ordr.orderItemID];
    FMResultSet *results = [database executeQuery:queryString];
    
    int  maxQty=0;
    while([results next])
    {
        maxQty =[[results stringForColumn:@"quantity"]intValue];
        NSLog(@"Max Value %d",maxQty);
    }
    [database close];
    
    [self orderList:[NSString stringWithFormat:@"%d",ordr.orderItemID] :quantity];
    
    [self fetchOrders];
    
}
- (IBAction)decreaseItemBtnAction:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    orderOC *ordr = (orderOC *)[orderList objectAtIndex:indexPath.row];
    
    
    NSString *currentValue = [NSString stringWithFormat:@"%d",ordr.orderQuantity];
    int quantity = [currentValue integerValue];
    quantity -= 1;
    
    [self orderList:[NSString stringWithFormat:@"%d",ordr.orderItemID] :quantity];
    
    [self fetchOrders];
}


-(void) orderList:(NSString *)itemsID:(int)orderItemQuantities
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM orderHistory "];
    FMResultSet *results1 = [database executeQuery:queryString1];
    NSMutableArray *tempOrder = [[NSMutableArray alloc] init];
    while ([results1 next]) {
        [tempOrder addObject:[results1 stringForColumn:@"orderItemID"]];
    }
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM categoryItems where itemID = \"%@\"",[NSString stringWithString:itemsID]];
    FMResultSet *results = [database executeQuery:queryString];
    //    menuCategoryArray = [[NSMutableArray alloc] init];
    //    menuCategoryId = [[NSMutableArray alloc]init];
    while([results next]) {
        
        NSString *totalValue = [results stringForColumn:@"itemPrice"];
        int tPrice = [totalValue intValue];
        
        tPrice = tPrice * orderItemQuantities;
        
        if ([tempOrder containsObject:[NSString stringWithFormat:@"%@",itemsID]]) {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE orderHistory SET orderItemName = \"%@\" , ordercuisine = \"%@\", orderType = \"%@\", orderQuantity = %d, orderPrice = \"%d\" where orderItemID = \"%@\"" ,[results stringForColumn:@"itemName"],[results stringForColumn:@"cuisine"],[results stringForColumn:@"typeID"],orderItemQuantities,tPrice,[NSString stringWithFormat:@"%@",itemsID]];
            [database executeUpdate:updateSQL];
        }else{
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO orderHistory (orderItemID, orderItemName, ordercuisine, orderType, orderQuantity, orderPrice) VALUES (%@, \"%@\",\"%@\",\"%@\", \"%d\",\"%d\")",[results stringForColumn:@"itemID"],[results stringForColumn:@"itemName"],[results stringForColumn:@"cuisine"],[results stringForColumn:@"typeID"],orderItemQuantities,tPrice];
            [database executeUpdate:insert];
        }
    }
    [database close];
}

- (IBAction)CheckOutBtn:(id)sender
{
    NSString *timerStatus = [[NSUserDefaults standardUserDefaults]valueForKey:@"evenStatus"];
    if ([timerStatus isEqualToString:@"end"]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Event Time Out" message:@"Sorry for the inconvenience. We are not able to accept any order now." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

        return;
    }
    
    if([self.notesTextView.text isEqualToString:placeholderText]){
        self.notesTextView.text = @"";
    }
    
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    
    [dateformate setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    NSMutableArray *placeOrderArray = [[NSMutableArray alloc]init];
    
    NSLog(@"ordrlist count ..%lu  ",(unsigned long)orderList.count);
    for (int i= 0; i < [orderList count]; i ++) {
        
        orderOC* placeOrderObj= [[orderOC alloc]init];
        placeOrderObj = [orderList objectAtIndex:i];
        
        NSLog(@"placeOrderObj.Price ..%d  ",placeOrderObj.orderPrice);
        NSLog(@"placeOrderObj.Quantity ..%d  ", placeOrderObj.orderQuantity);
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",placeOrderObj.orderItemID],@"ItemId",[NSString stringWithFormat:@"%d",placeOrderObj.orderQuantity],@"Quantity",[NSString stringWithFormat:@"%d",placeOrderObj.orderPrice],@"Price", nil];
        
        NSLog(@"Object %@", postDict);
        [placeOrderArray addObject:postDict];
        
    }
    NSError *err;
    NSDictionary * jsonArray = [[NSDictionary alloc] initWithObjectsAndKeys:placeOrderArray,@"objPlaceOrder", nil];
    NSLog(@"Objects Array %@", placeOrderArray);
    NSString *tableIds = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *PlaceOrders = [[NSMutableDictionary alloc] initWithObjectsAndKeys:jsonString,@"objPlaceOrder",tableIds,@"tableId",[NSString stringWithFormat:@"1"],@"restaurantId",[NSString stringWithFormat:@"%.2f",totalPrice],@"totalbill",[NSString stringWithFormat:@"%@",self.notesTextView.text],@"notes",date_String,@"datetimeoforder",[defaults valueForKey:@"Event ID"],@"EventId", nil];
    
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:PlaceOrders options:NSJSONWritingPrettyPrinted error:&err];
    
    NSLog(@"JSON = %@", [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding]);
    // Checking the format
    NSLog(@"%@",[[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding]);
    NSString *jsonRequest = [PlaceOrders JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
   
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/PlaceOrders",Kwebservices]];
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
    if (webServiceCode == 0) {
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
       
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"result"]];
        if([resultStr isEqualToString:@"0"])
        {
           
            [defaults setValue:@"" forKey:@"Note"];
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            
            NSString *queryString = [NSString stringWithFormat:@"Delete FROM orderHistory "];
            [database executeUpdate:queryString];
            [database close];
            
            [self fetchOrders];
            [self.orderTableView reloadData];
            
            menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
            homeVC.isNewOrder = NO;
            homeVC.isOrderPlaced = YES;
            [self.navigationController pushViewController:homeVC animated:NO];
        }else{
            NSString *message = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OPHEMY" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        [self enable];
        [activityIndicator stopAnimating];
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
- (IBAction)Slideshow:(id)sender {

    eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
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
    }else if( alertView.tag == 999 && buttonIndex == 0){
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString = [NSString stringWithFormat:@"Delete FROM orderHistory "];
        [database executeUpdate:queryString];
        [database close];
        
        [self fetchOrders];
        [self.orderTableView reloadData];
        
        menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
        
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

- (IBAction)startNewOrderAction:(id)sender {
    [self orderSomthingAction];
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
    }else if([sender.titleLabel.text isEqualToString:@"MENU"]){
        menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
        homeVC.isNewOrder = NO;
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
