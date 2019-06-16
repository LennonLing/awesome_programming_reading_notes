//
//  YDPersonViewController.m
//  CoreDemo
//
//  Created by Peter van de Put on 29/03/13.
//  Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#import "YDPersonViewController.h"
#import "YDAppDelegate.h"
@interface YDPersonViewController ()

@end

@implementation YDPersonViewController
- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
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
     self.title = @"Person";
    if (_thisPerson)
        {
        self.firstnameField.text = self.thisPerson.firstname;
        self.lastnameField.text = self.thisPerson.lastname;
        [self.isVip setOn:[self.thisPerson.vip boolValue]];
        }
}
-(IBAction)saveRecord:(id)sender
{
    if (_thisPerson)
        {
            //update the NSMAnagedObject
        self.thisPerson.firstname=_firstnameField.text;
        self.thisPerson.lastname=_lastnameField.text;
        self.thisPerson.vip = [NSNumber numberWithBool:_isVip.isOn];
        NSError *error = nil;
        if (![[self  appDelegate].managedObjectContext save:&error]) {
                //handle your error
        }
        }
    else
        {
        //Create
        
          
        Person*  newPerson =[NSEntityDescription
                                           insertNewObjectForEntityForName:@"Person"
                                           inManagedObjectContext:[self  appDelegate].managedObjectContext];
        newPerson.firstname=_firstnameField.text;
        newPerson.lastname=_lastnameField.text;
        newPerson.vip = [NSNumber numberWithBool:_isVip.isOn];
         NSError *error = nil;
        if (![[self  appDelegate].managedObjectContext save:&error]) {
                //handle your error
        }
        
        }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
