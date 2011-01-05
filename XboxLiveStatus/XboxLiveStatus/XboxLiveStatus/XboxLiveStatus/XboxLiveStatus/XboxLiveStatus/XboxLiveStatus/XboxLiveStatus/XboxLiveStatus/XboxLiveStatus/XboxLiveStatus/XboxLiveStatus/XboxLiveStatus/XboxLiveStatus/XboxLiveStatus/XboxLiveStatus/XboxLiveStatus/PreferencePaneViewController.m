//
//  PreferencePaneViewController.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 12/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "PreferencePaneViewController.h"


@implementation PreferencePaneViewController
-(id)init
{
	if(self == [super init])
	{
		self = [super initWithWindowNibName:@"Preferences"];
	}
	return self;
}


-(IBAction)buttonPressed:(id)sender
{
	if([sender tag] == 1)
	{
		[self.window close];
	}
	else
	{
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		NSUInteger result = [refreshInterval intValue];
		NSUInteger currentRefreshInterval = [[defaults objectForKey:@"REFRESH_INTERVAL"] intValue];
		
		if([growlCheckBox state]==NSOnState)
		{
			[defaults setObject:[NSNumber numberWithInt:1] forKey:@"GROWL_NOTIFY_PREF"];
			[defaults synchronize];
		}
		else
		{
			[defaults setObject:[NSNumber numberWithInt:0] forKey:@"GROWL_NOTIFY_PREF"];
			[defaults synchronize];
		}

		
		if(result != currentRefreshInterval/60)
		{
			if(result < MIN_REFRESH || result > MAX_REFRESH)
			{
				NSString *message = [NSString stringWithFormat:@"Input is invalid"];
				NSString *messageSub = [NSString stringWithFormat:@"The refresh interval is limited to be between %d and %d minutes", MIN_REFRESH, MAX_REFRESH];
				NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, messageSub, NSLocalizedRecoverySuggestionErrorKey, nil];
				NSError *error = [NSError errorWithDomain:PreferencesErrorDomain code:PreferencesInputInvalidError userInfo:errorDict];
				[NSApp presentError:error];
				[refreshInterval setStringValue:@""];
			}	
			else
			{
				NSLog(@"%@ | New refresh time is %d minutes", [self className], result);
				result = result*60;
				[defaults setObject:[NSNumber numberWithInt:result] forKey:@"REFRESH_INTERVAL"];
				[defaults synchronize];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshIntervalChanged" object:nil];
				[self.window close];
			}
		}
		else
		{
			NSLog(@"%@ | Will not be resetting refresh interval as it is the same as the current value", [self className]);
			[self.window close];
		}
	}
}

-(IBAction)resetSettings:(id)sender
{
	[refreshInterval setStringValue:@"-----------"];
	[AppSettings resetAppPreferences];
	[self populateWindow];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshIntervalChanged" object:nil];
}

-(void)controlTextDidEndEditing:(NSNotification *)aNotification
{
	if([[refreshInterval stringValue] isEqualToString:@""] == NO)
	{
		[self buttonPressed:nil];
	}
}

-(void)setLastRefreshDate:(NSDate *)date
{
	//get the suffix for the day
	NSInteger dayOfMonth= (NSInteger)[[date descriptionWithCalendarFormat:@"%d" timeZone:nil locale:nil] integerValue];
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:[NSString stringWithFormat:@"H:mm:ss 'on' d'%@' 'of' MMMM YYYY", [AppUtilities returnDaySuffix:dayOfMonth]]];
	NSString *dateStr = [format stringFromDate:date];
	[lastRefreshTime setStringValue:dateStr];
	[format release];
}

-(void)setNextRefreshDate:(NSDate *)date
{
	//get the suffix for the day
	NSInteger dayOfMonth= (NSInteger)[[date descriptionWithCalendarFormat:@"%d" timeZone:nil locale:nil] integerValue];
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:[NSString stringWithFormat:@"H:mm:ss 'on' d'%@' 'of' MMMM YYYY", [AppUtilities returnDaySuffix:dayOfMonth]]];
	NSString *dateStr = [format stringFromDate:date];
	
	[nextRefreshTime setStringValue:dateStr];
	[format release];
}

-(void)populateWindow
{
	NSNumber *refresh = [[NSUserDefaults standardUserDefaults] objectForKey:@"REFRESH_INTERVAL"];
	refresh = [NSNumber numberWithInt:[refresh intValue]/60];
	[refreshInterval setStringValue:[refresh stringValue]];
	[self setRequestCounter];
	NSNumber *growlStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"GROWL_NOTIFY_PREF"];
	if([growlStatus intValue] == 1)
		[growlCheckBox setState:NSOnState];
	else
		[growlCheckBox setState:NSOffState];

}

-(void)setRefreshProj:(int)numberOfTags
{
	int refreshTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"REFRESH_INTERVAL"] intValue]/60;
	int refreshProjectionValue = numberOfTags * (60/refreshTime) * 24;
	NSString *message = [NSString stringWithFormat:@"%d requests/24 hours (%drph)", refreshProjectionValue, refreshProjectionValue/24];
	[refreshProjection setStringValue:message];
}

-(void)setRequestCounter
{
	int refreshCnt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"API_CALL_COUNT"] intValue];
	NSString *message = [NSString stringWithFormat:@"%d requests made to the server", refreshCnt];
	[requestCount setStringValue:message];
}

-(void)dealloc
{
	NSLog(@"%@ | dealloc called.", [self className]);
	[super dealloc];
}
@end
