//
//  YDViewController.h
//  FotoDownloader
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import <UIKit/UIKit.h>

@interface YDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *receivedImage;
//properties you need for the download process
@property (nonatomic, retain, readwrite) NSOutputStream* fileStream;
@property (nonatomic, assign, readonly)  BOOL isReceiving;
@property (nonatomic, retain, readwrite) NSURLConnection* connection;
@property (nonatomic, copy,   readwrite) NSString*  filePath;

@end
