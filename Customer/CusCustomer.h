//
//  CusCustomer.h
//  Customer
//
//  Created by Lokesh Yadav on 01/12/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CusCustomer : NSObject<NSCopying>
@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString * country;
@property (strong,nonatomic)  NSString *asset;


@end
