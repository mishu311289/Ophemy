
#import "splashScreenViewController.h"
#import "loginViewController.h"
#import "homeViewController.h"
#import "serviceProviderHomeViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "appHomeViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "Base64.h"
#import "menuStateViewController.h"

@interface splashScreenViewController ()

@end

@implementation splashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *urlString = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"output_U78sIP" ofType:@"mp4"]];
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:urlString];
    double width = [[UIScreen mainScreen] bounds].size.width;
    double height = [[UIScreen mainScreen] bounds].size.height;
    if (IS_IPAD_Pro) {
        NSLog(@"Ipad PRo screen");
        [_moviePlayer.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-20,width,height+40)];
    }else{
    NSLog(@"Width = %f, HEight = %f",self.view.frame.size.width,self.view.frame.size.height);
    [_moviePlayer.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-20,width,height+40)];
    }
    _moviePlayer.fullscreen = YES;
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.view addSubview:_moviePlayer.view];
    
    [_moviePlayer setFullscreen:YES animated:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
}
- (void)presentnextView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults valueForKey:@"isLogedOut"]);
    NSString *isLogedOut;
    NSString *isTerminated = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"isTerminated"]];
    if ([defaults valueForKey:@"isLogedOut"] == NULL ) {
        isLogedOut =[NSString stringWithFormat:@"YES"];
    }else{
        isLogedOut =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"isLogedOut"]];
    }
    NSLog(@"ROLE... %@",[defaults valueForKey:@"Role"]);
    if ([isLogedOut isEqualToString:@"YES"] || [isTerminated isEqualToString:@"1"]) {
        loginViewController *loginVC = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        if ([[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Role"]] isEqualToString:@"ServiceProvider"]) {
            serviceProviderHomeViewController *serviceProviderHomeVC= [[serviceProviderHomeViewController alloc]initWithNibName:@"serviceProviderHomeViewController" bundle:nil];
            [self.navigationController pushViewController:serviceProviderHomeVC animated:YES];
        }else{
//            [self menuItems];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *slideShowStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"SlideShow"]];
            if ([slideShowStatus isEqualToString:@"1"]) {
                eventImagesSlideViewViewController *homeVC= [[eventImagesSlideViewViewController alloc]initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
                [self.navigationController pushViewController:homeVC animated:YES];
            }else{
                menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
                homeVC.isNewOrder = NO;
                [self.navigationController pushViewController:homeVC animated:NO];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)menuItems
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *timeStamp = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"menuTimeStamp"]];
    if ([timeStamp isEqualToString:@"(null)"]) {
        timeStamp = [NSString stringWithFormat:@""];
    }
    NSString *eventId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:timeStamp, @"Timestamp",eventId,@"EventId", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchCategoryItems",Kwebservices]];
    
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
    [self enable];
    [activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Internet connection seems to be down. Application might not work properly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    menuDetails = [[NSMutableArray alloc]init];
    menuCategoryIdsArray = [[NSMutableArray alloc]init];
    menuItemsDetail = [[NSMutableArray alloc] init];
    itemsIdsArray = [[NSMutableArray alloc]init];
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"Dictionary %@",userDetailDict);
    if (userDetailDict.count != 0) {
        
        NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"updatedtimestamp"]];
        [defaults setObject:resultStr forKey:@"menuTimeStamp"];
        NSMutableArray *menuData = [[NSMutableArray alloc] initWithArray:[userDetailDict valueForKey:@"listCategory"]];
        for (int i =0; i < [menuData count]; i++) {
            menuObj = [[menuOC alloc]init];
            menuObj.categoryID = [[[menuData valueForKey:@"categoryId"] objectAtIndex:i] intValue];
            menuObj.categoryName = [[menuData valueForKey:@"categoryName"] objectAtIndex:i];
            menuObj.type = [[menuData valueForKey:@"type"] objectAtIndex:i];
            
            menuObj.isDeleted = [[[menuData valueForKey:@"IsDeleted"] objectAtIndex:i]intValue];
            menuObj.itemsList = [[menuData valueForKey:@"listFoodItems"] objectAtIndex:i];
            
            for (int j = 0;j<[menuObj.itemsList count]; j++) {
                
                menuItemsObj = [[menuItemsOC alloc]init];
                menuItemsObj.categoryId = [[NSString stringWithFormat:@"%d",menuObj.categoryID]intValue];
                menuItemsObj.ItemId = [[[menuObj.itemsList valueForKey:@"ItemId"] objectAtIndex:j]intValue];
                menuItemsObj.ItemName = [[menuObj.itemsList valueForKey:@"ItemName"] objectAtIndex:j];
                menuItemsObj.Cuisine = [[menuObj.itemsList valueForKey:@"Cuisine"] objectAtIndex:j];
                menuItemsObj.type = [[menuObj.itemsList valueForKey:@"Type"] objectAtIndex:j];
                menuItemsObj.Quantity = [[[menuObj.itemsList valueForKey:@"Quantity"] objectAtIndex:j] intValue];
                menuItemsObj.Price = [[menuObj.itemsList valueForKey:@"Price"] objectAtIndex:j];
                menuItemsObj.Image = [[menuObj.itemsList valueForKey:@"Image"] objectAtIndex:j];
                menuItemsObj.Image = [menuItemsObj.Image stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", menuItemsObj.Image]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [UIImage imageWithData:data];
                
                NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
                NSString *strEncoded = [Base64 encode:imgdata];
                menuItemsObj.Image = [NSString stringWithString:strEncoded];
                menuObj.imageUrl = strEncoded;
                menuItemsObj.IsDeletedItem = [[[menuObj.itemsList valueForKey:@"IsDeleted"] objectAtIndex:j] intValue];
                [menuItemsDetail addObject:menuItemsObj];
                [itemsIdsArray addObject:[NSString stringWithFormat:@"%d",menuItemsObj.ItemId]];
            }
            
            [menuDetails addObject:menuObj];
            [menuCategoryIdsArray addObject:[NSString stringWithFormat:@"%d",menuObj.categoryID]];
        }
        
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM menu "];
        FMResultSet *results1 = [database executeQuery:queryString1];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        while([results1 next]) {
            [tempArray addObject:[results1 stringForColumn:@"categoryID"]];
        }
        
        
        for (int i = 0;i < [menuCategoryIdsArray count]; i++) {
            menuObj = [menuDetails objectAtIndex:i];
            NSString *menuIsDeletedStr = [NSString stringWithFormat:@"%d",menuObj.isDeleted];
            if ([tempArray containsObject:[menuCategoryIdsArray objectAtIndex:i]])
            {
                if ([menuIsDeletedStr isEqualToString:@"0"]){
                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE menu SET categoryName = \"%@\" , type = \"%@\",imageUrl = \"%@\" , where categoryID = %d" ,menuObj.categoryName,menuObj.type,menuObj.imageUrl,menuObj.categoryID];
                    [database executeUpdate:updateSQL];
                }
                else
                {
                    NSString *updateSQL = [NSString stringWithFormat:@"Delete FROM menu where categoryID = %d" ,menuObj.categoryID];
                    [database executeUpdate:updateSQL];
                }
                
            }
            else{
                NSString *insert = [NSString stringWithFormat:@"INSERT INTO menu (categoryID, categoryName, type, imageUrl) VALUES (%d, \"%@\", \"%@\", \"%@\")",menuObj.categoryID,menuObj.categoryName,menuObj.type,menuObj.imageUrl];
                [database executeUpdate:insert];
            }
            
            
            NSString *itemsQueryString = [NSString stringWithFormat:@"Select * FROM categoryItems "];
            FMResultSet *itemsResults = [database executeQuery:itemsQueryString];
            NSMutableArray *itemsTempArray = [[NSMutableArray alloc] init];
            while([itemsResults next]) {
                [itemsTempArray addObject:[itemsResults stringForColumn:@"itemID"]];
            }
            for (int i = 0;i < [itemsIdsArray count]; i++) {
                
                menuItemsObj = [menuItemsDetail objectAtIndex:i];
                NSString *menuItemIsDeletedStr = [NSString stringWithFormat:@"%d",menuItemsObj.IsDeletedItem];
                if ([itemsTempArray containsObject:[itemsIdsArray objectAtIndex:i]]) {
                    if ([menuItemIsDeletedStr isEqualToString:@"0"]){
                        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE categoryItems SET itemName = \"%@\" , cuisine = \"%@\", categoryID = %d, typeID=\"%@\" ,quantity=%d ,itemPrice=\"%@\" ,itemImage=\"%@\" where itemID = %d" ,menuItemsObj.ItemName,menuItemsObj.Cuisine,menuItemsObj.categoryId,menuItemsObj.type,menuItemsObj.Quantity,menuItemsObj.Price,menuItemsObj.Image,menuItemsObj.ItemId];
                        [database executeUpdate:updateSQL];
                    }else
                    {
                        NSString *updateSQL = [NSString stringWithFormat:@"Delete FROM categoryItems where itemID = %d" ,menuItemsObj.ItemId];
                        [database executeUpdate:updateSQL];
                    }
                    
                }else{
                    
                    NSString *insert = [NSString stringWithFormat:@"INSERT INTO categoryItems (itemID, itemName, cuisine, categoryID, typeID, quantity,itemPrice, itemImage) VALUES (%d, \"%@\", \"%@\",%d,\"%@\",%d,\"%@\",\"%@\")",menuItemsObj.ItemId,menuItemsObj.ItemName,menuItemsObj.Cuisine,menuItemsObj.categoryId,menuItemsObj.type,menuItemsObj.Quantity,menuItemsObj.Price,menuItemsObj.Image];
                    [database executeUpdate:insert];
                }
                
            }
            [database close];
            //[self loginWebservice:[NSString stringWithFormat:@"table3@test.com"] :[NSString stringWithFormat:@"table3"]];
            
        }
        
        
        // [self fetchBannerImages];
        
        
        [self enable];
        [activityIndicator stopAnimating];
        
        
        
        
    }
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
