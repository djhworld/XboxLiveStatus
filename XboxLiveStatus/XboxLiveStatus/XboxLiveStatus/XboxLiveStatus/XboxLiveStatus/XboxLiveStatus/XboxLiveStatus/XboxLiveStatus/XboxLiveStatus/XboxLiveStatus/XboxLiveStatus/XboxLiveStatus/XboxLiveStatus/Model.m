//
//  Model.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 06/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "Model.h"


@implementation Model
@synthesize delegate;
@synthesize modelStoragePath;
-(void)dealloc
{
	[modelStoragePath release];
	delegate = nil;
	[super dealloc];
}
@end
