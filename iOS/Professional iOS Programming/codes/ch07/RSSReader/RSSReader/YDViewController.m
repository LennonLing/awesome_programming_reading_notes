//
//  YDViewController.m
//  RSSReader
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

@interface YDViewController ()<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>
{
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
}
@end

@implementation YDViewController
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseXMLFileAtURL:@"http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"];
}
#pragma mark XML Parsing

/*
This method is called with a urlstring of the feed that need to be parsed
 */
- (void)parseXMLFileAtURL:(NSString *)URL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:URL]];
        //  NSURL *myURL = [NSURL URLWithString:URL];
    URLRequest *urlRequest = [[URLRequest alloc] initWithRequest:request];
    [urlRequest startWithCompletion:^(URLRequest *request, NSData *data, BOOL success) {
        if (success)
            {
            //create the article array
            articles = [[NSMutableArray alloc] init];
            errorParsing=NO;
            //create the NSXMLParser and initialize it with the data received
            rssParser = [[NSXMLParser alloc] initWithData:data];
            //set the delegate
           
            [rssParser setDelegate:self];
            // You may need to turn some of these on depending on the type of XML file you are parsing
            [rssParser setShouldProcessNamespaces:NO];
            [rssParser setShouldReportNamespacePrefixes:NO];
            [rssParser setShouldResolveExternalEntities:NO];
            [rssParser parse];
            }
        else
            {
            NSLog(@"error  %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }
    }];

}
    //this method is called when the parser have found a valid start element
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
   
}


/*
 This method is called if an error occurs
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
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
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    ElementValue = [[NSMutableString alloc] init];
    if ([elementName isEqualToString:@"item"]) {
        item = [[NSMutableDictionary alloc] init];
    }
}
/*
When the parser find characters, they are added to your variable "ElementValue".
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [ElementValue appendString:string];
}
/*
 If the endelement for the item is found the item is copied and added to the articles array
 Also the tableview is reloaded here
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [articles addObject:[item copy]];
        [self.mTableView reloadData];
    } else {
        [item setObject:ElementValue forKey:elementName];
    }
    
}

#pragma mark UITableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [articles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //get the item from the articles array as a dictionary
    NSDictionary* feedItem = [articles objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[feedItem objectForKey:@"title"];
    return cell;
}
 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
