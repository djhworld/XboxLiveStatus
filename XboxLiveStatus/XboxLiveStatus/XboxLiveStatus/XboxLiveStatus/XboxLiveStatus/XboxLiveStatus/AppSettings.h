//
//  AppSettings.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 16/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define DEFAULT_REFRESH_INTERVAL 300
#define DEFAULT_IMAGE_DIR @"Images"
#define DEFAULT_AVATAR_IMAGE_DIR @"Avatars"
#define DEFAULT_GAME_IMAGE_DIR @"Games"
#define DEFAULT_TAGS_FILE @"GamerTags"
#define DEFAULT_GAMES_FILE @"GamesInfo"
#define DEFAULT_API_URL @"http://xboxapi.duncanmackenzie.net/gamertag.ashx?GamerTag="
#define DEFAULT_GROWL_NOTIFY_PREF 1
#define DEFAULT_FIRST_TIME_START_IND 0
#define DEFAULT_API_CALL_COUNT 0

#define KEY_REFRESH_INTERVAL @"REFRESH_INTERVAL"
#define KEY_IMAGE_FULL_DIR @"IMAGE_FULL_DIR" 
#define KEY_AVATAR_IMAGE_FULL_DIR @"AVATAR_IMAGE_FULL_DIR"
#define KEY_GAME_IMAGE_FULL_DIR @"GAME_IMAGE_FULL_DIR"
#define KEY_TAGS_FILE @"TAGS_FILE"
#define KEY_GAMES_FILE @"GAMES_FILE"
#define KEY_API_URL @"API_URL"
#define KEY_GROWL_NOTIFY_PREF @"GROWL_NOTIFY_PREF"
#define KEY_FIRST_TIME_START_IND @"FIRST_TIME_START_IND"
#define KEY_API_CALL_COUNT @"API_CALL_COUNT"

@interface AppSettings : NSObject {

}
+(void)setAPICountAmount;
+(void)registerAppSettings;
+(BOOL)createDirectory:(NSString *)path;
+(NSString *)createFullPath:(NSString *)dirName;
+(BOOL)doesDirectoryExist:(NSString *)path;
+(void)resetAppPreferences;
+(BOOL)validateUserDefaults;
@end
