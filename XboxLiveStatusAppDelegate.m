//
//  XboxLiveStatusAppDelegate.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 08/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "XboxLiveStatusAppDelegate.h"

@implementation XboxLiveStatusAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	NSLog(@"Terminating....");
	[window release];
	return NSTerminateNow;
}


-(void)dealloc
{
	[super dealloc];
}
@end
