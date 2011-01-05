//
//  GameModel.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 05/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "Model.h"
#import "Game.h"

#define K_NAME @"Name"
#define K_TOTAL_ACHIEVEMENTS @"TotalAchievements"
#define K_TOTAL_GAMER_SCORE @"TotalGamerScore"
#define K_IMAGE_URL @"Image64Url"
@interface GameModel : Model
{
	NSMutableDictionary *games;
}

-(void)updateModel:(NSArray *)content;
-(Game *)getGame:(NSString *)gameName;
@end
