//
//  WMActionSheetAppDelegate.m
//  WMActionSheet
//
//  Created by Marcus Wagner on 16.12.10.
//  Copyright 2010 wintermute.de. All rights reserved.
//

#import "WMActionSheetAppDelegate.h"
#import "WMActionSheet.h"


@interface ShowCaseController : UIViewController<WMActionSheetDelegate>
@end

@implementation ShowCaseController

# define CANCEL_BUTTON_ID  1
# define GREEN_BUTTON_ID  2
# define RED_BUTTON_ID  3


- (void)loadView
{
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[self.view release];
	
	self.view.backgroundColor = [UIColor lightGrayColor];
	
	// Add a Label
	UILabel* infoLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 50, 280, 50)];
	infoLabel.tag = 11;
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview: infoLabel];
	[infoLabel release];
	
	// add a button to show the action sheet
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchDown];
	button.frame =  CGRectMake(20, 100, 280, 40);
	[self.view addSubview: button];
}

# pragma mark -
# pragma mark ShowCase Showing an Action Sheet 

// Showing an Action Sheet
- (void) showActionSheet {
	// add WMActionSheet. 
	WMActionSheet* actionSheet = [[[WMActionSheet alloc] initWithTitle:@"Please select an Action" delegate: self] autorelease];
	[actionSheet addButtonWithTitle:@"The Green Button" buttonId: GREEN_BUTTON_ID textColor:[UIColor whiteColor] textShadowColor:nil backgroundColor: [UIColor greenColor] increasedSpacing:NO];
	[actionSheet addButtonWithTitle:@"The Red Button" buttonId: RED_BUTTON_ID textColor:[UIColor whiteColor] textShadowColor:nil backgroundColor: [UIColor redColor] increasedSpacing:NO];	
	[actionSheet addButtonWithTitle:@"Cancel" buttonId: CANCEL_BUTTON_ID textColor:[UIColor whiteColor] textShadowColor:nil backgroundColor: [UIColor blackColor]  increasedSpacing:YES];	
	[actionSheet showWithAnimation:YES];	
	
}

# pragma mark ShowCase Implementing the delegate

// the action sheet delegate method
- (void) actionSheet: (WMActionSheet*) theActionSheet triggeredButtonWithId: (NSInteger) buttonId {
	UILabel* info = (UILabel*)[self.view viewWithTag:11];
	NSString* buttonInfo;
	switch (buttonId) {
		case  GREEN_BUTTON_ID:
			buttonInfo = @"Green";
			break;
		case  RED_BUTTON_ID:
			buttonInfo = @"Red";
			break;
		default:
			buttonInfo = @"Cancel";
			break;
	
	}
	info.text = [NSString stringWithFormat: @"Action triggered: %@" , buttonInfo ]; 
}

@end


# pragma mark -
# pragma mark WMActionSheetAppDelegate

@implementation WMActionSheetAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	ShowCaseController *showCaseController = [[ShowCaseController alloc] init];
	[window addSubview:showCaseController.view];
	
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
