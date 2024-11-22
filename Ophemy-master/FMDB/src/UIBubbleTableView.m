
#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "UIBubbleHeaderTableViewCell.h"
#import "UIBubbleTypingTableViewCell.h"

@interface UIBubbleTableView ()

@property (nonatomic, retain) NSMutableArray *bubbleSection;

@end

@implementation UIBubbleTableView

@synthesize bubbleDataSource = _bubbleDataSource;
@synthesize snapInterval = _snapInterval;
@synthesize bubbleSection = _bubbleSection;
@synthesize typingBubble = _typingBubble;
@synthesize showAvatars = _showAvatars;

#pragma mark - Initializators

- (void)initializator
{
    // UITableView properties
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
    
    self.delegate = self;
    self.dataSource = self;
    
    // UIBubbleTableView default properties
    
    self.snapInterval = 120;
    self.typingBubble = NSBubbleTypingTypeNobody;
}

- (id)init
{
    self = [super init];
    if (self) [self initializator];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) [self initializator];
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_bubbleSection release];
	_bubbleSection = nil;
	_bubbleDataSource = nil;
    [super dealloc];
}
#endif

#pragma mark - Override

- (void)reloadData
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    // Cleaning up
	self.bubbleSection = nil;
    
    // Loading new data
    int count = 0;
#if !__has_feature(objc_arc)
    self.bubbleSection = [[[NSMutableArray alloc] init] autorelease];
#else
    self.bubbleSection = [[NSMutableArray alloc] init];
#endif
    
    if (self.bubbleDataSource && (count = [self.bubbleDataSource rowsForBubbleTable:self]) > 0)
    {
#if !__has_feature(objc_arc)
        NSMutableArray *bubbleData = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
#else
        NSMutableArray *bubbleData = [[NSMutableArray alloc] initWithCapacity:count];
#endif
        
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.bubbleDataSource bubbleTableView:self dataForRow:i];
            assert([object isKindOfClass:[NSBubbleData class]]);
            [bubbleData addObject:object];
        }
        
        [bubbleData sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             NSBubbleData *bubbleData1 = (NSBubbleData *)obj1;
             NSBubbleData *bubbleData2 = (NSBubbleData *)obj2;
             
             return [bubbleData1.date compare:bubbleData2.date];            
         }];
        
        NSDate *last = [NSDate dateWithTimeIntervalSince1970:0];
        NSMutableArray *currentSection = nil;
        
        for (int i = 0; i < count; i++)
        {
            NSBubbleData *data = (NSBubbleData *)[bubbleData objectAtIndex:i];
            
            if ([data.date timeIntervalSinceDate:last] > self.snapInterval)
            {
#if !__has_feature(objc_arc)
                currentSection = [[[NSMutableArray alloc] init] autorelease];
#else
                currentSection = [[NSMutableArray alloc] init];
#endif
                [self.bubbleSection addObject:currentSection];
            }
            
            [currentSection addObject:data];
            last = data.date;
        }
    }
    
    [super reloadData];
}

#pragma mark - UITableViewDelegate implementation

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = [self.bubbleSection count];
    if (self.typingBubble != NSBubbleTypingTypeNobody) result++;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // This is for now typing bubble
	if (section >= [self.bubbleSection count]) return 1;
    
    return [[self.bubbleSection objectAtIndex:section] count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
    if (indexPath.section >= [self.bubbleSection count])
    {
        return MAX([UIBubbleTypingTableViewCell height], self.showAvatars ? 64 : 0);
    }
    
    // Header
    if (indexPath.row == 0)
    {
        return 0;
    }
    
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    return MAX(data.insets.top + data.view.frame.size.height + data.insets.bottom + 10, self.showAvatars ? 64 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
	if (indexPath.section >= [self.bubbleSection count])
    {
        static NSString *cellId = @"tblBubbleTypingCell";
        UIBubbleTypingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil)
        {
            cell = [[UIBubbleTypingTableViewCell alloc] init];
        }
        cell.type = self.typingBubble;
        cell.showAvatar = self.showAvatars;
        
        return cell;
    }

    // Header with date and time
    if (indexPath.row == 0)
    {
        static NSString *cellId = @"tblBubbleHeaderCell";
        UIBubbleHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:0];
        
        if (cell == nil)
        {
            
            cell = [[UIBubbleHeaderTableViewCell alloc] init];
        }
        cell.date = data.date;
       
        return cell;
    }
    
    // Standard bubble    
    static NSString *cellId = @"tblBubbleCell";
    UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
    UILabel *label;
    
    cell = [[UIBubbleTableViewCell alloc] init];
    if ([data.isCorner isEqualToString:@"Table"]) {
        if (IS_IPAD_Pro) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2 + 370, -20, cell.frame.size.width, 50)];
        }else{
        label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2 + 170, -20, cell.frame.size.width, 50)];
        }

    }else{
        if (IS_IPAD_Pro) {
             label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2+150 , -20, cell.frame.size.width, 50)];
        }else{
             label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2+30 , -20, cell.frame.size.width, 50)];
        }
       

    }
    
    
    cell.data = data;
    cell.showAvatar = self.showAvatars;
    
    CGFloat width = data.view.frame.size.width;
    CGFloat height = 22;
    CGFloat y = data.view.frame.size.height-5;

    NSBubbleType type = data.type;
    
    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - data.insets.left - data.insets.right;
    NSLog(@"%f",x);
    NSLog(@"%f",width);
    NSLog(@"%f",height);
    
    dateLbl=[[UILabel alloc]initWithFrame:CGRectMake(10,0, cell.frame.size.height-27,12)];
    
    
    nameLbl=[[UILabel alloc]init];
    
    if (type == BubbleTypeSomeoneElse)
    {
        dateLbl.frame=CGRectMake(70, y, cell.frame.size.width, height);
        dateLbl.textAlignment=NSTextAlignmentLeft;

    }else{
        
        dateLbl.frame=CGRectMake(width,y, width, height);
        dateLbl.textAlignment=NSTextAlignmentRight;
    }
    
    NSLog(@"Height ...... %f",dateLbl.frame.origin.y);
    //dateLbl.font = [UIFont boldSystemFontOfSize:7];
    dateLbl.textColor = [UIColor blackColor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    if (data.dateStr.length <= dateLbl.frame.size.width) {
        if (type == BubbleTypeSomeoneElse){
            
            dateLbl.frame=CGRectMake(70, y+23, width+8, height);
            dateLbl.textAlignment=NSTextAlignmentLeft;
            
        }else{
            
            dateLbl.frame=CGRectMake(x-50,y+23, width, height);
            dateLbl.textAlignment=NSTextAlignmentRight;
        }
        
    }
    if ( y >=25) {
        if (type == BubbleTypeSomeoneElse){
            
            dateLbl.frame=CGRectMake(70, y-1, width+78, height);
            dateLbl.textAlignment=NSTextAlignmentLeft;
            
        }else{
            
            dateLbl.frame=CGRectMake(x-50,y-1, width, height);
            dateLbl.textAlignment=NSTextAlignmentRight;
        }
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateStr = [NSString stringWithFormat:@"%@",data.dateStr];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
    dateStr = [dateArray objectAtIndex:0];
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@",[dateArray objectAtIndex:1],[dateArray objectAtIndex:2]];
    
    if ([data.dateChangeStr isEqualToString:@"YES"]) {
    label.text = dateStr;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.shadowOffset = CGSizeMake(0, 1);
    label.shadowColor = [UIColor whiteColor];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    [cell addSubview:label];
    }
    
    
    dateLbl.text=timeStr;
    
    [dateLbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:10]];
    
    [cell addSubview:dateLbl];
    cell.clipsToBounds = YES;                                           
    return cell;
}

#pragma mark - Public interface

- (void) scrollBubbleViewToBottomAnimated:(BOOL)animated
{
    NSInteger lastSectionIdx = [self numberOfSections] - 1;
    
    if (lastSectionIdx >= 0)
    {
    	[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self numberOfRowsInSection:lastSectionIdx] - 1) inSection:lastSectionIdx] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}


@end
