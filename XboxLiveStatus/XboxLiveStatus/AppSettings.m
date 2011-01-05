//
//  AppSettings.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 16/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "AppSettings.h"


@implementation AppSettings

+(void)setAPICountAmount
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
	[defaults setObject:[NSNumber numberWithInt:0] forKey:KEY_API_CALL_COUNT];
}

+(void)registerAppSettings
{
	if([AppSettings validateUserDefaults] == NO)
	{
		NSLog(@"%@ | Setting up default application preferences", [self className]);
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults synchronize];
		NSNumber *refresh = [NSNumber numberWithInt:DEFAULT_REFRESH_INTERVAL];
		[defaults setObject:refresh forKey:KEY_REFRESH_INTERVAL];
		
		NSString *imageDirPath = [AppSettings createFullPath:DEFAULT_IMAGE_DIR];
		if([AppSettings doesDirectoryExist:imageDirPath] == NO)
		{
			[AppSettings createDirectory:imageDirPath];
		}
		[defaults setObject:imageDirPath forKey:KEY_IMAGE_FULL_DIR];
		
		NSString *avatarDirPath = [imageDirPath stringByAppendingFormat:@"/%@", DEFAULT_AVATAR_IMAGE_DIR];
		if([AppSettings doesDirectoryExist:avatarDirPath] == NO)
		{
			[AppSettings createDirectory:avatarDirPath];
		}
		[defaults setObject:avatarDirPath forKey:KEY_AVATAR_IMAGE_FULL_DIR];
		
		NSString *gameImageDirPath = [imageDirPath stringByAppendingFormat:@"/%@", DEFAULT_GAME_IMAGE_DIR];
		if([AppSettings doesDirectoryExist:gameImageDirPath] == NO)
		{
			[AppSettings createDirectory:gameImageDirPath];
		}
		[defaults setObject:gameImageDirPath forKey:KEY_GAME_IMAGE_FULL_DIR];
		[defaults setObject:DEFAULT_TAGS_FILE forKey:KEY_TAGS_FILE];
		[defaults setObject:DEFAULT_GAMES_FILE forKey:KEY_GAMES_FILE];
		[defaults setObject:DEFAULT_API_URL	forKey:KEY_API_URL];
		NSNumber *growlStatus = [NSNumber numberWithInt:DEFAULT_GROWL_NOTIFY_PREF];
		[defaults setObject:growlStatus forKey:KEY_GROWL_NOTIFY_PREF];
		[defaults setObject:[NSNumber numberWithInt:DEFAULT_FIRST_TIME_START_IND] forKey:KEY_FIRST_TIME_START_IND];
		[defaults synchronize];
	}
}

+(BOOL)validateUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
	if([defaults objectForKey:KEY_REFRESH_INTERVAL] == nil
	   || [defaults objectForKey:KEY_IMAGE_FULL_DIR] == nil
	   || [defaults objectForKey:KEY_AVATAR_IMAGE_FULL_DIR] == nil
	   || [defaults objectForKey:KEY_GAME_IMAGE_FULL_DIR] == nil
	   || [defaults objectForKey:KEY_TAGS_FILE] == nil
	   || [defaults objectForKey:KEY_GAMES_FILE] == nil
	   || [defaults objectForKey:KEY_API_URL] == nil
	   || [defaults objectForKey:KEY_GROWL_NOTIFY_PREF] == nil
	   || [defaults objectForKey:KEY_FIRST_TIME_START_IND] == nil)
	{
		return NO;
	}
	
	NSString *imageDirPath = [AppSettings createFullPath:DEFAULT_IMAGE_DIR];
	if([AppSettings doesDirectoryExist:imageDirPath] == NO)
	{
		return NO;
	}
	
	return YES;
}

+(void)resetAppPreferences
{
	NSLog(@"%@ | Resetting application preferences", [self className]);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:KEY_REFRESH_INTERVAL];
	[defaults removeObjectForKey:KEY_IMAGE_FULL_DIR];
	[defaults removeObjectForKey:KEY_AVATAR_IMAGE_FULL_DIR];
	[defaults removeObjectForKey:KEY_GAME_IMAGE_FULL_DIR];
	[defaults removeObjectForKey:KEY_TAGS_FILE];
	[defaults removeObjectForKey:KEY_GAMES_FILE];
	[defaults removeObjectForKey:KEY_API_URL];
	[defaults removeObjectForKey:KEY_GROWL_NOTIFY_PREF];
	[defaults removeObjectForKey:KEY_FIRST_TIME_START_IND];
	[defaults synchronize];
	[AppSettings registerAppSettings];
}

+(BOOL)createDirectory:(NSString *)path
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	NSLog(@"%@ | Creating directory at path: %@", [self className], path);
	[fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
	if(error != nil)
	{
		[NSApp presentError:error];
		return NO;
	}
	return YES;
}

+(NSString *)createFullPath:(NSString *)dirName
{
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *fullPath = [resourcePath stringByAppendingFormat:@"/%@", dirName];
	return fullPath;
}

+(BOOL)doesDirectoryExist:(NSString *)path
{
	NSLog(@"%@ | Checking if directory exists at path: %@", [self className], path);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path])
	{
		return YES;
	}
	return NO;
}
@end
