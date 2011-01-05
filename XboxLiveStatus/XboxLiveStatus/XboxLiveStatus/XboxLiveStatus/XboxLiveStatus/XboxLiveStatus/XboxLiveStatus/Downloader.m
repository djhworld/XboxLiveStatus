//
//  Downloader.m
//  XboxLiveStatus
//
//  Created by Daniel Harper on 30/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "Downloader.h"
@implementation Downloader
@synthesize delegate;
@synthesize urlStr;
@synthesize receivedData;

-(id)initWithUrlString:(NSString *)url delegate:(id <NSObject, DownloaderDelegate>)dele
{
	if(self == [super init])
	{
		self.urlStr = url;
		self.delegate = dele;
		self.receivedData = [[[NSMutableData alloc] init] autorelease];
		isDownloading = NO;
	}
	return self;
}

-(void)download
{
	if(!isDownloading)
	{
		if(urlStr != nil && [urlStr length] > 0)
		{
			NSURLRequest *req = [[NSURLRequest alloc] 
								 initWithURL:[NSURL URLWithString:self.urlStr]];
            NSURLConnection *conn = [[NSURLConnection alloc]
                                    initWithRequest:req
                                    delegate:self
                                    startImmediately:NO];

            [conn scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
            [conn start];

			
			if (!conn) 
            {
                NSError *error = [NSError errorWithDomain:DownloaderErrorDomain 
                                                     code:DownloaderErrorNoConnection 
                                                 userInfo:nil];
                if ([self.delegate respondsToSelector:@selector(download:didFailWithError:)])
				{
                    [delegate download:self didFailWithError:error];
				}
            }   
            [req release];
            
            isDownloading = YES;
			
		}
	}
}

-(void)dealloc
{
	NSLog(@"%@ | dealloc called", [self className]);
	[urlStr release];
	delegate = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Connection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error 
{
    [connection release];
    if ([delegate respondsToSelector:@selector(download:didFailWithError:)])
	{
        [delegate download:self didFailWithError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    if ([delegate respondsToSelector:@selector(downloadDidFinishDownloading:)])
	{
		[delegate downloadDidFinishDownloading:self];
	}
    
    [connection release];
    self.receivedData = nil;
}
@end
