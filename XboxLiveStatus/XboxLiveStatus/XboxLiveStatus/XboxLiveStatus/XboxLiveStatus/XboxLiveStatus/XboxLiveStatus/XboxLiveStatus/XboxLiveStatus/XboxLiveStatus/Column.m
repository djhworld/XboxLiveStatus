//
//  Column.m
//  TVShowOrganise
//
//  Created by Daniel Harper on 07/04/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "Column.h"


@implementation Column
@synthesize colName;
@synthesize colType;
@synthesize canBeNull;
@synthesize autoIncrement;
@synthesize isPrimaryKey;
@synthesize mapTo;
-(id)init
{
	if(self == [super init])
	{
	}
	return self;
}

-(id)initColumnWithName:(NSString *)name 
				   type:(NSString *)type 
			nullAllowed:(BOOL)nullCol 
		autoIncremented:(BOOL)autoInc 
			  isPrimKey:(BOOL)isPrimKey
				mapping:(NSString *)mapping
{
	if(self == [super init])
	{
		self.colName = name;
		self.colType = type;
		canBeNull = nullCol;
		autoIncrement = autoInc;
		isPrimaryKey = isPrimKey;
		self.mapTo = mapping;
	}
	return self;
}


- (void) dealloc
{
	[colName release];
	[colType release];
	[mapTo release];
	[super dealloc];
}
@end
