//
//  GamerTagModel.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 10/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GamerTag.h"
#import "NSString-CompareCaseInsensitive.h"
#import "GamerTagXMLParser.h"
#import "GamerTagUpdater.h"
#import "Model.h"

@interface GamerTagModel : Model <GamerTagUpdaterDelegate>
{
	NSMutableArray *gamerTags;
	int updatedTags;
}

-(void)addGamerTag:(GamerTag *)tag;
-(int)addNewGamerTag:(NSString *)tagName;
-(void)removeGamerTag:(int)tagPos;
-(GamerTag *)gamerTagAtPosition:(int)pos;
-(BOOL)doesGamerTagAlreadyExist:(NSString *)tagName;
-(BOOL)isEmpty;
-(void)updateTags;
-(void)refreshAvatars;
-(void)removeAvatars;
-(void)setTagStatusToUpdating;
-(void)sortModelByStatus:(BOOL)asc;
-(void)sortModelByName:(BOOL)asc;
-(void)notifyUpdate;
@end
