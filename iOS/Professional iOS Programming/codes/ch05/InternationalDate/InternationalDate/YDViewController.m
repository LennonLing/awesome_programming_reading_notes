//
//  YDViewController.m
//  InternationalDate
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDViewController.h"

@interface YDViewController ()

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel* currentlbl = [[UILabel alloc] initWithFrame:CGRectMake(10,100,300,20)];
    currentlbl.textColor=[UIColor blackColor];
    currentlbl.backgroundColor=[UIColor clearColor];
    [self.view addSubview:currentlbl];
        //Create an instance variable from the currentLocale
    NSLocale *currentLocale = [NSLocale currentLocale];
    currentlbl.text = [NSString stringWithFormat:@"Current localeidentifier: %@",currentLocale.localeIdentifier];
    
        //create a UILabel to display a date for NSLocale current
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,140,300,20)];
    dateLabel.textColor=[UIColor blackColor];
    dateLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:dateLabel];
    
        //Create a default Calendar
        NSCalendar *defaultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
        //create an instance variable and initialize it with a date
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:162000];
        //create a NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //set the defaultCalendar to the formatter
       [formatter setCalendar:defaultCalendar];
        //set the current locale
    [formatter setLocale:currentLocale];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    dateLabel.text=[NSString stringWithFormat:@"Date for locale: %@",[formatter stringFromDate:date]];
    
        //create a UILabel to display a date for NSLocale current
    
    UILabel* frenchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,170,300,20)];
    frenchLabel.textColor=[UIColor blackColor];
    frenchLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:frenchLabel];
        //create an NSLocale variable and initialize it with a LocaleIdentifier
    NSLocale *frenchLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr"];
    [formatter setLocale:frenchLocale];
    frenchLabel.text=[NSString stringWithFormat:@"Date for French: %@",[formatter stringFromDate:date]];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
