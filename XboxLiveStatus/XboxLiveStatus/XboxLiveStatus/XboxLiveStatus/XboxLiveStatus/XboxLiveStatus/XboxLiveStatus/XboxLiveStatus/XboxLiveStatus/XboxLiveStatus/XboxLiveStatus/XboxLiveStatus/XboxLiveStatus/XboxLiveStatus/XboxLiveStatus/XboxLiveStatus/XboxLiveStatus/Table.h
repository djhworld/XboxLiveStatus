//
//  Table.h
//  TVShowOrganise
//
//  Created by Daniel Harper on 07/04/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "Column.h"

@interface Table : NSObject 
{
	NSString *tableName;
	NSMutableArray *columns;
	NSMutableDictionary *mappings;
}

@property (nonatomic, retain) NSString *tableName;
@property (nonatomic, readonly) NSArray *columns;
-(id)initTableWithName:(NSString *)tblName;
-(void)addColumn:(Column *)column;
-(NSString *)mappedColumnFor:(NSString *)mapping;
-(NSString *)countRecordsSQL;
-(NSString *)selectAllSQL;
@end
