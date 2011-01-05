//
//  XmlParser.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 29/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "GamerTagXMLParser.h"

@implementation GamerTagXMLParser
-(id)init
{
	if(self == [super init])
	{
		items = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;
}

- (NSDictionary *)parseXML:(NSString *)xml
{
	TBXML *xmlParser = [[TBXML alloc] initWithXMLString:xml];
	TBXMLElement *root = xmlParser.rootXMLElement;
	
	if (root)
	{
		TBXMLElement *elemAccountStatus = [TBXML childElementNamed:@"AccountStatus" parentElement:root];
		[items setObject:[TBXML textForElement:elemAccountStatus] forKey:[TBXML elementName:elemAccountStatus]];
		
		TBXMLElement *parentElemPresenceInfo = [TBXML childElementNamed:@"PresenceInfo" parentElement:root];
		while(parentElemPresenceInfo != nil)
		{
			NSMutableDictionary *presenceInfo = [[NSMutableDictionary alloc] init];
			TBXMLElement *elemValid = [TBXML childElementNamed:@"Valid" parentElement:parentElemPresenceInfo];
			
			if([[TBXML textForElement:elemValid] isEqualToString:@"true"] == NO)
			{
				return nil;
			}
			else
			{
				[presenceInfo setObject:[TBXML textForElement:elemValid] forKey:[TBXML elementName:elemValid]];
			}

			TBXMLElement *elemIsOnline = [TBXML childElementNamed:@"Online" parentElement:parentElemPresenceInfo];
			[presenceInfo setObject:[TBXML textForElement:elemIsOnline] forKey:[TBXML elementName:elemIsOnline]];
		
			TBXMLElement *elemLastSeen = [TBXML childElementNamed:@"LastSeen" parentElement:parentElemPresenceInfo];
			[presenceInfo setObject:[TBXML textForElement:elemLastSeen] forKey:[TBXML elementName:elemLastSeen]];
			
			TBXMLElement *elemInfo = [TBXML childElementNamed:@"Info" parentElement:parentElemPresenceInfo];
			[presenceInfo setObject:[TBXML textForElement:elemInfo] forKey:[TBXML elementName:elemInfo]];
			
			TBXMLElement *elemInfo2 = [TBXML childElementNamed:@"Info2" parentElement:parentElemPresenceInfo];
			[presenceInfo setObject:[TBXML textForElement:elemInfo2] forKey:[TBXML elementName:elemInfo2]];
			
			TBXMLElement *elemStatusText = [TBXML childElementNamed:@"StatusText" parentElement:parentElemPresenceInfo];
			[presenceInfo setObject:[TBXML textForElement:elemStatusText] forKey:[TBXML elementName:elemStatusText]];
			
			TBXMLElement *elemTitle = [TBXML childElementNamed:@"Title" parentElement:parentElemPresenceInfo];
			[presenceInfo setObject:[TBXML textForElement:elemTitle] forKey:[TBXML elementName:elemTitle]];

			[items setObject:presenceInfo forKey:@"PresenceInfo"];
			[presenceInfo release];
			
			parentElemPresenceInfo = [TBXML nextSiblingNamed:@"PresenceInfo" searchFromElement:parentElemPresenceInfo];
		}
		
		TBXMLElement *elemState = [TBXML childElementNamed:@"State" parentElement:root];
		[items setObject:[TBXML textForElement:elemState] forKey:[TBXML elementName:elemState]];
		
		TBXMLElement *elemGamertag = [TBXML childElementNamed:@"Gamertag" parentElement:root];
		[items setObject:[TBXML textForElement:elemGamertag] forKey:[TBXML elementName:elemGamertag]];
		
		TBXMLElement *elemProjectURL = [TBXML childElementNamed:@"ProfileUrl" parentElement:root];
		[items setObject:[TBXML textForElement:elemProjectURL] forKey:[TBXML elementName:elemProjectURL]];

		TBXMLElement *elemTileURL = [TBXML childElementNamed:@"TileUrl" parentElement:root];
		[items setObject:[TBXML textForElement:elemTileURL] forKey:[TBXML elementName:elemTileURL]];

		TBXMLElement *elemCountry = [TBXML childElementNamed:@"Country" parentElement:root];
		[items setObject:[TBXML textForElement:elemCountry] forKey:[TBXML elementName:elemCountry]];

		TBXMLElement *elemReputation = [TBXML childElementNamed:@"Reputation" parentElement:root];
		[items setObject:[TBXML textForElement:elemReputation] forKey:[TBXML elementName:elemReputation]];
		
		TBXMLElement *elemGamerscore = [TBXML childElementNamed:@"GamerScore" parentElement:root];
		[items setObject:[TBXML textForElement:elemGamerscore] forKey:[TBXML elementName:elemGamerscore]];
		
		TBXMLElement *parentElemRecentGames = [TBXML childElementNamed:@"RecentGames" parentElement:root];
		NSMutableArray *games = [[NSMutableArray alloc] init];
		
		TBXMLElement *parentElemGameInfo = [TBXML childElementNamed:@"XboxUserGameInfo" parentElement:parentElemRecentGames];
		while(parentElemGameInfo != nil)
		{
			TBXMLElement *elemGame = [TBXML childElementNamed:@"Game" parentElement:parentElemGameInfo];
			
			NSMutableDictionary *game = [[NSMutableDictionary alloc] init];
			
			TBXMLElement *elemGameName = [TBXML childElementNamed:@"Name" parentElement:elemGame];
			[game setObject:[TBXML textForElement:elemGameName] forKey:[TBXML elementName:elemGameName]];

			TBXMLElement *elemGameTotalAchievements = [TBXML childElementNamed:@"TotalAchievements" parentElement:elemGame];
			[game setObject:[TBXML textForElement:elemGameTotalAchievements] forKey:[TBXML elementName:elemGameTotalAchievements]];
			
			TBXMLElement *elemGameGamerscore = [TBXML childElementNamed:@"TotalGamerScore" parentElement:elemGame];
			[game setObject:[TBXML textForElement:elemGameGamerscore] forKey:[TBXML elementName:elemGameGamerscore]];
			
			TBXMLElement *elemGameImage32URL = [TBXML childElementNamed:@"Image32Url" parentElement:elemGame];
			[game setObject:[TBXML textForElement:elemGameImage32URL] forKey:[TBXML elementName:elemGameImage32URL]];
			
			TBXMLElement *elemGameImage64URL = [TBXML childElementNamed:@"Image64Url" parentElement:elemGame];
			[game setObject:[TBXML textForElement:elemGameImage64URL] forKey:[TBXML elementName:elemGameImage64URL]];
			
			[games addObject:game];
			[game release];
			
			parentElemGameInfo = [TBXML nextSiblingNamed:@"XboxUserGameInfo" searchFromElement:parentElemGameInfo];
		}
		
		[items setObject:games forKey:@"RecentGames"];
		[games release];
	}
	
	[xmlParser release];
	return items;
}


-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[items release];
	[super dealloc];
}
@end
