//
//  XmlParser.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 29/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TBXML.h"

@interface GamerTagXMLParser : NSObject
{
	NSMutableDictionary *items;
}
- (NSDictionary *)parseXML:(NSString *)xml;
@end
