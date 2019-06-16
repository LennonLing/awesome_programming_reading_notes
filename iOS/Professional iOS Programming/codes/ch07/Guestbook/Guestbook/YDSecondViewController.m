//
//  YDSecondViewController.m
//  Guestbook
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDSecondViewController.h"
#import "URLRequest.h"
@interface YDSecondViewController ()
-(IBAction)postMessage:(id)sender;
@end

@implementation YDSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Write", @"Write");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(IBAction)postMessage:(id)sender
{
    [self.nameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.messageField resignFirstResponder];
    if (([self.nameField.text length]==0) || ([self.emailField.text length]==0) || ([self.messageField.text length]==0))
        {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"fill all fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        }
    else{
            //fields are filled so make a post
        NSString *urlToPost = @"http://developer.yourdeveloper.net/api/Guestbook";
            //create a NSDictionary with the fields you need to pass
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        [jsonDict setObject:self.nameField.text forKey:@"name"];
        [jsonDict setObject:self.emailField.text forKey:@"email"];
        [jsonDict setObject:self.messageField.text forKey:@"message"];
        //serialize it as a JSON string
        NSError *error;
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:jsonDict
                            options:NSJSONWritingPrettyPrinted
                            error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        
        NSURL *myURL = [NSURL URLWithString:urlToPost];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:60];
            //http
        [request setHTTPMethod:@"POST"];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonString length]];
        [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        URLRequest *urlRequest = [[URLRequest alloc] initWithRequest:request];
        [urlRequest startWithCompletion:^(URLRequest *request, NSData *data, BOOL success) {
            if (success)
                {
              //  NSError* error=nil;
              //  NSString *responseString = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions  error:&error];

                }
            else
                {
               //  NSString *responseString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                }
        self.nameField.text=@"";
        self.emailField.text=@"";
        self.messageField.text=@"";
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thanks" message:@"for writing in our guestbook" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
        }];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
