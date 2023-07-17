#import "BSIslamicCalendar.h"
#import "BSIslamicCalendarCell.h"
#import "GridCollectionViewLayout.h"
#import "CalenderTableViewCell.h"



#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
@implementation BSIslamicCalendar  {
    
    //New Objects
    NSDictionary * dicForAttendenceCalender;
    NSMutableArray * arrayForCalendrer;
    NSString * strDate;
    long count ;
    NSMutableArray * arrayNew2;
    
    //
    
    NSInteger startIndex;
    NSDate *calForDate;
    NSDateComponents *componentsService;
    NSDateComponents *components;
    NSRange rangeOfDaysThisMonth;
    NSCalendar *gregorian;
    NSInteger rowCount;
    NSMutableArray *datesArry;
    UICollectionView *collectionVew;
    
    UITableView *tableView;
    
    UIColor *dateTextColor;
    UIColor *daysNameColor;
    UIColor *dateBGColor;
    UIColor *selectedDateBGColor;
    UIColor *currentDateTextColor;
    
    UIButton *btnNext;
    
    UIButton *btnGrid;
    UIButton *btnPrevious;
    UILabel *lblMonth;
    
    UILabel *lblNoDateFound;
    
    
    BOOL isShortInitials;
    BOOL isIslamicMonth;
    BOOL isArabicLocale;
    
    BOOL isGrid;
    
    NSMutableArray *selectionArry;
    
    UIView * ViewForTableHeader;
    
}
-(id)init{
    
    if (self=[super init]) {
        
        self.frame=CGRectMake(20, 20, 300, 300);
        
        [self initializeIslamicCalendar];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        self.frame=frame;
        if (frame.size.width>0) {
            
            [self initializeIslamicCalendar];
        }
    }
    return self;
}
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self initializeIslamicCalendar];
}
-(void)initializeIslamicCalendar{
    
    CGRect rect = self.frame;
    rect.origin.x=0;
    
    rect.size.height=rect.size.height-40;
    
    [tableView setHidden:YES];
    [lblNoDateFound setHidden:YES];
    
    /*
     UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
     flowLayout.itemSize=CGSizeMake(width/7.0, height/7.0);
     flowLayout.minimumLineSpacing=3.0;
     flowLayout.minimumInteritemSpacing=3.0;
     */
    
    isGrid = false;
    GridCollectionViewLayout *flowLayout = [[GridCollectionViewLayout alloc] init];
    
    collectionVew=[[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    collectionVew.showsVerticalScrollIndicator=NO;
    collectionVew.showsHorizontalScrollIndicator=NO;
    
    collectionVew.delegate=self;
    collectionVew.dataSource=self;
    
    collectionVew.backgroundColor=[UIColor clearColor];
    [self addSubview:collectionVew];
    [collectionVew registerNib:[UINib nibWithNibName:@"BSIslamicCalendarCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, collectionVew.frame.size.width, collectionVew.frame.size.height) style:UITableViewStylePlain];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    
    [self addSubview:tableView];
    UINib *cellNib = [UINib nibWithNibName:@"CalenderTableViewCell" bundle:nil];
    [tableView registerNib:cellNib forCellReuseIdentifier:@"CalenderTableViewCell"];
    
    lblNoDateFound = [[UILabel alloc] initWithFrame:CGRectMake(0,200,collectionVew.frame.size.width, 40)];
    lblNoDateFound.textAlignment = NSTextAlignmentCenter;
    lblNoDateFound.textColor = [UIColor lightGrayColor];
    lblNoDateFound.text = @"No data found";
    [self addSubview:lblNoDateFound];
    
//    ViewForTableHeader = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, collectionVew.frame.size.width, 25)];
//    ViewForTableHeader.backgroundColor = [UIColor lightGrayColor];
//    [self  addSubview:ViewForTableHeader];
//    [ViewForTableHeader setHidden:YES];
    
//    UILabel * lblDateHeader =[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, 25)];
//    [lblDateHeader setFont:[UIFont systemFontOfSize:12]];
//    lblDateHeader.textAlignment=NSTextAlignmentCenter;
//    lblDateHeader.text = @"Date";
//
//    lblDateHeader.textColor = [UIColor blackColor];
//    [ViewForTableHeader addSubview:lblDateHeader];
//
//    UILabel * lblInTimeHeader =[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 50, 25)];
//    [lblInTimeHeader setFont:[UIFont systemFontOfSize:12]];
//    lblInTimeHeader.textAlignment=NSTextAlignmentCenter;
//    lblInTimeHeader.text = @"In Time";
//
//    lblInTimeHeader.textColor = [UIColor blackColor];
//    [ViewForTableHeader addSubview:lblInTimeHeader];
//
//
//    UILabel * lblOutTimeHeader =[[UILabel alloc] initWithFrame:CGRectMake(160, 0, 60, 25)];
//    [lblOutTimeHeader setFont:[UIFont systemFontOfSize:12]];
//    lblOutTimeHeader.textAlignment=NSTextAlignmentCenter;
//    lblOutTimeHeader.text = @"Out Time";
//
//    lblOutTimeHeader.textColor = [UIColor blackColor];
//    [ViewForTableHeader addSubview:lblOutTimeHeader];
//
//    UILabel * lblStatusHeader =[[UILabel alloc] initWithFrame:CGRectMake(240, 0, 50, 25)];
//    [lblStatusHeader setFont:[UIFont systemFontOfSize:12]];
//    lblStatusHeader.textAlignment=NSTextAlignmentCenter;
//    lblStatusHeader.text = @"Status";
//
//    lblStatusHeader.textColor = [UIColor blackColor];
//    [ViewForTableHeader addSubview:lblStatusHeader];
//
//
    
    
    
    UIView * ViewForCustom = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, collectionVew.frame.size.width, 40)];
    //  ViewForCustom.backgroundColor = [UIColor blueColor]; #colorLiteral(red: 0, green: 0.5333333333, blue: 0.337254902, alpha: 1)
    //  #colorLiteral(red: 0.06666666667, green: 0.3921568627, blue: 0.7137254902, alpha: 1)
    //#colorLiteral(red: 0, green: 0.6775407791, blue: 0.2961367369, alpha: 1)
//#colorLiteral(red: 0.3529411765, green: 0.7294117647, blue: 0.3254901961, alpha: 1)
    //#colorLiteral(red: 0.01568627451, green: 0.2745098039, blue: 0.4549019608, alpha: 1)
//#colorLiteral(red: 0.4131571949, green: 0.6051561832, blue: 0.188331902, alpha: 1)
    
    //#colorLiteral(red: 0, green: 0.3719885647, blue: 0.697519362, alpha: 1)
    ViewForCustom.backgroundColor = [UIColor colorWithRed:0 green:0.3719885647 blue:0.697519362 alpha:1];
    [self addSubview:ViewForCustom];
    lblMonth=[[UILabel alloc] initWithFrame:CGRectMake((rect.size.width-100)*0.5, (ViewForCustom.frame.origin.y/2)-5, 100, 30)];
    [lblMonth setFont:[UIFont boldSystemFontOfSize:14]];
    lblMonth.textAlignment=NSTextAlignmentCenter;
    lblMonth.textColor = [UIColor whiteColor];
    
    [ViewForCustom addSubview:lblMonth];
    
    btnGrid = [[UIButton alloc] initWithFrame:CGRectMake((rect.size.width-110)*1.17, 2, 40, 40)];
    UIImage *ListImage = [UIImage imageNamed:@"list"];
    [btnGrid setImage:ListImage forState:UIControlStateNormal];
    //[btnGrid setTitle:@"List" forState:UIControlStateNormal];
    [btnGrid setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGrid.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [ViewForCustom addSubview:btnGrid];
    
    
    [btnGrid addTarget:self action:@selector(gridBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnNext = [[UIButton alloc] initWithFrame:CGRectMake(lblMonth.frame.origin.x+lblMonth.frame.size.width+20, lblMonth.frame.origin.y, 40, 30)];
    UIImage *nextImage = [UIImage imageNamed:@"next"];
    [btnNext setImage:nextImage forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnNext.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [ViewForCustom addSubview:btnNext];
    [btnNext addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnPrevious=[[UIButton alloc] initWithFrame:CGRectMake(lblMonth.frame.origin.x-60, lblMonth.frame.origin.y, 40, 30)];
    UIImage *prevImage = [UIImage imageNamed:@"prev"];
    [btnPrevious setImage:prevImage forState:UIControlStateNormal];
    [btnPrevious setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPrevious.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [ViewForCustom addSubview:btnPrevious];
    
    [btnPrevious addTarget:self action:@selector(previousBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    dateTextColor=[UIColor whiteColor];
    dateBGColor=[UIColor lightGrayColor];
    daysNameColor=[UIColor blackColor];
    selectedDateBGColor=[UIColor magentaColor];
    currentDateTextColor=[UIColor blueColor];
    
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    // now build a NSDate object for the next day
    //    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //    [offsetComponents setDay:1];
    //    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: [NSDate date] options:0];
    
    calForDate = [NSDate date];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    
    rangeOfDaysThisMonth = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:calForDate];
    
    components = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra) fromDate:calForDate];
    
    [components setTimeZone:[NSTimeZone systemTimeZone]];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    rowCount=7;
    
    selectionArry=[[NSMutableArray alloc] init];
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    // [self setUpIndexs:0];
}
#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{if (arrayForCalendrer.count > 0)
{
    return [arrayForCalendrer count];
}
else
{
    return 0;
}
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CalenderTableViewCell";
    
    CalenderTableViewCell *cell = (CalenderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalenderTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *  dic  = [arrayForCalendrer objectAtIndex:indexPath.row];
    
    NSString * strMyStatus = [dic objectForKey:@"Status"];
    
    cell.lblStatus.text = strMyStatus;
    NSString * str = [dic objectForKey:@"DateOffice2"];
//    NSArray * arrDate = [str componentsSeparatedByString:@"/"];
//    NSString * strDate = [arrDate objectAtIndex:0];
    
    //=================================
    NSString *dateString = str;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MMM dd"];
    NSString *finalDate = [dateFormatter stringFromDate:date];
    NSLog(@"%@", finalDate);
    NSArray * arrDate = [finalDate componentsSeparatedByString:@" "];
    NSString * strDate = [arrDate objectAtIndex:1];
    NSString * strDateMonth = [arrDate objectAtIndex:0];
    
    cell.lblDate.text = strDate;
    cell.lblMonthName.text = strDateMonth;
    
    cell.lblInTime.text = [dic objectForKey:@"InTime"];
    cell.lblOuttime.text = [dic objectForKey:@"OutTime"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return 125 + (15);
 }

#pragma mark CollectionView
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    if (arrayNew2.count > 0)
    {
        return  7;
    }
    else
    {
        return 0;
    }
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (arrayNew2.count > 0)
    {
        return  7;
    }
    else
    {
        return 0;
    }
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BSIslamicCalendarCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
  
    [self configureCellLabels:cell.lblTitle detailLabel:cell.lblDetail atIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item>7 && indexPath.item>=startIndex && datesArry.count>indexPath.item-startIndex) {
        
        NSDate *date=[datesArry objectAtIndex:indexPath.item-startIndex];
        
        if ([self.delegate respondsToSelector:@selector(islamicCalendar:shouldSelectDate:)]) {
            
            if ([self.delegate islamicCalendar:self shouldSelectDate:date]) {
                
                [self updateSelectionForDate:date];
                [self.delegate islamicCalendar:self dateSelected:date withSelectionArray:selectionArry];
            }
            
        }else{
            
            [self updateSelectionForDate:date];
        }
        
    }
    
}



-(void)updateSelectionForDate:(NSDate*)date{
    
    if ([selectionArry containsObject:date]) {
        
        [selectionArry removeObject:date];
    }else{
        [selectionArry addObject:date];
    }
    
    [collectionVew reloadData];
}

-(void)configureCellLabels:(UILabel*)titelLbl detailLabel:(UILabel *)detailLbl atIndexPath:(NSIndexPath*)indexPath{
    
    GridCollectionViewLayout *flowLayout = (GridCollectionViewLayout*)[collectionVew collectionViewLayout];
    
    if (indexPath.section == 0) {
        
         titelLbl.superview.backgroundColor=[UIColor lightGrayColor];
        titelLbl.frame=CGRectMake(4, 0, flowLayout.itemSize.width-8, flowLayout.itemSize.height);
        detailLbl.frame=CGRectMake(0,0,0,0);
        detailLbl.text=@"";
        
        NSString *dayName;
        
        switch (indexPath.item) {
            case 0:
                
                dayName=@"Mon";
                break;
            case 1:
                
                dayName=@"Tue";
                break;
            case 2:
                
                dayName=@"Wed";
                break;
            case 3:
                
                dayName=@"Thu";
                break;
            case 4:
                
                dayName=@"Fri";
                break;
            case 5:
                
                dayName=@"Sat";
                break;
            case 6:
                
                dayName=@"Sun";
                break;
                
            default:
                break;
        }
        
        if (isShortInitials) {
            
            dayName=[dayName substringToIndex:1];
        }
        titelLbl.text=dayName;
        
        if ([self todayDayName:indexPath]) {
            
            titelLbl.textColor= [UIColor whiteColor];//currentDateTextColor;
            detailLbl.textColor=[UIColor whiteColor];//currentDateTextColor;
        }else{
            titelLbl.textColor = [UIColor whiteColor];//daysNameColor;
            detailLbl.textColor=[UIColor whiteColor];//dateTextColor;
        }
        titelLbl.superview.backgroundColor = [UIColor colorWithRed:0 green:0.3719885647 blue:0.697519362 alpha:1];
        
    }else{
        long indexItem  = 0;
        if (indexPath.section == 1)
        {
            indexItem =   indexPath.item+7;
        }
        else if (indexPath.section == 2)
        {
            indexItem =   indexPath.item+14;
        }
        else if (indexPath.section == 3)
        {
            indexItem =   indexPath.item+21;
        }
        else if (indexPath.section == 4)
        {
            indexItem =   indexPath.item+28;
        }
        else if (indexPath.section == 5)
        {
            indexItem =   indexPath.item+35;
        }
        else if (indexPath.section == 6)
        {
            indexItem =   indexPath.item+42;
        }
        if (arrayNew2.count > 0) {
            
            
            titelLbl.frame=CGRectMake(0, 0, flowLayout.itemSize.width-8, flowLayout.itemSize.height*0.5);
            detailLbl.frame=CGRectMake(4, flowLayout.itemSize.height*0.5, flowLayout.itemSize.width-12, flowLayout.itemSize.height*0.5);
            detailLbl.textAlignment = NSTextAlignmentCenter;
            if (indexItem>=startIndex && arrayNew2.count>indexItem-startIndex) {
                
                NSDate *date=[[arrayNew2 objectAtIndex:indexItem-startIndex] valueForKey:@"date"];
                NSLog(@"date====%@",date);
                
                // NSDictionary * dicForCalender = [arrayForCalendrer objectAtIndex:indexItem-startIndex];
                
                
                
                NSString * isPresent = [[arrayNew2 objectAtIndex:indexItem-startIndex] valueForKey:@"isPresent"];
                if ([isPresent isEqualToString:@"1" ]) {
                    NSString * strMyStatus = [[arrayNew2 objectAtIndex:indexItem-startIndex] valueForKey:@"Status"];
                    //                NSArray * arr = [strMyStatus componentsSeparatedByString:@"|"];
                    //                NSLog(@"Array values are : %@",arr);
                    NSString * MyStatus = strMyStatus;
                    NSString * MyColor = [[arrayNew2 objectAtIndex:indexItem-startIndex] valueForKey:@"Color"];
                    
                    UIColor * backGround =  [self colorFromHexString:MyColor];
                    titelLbl.superview.backgroundColor = backGround;
                    detailLbl.text = MyStatus;
                    titelLbl.textColor = UIColor.blackColor;
                    detailLbl.textColor = UIColor.blackColor;
                    
                }
                else
                {   detailLbl.text = @"";
                    titelLbl.superview.backgroundColor =  UIColor.whiteColor;
                    ;
                    titelLbl.textColor = UIColor.blackColor;
                    detailLbl.textColor = UIColor.blackColor;
                }
                
                
                
                titelLbl.text  = [self getGregorianDayFromDate:date];
                //detailLbl.text = [self getIslamicDayFromDate:date];
                
            }else{
                titelLbl.textColor = UIColor.blackColor;
                detailLbl.textColor = UIColor.blackColor;
                titelLbl.superview.backgroundColor =  UIColor.whiteColor;
                
                titelLbl.text=@"";
                detailLbl.text=@"";
            }
        }
        
    }
    
}
// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    
    if ([hexString isEqualToString:@""]){
        return UIColor.clearColor;
        
    }else {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }
    
}
-(void)setUpIndexs:(NSInteger)num{
    
    
    components = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra) fromDate:calForDate];
    [components setDay:1];
    
    [components setMonth:components.month+num];
    
    if (components.month>12) {
        
        [components setMonth:1];
        [components setYear:components.year+1];
        
    }else if (components.month<=0){
        
        [components setMonth:12];
        [components setYear:components.year-1];
        
    }
    
    calForDate=[gregorian dateFromComponents:components];
    
    rangeOfDaysThisMonth = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:calForDate];
    
    datesArry=[[NSMutableArray alloc] init];
    for (NSInteger i = rangeOfDaysThisMonth.location; i < NSMaxRange(rangeOfDaysThisMonth); ++i) {
        [components setDay:i];
        
        NSDate *dayInMonth = [gregorian dateFromComponents:components];
        [datesArry addObject:dayInMonth];
    }
    
    
    if (datesArry.count>0) {
        
        NSDate *firstDate=[datesArry objectAtIndex:0];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        
        NSDateFormatter *dateFormatterService=[[NSDateFormatter alloc] init];
        
        if (isIslamicMonth) {
            
            NSCalendar *islamicCalander = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            [dateFormatter setCalendar:islamicCalander];
            [dateFormatter setDateFormat:@"MMM-YYYY"];
            
            
            [dateFormatterService setCalendar:islamicCalander];
            [dateFormatterService setDateFormat:@"YYYY-MM-dd"];
        }else{
            
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:@"MMMM"];
            
            [dateFormatterService setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatterService setDateFormat:@"YYYY-MM-dd"];
        }
        
        lblMonth.text = [[dateFormatter stringFromDate:firstDate] uppercaseString];
        strDate = [[dateFormatterService stringFromDate:firstDate] uppercaseString];
        NSLog(@"strDate======%@",strDate);
        
        
        NSDateFormatter *dateFormatterCurrent = [[NSDateFormatter alloc] init];
        [dateFormatterCurrent setDateFormat:@"MMM-YYYY"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatterCurrent stringFromDate:[NSDate date]]);
        
        
        if ([dateFormatterCurrent stringFromDate:[NSDate date]] == [dateFormatter stringFromDate:firstDate])  {
            btnNext.hidden = YES;
        }else {
            btnNext.hidden = NO;
        }
        
        
        components  = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitWeekday) fromDate:firstDate];
        startIndex = (((components.weekday + 5) % 7) + 1)+6;
        
    }
    
    float tempCount=(startIndex+datesArry.count)/7.0;
    rowCount=ceil(tempCount);
    [self getCalenderDetailsWebService];
    //[collectionVew reloadData];
    count = 0;
    
}


-(BOOL)compareDate:(NSDate*)date1 withDate:(NSDate*)date2
{
    
    NSDateComponents *comp1 = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date1];
    
    NSDateComponents *comp2 = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date2];
    
    if (comp1.day==comp2.day && comp1.month==comp2.month && comp1.year==comp2.year) {
        
        return YES;
    }else{
        return false;
    }
    
}

-(NSString*)getGregorianDayFromDate:(NSDate*)date{
    
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitDay) fromDate:date];
    
    NSString *retStr=[NSString stringWithFormat:@"%li",(long)comp.day];
    return retStr;
}
-(NSString*)getIslamicDayFromDate:(NSDate*)date {
    
    NSCalendar *islamicCalander = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIndian];
    NSDateComponents *comp = [islamicCalander components:(NSCalendarUnitDay) fromDate:date];
    
    NSString *retStr=[NSString stringWithFormat:@"%li",(long)comp.day];
    
    if (isArabicLocale) {
        
        NSDecimalNumber *someNumber = [NSDecimalNumber decimalNumberWithString:retStr];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSLocale *gbLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"];
        [formatter setLocale:gbLocale];
        retStr = [formatter stringFromNumber:someNumber];
    }
    
    return retStr;
}
-(BOOL)todayDayName:(NSIndexPath *)indexPath{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E"];
    [dateFormatter setTimeZone: [NSTimeZone systemTimeZone]];
    NSString *currDayName = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([currDayName isEqualToString:@"Mon"] && indexPath.section==0) {
        
        return YES;
    }else if ([currDayName isEqualToString:@"Tue"] && indexPath.section==1) {
        
        return YES;
    }else if ([currDayName isEqualToString:@"Wed"] && indexPath.section==2) {
        
        return YES;
    }else if ([currDayName isEqualToString:@"Thu"] && indexPath.section==3) {
        
        return YES;
    }else if ([currDayName isEqualToString:@"Fri"] && indexPath.section==4) {
        
        return YES;
    }else if ([currDayName isEqualToString:@"Sat"] && indexPath.section==5) {
        
        return YES;
    }else if ([currDayName isEqualToString:@"Sun"] && indexPath.section==6) {
        
        return YES;
    }else{
        return NO;
    }
}

-(void)previousBtnPressed:(UIButton*)btn{
    
    [selectionArry removeAllObjects];
    [self setUpIndexs:-1];
    //[self getCalenderDetailsWebService];
}
-(void)nextBtnPressed:(UIButton*)btn{
    
    [selectionArry removeAllObjects];
    [self setUpIndexs:+1];
    //[self getCalenderDetailsWebService];
}

-(void)gridBtnPressed:(UIButton*)btn{
    
    if (isGrid == true)
    {
        UIImage *ListImage = [UIImage imageNamed:@"list"];
        [btnGrid setImage:ListImage forState:UIControlStateNormal];
        
        if (arrayNew2.count>0) {
            isGrid = false;
            [tableView setHidden:YES];
            [collectionVew setHidden:NO];
            [collectionVew reloadData];
            [ViewForTableHeader setHidden:YES];
        }
    }
    else
    {
        UIImage *gridImage = [UIImage imageNamed:@"grid"];
        [btnGrid setImage:gridImage forState:UIControlStateNormal];
        if (arrayForCalendrer.count >0) {
            
            isGrid = true;
            [tableView setHidden:NO];
            [collectionVew setHidden:YES];
            [tableView reloadData];
            [ViewForTableHeader setHidden:NO];
            
        }
    }
    
    
    
}

#pragma mark - Set properties
-(void)setShortInitials:(BOOL)isShort{
    
    isShortInitials=isShort;
    [collectionVew reloadData];
}
-(void)setShowIslamicMonth:(BOOL)isIslamic{
    
    isIslamicMonth=isIslamic;
    [self setUpIndexs:0];
}
-(void)setIslamicDatesInArabicLocale:(BOOL)isArabic;{
    
    isArabicLocale=isArabic;
    [collectionVew reloadData];
}

#pragma mark - Set Colors
-(void)setDateTextColor:(UIColor*)color{
    
    dateTextColor=color;
    [collectionVew reloadData];
}
-(void)setDateBGColor:(UIColor*)color{
    
    dateBGColor=color;
    [collectionVew reloadData];
}
-(void)setDaysNameColor:(UIColor*)color{
    
    daysNameColor=color;
    [collectionVew reloadData];
}
-(void)setSelectedDateBGColor:(UIColor*)color{
    
    selectedDateBGColor=color;
    [collectionVew reloadData];
}
-(void)setCurrentDateTextColor:(UIColor*)color{
    
    currentDateTextColor=color;
    [collectionVew reloadData];
}

-(NSArray*)getSelectedDates{
    
    return selectionArry;
}
#pragma mark - Service Call Method


-(void)getCalenderDetailsWebService
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userId = [prefs stringForKey:@"UserID"];
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL * url = [NSURL URLWithString:[ NSString stringWithFormat:@"https://connect.trivitron.com/MobileAPI/AppServices.svc/GetMyAttendance"]];;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [standardUserDefaults objectForKey:@"TokenNo"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:token,@"TokenNo",userId,@"UserId",strDate,@"Date",
                             nil];
    
    NSLog(@"mapData====== %@",mapData);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          
                                          {
        
        if(error == nil)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&error];
            NSLog(@"json = %@",json);
            
            
            
            self->arrayForCalendrer = [[NSMutableArray alloc] init];
            self->arrayNew2  = [[NSMutableArray alloc] init];
            NSMutableArray * arrayNew = [[NSMutableArray alloc] init];
            if ([json objectForKey:@"objMyAttendanceRes"] == (id)[NSNull null]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->collectionVew setHidden:YES];
                    [self->tableView setHidden:YES];
                    [self->lblNoDateFound setHidden:NO];
                    
                });
            }
            else
            {
                if (self->isGrid == true) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->collectionVew setHidden:YES];
                        [self->tableView setHidden:NO];
                        [self->lblNoDateFound setHidden:YES];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->collectionVew setHidden:NO];
                        [self->tableView setHidden:YES];
                        [self->lblNoDateFound setHidden:YES];
                    });
                }
                
                self->arrayForCalendrer = [json objectForKey:@"objMyAttendanceRes"];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"MyAttendanceAbbreviationRes"] forKey:@"abbrevation"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (self->arrayForCalendrer.count > 0)
                {
                    
                    for (int j= 0; j<self->arrayForCalendrer.count; j++) {
                        NSDictionary * dicForCalender = [self->arrayForCalendrer objectAtIndex:j];
                        NSString * str = [dicForCalender objectForKey:@"DateOffice2"];
                        NSArray * arrDate = [str componentsSeparatedByString:@"/"];
                        NSString * strDate2 = [arrDate objectAtIndex:0];
                        NSInteger b = [strDate2 integerValue];
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
                        
                        [dict setObject:[NSNumber numberWithInteger:b] forKey:@"date"];
                        [dict setObject:[dicForCalender objectForKey:@"Status"] forKey:@"Status"];
                        [dict setObject:[dicForCalender objectForKey:@"Color"] forKey:@"Color"];
                        
                        
                        [arrayNew addObject:dict];
                        
                    }
                    
                    NSLog(@"arrayNew  = %@",arrayNew);
                    for (int i =0; i<self->datesArry.count; i++) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
                        
                        [dict setObject:[self->datesArry objectAtIndex:i] forKey:@"calDate"];
                        
                        NSDate *date=[self->datesArry objectAtIndex:i];
                        NSString * dateStr = [self getGregorianDayFromDate:date];
                        NSInteger dateInt =   [dateStr integerValue];
                        
                        NSArray *filteredData = [arrayNew filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(date == %d)", dateInt]];
                        
                        NSLog(@"filteredData  = %@",filteredData);
                        
                        [dict setObject:[self->datesArry objectAtIndex:i] forKey:@"date"];
                        
                        if (filteredData.count)
                        {
                            NSLog(@"Item found = %@",[NSNumber numberWithInteger:dateInt]);
                            
                            NSDictionary * d = [filteredData objectAtIndex:0];
                            
                            [dict setObject:@"1" forKey:@"isPresent"];
                            [dict setObject:[d objectForKey:@"Status"] forKey:@"Status"];
                            [dict setObject:[d objectForKey:@"Color"] forKey:@"Color"];
                            
                            // [dict setObject:@"0" forKey:@"Status"];
                            
                        }
                        else
                        {
                            [dict setObject:@"0" forKey:@"isPresent"];
                            [dict setObject:@"NA" forKey:@"Status"];
                            [dict setObject:@"" forKey:@"Color"];
                            
                        }
                        
                        [self->arrayNew2 addObject:dict];
                        
                    }
                    
                    NSLog(@"arrayNew2  = %@",self->arrayNew2);
                    
                    /*
                     for (int i =0; i< arrayForCalendrer.count; i++)
                     {
                     NSDictionary * dicForCalender = [arrayForCalendrer objectAtIndex:i];
                     NSString * str = [dicForCalender objectForKey:@"Date2"];
                     NSArray * arrDate = [str componentsSeparatedByString:@"/"];
                     NSString * strDate2 = [arrDate objectAtIndex:1];
                     NSInteger b = [strDate2 integerValue];
                     for (int j = 0; j<31; j++) {
                     
                     if (b != j) {
                     
                     NSLog(@"b======%ld",(long)b);
                     [arrayNew insertObject:dict atIndex:j];
                     }
                     else{
                     NSLog(@"i======%d",i);
                     [arrayNew insertObject:dicForCalender atIndex:j];
                     }
                     
                     }
                     }
                     */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->collectionVew reloadData];
                        [self->tableView reloadData];
                        
                    });
                }
                NSLog(@"arrayForCalendrer = %@",self->arrayForCalendrer);
                //NSLog(@"arrayNew = %@",arrayNew);
                //NSLog(@"arrayNewCount = %lu",(unsigned long)arrayNew.count);
            }
            
            
            
            
        }
        
    }];
    
    [postDataTask resume];
}



@end
