//
//  GamerTagModel.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 10/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "GamerTagModel.h"

@implementation GamerTagModel
-(id)init
{
	if(self == [super init])
	{
		gamerTags = [[NSMutableArray alloc] initWithCapacity:1];
		updatedTags = 0;
	}
	return self;
}

-(void)addGamerTag:(GamerTag *)tag
{
	NSLog(@"%@ | Adding '%@' to the system",[self className], tag.name);
	[gamerTags addObject:tag];
}

-(int)addNewGamerTag:(NSString *)tagName
{
	NSLog(@"%@ | Adding new gamertag '%@' to the system",[self className], tagName);
	if( ![self doesGamerTagAlreadyExist:tagName] )
	{
		GamerTag *tag = [[GamerTag alloc] initWithName:tagName];
		[gamerTags addObject:tag];
		updatedTags = [gamerTags count]-1;
		int position = [gamerTags indexOfObject:tag];
		GamerTagUpdater *updater = [[GamerTagUpdater alloc] initWithTag:tag andTagIdentifier:position withDelegate:self];
		updater.addMode = YES;
		[updater startUpdate];
		[tag release];
	}
	else
	{
		NSLog(@"%@ | Gamertag '%@' already exists in the system",[self className], tagName);
		updatedTags = [gamerTags count];
		[self notifyUpdate];
		return -1;
	}
	return 0;
}

-(BOOL)doesGamerTagAlreadyExist:(NSString *)tagName
{
	BOOL result = NO;
	NSString *lowerCaseInput = [tagName lowercaseString];
	for(GamerTag *tag in gamerTags)
	{
		NSString *lowerCaseOriginal = [tag.name lowercaseString];
		NSLog(@"%@ | Checking if %@ is equal to %@", [self className], lowerCaseInput, lowerCaseOriginal);
		if([lowerCaseInput isEqualToString:lowerCaseOriginal])
		{
			NSLog(@"%@ | Match found, returning true.", [self className]);
			result = YES;
			break;
		}
	}
	return result;
}

-(void)removeGamerTag:(int)tagPos
{
	GamerTag *tag = [[gamerTags objectAtIndex:tagPos] retain];
	NSLog(@"%@ | Removing '%@' from system", [self className], tag.name);
	[tag removeAvatar];
	[tag release];
	[gamerTags removeObjectAtIndex:tagPos];
}

-(GamerTag *)gamerTagAtPosition:(int)pos
{
	return [gamerTags objectAtIndex:pos];
}

-(int)numberOfItems
{
	return [gamerTags count];
}

-(BOOL)isEmpty
{
	if([gamerTags count] == 0)
		return YES;
	
	return NO;
}

-(void)updateTags
{
	NSLog(@"%@ | Calling API to update %d gamertags",[self className], [self numberOfItems]);
	updatedTags = 0;
	for(GamerTag *tag in gamerTags)
	{
		int position = [gamerTags indexOfObject:tag];
		GamerTagUpdater *updater = [[GamerTagUpdater alloc] initWithTag:tag andTagIdentifier:position withDelegate:self];
		[updater startUpdate];
	}
}

-(void)setTagStatusToUpdating
{
	for(GamerTag *tag in gamerTags)
	{
		tag.currentActivity = @"Updating....";
	}
}

-(void)refreshAvatars
{
	NSLog(@"%@ | Refreshing avatars for %d tags",[self className], [self numberOfItems]);
	for(GamerTag *tag in gamerTags)
	{
		[tag setAvatar];
	}
}

-(void)removeAvatars
{
	NSLog(@"%@ | Removing avatars for %d tags",[self className], [self numberOfItems]);
	for(GamerTag *tag in gamerTags)
	{
		[tag removeAvatar];
	}
}

-(void)sortModelByName:(BOOL)asc
{
	NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:asc selector:@selector(compareCaseInsensitive:)];
	[gamerTags sortUsingDescriptors:[NSArray arrayWithObject:desc]];
}

-(void)sortModelByStatus:(BOOL)asc
{
	NSSortDescriptor *desc2 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"online" ascending:asc];

	[gamerTags sortUsingDescriptors:[NSArray arrayWithObjects:desc, desc2, nil]];
}


-(void)commitModel
{
	NSLog(@"%@ | Writing data to file: %@", [self className], modelStoragePath);
	NSMutableArray *tagNames = [[NSMutableArray alloc] initWithCapacity:1];
	NSString *yes = @"Y";
	NSString *no = @"N";
	NSString *isValid;
	for(GamerTag *tag in gamerTags)
	{
		isValid = (tag.hasBeenValidated) ? yes : no;
		
		[tagNames addObject:[NSString stringWithFormat:@"%@,%@",tag.name,isValid]];
	}
	[tagNames writeToFile:modelStoragePath atomically:YES];	
	[tagNames release];
}

-(void)loadModelFromFile
{
	NSArray *names = [NSArray arrayWithContentsOfFile:modelStoragePath];
	NSString *nameString;
	NSString *isValidString;
	if([names count] > 0)
	{
		for(NSString *name in names)
		{
			if(name != nil)
			{
				NSArray *split = [name componentsSeparatedByString:@","];
				nameString = [split objectAtIndex:0];
				isValidString = [split objectAtIndex:1];
				NSLog(@"%@ | Picked up '%@' for processing",[self className], nameString);
				GamerTag *tag = [[GamerTag alloc] initWithName:nameString];
				tag.hasBeenValidated = ([isValidString isEqualToString:@"Y"]) ? YES : NO;
				[self addGamerTag:tag];
				[tag release];
			}
		}
	}
}

-(void)notifyUpdate
{
	if([delegate respondsToSelector:@selector(notifyUpdated:)])
		[delegate notifyUpdated:self];
	
	if(updatedTags == [gamerTags count])
	{
		if([delegate respondsToSelector:@selector(notifyComplete:)])
		{
			[delegate notifyComplete:self];
		}
	}
}

-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[gamerTags release];
	[super dealloc];
}


#pragma mark -
#pragma mark GamerTagUpdaterDelegate Delegate Methods
-(void)updatedTagSuccessfully:(GamerTagUpdater *)updater
{
	GamerTag *tag = [gamerTags objectAtIndex:updater.identity];
	NSLog(@"%@ | Tag '%@' updated successfully.", [self className], tag.name);
	
	if(updater.addMode)
	{
		[self commitModel];
	}
	
	NSDictionary *recentGames = [updater.gamesDictionary retain];
	if([delegate respondsToSelector:@selector(postItemForProcessing:)])
		[delegate postItemForProcessing:recentGames];
	
	[updater release];
	updatedTags++;
	[self notifyUpdate];
}

-(void)updateFailed:(GamerTagUpdater *)updater error:(NSError *)error
{
	GamerTag *tag = [gamerTags objectAtIndex:updater.identity];
	if(error.code == DownloaderErrorNoConnection)
	{
		updatedTags++;
		tag.currentActivity = @"Error: Could not connect to network!";
	}
	else if(error.code == GamerTagUpdaterTagOver15CharsError 
			|| error.code == GamerTagUpdaterInvalidTagError 
			|| error.code == GamerTagUpdaterErrorAddingTagDueToNetworkIssueError)
	{
		[NSApp presentError:error];
		[self removeGamerTag:updater.identity];
		updatedTags = [gamerTags count];
	}

	[updater release];
	[self notifyUpdate];
}
@end
