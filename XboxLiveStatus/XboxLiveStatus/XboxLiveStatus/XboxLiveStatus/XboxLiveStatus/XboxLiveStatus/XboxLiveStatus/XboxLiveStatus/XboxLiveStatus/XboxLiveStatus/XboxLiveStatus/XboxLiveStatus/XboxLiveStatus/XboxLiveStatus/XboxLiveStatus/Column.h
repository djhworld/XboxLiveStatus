//
//  Column.h
//  TVShowOrganise
//
//  Created by Daniel Harper on 07/04/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "NSDictionary-ContainsKey.h"

@interface Column : NSObject 
{
	NSString *colName;
	NSString *colType;
	BOOL canBeNull;
	BOOL autoIncrement;
	BOOL isPrimaryKey;
	NSString *mapTo;
}

@property (nonatomic, retain) NSString *colName;
@property (nonatomic, retain) NSString *colType;
@property (nonatomic) BOOL canBeNull;
@property (nonatomic) BOOL autoIncrement;
@property (nonatomic) BOOL isPrimaryKey;
@property (nonatomic, retain) NSString *mapTo;
-(id)init;
-(id)initColumnWithName:(NSString *)name 
				type:(NSString *)type 
				nullAllowed:(BOOL)nullCol 
				autoIncremented:(BOOL)autoInc 
				isPrimKey:(BOOL)isPrimKey
				mapping:(NSString *)mapping;

@end
