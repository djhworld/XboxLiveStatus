//
//  PreferencePaneViewController.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 12/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppSettings.h"
#import "AppUtilities.h"
#define MAX_REFRESH 60
#define MIN_REFRESH 3
#define PreferencesErrorDomain @"Preference Error Domain"
enum 
{   
	PreferencesInputInvalidError = 1
};

@interface PreferencePaneViewController : NSWindowController
{
	IBOutlet NSTextField *lastRefreshTime;
	IBOutlet NSTextField *nextRefreshTime;
	IBOutlet NSTextField *refreshInterval;
	IBOutlet NSTextField *refreshProjection;
	IBOutlet NSTextField *requestCount;
	IBOutlet NSButton *growlCheckBox;

}

-(IBAction)buttonPressed:(id)sender;
-(IBAction)resetSettings:(id)sender;
-(void)setLastRefreshDate:(NSDate *)date;
-(void)setNextRefreshDate:(NSDate *)date;
-(void)populateWindow;
-(void)setRefreshProj:(int)numberOfTags;
-(void)setRequestCounter;
@end
