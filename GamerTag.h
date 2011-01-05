//
//  GamerTag.h
//  XboxFriends
//
//  Created by Daniel Harper on 08/05/2010.
//  Copyright 2010 AO. All rights reserved.
//
#import "Game.h"
@interface GamerTag : NSObject
{
	NSImage *avatar;
	NSString *avatarPath;
	NSString *name;
	NSString *lastSeen;
	BOOL online;
	BOOL hasBeenValidated;
	BOOL isGold;
	NSNumber *gamerScore;
	NSString *currentActivity;
	NSString *profileURL;
	NSString *country;
	Game *currentlyPlaying;
	NSString *playing;
	
}

@property (nonatomic, retain) NSString *name;
@property (readonly) NSImage *avatar;
@property (nonatomic, retain) NSString *avatarPath;
@property (nonatomic, retain) NSString *lastSeen;
@property (nonatomic) BOOL online;
@property (nonatomic) BOOL isGold;
@property (nonatomic, retain) NSNumber *gamerScore;
@property (nonatomic, retain) NSString *currentActivity;
@property (nonatomic, retain) NSString *profileURL;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, assign) Game *currentlyPlaying;
@property (nonatomic, retain) NSString *playing;
@property (nonatomic) BOOL hasBeenValidated;
-(id)initWithName:(NSString *)gamerTag;
-(void)setAvatar;
-(void)removeAvatar;
@end
