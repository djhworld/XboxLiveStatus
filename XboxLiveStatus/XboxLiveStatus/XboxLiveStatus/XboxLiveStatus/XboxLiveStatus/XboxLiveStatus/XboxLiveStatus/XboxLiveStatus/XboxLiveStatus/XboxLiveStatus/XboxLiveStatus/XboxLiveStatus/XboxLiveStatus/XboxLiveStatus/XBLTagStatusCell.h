//
//  XBLTagStatusCell.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 19/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

//#import "XBLTagStatusDelegate.h"

@interface XBLTagStatusCell : NSCell 
{
	int identity;
	id delegate;
	BOOL isHighlighted;
	BOOL isOnline;
	NSImage *onImage;
	NSImage *offImage;
}

-(id)initWithDelegate:(id)dele;
-(void)setIdentity:(int)ident;
-(void)setDelegate:(id) dele;
-(void)setIsHighlighted:(BOOL)high;
-(void)setIsOnline:(BOOL)online;
-(NSImage *)getImageForOnlineStatus;
-(NSString *)getGamerTag;
-(NSImage *)getAvatarImage;
-(NSString *)getStatusText;
@end
