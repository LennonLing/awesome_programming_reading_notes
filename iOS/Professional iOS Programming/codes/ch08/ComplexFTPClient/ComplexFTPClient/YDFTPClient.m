//
//  YDFTPClient.m
//  ComplexFTPClient
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //
#import <Foundation/Foundation.h>
#import "YDFTPClient.h"

#define kFTPServer @"FTP_SERVER_ADDRESS"
#define kFTPPort 21
#define kFTPUsername @"FTP_USERNAME"
#define kFTPpassword @"FTP_PASSWORD"
enum {
    kSendBufferSize = 32768
};
@interface YDFTPClient()
{
    UInt64 numberOfBytesSent;
	UInt64 numberOfBytesReceived;
    int uploadbytesreadSoFar;
}
@property (readwrite, assign) NSString* dataIPAddress;
@property (readwrite, assign) UInt16 dataPort;

@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;

@property (nonatomic,assign) int lastResponseInt;
@property (nonatomic,assign) NSString* lastResponseCode;
@property (nonatomic,assign) NSString* lastCommandSent;
@property (nonatomic,assign) NSString* lastResponseMessage;


@property (nonatomic,retain, strong) NSInputStream *inputStream;
@property (nonatomic, retain,strong) NSOutputStream *outputStream;

@property (nonatomic, retain,strong) NSInputStream *dataInStream;
@property (nonatomic, retain,strong) NSOutputStream *dataOutStream;

@property (nonatomic,assign) BOOL isConnected;
@property (nonatomic,assign) BOOL loggedOn;
@property (nonatomic,assign) BOOL isDataStreamConfigured;
@property (nonatomic,assign) BOOL isDataStreamAvailable;

@end

 
@implementation YDFTPClient
{
    uint8_t                     _buffer[kSendBufferSize];
};


@synthesize bufferOffset  = _bufferOffset;
@synthesize bufferLimit   = _bufferLimit;


-(id)initClient
{
    if ((self = [super init]))
        {
        self.isConnected=NO;
        self.dataIPAddress=0;
        self.dataPort=0;
        self.isConnected=NO;
        self.isDataStreamAvailable=NO;
        self.lastCommandSent=@"";
        self.lastResponseCode=@"";
        self.lastResponseMessage=@"";
        }
	return self;
}

-(void)connect
{
    if (!self.isConnected)
        [self initNetworkCommunication];
}
-(void)disconnect
{
    if (self.isConnected)
        [self logoff];
}
#pragma thread management
+ (NSThread *)networkThread {
    static NSThread *networkThread = nil;
    static dispatch_once_t oncePredicate;
	
    dispatch_once(&oncePredicate, ^{
        networkThread =
		[[NSThread alloc] initWithTarget:self
								selector:@selector(networkThreadMain:)
								  object:nil];
        [networkThread start];
    });
	
    return networkThread;
}

+ (void)networkThreadMain:(id)unused {
    do {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

- (void)scheduleInCurrentThread:(NSStream*)aStream
{
    [aStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];
}
#pragma internal

- (void) initNetworkCommunication {
	
    CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)kFTPServer, kFTPPort, &readStream, &writeStream);
  	self.inputStream = (__bridge_transfer NSInputStream *)readStream;
 	self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;
	[self.inputStream setDelegate:self];
	[self.outputStream setDelegate:self];
    [self performSelector:@selector(scheduleInCurrentThread:)
                 onThread:[[self class] networkThread]
               withObject:self.inputStream
            waitUntilDone:YES];
    [self performSelector:@selector(scheduleInCurrentThread:)
                 onThread:[[self class] networkThread]
               withObject:self.outputStream
            waitUntilDone:YES];
	[self.inputStream open];
	[self.outputStream open];
    self.isConnected=YES;
    self.isDataStreamConfigured=NO;
}
#pragma stream delegate
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
 	switch (streamEvent) {
		case NSStreamEventOpenCompleted:
			break;
        case NSStreamEventNone:
            break;
		case NSStreamEventHasBytesAvailable:
			if (theStream == self.inputStream) {
				uint8_t buffer[1024];
				int len;
				while ([self.inputStream hasBytesAvailable]) {
					len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    numberOfBytesReceived+=len;
					if (len > 0) {
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (output) {
                            [self messageReceived:output];
                        }
                    }
                }
            }
            else if (theStream == self.dataInStream) {
                uint8_t buffer[8192];//8kB block
				int len;
				while ([self.dataInStream hasBytesAvailable]) {
					len = [self.dataInStream read:buffer maxLength:sizeof(buffer)];
                    numberOfBytesReceived+=len;
					if (len > 0) {
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (output) {
                            [self messageReceived:output];
                        }
                    }
                }
            }
			break;
        case NSStreamEventHasSpaceAvailable:
            if (theStream == self.dataOutStream) {
                    //write your custom code for upload and download
                     }
            break;
		case NSStreamEventErrorOccurred:
			[self.delegate ftpError:@"Network stream error occured"];
			break;
		case NSStreamEventEndEncountered:
			break;
	}
    
}
 
#pragma command helpers
-(void)sendUsername
{
    [self sendCommand:[NSString stringWithFormat:@"USER %@",kFTPUsername]];
}
-(void)sendPassword
{
    [self sendCommand:[NSString stringWithFormat:@"PASS %@",kFTPpassword]];
}
-(void)sendRAWCommand:(NSString *)command
{
    [self sendCommand:command];
}
    //internal method to send command to the stream
-(void) sendCommand:(NSString *)cmd{
	if (self.isConnected){
        if (self.outputStream){
            NSString *cmdToSend = [NSString stringWithFormat:@"%@\n",cmd];
            self.lastCommandSent=cmdToSend;
            NSData *data = [[NSData alloc] initWithData:[cmdToSend dataUsingEncoding:NSASCIIStringEncoding]];
            numberOfBytesSent+=[data length];
            [self.outputStream write:[data bytes] maxLength:[data length]];
        }
        else
        {
            [self.delegate ftpError:@"trying to send command when not connected"];
        }
    }
}

- (void) messageReceived:(NSString *)message {
	self.lastResponseCode = [message substringToIndex:3];
    self.lastResponseMessage=message;
   
    int response = [self.lastResponseCode intValue];
    self.lastResponseInt=response;
    [self.delegate serverResponseReceived:self.lastResponseCode message:self.lastResponseMessage];
    switch (response) {
        case 150:
                //connection accepted
            break;
        case 200:
            
            [self sendCommand:@"PASV"];
        case 220: //server welcome message so wait for username
            
            [self sendUsername];
            break;
        case 226:
                //transfer OK
            break;
        case 227:
            [self acceptDataStreamConfiguration:message];
            break;
        case 230: //server logged in
            self.loggedOn=YES;
            [self sendCommand:@"PASV"];
            [self.delegate loggedOn];
            break;
            
        case 331: //server waiting for password
            [self sendPassword];
            
            break;
        case 530: //Login or passwod incorrect
            [self.delegate logginFailed];
            self.loggedOn=NO;
            break;
        default:
            break;
    }
    
}
-(void)acceptDataStreamConfiguration:(NSString*)serverResponse
{  NSString *pattern=  @"([-\\d]+),([-\\d]+),([-\\d]+),([-\\d]+),([-\\d]+),([-\\d]+)";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:0
                                  error:&error];
    
       NSTextCheckingResult *match = [regex firstMatchInString:serverResponse
                                                    options:0
                                                      range:NSMakeRange(0, [serverResponse length])];
    
    self.dataIPAddress = [NSString stringWithFormat:@"%@.%@.%@.%@",
                     [serverResponse substringWithRange:[match rangeAtIndex:1]],
                     [serverResponse substringWithRange:[match rangeAtIndex:2]],
                     [serverResponse substringWithRange:[match rangeAtIndex:3]],
                     [serverResponse substringWithRange:[match rangeAtIndex:4]]];
    self.dataPort = ([[serverResponse substringWithRange:[match rangeAtIndex:5]] intValue] * 256)+
    [[serverResponse substringWithRange:[match rangeAtIndex:6]] intValue];
    self.isDataStreamConfigured=YES;
    [self openDataStream];
    
    
}
-(void)openDataStream
{
    if (self.isDataStreamConfigured && !self.isDataStreamAvailable){
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.dataIPAddress,
                                           self.dataPort, &readStream, &writeStream);
        self.dataInStream = (__bridge_transfer NSInputStream *)readStream;
        self.dataOutStream = (__bridge_transfer NSOutputStream *)writeStream;
        [self.dataInStream setDelegate:self];
        [self.dataOutStream setDelegate:self];
        [self performSelector:@selector(scheduleInCurrentThread:)
                     onThread:[[self class] networkThread]
                   withObject:self.dataInStream
                waitUntilDone:YES];
        [self performSelector:@selector(scheduleInCurrentThread:)
                     onThread:[[self class] networkThread]
                   withObject:self.dataOutStream
                waitUntilDone:YES];

        [self.dataInStream open];
        [self.dataOutStream open];
        self.isDataStreamAvailable=YES;
    }
}
-(void)closeDataStream
{
    if (self.dataInStream.streamStatus != NSStreamStatusClosed)
        {
        [self.dataInStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.dataInStream.delegate = nil;
        [self.dataInStream close];
        }
    if (self.dataOutStream.streamStatus != NSStreamStatusClosed)
        {
        [self.dataOutStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.dataOutStream.delegate = nil;
        [self.dataOutStream close];
        }
}
-(void)logoff
{
    [self sendCommand:@"QUIT"];
    [self closeDataStream];
    if (self.inputStream.streamStatus != NSStreamStatusClosed)
        {
        [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.inputStream.delegate = nil;
        [self.inputStream close];
        }
    if (self.outputStream.streamStatus != NSStreamStatusClosed)
        {
        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.outputStream.delegate = nil;
        [self.outputStream close];
        }
    self.isConnected=NO;
    self.isDataStreamAvailable=NO;
    self.isDataStreamConfigured=NO;
}

#pragma readonly properties
- (uint8_t *)buffer
{
    return  self.buffer;
}
- (UInt64)numberOfBytesSent
{
    return numberOfBytesSent;
}
- (UInt64)numberOfBytesReceived
{
    return numberOfBytesReceived;
}
@end
