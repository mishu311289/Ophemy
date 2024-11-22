
#import <UIKit/UIKit.h>
#import "tableAllotedOC.h"

@interface gettingCountViewController : UIViewController
{
    NSMutableData *webData;
    tableAllotedOC *tableAllotedObj;
     NSMutableArray *pingsList, *tableNameArray, *allChatMessages,*orderIdsArray, *tableAllotedIdsArray, *assignedTablesArray, *assignedTableTimestampsArray,*fetchedChatData, *fetchTableIdsArray,*tablesList,*fetchingChat;
     NSString *documentsDir, *dbPath,* timeStampKey, *selectedTable;
}
-(void) fetchCounts;
@property (strong, nonatomic) NSMutableArray *tablesAllotedArray;
@end
