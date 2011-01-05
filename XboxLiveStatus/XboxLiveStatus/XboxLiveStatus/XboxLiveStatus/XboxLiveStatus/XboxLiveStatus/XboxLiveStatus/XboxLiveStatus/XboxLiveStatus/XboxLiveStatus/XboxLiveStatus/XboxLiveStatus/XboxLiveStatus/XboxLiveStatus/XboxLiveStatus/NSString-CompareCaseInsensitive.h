//
//  NSString-CompareCaseInsensitive.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 16/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (Compare)
-(NSComparisonResult)compareCaseInsensitive:(NSString *)other;
@end
