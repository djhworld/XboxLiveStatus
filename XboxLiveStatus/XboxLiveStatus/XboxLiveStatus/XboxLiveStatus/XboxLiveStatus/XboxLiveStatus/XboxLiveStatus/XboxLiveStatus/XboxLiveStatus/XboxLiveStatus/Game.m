//
//  Game.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 05/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "Game.h"


@implementation Game
@synthesize name;
@synthesize imageUrl;
@synthesize achievementsScoreTotal;
@synthesize achievementsAvailable;

-(void)setImage
{
	NSLog(@"%@ | Setting image for %@", [self className], self.name); 
	NSString *imageDir = [[NSUserDefaults standardUserDefaults] objectForKey:@"GAME_IMAGE_FULL_DIR"];
	NSString *nameConverted = [self.name stringByReplacingOccurrencesOfString:@" " withString:@""];
	imageFilePath = [[NSString alloc] initWithFormat:@"%@/%@.png",
						  imageDir, nameConverted];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:imageFilePath])
	{
		NSLog(@"%@ | Image for '%@' already in cache", [self className], self.name);
		image = [[NSImage alloc] initWithContentsOfFile:imageFilePath];
	}
	else
	{
		if(imageUrl != nil)
		{
			NSLog(@"%@ | Image for '%@' not in cache, downloading", [self className], self.name);
			
			NSURL *urlo = [NSURL URLWithString:imageUrl];
			NSData *data = [NSData dataWithContentsOfURL:urlo];
			NSError *error = nil;
			if(![data writeToFile:imageFilePath options:NSDataWritingAtomic error:&error])
			{
				NSLog(@"Error writing image file: %@", [error localizedDescription]);
			}
			else
			{
				image = [[NSImage alloc] initWithContentsOfFile:imageFilePath];
			}

		}
	}
}

-(NSImage *)getImage
{
	if(imageFilePath == nil)
	{
		[self setImage];
	}
	return image;
}

-(void)dealloc
{
	[name release];
	[image release];
	[imageUrl release];
	[imageFilePath release];
	[super dealloc];
}
@end
