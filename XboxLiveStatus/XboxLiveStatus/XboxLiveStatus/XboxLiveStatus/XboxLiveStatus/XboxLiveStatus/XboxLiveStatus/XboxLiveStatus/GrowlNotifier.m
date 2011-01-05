//
//  GrowlNotifier.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 02/07/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "GrowlNotifier.h"


@implementation GrowlNotifier
-(id)init
{
	if(self == [super init])
	{
		[GrowlApplicationBridge setGrowlDelegate: self];
	}
	return self;
}

-(void)growlNotification:(NSString *)title withMessage:(NSString *)message andImage:(NSImage *)image
{
	//ensures no notifications are thrown when the application is first started
	NSNumber *growlPref = [[NSUserDefaults standardUserDefaults] objectForKey:@"GROWL_NOTIFY_PREF"];
	NSNumber *firstLoad = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRST_TIME_START_IND"];
	if([growlPref intValue] == 1 && [firstLoad intValue] != 1)
	{
		NSLog(@"%@ | Growl notifications are enabled, posting notification", [self className]);
		[GrowlApplicationBridge 
		 notifyWithTitle:title
		 description:message 
		 notificationName:@"OnlineNotify" 
		 iconData:[image TIFFRepresentation] 
		 priority:0 
		 isSticky:NO 
		 clickContext:nil];
	}
}

-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[super dealloc];
}
@end
