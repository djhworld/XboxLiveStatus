//
//  TagInfoPaneViewController.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 25/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "TagInfoPaneViewController.h"


@implementation TagInfoPaneViewController
@synthesize tag;
@synthesize isOpen;

-(id)init
{
	if(self == [super init])
	{
		
		self = [super initWithWindowNibName:@"TagInfoPane"];
		isOpen = NO;
	}
	return self;
}

-(void)show
{
	[self window];
	[self.window makeKeyAndOrderFront:self];
	[self populateWindow];
	isOpen = YES;
}

-(void)windowDidLoad
{
	isOpen = YES;
	[self populateWindow];
}

-(void)populateWindow
{
	NSLog(@"%@ | Populating window with data for tag: '%@'", [self className], tag.name);
	[tagName setStringValue:tag.name];
	NSString *statusFormatted = [tag.currentActivity stringByReplacingOccurrencesOfString:@" ~ " withString:@"\r\n"];
	statusFormatted = [statusFormatted stringByReplacingOccurrencesOfString:@"   " withString:@"\r\n"];
	
	[tagStatus setStringValue:statusFormatted];
	[tagGamerScore setIntValue:[tag.gamerScore intValue]];
	[tagImage setImage:tag.avatar];

	if(tag.currentlyPlaying != nil)
		[gameImage setImage:[tag.currentlyPlaying getImage]];
	else
		[gameImage setImage:[NSImage imageNamed:@"question"]];

	[tagCountry setStringValue:tag.country];
	
	if(tag.isGold)
		[tagAccountType setStringValue:@"Gold"];
	else
		[tagAccountType setStringValue:@"Silver"];
	
	if(tag.online)
		[onlineInd setHidden:NO];
	else
		[onlineInd setHidden:YES];

		
	[self.window setTitle:[NSString stringWithFormat:@"%@'s info", tag.name]];
}

-(IBAction)clickedImage:(id)sender
{
	if(gameImage == sender)
	{
		NSLog(@"Game Image clicked!");
	}
	else
	{
		NSLog(@"Tag image clicked!");
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:tag.profileURL]];
	}

}

- (void)reset
{
	NSString *updating = @"Updating...";
	[tagStatus setStringValue:updating];
	[tagGamerScore setStringValue:updating];
	[tagAccountType setStringValue:updating];
	[tagCountry setStringValue:updating];
	[onlineInd setHidden:YES];
}

- (void)windowWillClose:(NSNotification *)notification
{
	isOpen = NO;
}

-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[tag release];
	[super dealloc];
}
@end
