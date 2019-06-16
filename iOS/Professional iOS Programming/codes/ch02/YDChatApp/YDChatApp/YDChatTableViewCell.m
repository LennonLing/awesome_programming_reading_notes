    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import <QuartzCore/QuartzCore.h>
#import "YDChatTableViewCell.h"
#import "YDChatData.h"
#import "YDChatUser.h"
@interface YDChatTableViewCell ()
//declare properties
@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;

    //- (void) setupInternalData;

@end

@implementation YDChatTableViewCell
@synthesize data=_data;
- (void) setData : (YDChatData*)data
{
    _data = data;
    [self rebuildUserInterface];
}

-(void)rebuildUserInterface
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.bubbleImage)
        {
        self.bubbleImage = [[UIImageView alloc] init];
        [self addSubview:self.bubbleImage];
        }
    YDChatType type = self.data.type;
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
    CGFloat x = (type == ChatTypeSomeone) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
        //if we have a chatUser show the avatar of the YDChatUser property
    if (self.data.chatUser)
        {
        YDChatUser *thisUser = self.data.chatUser;
        [self.avatarImage removeFromSuperview];
        self.avatarImage = [[UIImageView alloc] initWithImage:(thisUser.avatar ? thisUser.avatar : [UIImage imageNamed:@"noAvatar.png"])];
        self.avatarImage.layer.cornerRadius = 9.0;
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        self.avatarImage.layer.borderWidth = 1.0;
            //calculate the x position
        CGFloat avatarX = (type == ChatTypeSomeone) ? 2 : self.frame.size.width - 52;
        CGFloat avatarY = self.frame.size.height - 50;
            //set the frame correctly
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        [self addSubview:self.avatarImage];
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        if (type == ChatTypeSomeone) x += 54;
        if (type == ChatTypeMine) x -= 54;
        }
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];
        //depending on the ChatType a bubble image on the left or right
    if (type == ChatTypeSomeone)
        {
        self.bubbleImage.image = [[UIImage imageNamed:@"yoububble.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"mebubble.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    }
    self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
}

- (void)setUP:(YDChatData *)value
{
	self.data = value;

       [self rebuildUserInterface];
}



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
         [self rebuildUserInterface];
}

@end
