//
//  DetailsViewController.h
//  Customer
//
//  Created by Lokesh Yadav on 01/12/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusCustomer.h"
#import "MyProtocol.h"
@interface DetailsViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isNewCustomer;
@property (strong, nonatomic) CusCustomer *custLocal;
@property(nonatomic, assign)id<myProtocol>protocol;



@end
