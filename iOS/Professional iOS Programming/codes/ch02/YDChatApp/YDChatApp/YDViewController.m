//
//  YDViewController.m
//  YDChatApp
//
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //
#import "YDChatUser.h"

#import "YDViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "YDChatData.h"
#import "YDChatUser.h"
#define lineHeight  16.0f
@interface YDViewController ()<UITextViewDelegate,YDChatTableViewDataSource>
{

    UIView *textInputView;
    UITextField *textField;
    NSMutableArray *Chats;
    
    UIView* sendView;
    UIButton* sendButton;
    UITextView* msgText;
    BOOL composing;
    float prevLines;
    YDChatUser* me ;
    YDChatUser* you ;
}
@property (strong, nonatomic)  YDChatTableView *chatTable;
@end

@implementation YDViewController

CGRect  appFrame;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    appFrame= [[UIScreen mainScreen] bounds];

      self.chatTable=[[YDChatTableView alloc] initWithFrame:CGRectMake(0,40,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height -40)  style:UITableViewStylePlain];
      [self.view addSubview:self.chatTable];
    //Create a UIView that will hold a UITextView and a UIButton to accept user input and a send button
    sendView = [[UIView alloc] initWithFrame:CGRectMake(0,502,320,56)];
    sendView.backgroundColor=[UIColor blueColor];
    sendView.alpha=0.9;
    
    msgText = [[UITextView alloc] initWithFrame:CGRectMake(7,10,225,36)];
    msgText.backgroundColor = [UIColor whiteColor];
    msgText.textColor=[UIColor blackColor];
    msgText.font=[UIFont boldSystemFontOfSize:12];
    msgText.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    msgText.layer.cornerRadius = 10.0f;
    msgText.returnKeyType=UIReturnKeySend;
    msgText.showsHorizontalScrollIndicator=NO;
    msgText.showsVerticalScrollIndicator=NO;
        //Set the delegate so you can respond to user input
    msgText.delegate=self;
    [sendView addSubview:msgText];
    msgText.contentInset = UIEdgeInsetsMake(0,0,0,0);
    [self.view addSubview:sendView];
    
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(235,10,77,36)];
    sendButton.backgroundColor=[UIColor lightGrayColor];
    [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    sendButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    sendButton.layer.cornerRadius=6.0f;
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendView addSubview:sendButton];
    //create two YDChatUser object one representing me and one representing the other party
    
    me = [[YDChatUser alloc] initWithUsername:@"Peter" avatarImage:[UIImage imageNamed:@"me.png"]];
    you  =[[YDChatUser alloc] initWithUsername:@"You" avatarImage:[UIImage imageNamed:@"noavatar.png"]];
        //Create some YDChatData objects here
    YDChatData *first = [YDChatData dataWithText:@"Hey, how are you doing? I'm in Paris take a look at this picture." date:[NSDate dateWithTimeIntervalSinceNow:-600] type:ChatTypeMine andUser:me];
    YDChatData *second = [YDChatData dataWithImage:[UIImage imageNamed:@"eiffeltower.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:ChatTypeMine andUser:me];
    YDChatData *third = [YDChatData dataWithText:@"Wow.. Really cool picture out there. Wish I could be with you" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:ChatTypeSomeone andUser:you];
    YDChatData *forth = [YDChatData dataWithText:@"Maybe next time you can come with me." date:[NSDate dateWithTimeIntervalSinceNow:+0] type:ChatTypeMine andUser:me];
        //Initialize the Chats array with the created YDChatData objects
        Chats = [[NSMutableArray alloc] initWithObjects:first, second, third,forth, nil];
    
        //set the chatDataSource
    self.chatTable.chatDataSource = self;

        //call the reloadData, this is actually calling your override method
    [self.chatTable reloadData];
}

-(void)sendMessage
{
    composing=NO;
    YDChatData *thisChat = [YDChatData dataWithText:msgText.text date:[NSDate date] type:ChatTypeMine andUser:me];
    [Chats addObject:thisChat];
    [self.chatTable reloadData];
    [self showTableView];
    [msgText resignFirstResponder];
    msgText.text=@"";
    sendView.frame=CGRectMake(0,appFrame.size.height-56,320,56);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.chatTable scrollToRowAtIndexPath:indexPath
                     atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
}
#pragma mark UITextViewDelegate
    //if user presses enter consider as end of message and send it
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
    }
    return YES;
}
    // this function returns the height of the entered text in the msgText field
-(CGFloat )textY
{
    UIFont* systemFont = [UIFont boldSystemFontOfSize:12];
     int width = 225.0, height = 10000.0;
     NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
     [atts setObject:systemFont forKey:NSFontAttributeName];
     
     CGRect size = [msgText.text boundingRectWithSize:CGSizeMake(width, height)
     options:NSStringDrawingUsesLineFragmentOrigin
     attributes:atts
     context:nil];
       float textHeight = size.size.height;
    
    float lines = textHeight / lineHeight;
    if (lines >=4)
        lines=4;
    if ([msgText.text length]==0)
        lines=0.9375f;
    return 190 - (lines * lineHeight) + lineHeight;
}
    //if msgText changed calculate height and reposition the frame above the keyboard
-(void)textViewDidChange:(UITextView *)textView
{

    UIFont* systemFont = [UIFont boldSystemFontOfSize:12];
    int width = 225.0, height = 10000.0;
    NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
    [atts setObject:systemFont forKey:NSFontAttributeName];
    
    CGRect size = [msgText.text boundingRectWithSize:CGSizeMake(width, height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:atts
                                             context:nil];
    float textHeight = size.size.height;
    float lines = textHeight / lineHeight;
    if (lines >=4)
        lines=4;
    
    composing=YES;
    msgText.contentInset = UIEdgeInsetsMake(0,0,0,0);
    sendView.frame = CGRectMake(0,appFrame.size.height-270 - (lines * lineHeight) + lineHeight ,320,56 + (lines * lineHeight)-lineHeight);
    
    if (prevLines!=lines)
        [self shortenTableView];
    
    prevLines=lines;
}
    //let's change the frame of the chatTable so we can see the bottom
-(void)shortenTableView
{   [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.1];
    self.chatTable.frame=CGRectMake(0, 0, 320, [self textY] );
    [UIView commitAnimations];
    prevLines=1;
    
}
    // show the chatTable as it wass
-(void)showTableView
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.1];
    self.chatTable.frame=CGRectMake(0,0,320,548 - 56);
    [UIView commitAnimations];
}
    //when user starts typing change the frame position and shorten the chatTable
-(void)textViewDidBeginEditing:(UITextView *)textView
{ [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.3];
    sendView.frame = CGRectMake(0,548-270,320,56);
    [UIView commitAnimations];
    [self shortenTableView];
    [msgText becomeFirstResponder];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - YDChatTableView implementation
//here are the required implementation from your YDChatTableViewDataSource

- (NSInteger)rowsForChatTable:(YDChatTableView *)tableView
{
    return [Chats count];
}

- (YDChatData *)chatTableView:(YDChatTableView *)tableView dataForRow:(NSInteger)row
{
    return [Chats objectAtIndex:row];
}

@end