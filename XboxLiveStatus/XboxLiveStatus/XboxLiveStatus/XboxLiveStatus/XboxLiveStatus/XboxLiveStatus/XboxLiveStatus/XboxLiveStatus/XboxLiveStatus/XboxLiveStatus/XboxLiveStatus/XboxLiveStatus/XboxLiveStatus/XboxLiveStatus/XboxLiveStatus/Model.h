//
//  Model.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 06/06/2010.
//  Copyright 2010 AO. All rights reserved.
//

@class Model;
@protocol ModelDelegate
-(void)notifyUpdated:(Model *)model;
-(void)notifyComplete:(Model *)model;
-(void)postItemForProcessing:(NSObject *)item;
@end

@interface Model : NSObject 
{
	id delegate;
	NSString *modelStoragePath;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *modelStoragePath;

-(int)numberOfItems;
-(void)commitModel;
-(void)loadModelFromFile;
@end
