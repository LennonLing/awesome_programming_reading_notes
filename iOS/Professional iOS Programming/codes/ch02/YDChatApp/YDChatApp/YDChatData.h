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
@class YDChatUser;
//enumerator to identify the chattype
typedef enum _YDChatType
{
    ChatTypeMine = 0,
    ChatTypeSomeone = 1
}   YDChatType;

@interface YDChatData : NSObject
@property (readonly, nonatomic) YDChatType type;
@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic,strong) YDChatUser *chatUser;

//custom initializers
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user;
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user insets:(UIEdgeInsets)insets;

@end
