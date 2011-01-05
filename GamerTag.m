//
//  GamerTag.m
//  XboxFriends
//
//  Created by Daniel Harper on 08/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "GamerTag.h"
#import "TBXML.h"

@implementation GamerTag
@synthesize name;
@synthesize online;
@synthesize lastSeen;
@synthesize currentActivity;
@synthesize avatar;
@synthesize avatarPath;
@synthesize isGold;
@synthesize country;
@synthesize gamerScore;
@synthesize profileURL;
@synthesize playing;
@synthesize currentlyPlaying;
@synthesize hasBeenValidated;
-(id)initWithName:(NSString *)gamerTag
{
	if(self == [super init])
	{
		self.name = gamerTag;
		self.online = NO;
		self.lastSeen = @"Never";
		self.currentActivity = @"Nothing";
		self.hasBeenValidated = NO;
		[self setAvatar];
	}
	return self;
}

-(void)setAvatar
{
	NSString *imageDir = [[NSUserDefaults standardUserDefaults] objectForKey:@"AVATAR_IMAGE_FULL_DIR"];
	NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",
						  imageDir, self.name];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:filePath])
	{
		NSLog(@"%@ | Avatar for %@ already in cache", [self className], self.name);
		if(avatar != nil)
			[avatar release];
		
		avatar = [[NSImage alloc] initWithContentsOfFile:filePath];
	}
	else
	{
		if(avatarPath != nil)
		{
			NSLog(@"%@ | Avatar for %@ not in cache, downloading....", [self className], self.name);
			if(avatar != nil)
				[avatar release];
			
			NSURL *urlo = [NSURL URLWithString:avatarPath];
			NSData *data = [NSData dataWithContentsOfURL:urlo];
			
			if(data != nil || data != NULL)
			{
				[data writeToFile:filePath atomically:YES];
				avatar = [[NSImage alloc] initWithContentsOfFile:filePath];
			}
			else
			{
				filePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"question.png"];
				avatar = [[NSImage alloc] initWithContentsOfFile:filePath];
			}
		}
		else
		{
			filePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"question.png"];
			avatar = [[NSImage alloc] initWithContentsOfFile:filePath];
		}

	}
}

-(void)removeAvatar
{
	NSString *imageDir = [[NSUserDefaults standardUserDefaults] objectForKey:@"AVATAR_IMAGE_FULL_DIR"];
	NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",
						  imageDir, self.name];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:filePath])
	{
		NSLog(@"%@ | Removing avatar for %@", [self className], self.name);
		[fileManager removeItemAtPath:filePath error:nil];
	}
}

-(void)dealloc
{
	[avatar release];
	[avatarPath release];
	[name release];
	[lastSeen release];
	[currentActivity release];
	[gamerScore release];
	[profileURL release];
	[country release];
	[playing release];
	[super dealloc];
}
@end
