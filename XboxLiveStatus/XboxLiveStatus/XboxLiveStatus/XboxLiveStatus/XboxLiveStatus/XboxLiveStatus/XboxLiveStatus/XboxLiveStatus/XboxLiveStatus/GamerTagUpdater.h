//
//  GamerTagUpdater.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 31/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Downloader.h"
#import "GamerTag.h"
#import "GamerTagXMLParser.h"
#import "GrowlNotifier.h"
#define GamerTagUpdaterErrorDomain @"GamerTagUpdater Error Domain"
enum 
{   
	GamerTagUpdaterTagOver15CharsError = 10,
	GamerTagUpdaterInvalidTagError = 20,
	GamerTagUpdaterErrorAddingTagDueToNetworkIssueError = 30
};

@class GamerTagUpdater;
@protocol GamerTagUpdaterDelegate
-(void)updatedTagSuccessfully:(GamerTagUpdater *)updater;
-(void)updateFailed:(GamerTagUpdater *)updater error:(NSError *)error;
@end


@interface GamerTagUpdater : NSObject <DownloaderDelegate>
{
	Downloader *downloader;
	GamerTag *tag;
	NSString *apiURL;
	id <NSObject, GamerTagUpdaterDelegate> delegate;
	int identity;
	BOOL addMode;
	NSDictionary *gamesDictionary;
}

@property (nonatomic, retain) GamerTag *tag;
@property (nonatomic, assign) id <NSObject, GamerTagUpdaterDelegate> delegate;
@property (nonatomic) int identity;
@property (nonatomic) BOOL addMode;
@property (nonatomic, readonly) NSDictionary *gamesDictionary;
-(id)initWithTag:(GamerTag *)gamerTag andTagIdentifier:(int)ident withDelegate:(id <NSObject, GamerTagUpdaterDelegate>) dele;
-(void)startUpdate;
-(BOOL)updateTagWithXMLData:(NSDictionary *)gamerTagInfo;
@end
