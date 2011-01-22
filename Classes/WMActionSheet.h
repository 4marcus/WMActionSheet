//
//  WMActionSheet.h
//  
// 
//  This class mimics an action sheet black translucent, but has a completly different API to support more
//  button customization.
//  
//  The implementation does NOT adhere to changes for rotation. 
//  The implementation does NOT support iPad type Action Sheet display.
//
//  If the default button does not serve your needs, exchange the wmdefaulbutton.png
//
//  Created by Marcus Wagner on 14.12.10.
//  Copyright 2010 wintermute.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol WMActionSheetDelegate;

@interface WMActionSheet : UIView {
	
	// private
	id<WMActionSheetDelegate> delegate;
	UILabel* title;
	CALayer* coverLayer;
	UIView* sheetView;
	CGFloat currentYOffset;
}
// create an action sheet
- (id)initWithTitle:(NSString *) aTitle delegate:(id <WMActionSheetDelegate >) aDelegate;

// add a button with set attributes. If text color or background color is nil, default color will be used. If textShadowColor is nil, not shadow will be set to the button. increasedSpacing renders the button with a larger distance to the neighbour buttons.
- (void) addButtonWithTitle: (NSString*) buttonTitle buttonId: (NSInteger) buttonId textColor: (UIColor*) textColor textShadowColor: (UIColor*) textShadowColor backgroundColor: (UIColor*) buttonBackgroundColor increasedSpacing: (BOOL) spacing;

// as soon as show is called, no changes must be done to the appearance.
- (void) showWithAnimation: (BOOL) animated;

// dismiss the action sheet. Will NOT trigger any delegate message.
- (void) dismissWithAnimation: (BOOL) animated;


@end

@protocol WMActionSheetDelegate

- (void) actionSheet: (WMActionSheet*) theActionSheet triggeredButtonWithId: (NSInteger) buttonId;

@end