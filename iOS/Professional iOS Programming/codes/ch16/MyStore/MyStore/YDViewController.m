//
//  YDViewController.m
//  MyStore
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
 #import "GADBannerView.h"
@interface YDViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    GADBannerView* bannerView;
}
@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	/*
    self.surrogateAdvertisementView=[[UIView alloc] initWithFrame:
                                CGRectMake(0,0,320,50)];
    self.surrogateAdvertisementView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.surrogateAdvertisementView];
     */
    [self initializeInAppPurchaseManager];
    [self displayAdvertisement];
}

-(void)displayAdvertisement
{
    if (![[YDInAppPurchaseManager sharedInstance] productPurchased:@"net.yourdeveloper.MyStore.upgrade"])
        {
        // Create the GADBannerview
        bannerView = [[GADBannerView alloc]
                      initWithFrame:CGRectMake(0,0,GAD_SIZE_320x50.width,GAD_SIZE_320x50.height)];
        // Specify your AdMob Publisher ID.
        bannerView.adUnitID = @"a14f0070e2b8015";
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView.rootViewController = self;
        [self.view addSubview:bannerView];
        
        GADRequest *request = [GADRequest request];
        request.testing=YES; // or NO
        // Initiate a generic request to load it with an ad.
        [bannerView loadRequest:[GADRequest request]];
        }
    else
        {
        self.mTableView.frame = [[UIScreen mainScreen] bounds];

        }
}
-(void)initializeInAppPurchaseManager
{
     if ([[YDInAppPurchaseManager sharedInstance] canMakePurchases])
    {
        //add notification called when products have been fetched
        [[NSNotificationCenter defaultCenter] addObserver:self
                selector:@selector(productListReceived:)
                name:kYDInAppPurchaseManagerProductsFetchedNotification object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                selector:@selector(productPurchaseSucceeded:)
                name:kYDInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productPurchaseFailed:)
                                                 name:kYDInAppPurchaseManagerTransactionFailedNotification object:nil];
    
       [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deliverProduct:)
                                                 name:kYDInAppPurchaseManagerDeliverProduct object:nil];
    
        NSURL* url = [NSURL URLWithString:@"http://developer.yourdeveloper.net/products.json"];
        [[YDInAppPurchaseManager sharedInstance] retrieveProductListFromURL:url applicationName:@"MyStore"];
    
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                            message:@"you can't make purchases" delegate:self
                            cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
        
}

#pragma mark Notifications
//called when the product list has been received and is available in the productList property
- (void)productListReceived:(NSNotification *)notification
{
    [self.mTableView reloadData];
}


#pragma mark UITableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *) table numberOfRowsInSection: (NSInteger)section
{
	return [[[YDInAppPurchaseManager sharedInstance] availableProducts] count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyCellIdentifier"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SKProduct* product = [[[YDInAppPurchaseManager sharedInstance] availableProducts] objectAtIndex:indexPath.row];
    cell.textLabel.text =  product.localizedTitle ;
    // Create an NSNumberFormatter
    NSNumberFormatter* priceFormatter;

    priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [priceFormatter setLocale:product.priceLocale];
    
    cell.detailTextLabel.text = [priceFormatter stringFromNumber:product.price];
    
    if ([[YDInAppPurchaseManager sharedInstance] productPurchased:product.productIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else {
        UIButton* buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 72, 37);
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;
    }
    
    
    
	return cell;
}

- (void)buyButtonTapped:(id)sender
{    
    UIButton* buyButton = (UIButton *)sender;
    SKProduct* product = [[[YDInAppPurchaseManager sharedInstance] availableProducts] objectAtIndex:buyButton.tag];
    [[YDInAppPurchaseManager sharedInstance] purchaseProduct:product];
}


- (void)productPurchaseSucceeded:(NSNotification *)notification
{
    [self.mTableView reloadData];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *)[notification.userInfo objectForKey:@"transaction"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thanks!"
                                                   message:@"for your purchase."
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil];
    
    [alert show];
    //Test if it's our upgrade product
    if ([ transaction.payment.productIdentifier isEqualToString:@"net.yourdeveloper.MyStore.upgrade"])
         {
         [self upgradeToProVersion];
         }
}

- (void)productPurchaseFailed:(NSNotification *)notification
{
    SKPaymentTransaction * transaction = (SKPaymentTransaction *)[notification.userInfo objectForKey:@"transaction"];
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:transaction.error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
}

- (void)deliverProduct:(NSNotification *)notification
{
    SKPaymentTransaction * transaction = (SKPaymentTransaction *)[notification.userInfo objectForKey:@"transaction"];
    //Test if it's our upgrade product
    if ([ transaction.payment.productIdentifier isEqualToString:@"net.yourdeveloper.MyStore.upgrade"])
        {
        [self upgradeToProVersion];
        }
    else
        {
            //Deliver the product e.g. opening a level in a game or download a PDF
        }
}
-(void)upgradeToProVersion
{
    //remove the surrogateView from the superview
        //[self.surrogateAdvertisementView removeFromSuperview];
    [bannerView removeFromSuperview];
    self.mTableView.frame = [[UIScreen mainScreen] bounds];
    [self.mTableView reloadData];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYDInAppPurchaseManagerProductListRetrievedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYDInAppPurchaseManagerTransactionFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYDInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
