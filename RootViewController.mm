#import "RootViewController.h"

#import <AppList/AppList.h>

#define kBounds [[UIScreen mainScreen] bounds]

@implementation RootViewController

- (void)loadView {
	
	bounds = [[UIScreen mainScreen] bounds];
	bounds.origin.y += 20;
	bounds.size.height -= 20;

	tabView = [[UITableView alloc] initWithFrame:bounds];
	tabView.delegate = self;
	tabView.dataSource = self;
    [tabView setAlwaysBounceVertical:YES];

	self.view = tabView;

}

- (void)viewDidLoad {
	
	ALApplicationList* apps = [ALApplicationList sharedApplicationList];
	
	theApps = [[NSMutableDictionary alloc] init];
	for(int i = 0; i < [apps.applications allKeys].count; i++) {
		theApps[[[apps.applications allKeys] objectAtIndex:i]] = [[apps.applications allValues] objectAtIndex:i];
	}

	theArray = [[NSMutableArray alloc] init];

	for(NSString* i in [theApps allValues]) {
		[theArray addObject:i];
	}

	theArray = [[theArray sortedArrayUsingSelector:@selector(compare:)] mutableCopy];

	[tabView reloadData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString* str = [theApps allKeysForObject:[theArray objectAtIndex:indexPath.row]][0];
	[UIPasteboard generalPasteboard].string = str;
	[self showID:str];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [theArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Bundle IDs";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [theArray objectAtIndex:indexPath.row];

    return cell;

}

- (void)showID:(NSString *)label {

	UIWindow* window = [[UIWindow alloc] initWithFrame:kBounds];
	window.windowLevel = UIWindowLevelStatusBar;

	int daWidth = 200;
	int daHeight = 90;
	CGRect frame = CGRectMake(0,0,0,0);
	frame.origin.x = (bounds.size.width/2)-(daWidth/2);
	frame.origin.y = (bounds.size.height/2)-(daHeight/2);
	frame.size.width = daWidth;
	frame.size.height = daHeight;

	CGRect tempFrame = kBounds;
	tempFrame.size.width -= 70;

	UILabel* drawLabel = [[UILabel alloc] initWithFrame:tempFrame];
	drawLabel.text = label;
	drawLabel.font = [UIFont systemFontOfSize:16.0];
	drawLabel.numberOfLines = 2;
	drawLabel.textColor = [UIColor whiteColor];
	drawLabel.textAlignment = NSTextAlignmentCenter;

	float newWidth = [label boundingRectWithSize:drawLabel.frame.size
		options:NSStringDrawingUsesLineFragmentOrigin
		attributes:@{ NSFontAttributeName: drawLabel.font }
		context:nil].size.width;

	newWidth += 20;

	if(newWidth < 100.0) {
		newWidth = 100.0;
	}

	frame.size.width = newWidth + 50;
	frame.origin.x = (bounds.size.width/2)-(frame.size.width/2);

	CGRect newFrame = CGRectMake(0,0,0,0);
	newFrame.size.width = newWidth;
	newFrame.size.height = 120;
	newFrame.origin.x = (frame.size.width/2)-(newWidth/2);
	newFrame.origin.y = (frame.size.height/2)-60;

	[drawLabel setFrame:newFrame];

	UIView* preView = [[UIView alloc] initWithFrame:frame];
	preView.backgroundColor = [UIColor blackColor];
	preView.alpha = 0.0;
	preView.layer.cornerRadius = 20;
	preView.layer.masksToBounds = YES;

	UILabel* dismissLabel = [[UILabel alloc] initWithFrame:(CGRectMake((frame.size.width / 2) - 40, frame.size.height - 37, 80, 40))];
	dismissLabel.text = @"Tap to Dismiss";
	dismissLabel.adjustsFontSizeToFitWidth = YES;
	dismissLabel.numberOfLines = 1;
	dismissLabel.textColor = [UIColor whiteColor];
	dismissLabel.textAlignment = NSTextAlignmentCenter;

	[preView addSubview:drawLabel];
	[preView addSubview:dismissLabel];

	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeWindowNow:)];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 1;

	[preView addGestureRecognizer:tapGesture];
	[tapGesture release];

	[window addSubview:preView];

	[UIView animateWithDuration:0.35
        delay:0.0
        options: UIViewAnimationCurveEaseInOut
        animations:^{preView.alpha = 0.85;}
        completion:^(BOOL){}];

	[window makeKeyAndVisible];

}

- (void)removeWindowNow:(UITapGestureRecognizer *)recognizer {
	UIView* view = recognizer.view;
	UIWindow* window = (UIWindow *)view.superview;
	[UIView animateWithDuration:0.35
        delay:0.0
        options: UIViewAnimationCurveEaseInOut
        animations:^{view.alpha = 0.0;}
        completion:^(BOOL){
        	[window removeFromSuperview];
        	[window release];
        }];
}
 
@end
