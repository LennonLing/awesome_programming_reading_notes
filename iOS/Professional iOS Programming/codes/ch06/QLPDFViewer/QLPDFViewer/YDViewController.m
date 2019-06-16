//
//  YDViewController.m
//  QLPDFViewer
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
#import <QuickLook/QuickLook.h>
@interface YDViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,QLPreviewItem>
{
    QLPreviewController* previewController;

}

@end

@implementation YDViewController
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.documents=[[NSArray alloc] initWithObjects:@"MobileHIG.pdf", nil];
    //initialize the QLPreviewController
    previewController = [[QLPreviewController alloc] init];
    previewController.dataSource=self;
    previewController.delegate=self;
    [self performSelector:@selector(showDocument) withObject:nil afterDelay:3];
}
-(void)showDocument
{
        [self presentViewController:previewController animated:YES completion:nil];
    
}
#pragma mark delegates
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return [self.documents count];
}
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[self.documents objectAtIndex:index] ofType:nil]];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
