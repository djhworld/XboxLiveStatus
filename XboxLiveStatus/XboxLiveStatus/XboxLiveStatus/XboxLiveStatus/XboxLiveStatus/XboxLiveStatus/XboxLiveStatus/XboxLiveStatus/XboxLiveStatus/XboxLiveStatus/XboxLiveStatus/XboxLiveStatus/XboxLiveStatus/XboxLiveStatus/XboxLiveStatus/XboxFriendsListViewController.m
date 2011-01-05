//
//  XboxFriendsListViewController.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 08/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "XboxFriendsListViewController.h"


@implementation XboxFriendsListViewController
-(id)init
{
	if(self == [super init])
	{
		[AppSettings registerAppSettings];
		[AppSettings setAPICountAmount];
		statusAscending = NO;
		namesAscending = YES;
		panelToggle = NO;
		refreshInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:@"REFRESH_INTERVAL"] intValue];
		tagPaneController = [[TagInfoPaneViewController alloc] init];
		prefPaneViewController = [[PreferencePaneViewController alloc] init];
        aboutPaneViewController = [[AboutPaneViewController alloc] init];
		lastFireDate = [[NSDate date] retain];
	}
	return self;
}

- (void)awakeFromNib 
{
	model = [[ModelIntermediary alloc] init];
	[model setupStoragePaths];
	[model initialiseModels];
	[self sortNames];
	
	if([model.gamerTagModel isEmpty])
		[self disableRemoveAndRefreshMenuItems];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"FIRST_TIME_START_IND"];
	
	[self sortStatuses];
	[self startRefreshScheduler];
	
	[addGamerTagPanel setMovable:NO];
	[table setRowHeight:64.0];
	[table setIntercellSpacing:NSSizeFromString(@"0.0")];
	[table setDoubleAction:@selector(rowClicked)];
	[table setTarget:self];

	
	NSTableColumn* column = [[table tableColumns] objectAtIndex:0];
	XBLTagStatusCell* cell = [[[XBLTagStatusCell alloc] initWithDelegate:self] autorelease];
	[column setDataCell: cell];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tagUpdated:)
                                                 name:@"TagUpdated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(allTagsHaveBeenUpdated:)
                                                 name:@"AllTagsUpdated" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(restartRefreshScheduler:)
                                                 name:@"RefreshIntervalChanged" object:nil];
}

-(void)rowClicked
{
	int clickedRow = [table clickedRow];
				
	if(clickedRow != -1)
	{
		XboxLiveStatusAppDelegate *dele = [[NSApplication sharedApplication] delegate];
		tagPaneController.tag = [model.gamerTagModel gamerTagAtPosition:clickedRow];
		if(tagPaneController.isOpen == NO)
		{
			NSPoint point = dele.window.frame.origin;
			point.x += (dele.window.frame.size.width);
			point.y += (dele.window.frame.size.height) - (tagPaneController.window.frame.size.height);
			[tagPaneController.window setFrameOrigin:point];
			[tagPaneController show];
		}
		else
		{
			NSPoint point = dele.window.frame.origin;
			point.x += (dele.window.frame.size.width);
			point.y += (dele.window.frame.size.height) - (tagPaneController.window.frame.size.height);
			[tagPaneController.window setFrameOrigin:point];
			[tagPaneController populateWindow];
		}
	}

}

-(IBAction)refreshAvatars:(id)sender
{
	[self toggleMenuItemsOn:NO];
	[progress startAnimation:nil];
	if([model.gamerTagModel isEmpty] == NO)
	{
		[model.gamerTagModel removeAvatars];
		[table reloadData];
		[model.gamerTagModel refreshAvatars];
		[table reloadData];
	}
	[progress stopAnimation:nil];
	[self toggleMenuItemsOn:YES];
}

-(IBAction)refresh:(id)sender
{
	if([model.gamerTagModel isEmpty] == NO)
	{
		NSLog(@"%@ | Refresh models has been initiated.", [self className]);
		[model.gamerTagModel setTagStatusToUpdating];
		[table reloadData];
		
		[lastFireDate release];
		lastFireDate = [[NSDate date] retain];
		
		if([sender isKindOfClass:[NSTimer class]] == NO)
		{
			NSDate *date = [NSDate date];
			NSDate *nextTimeToFire = [date dateByAddingTimeInterval:refreshInterval];
			NSLog(@"%@ | Scheduler was due to fire at: %@", [self className], [refreshScheduler fireDate]);
			[refreshScheduler setFireDate:nextTimeToFire];
			NSLog(@"%@ | Scheduler is now due to fire at: %@", [self className], [refreshScheduler fireDate]);
		}
		else
		{
			NSLog(@"%@ | Scheduler is now due to fire at: %@", [self className], [refreshScheduler fireDate]);
		}

		
		[progress startAnimation:sender];
		[self toggleMenuItemsOn:NO];
		
		if(tagPaneController.isOpen) 
			[tagPaneController reset];
		
		[model.gamerTagModel updateTags];
	}
}

- (void)tagUpdated:(NSNotification *)notification
{	
	[table reloadData];	
}

-(void)allTagsHaveBeenUpdated:(NSNotification *)notification
{
	NSNumber *firstTimeInd = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRST_TIME_START_IND"];
	if([firstTimeInd intValue] == 1)
	{
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"FIRST_TIME_START_IND"];
	}
	
	//incrememnt api call counter
	int apiCallsCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"API_CALL_COUNT"] intValue];
	apiCallsCount += [model.gamerTagModel numberOfItems];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"API_CALL_COUNT"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:apiCallsCount] forKey:@"API_CALL_COUNT"];
	
	[table deselectAll:nil];
	[self toggleMenuItemsOn:YES];
	[progress stopAnimation:nil];
	[self sortStatuses];
	if(tagPaneController.isOpen) 
		[tagPaneController populateWindow];
}

-(IBAction)toggleAddGamerTagTextBox:(id)sender
{
	XboxLiveStatusAppDelegate *dele = [[NSApplication sharedApplication] delegate];
	if(panelToggle == NO)
	{
		panelToggle = YES;
		NSPoint point = dele.window.frame.origin;
		point.x += (dele.window.frame.size.width/2) - (addGamerTagPanel.frame.size.width/2);
		point.y += (dele.window.frame.size.height/2) - (addGamerTagPanel.frame.size.height/2);
		[addGamerTagPanel setFrameOrigin:point];
		[addGamerTagPanel makeKeyAndOrderFront:self];
		[addGamerTagTextBox becomeFirstResponder];
	}
	else
	{
		panelToggle = NO;
		[addGamerTagTextBox resignFirstResponder];
		[addGamerTagPanel orderOut:self];
	}	
}

-(IBAction)displayAboutPanel:(id)sender
{
	XboxLiveStatusAppDelegate *dele = [[NSApplication sharedApplication] delegate];
	NSPoint point = dele.window.frame.origin;
	point.x += (dele.window.frame.size.width/2) - (aboutPaneViewController.window.frame.size.width/2);
	point.y += (dele.window.frame.size.height/2) - (aboutPaneViewController.window.frame.size.height/2);
	[aboutPaneViewController showWindow:nil];
	[aboutPaneViewController.window setFrameOrigin:point];	
}

-(IBAction)showPreferencesPane:(id)sender
{
	XboxLiveStatusAppDelegate *dele = [[NSApplication sharedApplication] delegate];
	NSPoint point = dele.window.frame.origin;
	point.x += (dele.window.frame.size.width/2) - (prefPaneViewController.window.frame.size.width/2);
	point.y += (dele.window.frame.size.height/2) - (prefPaneViewController.window.frame.size.height/2);
	[prefPaneViewController showWindow:nil];
	[prefPaneViewController.window setFrameOrigin:point];
		[prefPaneViewController setRefreshProj:[model.gamerTagModel numberOfItems]];
	[prefPaneViewController populateWindow];
	[prefPaneViewController setLastRefreshDate:lastFireDate];
	[prefPaneViewController setNextRefreshDate:[refreshScheduler fireDate]];

}

-(void)addGamerTag:(NSString *)tagName
{
	if(![tagName isEqualToString:@""])
	{
		[progress startAnimation:nil];
		[self toggleMenuItemsOn:NO];
		
		int addResult = [model.gamerTagModel addNewGamerTag:tagName];
		if(addResult == -1)
		{
			NSString *message = [NSString stringWithFormat:@"Gamertag already exists!"];
			NSString *messageSub = [NSString stringWithFormat:@"The gamertag '%@' already exists in the system", tagName];
			NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, messageSub, NSLocalizedRecoverySuggestionErrorKey, nil];
			NSError *error = [NSError errorWithDomain:@"Normal" code:1 userInfo:errorDict];
			[NSApp presentError:error];
		}
	}
}

-(void)addGamerTagResult:(NSNotification *)notification
{
	if([notification object] != nil)
	{
		[model.gamerTagModel commitModel];
	}
	
	[progress stopAnimation:nil];
	[table reloadData];
	[self toggleMenuItemsOn:YES];
}

-(IBAction)removeSelectedGamerTag:(id)sender
{
	int index = [table selectedRow];
	if(index != -1)
	{
		[self toggleMenuItemsOn:NO];
		[model.gamerTagModel removeGamerTag:index];
		[model.gamerTagModel commitModel];
		[table reloadData];
		
		[self toggleMenuItemsOn:YES];
		
		if([model.gamerTagModel isEmpty])
			[self disableRemoveAndRefreshMenuItems];

	}
	else
	{
		NSAlert *alert = [NSAlert alertWithMessageText:@"No gamertag has been selected" 
										 defaultButton:@"OK" 
									   alternateButton:nil 
										   otherButton:nil 
							 informativeTextWithFormat:@"Please select a gamertag from the list for removal"];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert runModal];	
	}


}

-(void)controlTextDidEndEditing:(NSNotification *)aNotification
{
	if([[addGamerTagTextBox stringValue] isEqualToString:@""] == NO)
	{
		XboxLiveStatusAppDelegate *dele = [[NSApplication sharedApplication] delegate];
		[dele.window resignFirstResponder];
		[addGamerTagPanel orderOut:self];
		panelToggle = NO;
		[self addGamerTag:[addGamerTagTextBox stringValue]];
		[addGamerTagTextBox setStringValue:@""];
	}
}

-(void)toggleMenuItemsOn:(BOOL)enabled
{
	if(enabled)
	{
		[refreshMenuItem setEnabled:YES];
		[refreshAvatarsMenuItem setEnabled:YES];
		[removeMenuItem	setEnabled:YES];
	}
	else
	{
		[refreshMenuItem setEnabled:NO];
		[removeMenuItem	setEnabled:NO];
		[refreshAvatarsMenuItem setEnabled:NO];
	}

}

-(void)startRefreshScheduler
{
	refreshScheduler = [NSTimer scheduledTimerWithTimeInterval:refreshInterval target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
	[refreshScheduler fire];
}

-(void)restartRefreshScheduler:(NSNotification *)notification
{
	NSLog(@"%@ | Resetting refresh scheduler",[self className]);
	NSLog(@"%@ | Previous next fire date was %@",[self className], [refreshScheduler fireDate]);	
	[refreshScheduler invalidate];
	refreshScheduler = nil;
	refreshInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:@"REFRESH_INTERVAL"] intValue];
	NSLog(@"%@ | New refresh interval will be %d minutes",[self className], refreshInterval/60);
	refreshScheduler = [NSTimer scheduledTimerWithTimeInterval:refreshInterval target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
	NSLog(@"%@ | Next fire date will be %@",[self className], [refreshScheduler fireDate]);
}

-(void)disableRemoveAndRefreshMenuItems
{
	[refreshMenuItem setEnabled:NO];
	[refreshAvatarsMenuItem setEnabled:NO];
	[removeMenuItem	setEnabled:NO];
}

-(void)sortStatuses
{
	[model.gamerTagModel sortModelByStatus:statusAscending];
}

-(void)sortNames
{
	[model.gamerTagModel sortModelByName:namesAscending];
}

-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[model release];
	[tagPaneController release];
	[prefPaneViewController release];
	[aboutPaneViewController release];
	[lastFireDate release];
	[super dealloc];
}


#pragma mark -
#pragma mark TableView stuff
- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [model.gamerTagModel numberOfItems];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return nil;
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	cell = (XBLTagStatusCell *)cell;
	[cell setIdentity:row];
	GamerTag *tag = [model.gamerTagModel gamerTagAtPosition:row];
	
	if(tag.online)
		[cell setIsOnline:YES];
	else
		[cell setIsOnline:NO];

	if([tableView selectedRow] == row)
		[cell setIsHighlighted:YES];
	else
		[cell setIsHighlighted:NO];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[self release];
	[self release];
}

#pragma mark -
#pragma mark XBLTagStatusDelegate methods

-(NSImage *)avatarForCell:(XBLTagStatusCell *)cell gamerTagID:(int)ident
{
	GamerTag *gamerTag = [model.gamerTagModel gamerTagAtPosition:ident];
	return gamerTag.avatar;
}

-(NSString *)gamerTagForCell:(XBLTagStatusCell *)cell gamerTagID:(int)ident
{
	GamerTag *gamerTag = [model.gamerTagModel gamerTagAtPosition:ident];
	return gamerTag.name;
}

-(NSString *)statusTextForCell:(XBLTagStatusCell *)cell gamerTagID:(int)ident
{
	GamerTag *gamerTag = [model.gamerTagModel gamerTagAtPosition:ident];
	return gamerTag.currentActivity;
}

@end
