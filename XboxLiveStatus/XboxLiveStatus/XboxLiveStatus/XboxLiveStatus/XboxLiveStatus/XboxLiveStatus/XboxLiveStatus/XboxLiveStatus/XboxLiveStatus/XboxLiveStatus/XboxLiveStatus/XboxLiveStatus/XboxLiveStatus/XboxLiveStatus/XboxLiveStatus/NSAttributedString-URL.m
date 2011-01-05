//
//  NSAttributedString-URL.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 26/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "NSAttributedString-URL.h"

@implementation NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL andColor:(NSColor *)colour
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
	
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
	// make the text appear in blue
	if(colour != nil)
	{
		[attrString addAttribute:NSForegroundColorAttributeName value:colour range:range];
	}
	else
	{
		[attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
	}

	
    // next make the text appear with an underline
    [attrString addAttribute:
	 NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
	
	[attrString setAlignment:NSCenterTextAlignment range:range];
    [attrString endEditing];
	
    return [attrString autorelease];
}
@end

