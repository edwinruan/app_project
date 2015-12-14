//
//  CXSSqliteHelper.m
//  iVendPOS
//
//  Created by Shameem Ahamad on 7/24/14.
//  Copyright (c) 2014 cxsmac2. All rights reserved.
//

#import "CXSSqliteHelper.h"
#import "CusCustomer.h"
#import <objc/runtime.h>
//#import "NSString+MyString.h"

#if !defined(SQLITE_DATE)
#define SQLITE_DATE 6 // Defines the integer value for the table column datatype
#endif
static CXSSqliteHelper *sqliteHelper = nil;
@implementation CXSSqliteHelper
+ (CXSSqliteHelper*)sharedSqliteHelper{
    
    if (!sqliteHelper) {
        sqliteHelper = [[CXSSqliteHelper alloc] init];
    }
    
    return sqliteHelper;
}

- (NSString*)dataSource{
    if (!_dataSource) {
        //NSDocumentDirectory check for CusCustomer_update.sqlite
        NSString *database = [NSString stringWithFormat:@"CusCustomer_update.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *arr = NSSearchPathForDirectoriesInDomains(
                                                           NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDBPath = [arr objectAtIndex:0];
        
        //move from NSBundle to NSDocumentDirectory
        NSString *workingPath = [documentDBPath stringByAppendingPathComponent:database];
        if (![fileManager fileExistsAtPath:workingPath]) {
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"CusCustomer_update" ofType:@"sqlite"];
            NSError *error = nil;
            if (![fileManager copyItemAtPath: resourcePath toPath: workingPath error: &error]) {
                @throw [NSException exceptionWithName: @"DBException" reason: [NSString stringWithFormat: @"Failed to copy data source in resource directory to working directory. '%@'", [error localizedDescription]] userInfo: nil];
            }
        }
        _dataSource = workingPath;
    }
   

    
    return _dataSource;
}

- (void)dealloc {
    [self close];
}

- (void)open{
    if (!_isConnected) {
        NSString *dataSource = [self dataSource];
        if (sqlite3_open([dataSource UTF8String], &_database) != SQLITE_OK) {
            sqlite3_close(_database);
            @throw [NSException exceptionWithName: @"DBException" reason: [NSString stringWithFormat: @"Failed to open database connection. '%p'", sqlite3_errmsg16(_database)] userInfo: nil];
        }
        _isConnected = YES;
    }
}
- (void)close{
    if (_isConnected) {
        if (sqlite3_close(_database) != SQLITE_OK) {
            @throw [NSException exceptionWithName: @"DBException" reason: [NSString stringWithFormat: @"Failed to close database connection. '%p'", sqlite3_errmsg16(_database)] userInfo: nil];
        }
        _isConnected = NO;
        _dataSource = nil;
    }
}

-(NSArray*)getCustomerDataQuery:(NSString *)querySQL{
    
        [self open];
        sqlite3_stmt *statement = NULL;
        if (sqlite3_prepare_v2(_database, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            sqlite3_finalize(statement);
            NSLog(@"%s",sqlite3_errmsg(_database));
            @try {
                [NSException exceptionWithName: @"DBException" reason: [NSString stringWithFormat: @"Failed to perform query with SQL statement. '%p'", sqlite3_errmsg16(_database)] userInfo: nil];
            }
            @catch (NSException *exception) {
    #if SQLITER ==1
                
                NSLog(@"Sqlite Error : %@",exception);
    #endif
            }
            
        }
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        //int uniqueId = sqlite3_column_int(statement, 0);
        char *IdChars=(char *)sqlite3_column_text(statement, 0);
        char *nameChars = (char *) sqlite3_column_text(statement, 1);
        char *emailChars = (char *) sqlite3_column_text(statement, 2);
        char *phoneChars = (char *) sqlite3_column_text(statement, 3);
        char *genderChars = (char *) sqlite3_column_text(statement, 4);
        char *countryChars = (char *) sqlite3_column_text(statement, 5);
        char *assetChars = (char *) sqlite3_column_text(statement, 6);
        
        
        NSString *Id = [[NSString alloc] initWithUTF8String:IdChars];
        NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
        NSString *email=    [[NSString alloc] initWithUTF8String:emailChars];
        NSString *phone = [[NSString alloc] initWithUTF8String:phoneChars];
        NSString *gender = [[NSString alloc] initWithUTF8String:genderChars];
        NSString *country = [[NSString alloc] initWithUTF8String:countryChars];
        NSString *asset = [[NSString alloc] initWithUTF8String:assetChars];
        
        
        CusCustomer *info = [[CusCustomer alloc] init];
        info.Id = Id;
        info.name = name;
        info.email = email;
        info.phone = phone;
        info.gender = gender;
        info.country = country;
        info.asset = asset;
        
        [retval addObject:info];
        info = nil;
        
    }
    sqlite3_finalize(statement);
    
    return retval;
    
}

- (BOOL)InsertDeleteUpdateTable:(NSString*)sql{
#if SQLITER ==1
    NSLog(@"\n<Query>: <%@>\n\n",sql);
    
#endif
    [self open];
    BOOL isSuccess = NO;
    
    sqlite3_stmt *statement = NULL;
    
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        sqlite3_finalize(statement);
        @try {
            [NSException exceptionWithName: @"DBException" reason: [NSString stringWithFormat: @"Failed to perform query with SQL statement. '%p'", sqlite3_errmsg16(_database)] userInfo: nil];
        }
        @catch (NSException *exception) {
#if SQLITER ==1
            NSLog(@"Sqlite Error : %@",exception);
            
#endif
        }
        
    }
    if(sqlite3_step(statement) == SQLITE_DONE){
        isSuccess = YES;
    }
    sqlite3_finalize(statement);
    statement = NULL;
    return isSuccess;
    
}
/*

- (NSArray *)runQuery: (NSString *)sql asObject: (Class)model{
#if SQLITER ==1 
    NSLog(@"\n<Query>: <%@>\n",sql);

#endif
    
    NSLog(@"\n<Query>: <%@>\n",sql);

    [self open];
	sqlite3_stmt *statement = NULL;
	if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
		sqlite3_finalize(statement);
        NSLog(@"%s",sqlite3_errmsg(_database));
		        @try {
            [NSException exceptionWithName: @"DBException" reason: [NSString stringWithFormat: @"Failed to perform query with SQL statement. '%p'", sqlite3_errmsg16(_database)] userInfo: nil];
        }
        @catch (NSException *exception) {
#if SQLITER ==1
            
            NSLog(@"Sqlite Error : %@",exception);
#endif
        }

	}
    
	NSMutableArray *records = [[NSMutableArray alloc] init];
	while (sqlite3_step(statement) == SQLITE_ROW) {
		id record = [[model alloc] init];
        int columnCount = sqlite3_column_count(statement);
        
        for (int index = 0; index < columnCount; index++) {
            NSString *columnName = [NSString stringWithUTF8String: sqlite3_column_name(statement, index)];
            int columnType = [[NSNumber numberWithInt: [self columnTypeAtIndex: index inStatement: statement]] intValue];
            id value = [self columnValueAtIndex: index withColumnType:columnType  inStatement: statement];
            if([self propertyExistForClass:model withPropertyName:columnName]){
                if (value != nil) {
                    [record setValue: ([value isKindOfClass:[NSString class]]) ? [CXSSqliteHelper valueNotNull:value]: value forKey: columnName];
                }
            }
            

        }
		[records addObject: record];
	}
    
	sqlite3_finalize(statement);
    statement = NULL;
    return records;
}

- (int)rowCount: (NSString *)sql{
#if SQLITER ==1
    NSLog(@"\n<Query>: <%@>\n\n",sql);
#endif   
    [self open];
    int count = 0;
	sqlite3_stmt *statement = NULL;
	if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
		sqlite3_finalize(statement);
#if SQLITER ==1 
        NSLog(@"%s",sqlite3_errmsg(_database));

#endif
		        @try {
            [NSException exceptionWithName: @"DBException" reason: [NSString stringWithFormat: @"Failed to perform query with SQL statement. '%p'", sqlite3_errmsg16(_database)] userInfo: nil];
        }
        @catch (NSException *exception) {
#if SQLITER ==1 
            NSLog(@"Sqlite Error : %@",exception);

#endif
        }

	}
    
	while (sqlite3_step(statement) == SQLITE_ROW) {
        count = sqlite3_column_int(statement, 0);
	}
	sqlite3_finalize(statement);
    statement = NULL;
    return count;
}


- (int)columnTypeAtIndex:(int)column inStatement:(sqlite3_stmt *)statement {
	// Declared data types - http://www.sqlite.org/datatype3.html (section 2.2 table column 1)
	const NSSet *blobTypes = [NSSet setWithObjects: @"BINARY", @"BLOB", @"VARBINARY", nil];
	const NSSet *charTypes = [NSSet setWithObjects: @"CHAR", @"CHARACTER", @"CLOB", @"NATIONAL VARYING CHARACTER", @"NATIVE CHARACTER", @"NCHAR", @"NVARCHAR", @"TEXT", @"VARCHAR", @"VARIANT", @"VARYING CHARACTER", nil];
	const NSSet *dateTypes = [NSSet setWithObjects: @"DATE", @"DATETIME", @"TIME", @"TIMESTAMP", nil];
	const NSSet *intTypes  = [NSSet setWithObjects: @"BIGINT", @"BIT", @"BOOL", @"BOOLEAN", @"INT", @"INT2", @"INT8", @"INTEGER", @"MEDIUMINT", @"SMALLINT", @"TINYINT", nil];
	const NSSet *nullTypes = [NSSet setWithObjects: @"NULL", nil];
	const NSSet *realTypes = [NSSet setWithObjects: @"DECIMAL", @"DOUBLE", @"DOUBLE PRECISION", @"FLOAT", @"NUMERIC", @"REAL", nil];
	// Determine data type of the column - http://www.sqlite.org/c3ref/c_blob.html
	const char *columnType = (const char *)sqlite3_column_decltype(statement, column);
	if (columnType != NULL) {
		NSString *dataType = [[NSString stringWithUTF8String: columnType] uppercaseString];
		NSRange end = [dataType rangeOfString: @"("];
		if (end.location != NSNotFound) {
			dataType = [dataType substringWithRange: NSMakeRange(0, end.location)];
		}
		if ([dataType hasPrefix: @"UNSIGNED"]) {
			dataType = [dataType substringWithRange: NSMakeRange(0, 8)];
		}
		dataType = [dataType stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
		if ([intTypes containsObject: dataType]) {
			return SQLITE_INTEGER;
		}
		if ([realTypes containsObject: dataType]) {
			return SQLITE_FLOAT;
		}
		if ([charTypes containsObject: dataType]) {
			return SQLITE_TEXT;
		}
		if ([blobTypes containsObject: dataType]) {
			return SQLITE_BLOB;
		}
		if ([nullTypes containsObject: dataType]) {
			return SQLITE_NULL;
		}
		if ([dateTypes containsObject: dataType]) {
			return SQLITE_DATE;
		}
		return SQLITE_TEXT;
	}
	return sqlite3_column_type(statement, column);
}
- (id)columnValueAtIndex:(int)column withColumnType:(int)columnType inStatement:(sqlite3_stmt *)statement{
	if (columnType == SQLITE_INTEGER) {
		return [NSNumber numberWithLongLong: sqlite3_column_int64(statement, column)];
	}
	if (columnType == SQLITE_FLOAT) {
		return [NSDecimalNumber numberWithDouble:sqlite3_column_double(statement, column)];
	}
	if (columnType == SQLITE_TEXT) {
		const char *text = (const char *)sqlite3_column_text(statement, column);
		if (text != NULL) {
			return [NSString stringWithUTF8String: text];
		}
	}
	if (columnType == SQLITE_BLOB) {
		return [NSData dataWithBytes: sqlite3_column_blob(statement, column) length: sqlite3_column_bytes(statement, column)];
	}
	if (columnType == SQLITE_DATE) {
		const char *text = (const char *)sqlite3_column_text(statement, column);
		if (text != NULL) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			NSDate *date = [formatter dateFromString: [NSString stringWithUTF8String: text]];
            formatter = nil;
			return date;
		}
	}
	return [NSString string];
}



- (BOOL)propertyExistForClass:(Class)model withPropertyName:(NSString*)propertyName{
    
    return  class_getProperty(model, [propertyName UTF8String]) ? YES : NO;
    
}
*/
//+ (NSString *)valueNotNull:(id)value {
//    
//    if([value isEqualToString:@"(null)"] || value == NULL || [value isEqualToString:@"nul"]) {
//        return [NSString stringWithFormat:@""];
//    }
//    return value;
//}
//+ (NSString *) prepareValue: (id)value {
//    if ((value == nil) || [value isKindOfClass: [NSNull class]]) {
//        return @"NULL";
//    }
//    else if ([value isKindOfClass: [NSArray class]]) {
//        NSMutableString *buffer = [NSMutableString string];
//        [buffer appendString: @"("];
//        for (int i = 0; i < [value count]; i++) {
//            if (i > 0) {
//                [buffer appendString: @", "];
//            }
//            [buffer appendString: [self prepareValue: [value objectAtIndex: i]]];
//        }
//        [buffer appendString: @")"];
//        return buffer;
//    }
//    else if ([value isKindOfClass: [NSNumber class]]) {
//        return [NSString stringWithFormat: @"%@", value];
//    }
//    else if ([value isKindOfClass: [NSString class]]) {
//        char *escapedValue = sqlite3_mprintf("'%q'", [(NSString *)value UTF8String]);
//        NSString *string = [NSString stringWithUTF8String: (const char *)escapedValue];
//        sqlite3_free(escapedValue);
//        return string;
//    }
//    else if ([value isKindOfClass: [NSData class]]) {
//        NSData *data = (NSData *)value;
//        int length = [data length];
//        NSMutableString *buffer = [NSMutableString string];
//        [buffer appendString: @"x'"];
//        const unsigned char *dataBuffer = [data bytes];
//        for (int i = 0; i < length; i++) {
//            [buffer appendFormat: @"%02lx", (unsigned long)dataBuffer[i]];
//        }
//        [buffer appendString: @"'"];
//        return buffer;
//    }
//    else if ([value isKindOfClass: [NSDate class]]) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//        NSString *date = [NSString stringWithFormat: @"'%@'", [formatter stringFromDate: (NSDate *)value]];
//        return date;
//    }
//    
//    //TODO::
//    /*else if ([value isKindOfClass: [ZIMSqlExpression class]]) {
//     return [(ZIMSqlExpression *)value expression];
//     }
//     else if ([value isKindOfClass: [ZIMSqlSelectStatement class]]) {
//     NSString *statement = [(ZIMSqlSelectStatement *)value statement];
//     statement = [statement substringWithRange: NSMakeRange(0, [statement length] - 1)];
//     statement = [NSString stringWithFormat: @"(%@)", statement];
//     return statement;
//     }*/
//    else {
//        @throw [NSException exceptionWithName: @"SqlException" reason: [NSString stringWithFormat: @"Unable to prepare value. '%@'", value] userInfo: nil];
//    }
//}
//
//- (void)dealloc {
//    [self close];
//}

/*
- (void)deleteFromTable: (NSString *)table Where:(NSDictionary*)whereClause{
    
    __block NSMutableArray* sqliteFormatValuesWhere = [[NSMutableArray alloc]init];
    [[whereClause allKeys] enumerateObjectsUsingBlock:^(NSString* key, NSUInteger idx, BOOL *stop) {
        [sqliteFormatValuesWhere addObject:[NSString stringWithFormat:@"%@ = %@",key,[[whereClause valueForKey:key] sqliteString]]];
    }];
    NSString *query = [NSString stringWithFormat:@"delete from %@ where (%@)",table,[sqliteFormatValuesWhere componentsJoinedByString:@" AND "]];
    [self deleteFromTable:query];
}
 */




/*
- (void)updateTable: (NSString *)table ColumnsAndValues:(NSDictionary*)cv Where:(NSDictionary*)whereClause{
    
    __block NSMutableArray* sqliteFormatValues = [[NSMutableArray alloc]init];
    [[cv allKeys] enumerateObjectsUsingBlock:^(NSString* key, NSUInteger idx, BOOL *stop) {
        [sqliteFormatValues addObject:[NSString stringWithFormat:@"%@ = %@",key,[[cv valueForKey:key] sqliteString]]];
    }];
    __block NSMutableArray* sqliteFormatValuesWhere = [[NSMutableArray alloc]init];
    [[whereClause allKeys] enumerateObjectsUsingBlock:^(NSString* key, NSUInteger idx, BOOL *stop) {
        [sqliteFormatValuesWhere addObject:[NSString stringWithFormat:@"%@ = %@",key,[[whereClause valueForKey:key] sqliteString]]];
    }];
    
    NSString *query = [NSString stringWithFormat:@"update %@ set %@ where (%@)",table,[sqliteFormatValues componentsJoinedByString:@","],[sqliteFormatValuesWhere componentsJoinedByString:@" AND "]];
    [self updateIntoTable:query];
}
- (BOOL)updateIntoTable:(NSString*)sql{
#if SQLITER ==1
    NSLog(@"\n<Query>: <%@>\n\n",sql);
    
#endif
    [self open];
    BOOL isSuccess = NO;
    
    sqlite3_stmt *statement = NULL;
    
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        sqlite3_finalize(statement);
        @try {
            [NSException exceptionWithName: @"DBException" reason: [NSString stringWithFormat: @"Failed to perform query with SQL statement. '%p'", sqlite3_errmsg16(_database)] userInfo: nil];
        }
        @catch (NSException *exception) {
#if SQLITER ==1
            NSLog(@"Sqlite Error : %@",exception);
            
#endif
        }
        
    }
    if(sqlite3_step(statement) == SQLITE_DONE){
        isSuccess = YES;
    }
    sqlite3_finalize(statement);
    statement = NULL;
    return isSuccess;
    
    
}
*/
@end
