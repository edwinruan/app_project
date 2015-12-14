//
//  RegisterViewController.h
//  Customer_update
//
//  Created by Yongxiang Ruan on 12/4/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryTableViewController.h"
#import "CusCustomer.h"
#import "MyProtocol.h"



@class ViewController;

@interface RegisterViewController : UIViewController <CountryTableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate>

// should put back into implementation file
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *countryText;

@property (strong,nonatomic)NSString *gender;
@property (strong,nonatomic)NSString *asset;


@property (nonatomic, assign) BOOL isNewCustomer;
@property (strong, nonatomic) CusCustomer *custLocal;
@property(nonatomic, assign)id<myProtocol>protocol;


- (IBAction)maleBtn_Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
- (IBAction)femaleBtn_Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

- (IBAction)houseBtn_Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *houseBtn;
- (IBAction)carBtn_Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;



- (IBAction)saveDataBaseBtn:(id)sender;

- (IBAction)showDateBaseBtn:(id)sender;



@end
