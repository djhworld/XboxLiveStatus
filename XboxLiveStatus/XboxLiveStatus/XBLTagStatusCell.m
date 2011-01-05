//
//  XBLTagStatusCell.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 19/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "XBLTagStatusCell.h"


@implementation XBLTagStatusCell

-(id)initWithDelegate:(id)dele
{
	if(self == [super init])
	{
		isHighlighted = NO;
		onImage = [NSImage imageNamed:@"on"];
		offImage = [NSImage imageNamed:@"off"];
		[self setDelegate:dele];
	}
	return self;
}

-(void)setDelegate:(id)dele
{
	delegate = dele;
}

-(void)setIdentity:(int)ident
{
	identity = ident;
}

- (id) copyWithZone:(NSZone *)zone
{
	XBLTagStatusCell *cell = (XBLTagStatusCell *)[super copyWithZone:zone];
	return cell;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSColor* primaryColor   = (isHighlighted) ? [NSColor whiteColor] : [NSColor blackColor];
	NSString* primaryText   = [self getGamerTag];

	NSDictionary* primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: primaryColor, NSForegroundColorAttributeName,
									   [NSFont systemFontOfSize:18], NSFontAttributeName, nil];	

	[primaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+75, cellFrame.origin.y) withAttributes:primaryTextAttributes];
	NSColor *secondaryColor = (isHighlighted) ? [NSColor whiteColor] : [NSColor grayColor];
	NSString *secondaryText = [self getStatusText];
	
	//secondaryText = [secondaryText stringByReplacingOccurrencesOfString:@" ~ " withString:@"\r\n"];
	//secondaryText = [secondaryText stringByReplacingOccurrencesOfString:@"   " withString:@"\r\n"];
	NSDictionary* secondaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: secondaryColor, NSForegroundColorAttributeName,
											 [NSFont systemFontOfSize:11], NSFontAttributeName, nil];	
	[secondaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+75, cellFrame.origin.y+22.5) 
				withAttributes:secondaryTextAttributes];
	
	NSImage *ava = [self getAvatarImage];
	[ava setFlipped:YES];
	[ava drawAtPoint:cellFrame.origin
			fromRect:NSZeroRect
		   operation:NSCompositeSourceOver
			fraction:1.0];
	ava = nil;
	
	NSImage *i = [self getImageForOnlineStatus];
	[i setFlipped:YES];
	NSPoint point = cellFrame.origin;
	point.x += cellFrame.size.width - (i.size.width+5);
	point.y += cellFrame.size.height/2 - (i.size.height/2);
	[i drawAtPoint:point
			fromRect:NSZeroRect
		   operation:NSCompositeSourceOver
			fraction:1.0];
	i = nil;
}

-(NSString *)getGamerTag
{
	if([delegate respondsToSelector:@selector(gamerTagForCell:gamerTagID:)])
	{
		return [delegate gamerTagForCell:self gamerTagID:identity];
	}
	return @"GamerTag";
}

-(NSImage *)getAvatarImage
{
	if([delegate respondsToSelector:@selector(avatarForCell:gamerTagID:)])
	{
		return [delegate avatarForCell:self gamerTagID:identity];
	}
	return [NSImage imageNamed:@"NSRemoveTemplate"];
}

-(NSString *)getStatusText
{
	if([delegate respondsToSelector:@selector(statusTextForCell:gamerTagID:)])
	{
		return [delegate statusTextForCell:self gamerTagID:identity];
	}
	return @"GamerTag Status";
}

-(NSImage *)getImageForOnlineStatus
{
	if(isOnline)
	{
		return onImage;
	}
	else
	{
		return offImage;
	}

}

-(void)setIsHighlighted:(BOOL)high
{
	isHighlighted = high;
}

-(void)setIsOnline:(BOOL)online
{
	isOnline = online;
}

- (void) dealloc
{
	[super dealloc];
}
@end
