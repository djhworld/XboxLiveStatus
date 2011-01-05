//
//  XboxLiveStatusAppDelegate.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 08/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XboxFriendsListViewController.h"
#import "AppSettings.h"
@interface XboxLiveStatusAppDelegate : NSObject <NSApplicationDelegate> 
{
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
