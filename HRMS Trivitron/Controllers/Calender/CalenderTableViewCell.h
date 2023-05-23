//
//  CalenderTableViewCell.h
//  Bharat Seat
//
//  Created by Ankush Chauhan on 12/01/18.
//  Copyright © 2018 netcommlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalenderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblInTime;
@property (strong, nonatomic) IBOutlet UILabel *lblOuttime;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblMonthName;

@end
