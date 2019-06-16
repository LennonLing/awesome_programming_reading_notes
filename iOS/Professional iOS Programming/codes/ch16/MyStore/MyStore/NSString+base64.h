//
//  NSString+base64.h
//  MyStore
//
//  Created by Peter van de Put on 09/06/13.
//  Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (base64)
+ (NSString *) base64StringFromData:(NSData *)paramData length:(NSInteger)paramLength;
@end
