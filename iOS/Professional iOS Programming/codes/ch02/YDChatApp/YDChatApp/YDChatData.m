    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //
#import "YDChatData.h"
#import <QuartzCore/QuartzCore.h>

@implementation YDChatData

//create some constant UIEdgeInsets to property align text and images
const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};
const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};
#pragma mark initializers
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user
{
    return [[YDChatData alloc] initWithText:text date:date type:type andUser:_user];
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user
{ 
    UIFont* font = [UIFont boldSystemFontOfSize:12];
    int width = 225, height = 10000.0;
    NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
    [atts setObject:font forKey:NSFontAttributeName];
    CGRect size = [text boundingRectWithSize:CGSizeMake(width, height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:atts
                                             context:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.size.width, size.size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    UIEdgeInsets insets = (type == ChatTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type andUser:_user   insets:insets];
}
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user
{
    return [[YDChatData alloc] initWithImage:image date:date type:type andUser:_user];
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user
{
    CGSize size = image.size;
    if (size.width > 220)
    {
        size.height /= (size.width / 220);
        size.width = 220;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    UIEdgeInsets insets = (type == ChatTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type andUser:_user  insets:insets];
}
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user insets:(UIEdgeInsets)insets
{
    return [[YDChatData alloc] initWithView:view date:date type:type andUser:_user   insets:insets];
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(YDChatType)type andUser:(YDChatUser *)_user insets:(UIEdgeInsets)insets  
{
    self = [super init];
    if (self)
    {
     _chatUser = _user;
    _view = view;
    _date = date;
    _type = type;
    _insets = insets;
    }
    return self;
}

@end
