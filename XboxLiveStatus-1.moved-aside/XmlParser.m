//
//  XMLParser.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 16/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "XMLParser.h"


@implementation XMLParser
-(id)init
{
	if(self == [super init])
	{
		returnMap = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;
}

-(NSDictionary *)parseXMLToDictionary:(NSString *)xml
{
	TBXML *bxml = [[TBXML alloc] initWithXMLString:xml];
	TBXMLElement *root = bxml.rootXMLElement;
	[self traverseElements:root];
	[bxml release];
	return returnMap;
}

								  
-(void) traverseElements:(TBXMLElement *)element 
{
	do 
	{
		// if the element has child elements, process them
		if (element->firstChild)
		{
			[self traverseElements:element->firstChild];
		}
		else
		{
			[returnMap setObject:[TBXML textForElement:element] forKey:[TBXML elementName:element]];
		}

		
		// Obtain next sibling element
	} while ((element = element->nextSibling));  
}

-(void)dealloc
{
	[returnMap release];
	[super dealloc];
}
@end
