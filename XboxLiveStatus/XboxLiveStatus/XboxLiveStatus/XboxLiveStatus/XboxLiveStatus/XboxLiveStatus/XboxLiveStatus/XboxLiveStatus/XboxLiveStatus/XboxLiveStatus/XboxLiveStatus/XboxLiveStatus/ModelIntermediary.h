//
//  ModelIntermediary.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 06/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "GamerTagModel.h"
#import "GameModel.h"

@interface ModelIntermediary : NSObject <ModelDelegate>
{
	GamerTagModel *gamerTagModel;
	GameModel *gameModel;
	NSMutableArray *itemsQueue;
}

@property (nonatomic, readonly) GamerTagModel *gamerTagModel;
@property (nonatomic, readonly) GameModel *gameModel;
-(void)setupStoragePaths;
-(void)initialiseModels;
@end
