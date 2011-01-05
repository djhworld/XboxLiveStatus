//
//  GamerTagUpdater.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 31/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "GamerTagUpdater.h"

@implementation GamerTagUpdater
@synthesize tag;
@synthesize identity;
@synthesize delegate;
@synthesize addMode;
@synthesize gamesDictionary;
-(id)initWithTag:(GamerTag *)gamerTag andTagIdentifier:(int)ident withDelegate:(id <NSObject, GamerTagUpdaterDelegate>) dele
{
	if(self == [super init])
	{
		self.tag = gamerTag;
		self.identity = ident;
		self.delegate = dele;
		addMode = FALSE;
		apiURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"API_URL"];
		gamesDictionary = [[NSDictionary alloc] init];
	}
	return self;
}

-(void)startUpdate
{
	if([tag.name length] > 15)
	{
		if([delegate respondsToSelector:@selector(updateFailed:error:)])
		{
			NSString *message = [NSString stringWithFormat:@"Tag is too big!"];
			NSString *messageSub = [NSString stringWithFormat:@"The gamertag '%@' is too big to be valid", tag.name];
			NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, messageSub, NSLocalizedRecoverySuggestionErrorKey, nil];
			NSError *err = [NSError errorWithDomain:GamerTagUpdaterErrorDomain code:GamerTagUpdaterTagOver15CharsError userInfo:errorDict];
			[delegate updateFailed:self error:err];
		}
	}
	else
	{
		NSString *formattedTagName = [tag.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		NSString *urlActual = [NSString stringWithFormat:@"%@%@",apiURL,formattedTagName];
		downloader = [[Downloader alloc] initWithUrlString:urlActual delegate:self];	
		[downloader download];	
	}
}

-(BOOL)updateTagWithXMLData:(NSDictionary *)gamerTagInfo
{
	NSLog(@"%@ | Updating tag: %@",[self className], tag.name);
	
	tag.lastSeen = [[gamerTagInfo objectForKey:@"PresenceInfo"] objectForKey:@"LastSeen"];
	tag.playing = [[gamerTagInfo objectForKey:@"PresenceInfo"] objectForKey:@"Title"];
	
	NSString *currentActivity = [[gamerTagInfo objectForKey:@"PresenceInfo"] objectForKey:@"Info"];
	NSString *currentActSubText = [[gamerTagInfo objectForKey:@"PresenceInfo"] objectForKey:@"Info2"];
	currentActSubText = [currentActSubText stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "]; 
	
	if([currentActSubText isEqualToString:@""] == NO)
	{
		tag.currentActivity = [NSString stringWithFormat:@"%@\r\n%@", currentActivity, currentActSubText];
	}
	else if([currentActivity isEqualToString:@""])
	{
		tag.currentActivity = @"No recent status updates are available";
	}
	else
	{
		NSArray *components = [currentActivity componentsSeparatedByString:@" "];
		if([[components objectAtIndex:0] isEqualToString:@"Last"] && [[components objectAtIndex:4] isEqualToString:@"ago"])
		{
			NSString *replaced = [currentActivity stringByReplacingOccurrencesOfString:@"ago playing" withString:@"ago\r\nPlaying"];
			tag.currentActivity = [NSString	stringWithFormat:@"%@\r\n%@", replaced, currentActSubText];
		}
		else
		{
			tag.currentActivity = [currentActivity stringByReplacingOccurrencesOfString:@"   playing" withString:@"\r\nPlaying"];
		}
		components = nil;
	}
	
	tag.avatarPath = [gamerTagInfo objectForKey:@"TileUrl"];
	
	NSString *gamerScoreStr = [gamerTagInfo objectForKey:@"GamerScore"];
	tag.gamerScore = [NSNumber numberWithInt:[gamerScoreStr intValue]];
	
	tag.country = [gamerTagInfo objectForKey:@"Country"];
	tag.isGold = [[gamerTagInfo objectForKey:@"AccountStatus"] isEqualToString:@"Gold"] ? YES : NO;
	tag.profileURL = [gamerTagInfo objectForKey:@"ProfileUrl"];
	
	NSString *systemTagName = [gamerTagInfo objectForKey:@"Gamertag"];
	if([tag.name isEqualToString:systemTagName] == NO)
	{
		NSLog(@"%@ | Inputted tag '%@' does not quite match '%@'. Correcting...",[self className], tag.name, systemTagName);
		tag.name = systemTagName;
	}
	[tag setAvatar];
	
	BOOL onlineStatus = [[[gamerTagInfo objectForKey:@"PresenceInfo"] objectForKey:@"Online"] isEqualToString:@"true"] ? YES : NO;	
	if(tag.online != onlineStatus)
	{
		if(tag.online == NO)
		{
			tag.online = onlineStatus;
			NSString *titleMessage = [NSString stringWithFormat:@"%@ is now online", tag.name];
			NSString *statusMessage = [NSString stringWithFormat:@"Playing %@", tag.playing];
			GrowlNotifier *gn = [[GrowlNotifier alloc] init];
			[gn growlNotification:titleMessage withMessage:statusMessage andImage:tag.avatar];
			[gn release];
		}
		else
		{
			tag.online = onlineStatus;
		}
	}
	
	return YES;
}

-(void)processData:(NSString *)data
{
	GamerTagXMLParser *parser = [[GamerTagXMLParser alloc] init];
	NSDictionary *gamerTagInfo = [[parser parseXML:data] retain];
	[parser release];
	if(gamerTagInfo == nil)
	{
		NSLog(@"%@ | Gamertag '%@' is invalid.",[self className], tag.name);
		if(!tag.hasBeenValidated)
		{
			if([delegate respondsToSelector:@selector(updateFailed:error:)])
			{
				NSString *message = [NSString stringWithFormat:@"Tag is invalid."];
				NSString *messageSub = [NSString stringWithFormat:@"The gamertag '%@' is invalid", tag.name];
				NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, messageSub, NSLocalizedRecoverySuggestionErrorKey, nil];
				NSError *err = [NSError errorWithDomain:GamerTagUpdaterErrorDomain code:GamerTagUpdaterInvalidTagError userInfo:errorDict];
				[delegate updateFailed:self error:err];
			}
		}
		else
		{
			tag.currentActivity = @"Cannot retrieve information at this time";
			tag.avatarPath = nil;
			[tag setAvatar];
			if([delegate respondsToSelector:@selector(updatedTagSuccessfully:)])
				[delegate updatedTagSuccessfully:self];
		}

	}
	else
	{
		tag.hasBeenValidated = YES;
		if([self updateTagWithXMLData:gamerTagInfo])
		{
			[gamesDictionary release];
			gamesDictionary = [gamerTagInfo objectForKey:@"RecentGames"];
			if([delegate respondsToSelector:@selector(updatedTagSuccessfully:)])
				[delegate updatedTagSuccessfully:self];
		}
	}
	[gamerTagInfo release];
}

-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[gamesDictionary release];
	[tag release];
	[super dealloc];
}

#pragma mark -
#pragma mark Downloader Delegate Methods
-(void)downloadDidFinishDownloading:(Downloader *)download
{
	NSLog(@"%@ | Downloaded XML for: %@", [self className], tag.name);
	NSString *result = [[NSString alloc] initWithData:download.receivedData encoding:NSUTF8StringEncoding];
	[download release];
	[self processData:result];
	[result release];
}

-(void)download:(Downloader *)download didFailWithError:(NSError *)error
{
	NSLog(@"%@ | Failed to download XML for: %@", [self className], tag.name);
	[download release];
	
	if([delegate respondsToSelector:@selector(updateFailed:error:)])
	{
		NSError *err = nil;
		if(self.addMode)
		{
			NSString *messageSub = [NSString stringWithFormat:@"There was an issue attempting to add gamertag '%@' to the system as there appears to be a problem connecting to the server.\n\nPlease check your network connection.", tag.name];
			NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Error attempting to add GamerTag", NSLocalizedDescriptionKey, messageSub, NSLocalizedRecoverySuggestionErrorKey, nil];
			err = [NSError errorWithDomain:GamerTagUpdaterErrorDomain code:GamerTagUpdaterErrorAddingTagDueToNetworkIssueError userInfo:errorDict];
		}
		else
		{
			err = [NSError errorWithDomain:DownloaderErrorDomain code:DownloaderErrorNoConnection userInfo:nil];
		}
		[delegate updateFailed:self error:err];
	}
}
@end
