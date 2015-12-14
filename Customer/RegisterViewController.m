//
//  RegisterViewController.m
//  Customer_update
//
//  Created by Yongxiang Ruan on 12/4/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import "RegisterViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *maleTxt;
@property (weak, nonatomic) IBOutlet UILabel *femaleTxt;

@end

@implementation RegisterViewController

@synthesize isNewCustomer;
@synthesize custLocal;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countryText.delegate=self;
    
    [self.countryText addTarget:self action:@selector(updateCountryTextField) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateCountryTextField{
    CountryTableViewController *tableviewcontroller= [self.storyboard instantiateViewControllerWithIdentifier:@"countrytableviewcontroller"];
    tableviewcontroller.delegate=self;
    
    [self.navigationController pushViewController:tableviewcontroller animated:YES];
}


-(void)countryTableDidFinishedSelect:(NSString *)country
{
    self.countryText.text=country;
    
    NSLog(@"%@", country);
    
}

-(void)assetBtnSetup{
    
    UIImage *nonCheckedImage=[UIImage imageNamed:@"Unchecked.png"];
    UIImage *CheckedImage=[UIImage imageNamed:@"Checked.png"];
    
    
    [self.houseBtn setImage:CheckedImage forState:UIControlStateSelected];
    [self.houseBtn setImage:nonCheckedImage forState:UIControlStateNormal];
    
    
    [self.carBtn setImage:CheckedImage forState:UIControlStateSelected];
    [self.carBtn setImage:nonCheckedImage forState:UIControlStateNormal];
    
    if (self.houseBtn.selected==YES && self.carBtn.selected==YES) {
        self.asset=@"House and Car";
        
    }else if (self.houseBtn.selected==YES &&self.carBtn.selected==NO) {
        self.asset=@"House";
    }else if (self.houseBtn.selected==NO &&self.carBtn.selected==YES)
    {
        self.asset=@"Car";
        
    }else
    {
        self.asset=nil;
        
    }
    NSLog(@"self.asset:%@", self.asset);
}

- (IBAction)houseBtn_Tapped:(id)sender {
    self.houseBtn.selected=!self.houseBtn.selected;
    
    [self assetBtnSetup];
}

- (IBAction)carBtn_Tapped:(id)sender {
    self.carBtn.selected=!self.carBtn.selected;
    
    [self assetBtnSetup];
}

- (IBAction)saveDataBaseBtn:(id)sender {
    NSString * query = nil;
    if (!isNewCustomer) {
        query = [NSString stringWithFormat:@"UPDATE Customer SET name = '%@', email = '%@', phone='%@', gender='%@', country='%@', asset='%@' WHERE ID = '%@'",self.custLocal.name,self.custLocal.email, self.custLocal.phone,self.custLocal.gender,self.custLocal.country,self.custLocal.asset,self.custLocal.Id] ;
    }else{
        query = [NSString stringWithFormat:@"INSERT INTO Customer VALUES('%@','%@','%@','%@', '%@','%@','%@');", self.custLocal.Id,self.custLocal.name,self.custLocal.email, self.custLocal.phone,self.custLocal.gender,self.custLocal.country,self.custLocal.asset];
    }
    BOOL  flag  = [[CXSSqliteHelper sharedSqliteHelper] InsertDeleteUpdateTable:query];
    if ([self protocol]) {
        [self.protocol updateDelegateValue];
    }
    if (flag) {
        NSLog(@"Success");
    }
    
    
    
}

- (IBAction)showDateBaseBtn:(id)sender {
    ViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
    //view.arr = self.arrCustomer;
    
    [self.navigationController pushViewController:view animated:YES];
    
}




//gender check box
- (IBAction)femaleBtn_Tapped:(id)sender {
    
    if (self.maleBtn.selected==NO && self.femaleBtn.selected==NO) {
        self.femaleBtn.selected=!self.femaleBtn.selected;
    }
    else if (self.maleBtn.selected==NO && self.femaleBtn.selected==YES)
    {
        self.maleBtn.selected=NO;
        self.femaleBtn.selected=NO;
        
    }
    else if (self.maleBtn.selected==YES && self.femaleBtn.selected==NO)
    {
        self.maleBtn.selected=NO;
        self.femaleBtn.selected=YES;
        
    }
    else if(self.maleBtn.selected==YES && self.femaleBtn.selected==YES)
    {
        self.maleBtn.selected=YES;
        self.femaleBtn.selected=NO;
    }
    
    
    [self genderBtnSetup];
    
}

- (IBAction)maleBtn_Tapped:(id)sender {
    if (self.maleBtn.selected==NO && self.femaleBtn.selected==NO) {
        self.maleBtn.selected=!self.maleBtn.selected;
    }
    else if (self.maleBtn.selected==NO && self.femaleBtn.selected==YES)
    {
        self.maleBtn.selected=YES;
        self.femaleBtn.selected=NO;
        
    }
    else if (self.maleBtn.selected==YES && self.femaleBtn.selected==NO)
    {
        self.maleBtn.selected=NO;
        self.femaleBtn.selected=NO;
        
    }
    else if(self.maleBtn.selected==YES && self.femaleBtn.selected==YES)
    {
        self.maleBtn.selected=NO;
        self.femaleBtn.selected=YES;
    }
    
    
    [self genderBtnSetup];
}


-(void)genderBtnSetup{
    
    UIImage *nonCheckedImage=[UIImage imageNamed:@"Unchecked.png"];
    UIImage *CheckedImage=[UIImage imageNamed:@"Checked.png"];
    
    
    [self.maleBtn setImage:CheckedImage forState:UIControlStateSelected];
    [self.maleBtn setImage:nonCheckedImage forState:UIControlStateNormal];
    
    
    [self.femaleBtn setImage:CheckedImage forState:UIControlStateSelected];
    [self.femaleBtn setImage:nonCheckedImage forState:UIControlStateNormal];
    
    if (self.maleBtn.selected==YES) {
        self.gender=@"Male";
        
    }else if (self.femaleBtn.selected==YES) {
        self.gender=@"Female";
    }else
    {
        self.gender=nil;
        
    }
}
@end
