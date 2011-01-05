//
//  KNFlippedAwareButton.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 10/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "KNFlippedAwareButton.h"


@implementation KNFlippedAwareButton
-(void)drawRect:(NSRect *)rect {
	
	NSSize oldSize = [[self image] size];
	NSSize newSize;
	NSPoint drawPoint;
	
	float imageSizeRatio = oldSize.height / oldSize.width; 
	float frameSizeRatio = [self bounds].size.width / [self bounds].size.height;
	
	if (imageSizeRatio > frameSizeRatio) {
		// Size image by height
		
		newSize = NSMakeSize([self bounds].size.height * imageSizeRatio, [self bounds].size.height);
		drawPoint = NSMakePoint(([self bounds].size.width / 2) - (newSize.width / 2), 0.0);
		
	} else {
		
		newSize = NSMakeSize([self bounds].size.width, [self bounds].size.width / imageSizeRatio);
		drawPoint = NSMakePoint(0.0, ([self bounds].size.height / 2) - (newSize.height / 2));
		
	}
	
	BOOL flipped = [[self image] isFlipped];
	
	[[self image] setDataRetained:YES];
	[[self image] setScalesWhenResized:YES];
	[[self image] setFlipped:[self isFlipped]];
	[[self image] setSize:newSize];
	[[self image] drawInRect:NSMakeRect(drawPoint.x, drawPoint.y, newSize.width, newSize.height) 
					fromRect:NSZeroRect 
				   operation:NSCompositeSourceOver 
					fraction:1.0];
	[[self image] setSize:oldSize];
	[[self image] setFlipped:flipped];
	
}
@end
