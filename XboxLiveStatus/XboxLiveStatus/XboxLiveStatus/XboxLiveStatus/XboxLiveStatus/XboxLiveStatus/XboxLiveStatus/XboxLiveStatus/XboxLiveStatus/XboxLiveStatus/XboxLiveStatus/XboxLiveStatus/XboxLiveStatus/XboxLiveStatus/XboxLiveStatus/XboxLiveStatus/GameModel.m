//
//  GameModel.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 05/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "GameModel.h"


@implementation GameModel
-(id)init
{
	if(self == [super init])
	{
		games = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void)addGame:(Game *)game
{
	[games setObject:game forKey:game.name];
}

-(void)updateModel:(NSArray *)content
{
	int discardedGames = 0;
	int addedGames = 0;
	for(NSDictionary *dict in content)
	{
		NSString *gameName = [dict objectForKey:K_NAME];
		if([games objectForKey:gameName] != nil)
		{
			discardedGames++;
		}
		else
		{
			Game *game = [[Game alloc] init];
			game.name = gameName;
			game.achievementsAvailable = [[dict objectForKey:K_TOTAL_ACHIEVEMENTS] intValue];
			game.achievementsScoreTotal = [[dict objectForKey:K_TOTAL_GAMER_SCORE] intValue];
			game.imageUrl = [dict objectForKey:K_IMAGE_URL];
			[self addGame:game];
			[game release];
			addedGames++;
		}
	}
	NSLog(@"%@ | %d games were added to the model. %d were discarded", [self className], addedGames, discardedGames);	
}

-(void)commitModel
{
	NSMutableArray *theGames = [[NSMutableArray alloc] init];
	for(Game *game in [games allValues])
	{
		NSMutableDictionary *gameInfo = [[NSMutableDictionary alloc] init];
		[gameInfo setObject:game.name forKey:K_NAME];
		
		NSNumber *totalAchieve = [[NSNumber alloc] initWithInt:game.achievementsAvailable];
		[gameInfo setObject:totalAchieve forKey:K_TOTAL_ACHIEVEMENTS];
		[totalAchieve release];
		
		NSNumber *totalScore = [[NSNumber alloc] initWithInt:game.achievementsScoreTotal];
		[gameInfo setObject:totalScore forKey:K_TOTAL_GAMER_SCORE];
		[totalScore release];
		
		[gameInfo setObject:game.imageUrl forKey:K_IMAGE_URL];
		[theGames addObject:gameInfo];
		[gameInfo release];
	}
	NSLog(@"%@ | Writing data to file: %@", [self className], modelStoragePath);
	[theGames writeToFile:modelStoragePath atomically:YES];
	[theGames release];
	
}

-(void)loadModelFromFile
{
	NSArray *theGames = [NSArray arrayWithContentsOfFile:modelStoragePath];
	if([theGames count] > 0)
	{
		NSLog(@"%@ | Loading game model into system", [self className]);
		[self updateModel:theGames];
	}
}

-(int)numberOfItems
{
	return [games count];
}

-(Game *)getGame:(NSString *)gameName
{
	return [games objectForKey:gameName];
}
-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[games release];
	[super dealloc];
}
@end
