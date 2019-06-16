//
//  YDViewController.m
//  SoapRequest
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
#import "URLRequest.h"
@interface YDViewController ()<NSXMLParserDelegate>
{
    NSXMLParser *soapParser;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSMutableDictionary *item;
}
-(IBAction)getIPAddress:(id)sender;
@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}
-(IBAction)getIPAddress:(id)sender
{

 //Construct the soapMessasge
    NSString *soapMsg =  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<MyIPAddress xmlns=\"http://tempuri.org/\" />"
                         "</soap:Body>"
                         "</soap:Envelope>";     
//Create the NSURL
    NSURL *url = [NSURL URLWithString:@"http://developer.yourdeveloper.net/soapservice.asmx"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //Set the SOAP Action
	[theRequest addValue: @"http://tempuri.org/MyIPAddress" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    //make sure it's a POST
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
 
    URLRequest *urlRequest = [[URLRequest alloc] initWithRequest:theRequest];
    [urlRequest startWithCompletion:^(URLRequest *request, NSData *data, BOOL success) {
        if (success)
        {   errorParsing=NO;
            //create the NSXMLParser and initialize it with the data received
            soapParser = [[NSXMLParser alloc] initWithData:data];
            //set the delegate
            [soapParser setDelegate:self];
            // You may need to turn some of these on depending on the type of XML file you are parsing
            [soapParser setShouldProcessNamespaces:NO];
            [soapParser setShouldReportNamespacePrefixes:NO];
            [soapParser setShouldResolveExternalEntities:NO];
            [soapParser parse];
        }
        else
        {
            NSLog(@"error  %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
   
}
 
#pragma delegates
- (void)parserDidStartDocument:(NSXMLParser *)parser{

}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}
/*
 This method is called if an error occurs
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    errorParsing=YES;
}
/*
 The XML parser contains three methods, one that runs at the beginning of an individual element,
 one that runs during the middle of parsing the element,
 and one that runs at the end of the element.
 
 For this example, we'll be parsing an RSS feed that break down elements into groups under the heading of "items".
 At the start of the processing, we are checking for the element name "item" and allocating our item dictionary when a new group is detected.
 Otherwise, we initialize our variable for the value.
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentElement = [elementName copy];
    ElementValue = [[NSMutableString alloc] init];
    if ([elementName isEqualToString:@"MyIPAddressResult"]) {
        item = [[NSMutableDictionary alloc] init];
    }
}
/*
 When the parser find characters, they are added to your variable "ElementValue".
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [ElementValue appendString:string];
}
/*
 If the endelement for the item is found the item is copied and added to the articles array
 Also the tableview is reloaded here
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"MyIPAddressResult"]) {
        self.ipLabel.text =  ElementValue;
         
    } else {
        [item setObject:ElementValue forKey:elementName];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
