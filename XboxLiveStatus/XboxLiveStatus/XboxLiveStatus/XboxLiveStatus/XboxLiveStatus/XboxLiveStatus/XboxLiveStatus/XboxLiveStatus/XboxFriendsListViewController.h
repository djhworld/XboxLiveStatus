//
//  XboxFriendsListViewController.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 08/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GamerTag.h"
#import "XboxLiveStatusAppDelegate.h"
#import "ModelIntermediary.h"
#import "XBLTagStatusCell.h"
#import "XBLTagStatusDelegate.h"
#import "TagInfoPaneViewController.h"
#import "PreferencePaneViewController.h"
#import "AboutPaneViewController.h"
@interface XboxFriendsListViewController : NSWindowController <NSTableViewDelegate, XBLTagStatusDelegate>
{
	ModelIntermediary *model;
	IBOutlet NSTableView *table;
	IBOutlet NSTextField *addGamerTagTextBox;
	IBOutlet NSProgressIndicator *progress;
	IBOutlet NSMenuItem *refreshMenuItem;
	IBOutlet NSMenuItem *refreshAvatarsMenuItem;
	IBOutlet NSMenuItem *removeMenuItem;
	IBOutlet NSPanel *addGamerTagPanel;
	IBOutlet NSPanel *aboutPanel;
	BOOL statusAscending;
	BOOL namesAscending;
	BOOL panelToggle;
	NSTimer *refreshScheduler;
	NSUInteger refreshInterval;
	NSDate *lastFireDate;
	IBOutlet id aboutDescField;
	IBOutlet NSTextField *aboutDescField2;
	
	TagInfoPaneViewController *tagPaneController;
	PreferencePaneViewController *prefPaneViewController;
	AboutPaneViewController *aboutPaneViewController;
}
-(IBAction)refresh:(id)sender;
-(IBAction)removeSelectedGamerTag:(id)sender;
-(IBAction)toggleAddGamerTagTextBox:(id)sender;
-(IBAction)displayAboutPanel:(id)sender;
-(IBAction)refreshAvatars:(id)sender;
-(IBAction)showPreferencesPane:(id)sender;
-(void)rowClicked;
-(void)addGamerTag:(NSString *)tagName;
-(void)toggleMenuItemsOn:(BOOL)enabled;
-(void)disableRemoveAndRefreshMenuItems;
-(void)sortStatuses;
-(void)sortNames;
-(void)startRefreshScheduler;
-(void)allTagsHaveBeenUpdated:(NSNotification *)notification;
-(void)addGamerTagResult:(NSNotification *)notification;
@end
