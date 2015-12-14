//
//  DetailsViewController.m
//  Customer
//
//  Created by Lokesh Yadav on 01/12/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import "DetailsViewController.h"
#import "CustomTableViewCell.h"
#import "AppDelegate.h"


//user custom cell and default cell in the same section

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblCustomer;


@end

@implementation DetailsViewController
@synthesize isNewCustomer;
@synthesize custLocal;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)SaveObject:(id)sender {
    
    [self.view endEditing:YES];

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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(SaveObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if (!self.isNewCustomer) {
        [self.navigationItem setTitle:@"Customer Edit"];
        
    }
    else {
        [self.navigationItem setTitle:@"New Customer"];
        
    }
    self.tblCustomer.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tblCustomer reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//user custom cell and default cell in the same section
//custom cell override the initWithStyle function
//use two dequeueReusablecellWithIdentifier

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 1;


}           // Default is 1 if not implemented

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    int i=0;
//    if (section==0) {
//        i=1;
//    }
//    else if (section==1)
//        i=8;
//    
//    return i;
    
    return 7;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *returncell;
    static NSString *cellIdentifier;
    
//    if (indexPath.section==0) {
//        cellIdentifier=@"CellIdentifier";
//    }
//    else if (indexPath.section==1)
//    {
//        cellIdentifier=@"CellIdentifier2";
//    }
    
    
    if (indexPath.row==0) {
        cellIdentifier=@"CellIdentifier";
    }
    else{
        cellIdentifier=@"CellIdentifier2";
    }
    
    
    
    
    if (indexPath.row==0) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text=@"Customer List";
        returncell= cell;
    }
    else
    {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        //overwrite initiate function
        if (cell==nil) {
            
            cell=[[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.textDetail setDelegate:self];
        switch (indexPath.row) {
            case 0: {
                [cell.lblTitle setText: @"Id"];
                [cell.textDetail setText: [self.custLocal.Id length]? self.custLocal.Id : @""];
                [cell.textDetail setTag:indexPath.row];
                if (!isNewCustomer)
                    [cell.textDetail setUserInteractionEnabled:NO];
                
                
                
            }
                break;
                
            case 1: {
                [cell.lblTitle setText: @"name"];
                [cell.textDetail setText: [self.custLocal.name length]? self.custLocal.name : @""];
                [cell.textDetail setTag:indexPath.row];
                [cell.textDetail setUserInteractionEnabled:YES];
            }
                break;
                
                
            case 2: {
                [cell.lblTitle setText: @"email"];
                [cell.textDetail setText: [self.custLocal.email length]? self.custLocal.email : @""];
                [cell.textDetail setTag:indexPath.row];
                [cell.textDetail setUserInteractionEnabled:YES];
            }
                break;
            case 3: {
                [cell.lblTitle setText: @"phone"];
                [cell.textDetail setText: [self.custLocal.phone length]? self.custLocal.phone : @""];
                [cell.textDetail setTag:indexPath.row];
                [cell.textDetail setUserInteractionEnabled:YES];
            }
                break;
            case 4: {
                [cell.lblTitle setText: @"gender"];
                [cell.textDetail setText: [self.custLocal.gender length]? self.custLocal.gender : @""];
                [cell.textDetail setTag:indexPath.row];
                [cell.textDetail setUserInteractionEnabled:YES];
            }
                break;
            case 5: {
                [cell.lblTitle setText: @"country"];
                [cell.textDetail setText: [self.custLocal.country length]? self.custLocal.country : @""];
                [cell.textDetail setTag:indexPath.row];
                [cell.textDetail setUserInteractionEnabled:YES];
            }
                break;
                
                
            default: {
                [cell.lblTitle setText: @"asset"];
                [cell.textDetail setText:[self.custLocal.asset length]? self.custLocal.asset : @""];
                [cell.textDetail setTag:indexPath.row];
                [cell.textDetail setUserInteractionEnabled:YES];
                
            }
                break;
        }
        returncell= cell;
        
        
    }
    
    
    
    
    
    
   return returncell;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"%d",textField.tag);
    switch (textField.tag) {
        case 0:{
           if (isNewCustomer)
               [self.custLocal setId:[NSDate date]];

        }
            break;
        case 1:{
             [self.custLocal setName:textField.text];
        }
            break;
        case 2:{
            [self.custLocal setEmail:textField.text];
        }
            break;
        case 3:{
            [self.custLocal setPhone:textField.text];
        }
            break;
        case 4:{
            [self.custLocal setGender:textField.text];
        }
            break;
        case 5:{
            [self.custLocal setCountry:textField.text];
        }
            break;
        default:{
            [self.custLocal setAsset:textField.text];
        }
            break;
    }
    
  //CustomTableViewCell *cell = (CustomTableViewCell*)[self.custLocal cellForRowAtIndexPath:indexPath];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
