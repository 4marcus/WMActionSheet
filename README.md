Intro
-----

The WMActionSheet is a simple replacement class for the UIActionSheet of iOS. But it does have an own interface and behaviour and is therefore not compatible with UIActionSheet.

Dependencies
------------

* The code requires iOS 4 but can easily be changed to support iOS 3.1, as well.
* The Xcode file is 3.1 compatible.
* QuartzCore framework required.

Restrictions
------------

* Only iPhone is supported, the action sheet does not render as popover on the iPad. 
* Device orientation changes are not yet supported.

Usage
-----

WMActionSheetAppDelegate.m shows how to use the WMActionSheet.
* Copy `WMActionSheet.h`, `WMActionSheet.m`, `UIImage+tinted.h` and `UIIamge+tinted.m` to your project. 
* Add the `wmdefaultbutton.png` and `wmdefaultbutton@2x.png` files as Resources.
* Add QuartzCore framework to your project's frameworks.
