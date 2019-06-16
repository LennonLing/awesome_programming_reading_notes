//
//  NSString+base64.m
//  MyStore
//
//  Created by Peter van de Put on 09/06/13.
//  Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#import "NSString+base64.h"

@implementation NSString (base64)
static char Base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};
+ (NSString *) base64StringFromData:(NSData *)paramData length:(NSInteger)paramLength {
    
    NSInteger ixtext = 0, dataLength = 0;
    long remainingCharacters;
    unsigned char inputCharacters[3] = {0, 0, 0}, outputCharacters[4] = {0, 0, 0, 0};
    short counter, charsonline = 0, charactersToCopy = 0;
    const unsigned char *rawBytes;
    
    NSMutableString *result;
    
    dataLength = [paramData length];
    if (dataLength < 1){
        return [NSString string];
    }
    result = [NSMutableString stringWithCapacity: dataLength];
    rawBytes = [paramData bytes];
    ixtext = 0;
    
    while (YES) {
        remainingCharacters = dataLength - ixtext;
        if (remainingCharacters <= 0)
            break;
        for (counter = 0; counter < 3; counter++) {
            NSInteger index = ixtext + counter;
            if (index < dataLength)
                inputCharacters[counter] = rawBytes[index];
            else
                inputCharacters[counter] = 0;
        }
        outputCharacters[0] = (inputCharacters[0] & 0xFC) >> 2;
        outputCharacters[1] = ((inputCharacters[0] & 0x03) << 4) | ((inputCharacters[1] & 0xF0) >> 4);
        outputCharacters[2] = ((inputCharacters[1] & 0x0F) << 2) | ((inputCharacters[2] & 0xC0) >> 6);
        outputCharacters[3] = inputCharacters[2] & 0x3F;
        charactersToCopy = 4;
        switch (remainingCharacters) {
            case 1:
                charactersToCopy = 2;
                break;
            case 2:
                charactersToCopy = 3;
                break;
        }
        
        for (counter = 0; counter < charactersToCopy; counter++){
            [result appendString: [NSString stringWithFormat: @"%c", Base64EncodingTable[outputCharacters[counter]]]];
        }
        
        for (counter = charactersToCopy; counter < 4; counter++){
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((paramLength > 0) && (charsonline >= paramLength)){
            charsonline = 0;
        }
    }     
    return result;
}
@end
