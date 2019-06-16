//
//  YDViewController.m
//  MyTwitter
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
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *addEventButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                           UIBarButtonSystemItemAdd target:self action:@selector(newTweet:)];
	self.navigationItem.rightBarButtonItem = addEventButtonItem;
}
 

- (void)newTweet:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        //Start by setting up a completion handler
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                //dismiss the view controller
            [self.composeVC dismissViewControllerAnimated:YES completion:nil];
            switch(result){
                case SLComposeViewControllerResultCancelled:
                {
                    //Cancel action
                
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                 
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                                    message:@"Your message have been posted to Twitter."
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                }
                    break;
            }};
        
        // Initialize Compose View Controller
        self.composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        // Configure the compose View Controller
        [self.composeVC setInitialText:@"A plane just flew over my head."];
        UIImage* imageToPost = [UIImage imageNamed:@"plane.jpg"];
        [self.composeVC addImage:imageToPost];
        [self.composeVC addURL:[NSURL URLWithString:@"http://www.yourdeveloper.net/"]];
        [self.composeVC setCompletionHandler:completionHandler];
         
        [self.navigationController presentViewController:self.composeVC animated:YES completion:nil];
      
    } else {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Can't connect to your Twitter account"
                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
