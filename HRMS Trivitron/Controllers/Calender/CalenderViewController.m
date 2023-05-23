//  CalenderViewController.m
//  Islamic Calendar Example
//  Created by Ankush Chauhan on 08/01/18.
//  Copyright © 2018 Bisma. All rights reserved.

#import "CalenderViewController.h"

@interface CalenderViewController ()
@property (weak, nonatomic) IBOutlet BSIslamicCalendar *calendar;

@end

@implementation CalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Attendance Calendar";
    
    
    BSIslamicCalendar *newCalendar = [[BSIslamicCalendar alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y+67, self.view.frame.size.width, self.view.frame.size.height-160)];
    newCalendar.delegate=self;
    [self.view addSubview:newCalendar];
    
    [newCalendar setIslamicDatesInArabicLocale:YES];
    [newCalendar setShowIslamicMonth:YES];
    
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Abbreviation"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(flipView:)];
    flipButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = flipButton;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)flipView:(UIButton*)btn{
    
    UIViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"AbbrevationVC"];
       [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - Calendar Delegate
-(BOOL)islamicCalendar:(BSIslamicCalendar *)calendar shouldSelectDate:(NSDate *)date{
    
    // e.g. Don't select if it's today
    if ([calendar compareDate:date withDate:[NSDate date]]) {
        
        return NO;
    }else{
        
        return YES;
    }
}
-(void)islamicCalendar:(BSIslamicCalendar *)calendar dateSelected:(NSDate *)date withSelectionArray:(NSArray *)selectionArry{
    
    NSLog(@"selections: %@",selectionArry);
}


@end
