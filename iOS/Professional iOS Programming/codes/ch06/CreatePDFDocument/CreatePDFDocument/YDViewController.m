//
//  YDViewController.m
//  CreatePDFDocument
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
#import "YDCar.h"
#import <QuickLook/QuickLook.h>


@interface YDViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,QLPreviewItem>
{
    CGSize PDFpageSize;
    QLPreviewController* previewController;
}
@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //load cars in array
    [self loadCars];
    previewController = [[QLPreviewController alloc] init];
    previewController.dataSource=self;
    previewController.delegate=self;
 }
-(void)loadCars
{
    self.cars= [[NSMutableArray alloc] initWithObjects:
           [[YDCar alloc] initWithMake:@"Ford" model:@"Shelby GT500" imageName:@"shelbygt500.jpg"],
           [[YDCar alloc] initWithMake:@"Ford" model:@"2013 F-150" imageName:@"2013f150.jpg"],
           [[YDCar alloc] initWithMake:@"Ford" model:@"2013 Super Duty" imageName:@"2013superduty.jpg"],
           [[YDCar alloc] initWithMake:@"Chevrolet" model:@"2013 Suburban 3/4 ton" imageName:@"suburban.png"],
           [[YDCar alloc] initWithMake:@"Chevrolet" model:@"2012 Colorado" imageName:@"colorado.jpg"],
           nil];
    
}
- (IBAction)showDocument:(UIButton *)sender
{
     [self presentViewController:previewController animated:YES completion:nil];
}

- (IBAction)createPDFDocument:(UIButton *)sender
{
    [self setupPDFDocument:850 height:2300];
    //Create a new Page
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, PDFpageSize.width, PDFpageSize.height), nil);
    
    
      [self addText:@"My favorite cars!"
          withFrame:CGRectMake(20, 20, 400, 200) fontSize:48.0f];
    int y=200;
    for(int i=0;i<[self.cars count];i++)
        {
        YDCar* thisCar = [self.cars objectAtIndex:i];
        [self addText:[NSString stringWithFormat:@"%@ %@",thisCar.make,thisCar.model] withFrame:CGRectMake(20, y, 400, 50) fontSize:48.0f];
        y+=50;
        UIImage *anImage = [UIImage imageNamed:thisCar.imageName];
        [self addImage:anImage
            atPoint:CGPointMake((PDFpageSize.width/2)-(anImage.size.width/2), y )];

        y+=anImage.size.height + 50.0f;
        }
    //finish the PDF Contents
    UIGraphicsEndPDFContext();
    //Set the image to thumbnail of page 1
    [self.previewButton setImage:[self createThumbnailforPage:1] forState:UIControlStateNormal];
}
-(NSString *)pdfFileName
{
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", @"cars"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    return pdfPath;
}

- (void)setupPDFDocument:(float)width height:(float)height{
    PDFpageSize = CGSizeMake(width, height);
    UIGraphicsBeginPDFContextToFile([self pdfFileName], CGRectZero, nil);
}

    //Helper function to add text to the Context
- (void)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize {
    // UIFont *font = [UIFont systemFontOfSize:fontSize];
	CGSize stringSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(PDFpageSize.width - 2*20-2*20, PDFpageSize.height - 2*20 - 2*20) lineBreakMode:NSLineBreakByWordWrapping];
	float textWidth = frame.size.width;
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > PDFpageSize.width)
        textWidth = PDFpageSize.width - frame.origin.x;
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    [text drawInRect:renderingRect
            withFont:[UIFont systemFontOfSize:fontSize]
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentLeft];
}

//helper to addImage
- (void)addImage:(UIImage*)image atPoint:(CGPoint)point {
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [image drawInRect:imageFrame];
}
-(UIImage*)createThumbnailforPage:(int)pageno
{
    NSURL* pdfFileUrl = [NSURL fileURLWithPath:[self pdfFileName]];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfFileUrl);
    
    CGRect aRect = CGRectMake(0, 0, 70, 100); // thumbnail size
    UIGraphicsBeginImageContext(aRect.size);
        // UIImage* thumbnailImage;
    
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, aRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -(aRect.origin.x), -(aRect.origin.y));
    
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextFillRect(context, aRect);
    
    //Grab the first PDF page
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, pageno);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, aRect, 0, false);
    // And apply the transform.
    CGContextConcatCTM(context, pdfTransform);
    CGContextDrawPDFPage(context, page);
    
    // Create the new UIImage from the context
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    CGPDFDocumentRelease(pdf);
    return thumbnail;
}


#pragma mark delegates
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:[self pdfFileName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
