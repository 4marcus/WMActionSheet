//
//  UIImage+tinted.m
//  
//
//  Created by Marcus Wagner on 14.12.10.
//  Copyright 2010 wintermute.de. All rights reserved.
//
//  Tint code based on code from Hardy Macia'S UICustomSwitch (http://www.catamount.com/blog/?p=1063):
//  Created by Hardy Macia on 10/28/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//

#import "UIImage+tinted.h"


@implementation UIImage (Tinted)

- (UIImage *) tintWithColor:(UIColor *) tintColor {	
	
    if (tintColor) 	{
		// iOS 4 and up
		UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
		CGContextDrawImage(context, CGRectMake(0,0, self.size.width, self.size.height), self.CGImage);
		
		[self drawAtPoint:CGPointZero];
		
		[tintColor setFill];
		UIRectFillUsingBlendMode(CGRectMake(0,0,self.size.width,self.size.height), kCGBlendModeColor);
		UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
        return tintedImage;
    } else {
        return self;
    }
}

@end
