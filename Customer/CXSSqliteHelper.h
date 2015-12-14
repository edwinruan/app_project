//
//  CXSSqliteHelper.h
//  iVendPOS
//
//  Created by Shameem Ahamad on 7/24/14.
//  Copyright (c) 2014 cxsmac2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> // Requires libsqlite3.dylib

@interface CXSSqliteHelper : NSObject
{

    NSString *_dataSource;
    sqlite3 *_database;
    BOOL _isConnected;

}

+ (CXSSqliteHelper*)sharedSqliteHelper;
//- (NSArray *) runQuery: (NSString *)sql asObject: (Class)model ;
//- (void)insertInto: (NSString *)table ColumnsAndValues:(NSDictionary*)cv ;
//- (void)deleteFromTable: (NSString *)table Where:(NSDictionary*)whereClause;
//- (void)updateTable: (NSString *)table ColumnsAndValues:(NSDictionary*)cv Where:(NSDictionary*)whereClause;
//- (int)rowCount: (NSString *)sql;
- (void)close;
- (void)open;


-(NSArray*)getCustomerDataQuery:(NSString *)querySQL;
- (BOOL)InsertDeleteUpdateTable:(NSString*)sql;

@end
