//
//  Game.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 05/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Game : NSObject 
{
	NSString *name;
	NSImage *image;
	NSString *imageUrl;
	NSString *imageFilePath;
	NSUInteger achievementsScoreTotal;
	NSUInteger achievementsAvailable;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic) NSUInteger achievementsScoreTotal;
@property (nonatomic) NSUInteger achievementsAvailable;

-(void)setImage;
-(NSImage *)getImage;
@end
