
#import "eventDetailViewController.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "appHomeViewController.h"
#import "CheckOutViewController.h"
#import "menuStateViewController.h"
@interface eventDetailViewController ()

@end

@implementation eventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults valueForKey:@"PDF"];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (IS_IPAD_Pro) {
        activityIndicator.center = CGPointMake(1366/2, 1028/2);
    }else{
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    [self disabled];
    
    _pdfURL = [_pdfURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_pdfURL]];
    [webView loadRequest:request];
    webView.backgroundColor = [UIColor clearColor];
    webView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    requestAssistanceViewController *requestVC = [[requestAssistanceViewController alloc] initWithNibName:@"requestAssistanceViewController" bundle:nil];
    [self.navigationController pushViewController:requestVC animated:NO];
}


- (IBAction)exitAction:(id)sender {
     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OPHEMY" message:@"ARE YOU SURE YOU WANT TO EXIT?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    alert.tag = 1;
    [alert show];
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
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"OFF" forKey:@"bulb"];
        }
        
        [defaults setObject:@"YES"forKey:@"isLogedOut"];
        loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //Start the progressbar..
    [activityIndicator startAnimating];
    [self disabled];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    [self enable];
    //Stop or remove progressbar
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OPHEMY" message:@"PDF url seems to be incorrect" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    alert.tag = 1;
    [alert show];
}

- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    disabledImgView.hidden = NO;
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    disabledImgView.hidden = YES;
}
@end
