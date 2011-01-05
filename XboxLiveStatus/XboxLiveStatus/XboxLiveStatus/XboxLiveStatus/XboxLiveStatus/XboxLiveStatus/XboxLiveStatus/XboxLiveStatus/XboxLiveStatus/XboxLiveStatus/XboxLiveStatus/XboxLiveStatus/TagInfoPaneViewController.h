//
//  TagInfoPaneViewController.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 25/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GamerTag.h"
#import "NSAttributedString-URL.h"
@interface TagInfoPaneViewController : NSWindowController
{
	GamerTag *tag;
	BOOL isOpen;
	IBOutlet NSTextField *tagName;
	IBOutlet NSButton *tagImage;
	IBOutlet NSButton *gameImage;
	IBOutlet NSTextField *tagStatus;
	IBOutlet NSTextField *tagGamerScore;
	IBOutlet NSTextField *tagCountry;
	IBOutlet NSTextField *tagAccountType;
	IBOutlet NSTextView *tagProfileURL;
	IBOutlet NSImageView *onlineInd;
}

@property (nonatomic, retain) GamerTag *tag;
@property (nonatomic, readonly) BOOL isOpen;
-(IBAction)clickedImage:(id)sender;
-(void)show;
-(void)populateWindow;
- (void)reset;
@end
