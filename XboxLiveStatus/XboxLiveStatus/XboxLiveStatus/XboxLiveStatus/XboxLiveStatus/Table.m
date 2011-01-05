//
//  Table.m
//  TVShowOrganise
//
//  Created by Daniel Harper on 07/04/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "Table.h"


@implementation Table
@synthesize tableName;
@synthesize columns; 

- (id) init
{
	if(self == [super init])
	{
		columns = [[NSMutableArray alloc] initWithCapacity:1];
		mappings = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;
}

-(id)initTableWithName:(NSString *)tblName
{
	if(self == [super init])
	{
		self.tableName = tblName;
		columns = [[NSMutableArray alloc] initWithCapacity:1];
		mappings = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;
}


-(void)addColumn:(Column *)column
{
	if(column.mapTo != nil)
		[mappings setObject:column.colName forKey:column.mapTo];
	
	[columns addObject:column];
}

-(NSString *)mappedColumnFor:(NSString *)mapping
{
	if([mappings count] > 0)
	{
		return [mappings objectForKey:mapping];
	}
	return nil;
}

-(NSString *)countRecordsSQL
{
	return [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",[self tableName]];
}

-(NSString *)selectAllSQL
{
	return [NSString stringWithFormat:@"SELECT * FROM %@",[self tableName]];
}

-(void) dealloc
{
	[tableName release];
	[columns release];
	[mappings release];
	[super dealloc];
}
@end
