//
//  NSString-CompareCaseInsensitive.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 16/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "NSString-CompareCaseInsensitive.h"


@implementation NSString (Compare)
-(NSComparisonResult)compareCaseInsensitive:(NSString *)other
{
	return [self compare:other options:NSCaseInsensitiveSearch];
}

@end
