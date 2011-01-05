//
//  XMLParser.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 16/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TBXML.h"

@interface XMLParser : NSObject {
	NSMutableDictionary *returnMap;
}
-(NSDictionary *)parseXMLToDictionary:(NSString *)xml;
-(void)traverseElements:(TBXMLElement *)element;
@end
