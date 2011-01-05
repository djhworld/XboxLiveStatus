//
//  AboutPaneViewController.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 20/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "AboutPaneViewController.h"


@implementation AboutPaneViewController
-(id)init
{
	if(self == [super init])
	{
		self = [super initWithWindowNibName:@"About"];
		appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];	
		NSString *iconFile = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"];
		iconFile = [iconFile stringByReplacingOccurrencesOfString:@".icns" withString:@""];
		appIcon = [NSImage imageNamed:iconFile];
		NSMutableString *version = [[NSMutableString alloc] init];
		[version appendString:@"Version: "];
		[version appendString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
		appVersion = [version copy];
		[version release];
	}
	return self;
}
-(void)awakeFromNib
{
	NSColor *color = [NSColor whiteColor];
	NSAttributedString *url = [NSAttributedString hyperlinkFromString:@"Duncan Mackenzie" withURL:[NSURL URLWithString: @"http://www.duncanmackenzie.net"] andColor:color];
	[urlForShoutOut setAttributedStringValue:url];

	
	url = [NSAttributedString hyperlinkFromString:@"djharperuk@gmail.com" withURL:[NSURL URLWithString: @"mailto:djharperuk@gmail.com"] andColor:color];
	[emailAddr setAttributedStringValue:url];
}

-(void)show
{
	[self window];
	[self.window makeKeyAndOrderFront:self];
}

-(void)windowDidLoad
{
	
	[applicationVersion setStringValue:appVersion];
	[applicationName setStringValue:appName];
	[applicationIcon setImage:appIcon];
	//[urlForShoutOut setStringValue:@"Duncan Mackenzie http://www.duncanmackenzie.net"];
}

-(void)dealloc
{
	NSLog(@"%@ | dealloc called" , [self className]);
	[appVersion release];
	[super dealloc];
}


@end
