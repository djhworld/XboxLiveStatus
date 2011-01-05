//
//  AboutPaneViewController.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 20/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSAttributedString-URL.h"
#import "DSClickableURLTextField.h"
@interface AboutPaneViewController : NSWindowController 
{
	IBOutlet NSTextField *applicationName;
	IBOutlet NSTextField *applicationVersion;
	IBOutlet NSImageView *applicationIcon;
	IBOutlet NSTextField *urlForShoutOut;
	IBOutlet NSTextField *emailAddr;
	NSString *appName;
	NSImage *appIcon;
	NSString *appVersion;
}
@end
