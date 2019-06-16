//
//  NSArray+CSV.m
//  YDCSVParsing
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "NSArray+CSV.h"
#define kLineSeparator    @"\n"
#define kFieldSeparator   @","
#define kRemoveFieldQuotes YES
#define kFieldQuote       @"\""
#define kSkipFirstLine    YES

@implementation NSArray (CSV)

+ (NSArray *)arrayWithCSVFile:(NSString *)path
{
    NSString *contentString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil ];
    return [self arrayWithCSVString:contentString];
}
+ (NSArray *)arrayWithCSVString:(NSString *)string
{
    NSArray* lines = [string  componentsSeparatedByString:kLineSeparator];
        //Create an Array to store the fieldnames, we assume this is the first line of the file
    NSArray* fieldNames =  [[lines objectAtIndex:0] componentsSeparatedByString:kFieldSeparator];
        //cleanLines will contain an object for each line in the CSV
    NSMutableArray* cleanLines =[[NSMutableArray alloc] init];
        //loop over each line
    for (int i=0;i<[lines count];i++)
        {
            //create an array to hold the fields
        NSMutableArray *fields = [NSMutableArray array];
            //These are the parsed rawfield contents
        NSArray* rawFields=  [[lines objectAtIndex:i] componentsSeparatedByString:kFieldSeparator];
            //for each field
        for(int j=0;j<[rawFields count];j++)
            {//create a NSDictionary to store fieldvalue and fieldname
                NSMutableDictionary *field = [NSMutableDictionary dictionary];
                NSString *fieldName;
                NSString *fieldVal;
                    //for the field name always remove quotes
                fieldName=[[fieldNames objectAtIndex:j] stringByReplacingOccurrencesOfString:kFieldQuote withString:@""];
                if (kRemoveFieldQuotes)
                    {//if option is set replave kFieldQuote symbol with empty string thus remove
                    fieldVal=[[rawFields objectAtIndex:j] stringByReplacingOccurrencesOfString:kFieldQuote withString:@""];
                    }
                else
                    {
                    fieldVal=[rawFields objectAtIndex:j];
                    }
                    //set the values
                [field setValue:fieldVal forKey:@"fieldvalue"];
                [field setValue:fieldName forKey:@"fieldname"];
                    //add to the fields array
                [fields addObject:field];
            }
            //add object to cleanLines Array
        [cleanLines addObject:fields];
        
        }
        //the first line containing file headers will be removed from the two arrays so the resulting NSDictionary contains only data
    
    if (kSkipFirstLine)
        [cleanLines removeObjectAtIndex:0];
        
        
    return cleanLines;
    
}

@end
