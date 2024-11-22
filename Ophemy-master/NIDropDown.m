
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;
@synthesize animationDirection;

- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSString *)direction {
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *) b :(int )flag {
    CGRect btn = b.frame;
    if (flag == 1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([animationDirection isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
        }else if ([animationDirection isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, 0);
        [UIView commitAnimations];
    }else{
        if ([animationDirection isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
        }else if ([animationDirection isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, 0);
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    UILabel *firstline= [[UILabel alloc]initWithFrame:CGRectMake(0, 40, tableView.frame.size.width, 1)];
    firstline.backgroundColor= [UIColor blackColor];
    firstline.alpha = 0.3;
    [cell.contentView addSubview:firstline];
    
    cell.textLabel.text =[[list objectAtIndex:indexPath.row] uppercaseString];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender:1];
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    
//    for (UIView *subview in btnSender.subviews) {
//        if ([subview isKindOfClass:[UIImageView class]]) {
//            [subview removeFromSuperview];
//        }
//    }
    [self myDelegate:c.textLabel.text];
}

- (void) myDelegate:(NSString *)title {
    [self.delegate niDropDownDelegateMethod:self :title];
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

@end
