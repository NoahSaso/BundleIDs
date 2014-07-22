@interface RootViewController: UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView* tabView;
	NSMutableArray* theArray;
	CGRect bounds;
	NSMutableDictionary* theApps;
}
@end
