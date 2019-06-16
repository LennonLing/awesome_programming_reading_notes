//
//  YDDetailViewController.m
//  CalloutAction
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDDetailViewController.h"

@interface YDDetailViewController ()
- (IBAction)closeViewController:(UIButton *)sender;

@end

@implementation YDDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.annotation.title;
    self.addressLabel.text=self.annotation.address;
    self.latLabel.text=[NSString stringWithFormat:@"latitude: %0.6f",self.annotation.latitude];
    self.lonLabel.text=[NSString stringWithFormat:@"longitude: %0.6f",self.annotation.longitude];
    if ([self.annotation.category isEqualToString:@"pizza"])
        {
        self.categoryImage.image=[UIImage imageNamed:@"pizza.png"];
        }
    else
        {
        self.categoryImage.image=[UIImage imageNamed:@"fastfood.png"];
        }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeViewController:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
