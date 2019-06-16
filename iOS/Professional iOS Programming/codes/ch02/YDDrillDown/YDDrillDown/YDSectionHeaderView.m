//
//  SectionHeaderView.m
    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import "YDSectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface YDSectionHeaderView()
 

@end
@implementation YDSectionHeaderView
 
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <YDSectionHeaderViewDelegate>)delegate  numrow:(NSInteger)numofRows{
    self = [super initWithFrame:frame];
    if (self != nil) {
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        _delegate = delegate;        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.numberOfRows=numofRows;
        self.key=title;
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 1)];
        redView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:redView];
        // Create and configure the title label.
        self.section = sectionNumber;
        self.expanded=NO; //start colapsed
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 5.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        self.titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
       
         // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(275.0, 10.0, 40.0, 40.0);
        [button setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateSelected];
        button.backgroundColor=[UIColor clearColor];
        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.disclosureButton = button;
    }
    return self;
}


-(IBAction)toggleOpen:(id)sender
{
    [self toggleOpenWithUserAction:YES];
}

-(void)toggleOpenWithUserAction:(BOOL)userAction
{    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                self.expanded=YES;
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                self.expanded=NO;
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}
@end