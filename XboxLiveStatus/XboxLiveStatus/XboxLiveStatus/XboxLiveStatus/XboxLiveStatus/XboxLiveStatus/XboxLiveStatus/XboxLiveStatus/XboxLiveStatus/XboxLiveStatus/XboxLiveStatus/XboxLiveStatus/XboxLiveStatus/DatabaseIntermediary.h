//
//  DatabaseIntermediary.h
//  TVShowManager
//
//  Created by Daniel Harper on 20/04/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Table.h"
#import "Column.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "ErrorHandler.h"
#define DATABASE_FILE @"TVDB.db"
#define TYPE_VARCHAR @"VARCHAR"
#define TYPE_INTEGER @"INTEGER"

@interface DatabaseIntermediary : NSObject 
{
	NSString *dbPath;
	BOOL isOpen;
	FMDatabase *db;
}

@property (nonatomic, readonly) BOOL isOpen;
-(id)init;
-(BOOL)openDB:(NSString *)path forceCreate:(BOOL)force error:(NSError **)error;
-(void)closeDB;
-(BOOL)createTables:(NSArray *)tables error:(NSError **)error;
-(BOOL)createTable:(Table *)table error:(NSError **)error;
-(BOOL)dropTable:(Table *)table error:(NSError **)error;
-(BOOL)truncateTable:(Table *)table error:(NSError **)error;
-(BOOL)doesTableExist:(Table *)table;
-(BOOL)doesTableHaveRecords:(Table *)table;
-(int)noOfRecordsInTable:(Table *)table;
-(BOOL)executeQuery:(NSString *)sql error:(NSError **)error;
-(BOOL)executeUpdate:(NSString *)sql error:(NSError **)error;
+(NSString *)constructCreateSQLForTable:(Table *)table error:(NSError **)error;
+(BOOL)doesFileExistAtPath:(NSString *)path;
@end
