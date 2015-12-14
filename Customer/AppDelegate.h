//
//  AppDelegate.h
//  Customer
//
//  Created by Lokesh Yadav on 01/12/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXSSqliteHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CXSSqliteHelper *sharedSqlite;


@end

