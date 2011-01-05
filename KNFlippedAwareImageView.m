//
//  KNFlippedAwareImageView.m
//  Music Rescue 4
//
/*
 
 Copyright (c) 2008 KennettNet Software Limited
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must, in all cases, contain attribution of 
 KennettNet Software Limited as the original author of the source code 
 shall be included in all such resulting software products or distributions.
 3. The name of the author may not be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS"' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 
 */

#import "KNFlippedAwareImageView.h"


@implementation KNFlippedAwareImageView


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
