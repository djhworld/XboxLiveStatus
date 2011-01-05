//
//  NSAttributedString-URL.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 26/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL andColor:(NSColor *)colour;
@end

