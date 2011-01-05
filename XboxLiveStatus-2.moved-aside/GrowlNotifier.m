//
//  GrowlNotifier.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 01/07/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "GrowlNotifier.h"


@implementation GrowlNotifier
+(void)postGrowlNotificationWithTitle:(NSString *)title description:(NSString *)description image:(NSData *)image
{
	[GrowlApplicationBridge notifyWithTitle:title description:description notificationName:@"OnlineNotify" iconData:image priority:0 isSticky:NO clickContext:nil];
}
@end
