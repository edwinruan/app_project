//
//  ViewController.m
//  Customer
//
//  Created by Lokesh Yadav on 01/12/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import "ViewController.h"
#import "DetailsViewController.h"
#import "CusCustomer.h"
#import "AppDelegate.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *Customtable;
@property (strong, nonatomic) NSMutableArray  *arrCustomer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchCustomerData];
    
       // Do any additional setup after loading the view, typically from a nib.
}

- (void)insertNewObject:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    DetailsViewController *productViewVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    
    [productViewVC setProtocol:self];
    [productViewVC setCustLocal:[CusCustomer alloc]];
    [productViewVC setIsNewCustomer:YES];
    [self.navigationController pushViewController:productViewVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
   
    
    
}
-(NSMutableArray*)arrCustomer{
    if (!_arrCustomer) {
        _arrCustomer = [[NSMutableArray alloc] init];
    }
    return _arrCustomer;

}
-(void)fetchCustomerData{
    
    NSString *query = @"SELECT * FROM Customer";
    NSArray *arr = [[CXSSqliteHelper sharedSqliteHelper] getCustomerDataQuery:query];
    NSLog(@"%@",arr);
    
    [[self arrCustomer] addObjectsFromArray:arr];
    
    [self.Customtable reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrCustomer count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    CusCustomer *cust = [self.arrCustomer objectAtIndex:indexPath.row];
    cell.textLabel.text = cust.Id;
    cell.detailTextLabel.text = cust.name;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // self.navigationController.navigationBarHidden = YES;
    CusCustomer *cust = [self.arrCustomer objectAtIndex:indexPath.row];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    DetailsViewController *productViewVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [productViewVC setProtocol:self];
    [productViewVC setIsNewCustomer:NO];
    [productViewVC setCustLocal:[cust copy]];
    [self.navigationController pushViewController:productViewVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES ;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CusCustomer *cust = [self.arrCustomer objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM Customer where ID = '%@'",cust.Id];
        BOOL delete = [[CXSSqliteHelper sharedSqliteHelper] InsertDeleteUpdateTable:query];
        if (delete) {
            [self.arrCustomer removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

-(void)updateDelegateValue{
    self.arrCustomer = nil;
    [self fetchCustomerData];
    [self.Customtable reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
