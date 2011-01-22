//
//  WMActionSheet.m
//  
//
//  Created by Marcus Wagner on 14.12.10.
//  Copyright 2010 wintermute.de. All rights reserved.
//

#import "WMActionSheet.h"
#import "UIImage+tinted.h";

@interface WMActionSheet () 

@property (nonatomic, assign) id<WMActionSheetDelegate> delegate;
@property (nonatomic, retain) UILabel* title;
@property (nonatomic, retain) CALayer* coverLayer;
@property (nonatomic, retain) UIView* sheetView;

@end

@implementation WMActionSheet

@synthesize delegate;
@synthesize title, coverLayer, sheetView;

# pragma mark -
# pragma mark setup

# define REGULAR_GAP 12
# define LARGE_GAP 24
# define BUTTON_HEIGHT 18
# define BUTTON_X_OFFSET 20

- (id)initWithTitle:(NSString *) aTitle delegate:(id <WMActionSheetDelegate >) aDelegate {
	// Use topWindow bounds as main orientation
	UIWindow* topWindow = [[UIApplication sharedApplication] keyWindow];
	
    self = [super initWithFrame:topWindow.bounds];
    if (self) {
		// setup this view
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
        // create the cover view
		self.coverLayer = [CALayer layer];
		self.coverLayer.backgroundColor = [[UIColor blackColor] CGColor];
		self.coverLayer.opacity = 0.0;
		[self.layer addSublayer:self.coverLayer];
		
		// create the sheetview
		self.sheetView = [[[UIView alloc] initWithFrame:topWindow.bounds] autorelease];
		self.sheetView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
		self.sheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
		[self addSubview:self.sheetView];
		
		// create the title label if needed
		if (aTitle && aTitle.length > 0) {
			currentYOffset = REGULAR_GAP;
			UIFont* titleFont = [UIFont fontWithName:@"Helvetica" size: 17];
			self.title = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
			self.title.text = aTitle;
			self.title.textAlignment = UITextAlignmentCenter;
			self.title.font = titleFont;
			self.title.numberOfLines = 0;
			self.title.backgroundColor = [UIColor clearColor];
			self.title.textColor = [UIColor whiteColor];
			CGFloat maxWidth = topWindow.frame.size.width -  2 * BUTTON_X_OFFSET;
			CGSize titleSize = [aTitle sizeWithFont: titleFont constrainedToSize: CGSizeMake(maxWidth, 9999)];
			self.title.frame = CGRectMake(BUTTON_X_OFFSET, currentYOffset, maxWidth, titleSize.height);
			currentYOffset += titleSize.height;
			self.title.clipsToBounds = YES;
			self.title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[self.sheetView addSubview:self.title];
		}
		
		// set the delegate
		self.delegate = aDelegate;
    }
    return self;
}

// disable actions on this view. 
- (UIResponder*) nextResponder {
	// Actually as this view is added to UIWindow, the nextResponder (the Appdelegate) would not handle events anyhow.
	return nil;
}


// add a button. Button will placed from top to botton.
- (void) addButtonWithTitle: (NSString*) buttonTitle buttonId: (NSInteger) buttonId textColor: (UIColor*) textColor textShadowColor: (UIColor*) textShadowColor backgroundColor: (UIColor*) buttonBackgroundColor increasedSpacing: (BOOL) spacing {

	// setup button details
	UIFont* buttonFont = [UIFont fontWithName:@"Helvetica-Bold" size: 20];
	UIImage *buttonImage  = [UIImage imageNamed:@"wmdefaultbutton.png"];
	UIWindow* topWindow = [[UIApplication sharedApplication] keyWindow];
	CGFloat maxWidth = topWindow.frame.size.width;
	
	// button image and background
	if (buttonBackgroundColor) {
		buttonImage = [buttonImage tintWithColor:buttonBackgroundColor];
	}
	buttonImage = [buttonImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	
	UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
	newButton.tag = buttonId;
	
	// prevent other buttons to be pressed at the same time.
	newButton.exclusiveTouch = YES;
	
	[newButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	
	// adjust text and shadow
	if (textColor) {
		[newButton setTitleColor: textColor forState:UIControlStateNormal];
	}
	
	if (textShadowColor) {
		[newButton setTitleShadowColor:textShadowColor forState:UIControlStateNormal];
		[newButton.titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
	}

	// register events
	[newButton addTarget:self action:@selector(processButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	
	// set title
	[newButton setTitle: buttonTitle forState:UIControlStateNormal];
	newButton.titleLabel.font = buttonFont;
	newButton.titleLabel.textAlignment = UITextAlignmentCenter;

	// layout
	CGSize textSize = [buttonTitle sizeWithFont: buttonFont];
	currentYOffset += spacing ? LARGE_GAP : REGULAR_GAP;
	newButton.frame = CGRectMake(BUTTON_X_OFFSET, currentYOffset, maxWidth - 2 * BUTTON_X_OFFSET, BUTTON_HEIGHT + textSize.height);
	currentYOffset += BUTTON_HEIGHT + textSize.height;
	newButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self.sheetView addSubview: newButton];

}

# pragma mark -
# pragma mark processing
- (void) processButtonAction: (id) sender {
	// trigger action for highlighted button.
	[self.delegate actionSheet:self triggeredButtonWithId:[(UIView *) sender tag]];
	[self dismissWithAnimation:YES];
}


# pragma mark -
# pragma mark lifecycle

// internal sheet view move from bottom transition
- (void) showAnimated {
	// fade in the dark overlay
	[CATransaction begin];
	[CATransaction setAnimationDuration:.25];
	self.coverLayer.opacity = 0.4;
	[CATransaction commit];
	
	// move the sheet 
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^{
		self.sheetView.center = CGPointMake(self.sheetView.center.x, self.sheetView.center.y - self.sheetView.bounds.size.height);
	} completion:^ (BOOL finished) {}];
}

- (void) showWithAnimation: (BOOL) animated {
	UIWindow* topWindow = [[UIApplication sharedApplication] keyWindow];
	self.frame = topWindow.bounds;
	// size the views
	self.coverLayer.frame = self.bounds;
	// size and layout the sheet. The title frame will only change due to autoresizing width, but will always keep its height.
	CGFloat sheetHeight = currentYOffset + LARGE_GAP;
	self.sheetView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, sheetHeight);
	
	[topWindow addSubview:self];
	
	// because addition of view, the animation is not done in this runloop event but performed within the next event handling run.
	if (animated) {	
		[self performSelector:@selector(showAnimated) withObject:nil afterDelay:0];
	} else {
		self.coverLayer.opacity = 0.4;
		self.sheetView.frame = CGRectMake(0, self.bounds.size.height - sheetHeight, self.bounds.size.width, sheetHeight);
	}
}



- (void) dismissWithAnimation: (BOOL) animated {
	if (animated) {
		[CATransaction begin];
		[CATransaction setAnimationDuration:.25];
		self.coverLayer.opacity = 0.0;
		[CATransaction commit];
		
		[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^{
			self.sheetView.center = CGPointMake(self.sheetView.center.x, self.sheetView.center.y + self.sheetView.bounds.size.height);
		} completion:^ (BOOL finished) {
			[self removeFromSuperview];
		}];
	} else {
		[self removeFromSuperview];
	}
	
}

# pragma mark -
# pragma mark dealloc

- (void)dealloc {
    [super dealloc];
	[coverLayer release];
	[title release];
	[sheetView release];
}


@end
