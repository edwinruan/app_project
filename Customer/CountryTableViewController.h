//
//  CountryTableViewController.h
//  Customer_update
//
//  Created by Yongxiang Ruan on 12/4/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryTableViewDelegate <NSObject>

-(void)countryTableDidFinishedSelect:(NSString*)country;

@end


@interface CountryTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray * array;

@property (nonatomic,weak)id<CountryTableViewDelegate> delegate;

@end
