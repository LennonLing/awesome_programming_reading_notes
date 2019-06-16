//
//  YDPersonViewController.h
//  CoreDemo
//
//  Created by Peter van de Put on 29/03/13.
//  Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface YDPersonViewController : UIViewController


@property(nonatomic,strong)Person* thisPerson;
@property(nonatomic,strong)IBOutlet UITextField* firstnameField;
@property(nonatomic,strong)IBOutlet UITextField* lastnameField;
@property(nonatomic,strong)IBOutlet UISwitch* isVip;
-(IBAction)saveRecord:(id)sender;
@end
