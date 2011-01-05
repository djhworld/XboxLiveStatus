//
//  DatabaseIntermediary.m
//  TVShowManager
//
//  Created by Daniel Harper on 20/04/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "DatabaseIntermediary.h"
@interface DatabaseIntermediary (Private)
-(BOOL)openDB;
@end

@implementation DatabaseIntermediary
@synthesize isOpen;
-(id)init
{
	if(self == [super init])
	{
		isOpen = NO;
	}
	return self;
}


-(BOOL)openDB:(NSString *)path forceCreate:(BOOL)force error:(NSError **)error
{
	dbPath = path;
	BOOL fileExists = [DatabaseIntermediary doesFileExistAtPath:dbPath];
	db = [FMDatabase databaseWithPath:dbPath];
	
	NSError *errorTmp = nil;
	if(fileExists && !force)
	{
		if(![self openDB])
		{
			*error = [[ErrorHandler sharedInstance] errorWithCode:OPEN_DATABASE_ERROR]; 
			return NO;
		}
	}
	else if(fileExists && force)
	{
		[[NSFileManager defaultManager] removeItemAtPath:dbPath error:&errorTmp];
		
		if(errorTmp != nil)
			return NO;
		
		if(![self openDB])
		{
			*error = [[ErrorHandler sharedInstance] errorWithCode:OPEN_DATABASE_ERROR]; 
			return NO;
		}
	}
	else
	{
		if(![self openDB])
		{
			*error = [[ErrorHandler sharedInstance] errorWithCode:OPEN_DATABASE_ERROR]; 
			return NO;
		}
	}
	
	return YES;
}

-(BOOL)openDB
{
	BOOL result = NO;
	if(!isOpen)
	{
		if([db open])
		{
			result = YES;
			isOpen = YES;
		} 
		else
		{
			result = NO;
			isOpen = NO;
		}
	}
	return result;
}

-(void)closeDB
{
	if(isOpen)
	{
		[db close];
		isOpen = NO;
	}
}

-(BOOL)createTables:(NSArray *)tables error:(NSError **)error
{
	NSError *errorTmp = nil;
	if([tables count] > 0)
	{
		for(Table *tab in tables)
		{
			if(![self createTable:tab error:&errorTmp])
			{
				*error = errorTmp;
				return NO;
			}
		}
	}
	else
	{
		return NO;
	}
	
	return YES;
}

-(BOOL)createTable:(Table *)table error:(NSError **)error
{	
	NSString *sql = [DatabaseIntermediary constructCreateSQLForTable:table error:nil];
	[db executeUpdate:sql];
	if(![db tableExists:table.tableName])
	{
		*error = [[ErrorHandler sharedInstance] errorWithCode:CREATED_TABLE_DOES_NOT_EXIST];
		return NO;
	}
	
	return YES;
}

-(BOOL)doesTableExist:(Table *)table
{
	if(!self.isOpen)
		return NO;
	
	return [db tableExists:table.tableName];
}

-(BOOL)dropTable:(Table *)table error:(NSError **)error
{
	if(!isOpen)
		return NO;
	
	if([self doesTableHaveRecords:table])
	{
		[self truncateTable:table error:nil];
	}
	
	NSString *sql = [NSString stringWithFormat:@"DROP TABLE '%@'", table.tableName];
	[db executeUpdate:sql];
	
	if([db hadError])
	{
		*error = [[ErrorHandler sharedInstance] errorWithCode:DROP_TABLE_ERROR appendMessage:[db lastErrorMessage]];
		return NO;
	}
	
	//in theory this should never happen
	if([self doesTableExist:table])
	{
		*error = [[ErrorHandler sharedInstance] errorWithCode:DROP_TABLE_ERROR appendMessage:@"Table still exists!"];
		return NO;
	}
	
	return YES;
}

-(BOOL)truncateTable:(Table *)table error:(NSError **)error
{
	if(!isOpen)
		return NO;
	
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", table.tableName];
	[db executeUpdate:sql];
	if([db hadError])
	{
		//TODO:Truncate table error
		if(error != nil)
		{
			*error = [[ErrorHandler sharedInstance] errorWithCode:TRUNCATE_TABLE_ERROR appendMessage:[db lastErrorMessage]];
		}
		return NO;
	}
	
	if([self doesTableHaveRecords:table])
		return NO;
	
	return YES;
	
}

-(BOOL)doesTableHaveRecords:(Table *)table
{
	if(!isOpen)
		return NO;

	NSUInteger result = [self noOfRecordsInTable:table];
	
	if(result > 0)
		return YES;
	
	return NO;
}

-(int)noOfRecordsInTable:(Table *)table
{
	if(!isOpen)
		return NO;
	
	NSString *sql = [table countRecordsSQL];
	NSUInteger result = [db intForQuery:sql];
	
	return result;
}

-(BOOL)executeUpdate:(NSString *)sql error:(NSError **)error
{
	if(!isOpen)
		return NO;
	
	[db executeUpdate:sql];
	
	if([db hadError])
	{
		if(error != nil)
		{
			//TODO:SQL table error
			*error = [[ErrorHandler sharedInstance] errorWithCode:SQL_EXCEPTION appendMessage:[db lastErrorMessage]];
		}
		return NO;
	}
	
	return YES;
		
}

+(BOOL)doesFileExistAtPath:(NSString *)path
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:path];
}

+(NSString *)constructCreateSQLForTable:(Table *)table error:(NSError **)error
{
	int counter = 0;
	
	NSMutableString *sql = [NSMutableString string];
	[sql appendString:@"CREATE TABLE \"main\".\""];
	[sql appendString:table.tableName];
	[sql appendString:@"\" ("];
	
	for(Column *col in table.columns)
	{
		[sql appendString:@"\""];
		[sql appendString:col.colName];
		[sql appendString:@"\" "];
		[sql appendString:col.colType];
		[sql appendString:@" "];
		
		if(col.isPrimaryKey)
			[sql appendString:@"PRIMARY KEY "];
		if(col.autoIncrement)
			[sql appendString:@"AUTOINCREMENT "];
		if(col.canBeNull == NO)
			[sql appendString:@"NOT NULL "];
		
		if(counter < ([table.columns count]-1))
			[sql appendString:@","];
		
		counter++;
	}
	
	[sql appendString:@");"];
	
	return sql;
}

-(void)dealloc
{
	NSLog(@"Dealloc called on database intermediary");
	[self closeDB];
	[super dealloc];
	
}

@end
