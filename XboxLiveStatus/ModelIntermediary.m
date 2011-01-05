//
//  ModelIntermediary.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 06/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "ModelIntermediary.h"


@implementation ModelIntermediary
@synthesize gamerTagModel;
@synthesize gameModel;

-(id)init
{
	if(self == [super init])
	{
		gamerTagModel = [[GamerTagModel alloc] init];
		gamerTagModel.delegate = self;
		gameModel = [[GameModel alloc] init];
		gameModel.delegate = self;
		
		itemsQueue = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)setupStoragePaths
{	
	NSString *gamerTagsFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"TAGS_FILE"];
	NSString *gamesFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"GAMES_FILE"];
	
	gamerTagModel.modelStoragePath = [[NSBundle mainBundle] pathForResource:gamerTagsFileName ofType:@"plist"];
	gameModel.modelStoragePath = [[NSBundle mainBundle] pathForResource:gamesFileName ofType:@"plist"];
}

-(void)initialiseModels
{
	[gamerTagModel loadModelFromFile];
	[gameModel loadModelFromFile];	
}

-(void)populateCurrentlyPlaying
{
	for(int i = 0; i < [gamerTagModel numberOfItems]; i++)
	{
		GamerTag *tag = [gamerTagModel gamerTagAtPosition:i];
		Game *current = [gameModel getGame:tag.playing];
		if(current != nil || current != NULL)
		{
			tag.currentlyPlaying = current;
		}

	}
}
-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[gamerTagModel release];
	[gameModel release];
	[itemsQueue release];
	[super dealloc];
}

#pragma mark -
#pragma mark ModelDelegate Methods
-(void)notifyUpdated:(Model *)model
{
	NSLog(@"%@ | Update notification for %@", [self className], [model className]);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TagUpdated" object:nil];

}

-(void)notifyComplete:(Model *)model
{
	NSLog(@"%@ | Complete notification for %@", [self className], [model className]);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AllTagsUpdated" object:nil];	
	if([model isKindOfClass:[GamerTagModel class]])
	{
		int numberOfGamesPrevious = [gameModel numberOfItems];
		NSLog(@"%@ | There are %d 'recent games' lists to process.", [self className], [itemsQueue count]);
		for(int i = 0; i < [itemsQueue count]; i++)
		{
			[gameModel updateModel:[itemsQueue objectAtIndex:i]];
		}
		[itemsQueue removeAllObjects];
		if([gameModel numberOfItems] > numberOfGamesPrevious)
		{
			NSLog(@"%@ | Game model has been modified. Commiting.", [self className]);
			[gameModel commitModel];
		}
		[self populateCurrentlyPlaying];
	}
}

-(void)postItemForProcessing:(NSObject *)item
{
	NSLog(@"%@ | Posting item to processing queue", [self className]);
	NSArray *itemDict = (NSArray *)item;
	[itemsQueue addObject:itemDict];
}

@end
