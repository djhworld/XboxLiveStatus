//
//  AppUtilities.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 04/07/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "AppUtilities.h"


@implementation AppUtilities
+(NSString *)returnDaySuffix:(NSInteger)day
{
	NSString *daySuffix;
	if (day == 1 || day == 21 || day == 31)
	{
		daySuffix = @"st";
	}
	else if (day == 2 || day == 22)
	{
		daySuffix = @"nd";
	}
	else if (day == 3 || day == 23)
	{
		daySuffix = @"rd";
	}
	else
	{
		daySuffix = @"th";
	}
	return daySuffix;
}
@end
