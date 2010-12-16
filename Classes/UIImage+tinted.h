//
//  UIImage+tinted.h
//  
//
//  Created by Marcus Wagner on 14.12.10.
//  Copyright 2010 wintermute.de. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Tinted) 

// returns a new image with the given tintColor. If nil is passed, self is returned.
- (UIImage *) tintWithColor:(UIColor *) tintColor;

@end
