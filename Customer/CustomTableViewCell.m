//
//  CustomTableViewCell.m
//  Customer
//
//  Created by Lokesh Yadav on 01/12/15.
//  Copyright © 2015 Lokesh Yadav. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
   
}

-(id)init{
    self=[super init];
    if (self) {
        self.lblTitle=nil;
        self.textDetail=nil;
    }
    return self;

}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        
        self.lblTitle=nil;
        self.textDetail=nil;
//        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        nearbyLocation = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
//        
//        [self addSubview:nearbyLocation];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
