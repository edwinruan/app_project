//
//  CusCustomer.m
//  Customer
//
//  Created by Lokesh Yadav on 01/12/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import "CusCustomer.h"

@implementation CusCustomer
//@synthesize Id = _Id;
//@synthesize name = _name;
//@synthesize email  = _email;


- (void) dealloc {
    self.Id = nil;
    self.name = nil;
    self.email = nil;
    self.phone=nil;
    self.gender=nil;
    self.country=nil;
    self.asset=nil;
    
}

- (id)copyWithZone:(NSZone *)zone {
    
    CusCustomer *cust = [[CusCustomer alloc] init];
    cust.Id = [self.Id copy];
    cust.name = [self.name copy];
    cust.email = [self.email copy];
    cust.phone=[self.phone copy];
    cust.gender=[self.gender copy];
    cust.country=[self.country copy];
    cust.asset=[self.asset copy];
    
    
    return cust;
    
}
@end
