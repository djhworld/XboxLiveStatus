//
//  Downloader.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 30/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#define DownloaderErrorDomain @"Downloader Error Domain"
enum 
{   DownloaderErrorNoConnection = 1000,
};

@class Downloader;
@protocol DownloaderDelegate
- (void)downloadDidFinishDownloading:(Downloader *)download;
- (void)download:(Downloader *)download didFailWithError:(NSError *)error;
@end

@interface Downloader : NSObject
{
	NSString *urlStr;
	id <NSObject, DownloaderDelegate>  delegate;
	NSMutableData *receivedData;
	BOOL isDownloading;
}
@property (nonatomic, assign) id <NSObject, DownloaderDelegate> delegate;
@property (nonatomic, retain) NSString *urlStr;
@property (nonatomic, retain) NSMutableData	*receivedData;
-(id)initWithUrlString:(NSString *)url delegate:(id <NSObject, DownloaderDelegate>)dele;
-(void)download;
@end
