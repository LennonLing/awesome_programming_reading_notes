//
//  YDViewController.m
//  emailler
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
#import <MessageUI/MessageUI.h>
@interface YDViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEmail:(UIButton *)sender {
    [self.subjectField resignFirstResponder];
    if ([MFMailComposeViewController canSendMail])
        {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:self.subjectField.text];
      
        NSArray *toRecipients = [NSArray arrayWithObjects:@"email@domain.com", nil];
        [mailer setToRecipients:toRecipients];
        [mailer setMessageBody:@"" isHTML:YES];
        //sample add some image
        UIImage* imgToAttach = [UIImage imageNamed:@"banner-ios.png"];
        NSData *data = UIImageJPEGRepresentation(imgToAttach, 1.0);
        [mailer addAttachmentData:data mimeType:@"image/png" fileName:@"banner-ios.png"];
        [self presentViewController:mailer animated:YES completion:nil];
        }
    else
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Your device doesn't support sending email."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //Mail cancelled: you cancelled the operation and no email message was queued. 
        break;
        case MFMailComposeResultSaved:
            //Mail saved: you saved the email message in the drafts folder.
        break;
        case MFMailComposeResultSent:
        {
            //Mail send: the email message is queued in the outbox. It is ready to send. ;
             
        }
        break;
        case MFMailComposeResultFailed:
            //Mail failed: the email message was not saved or queued, possibly due to an error.
        break;
        default:
           
        break;
    }
        // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
