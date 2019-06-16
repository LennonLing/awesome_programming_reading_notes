//
//  SectionHeaderView.h

    //  This file is part of source code lessons that are related to the book
    //  Title: Professional IOS Programming
    //  Publisher: John Wiley & Sons Inc
    //  ISBN 978-1-118-66113-0
    //  Author: Peter van de Put
    //  Company: YourDeveloper Mobile Solutions
    //  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
    //  Copyright (c) 2013 with the author and publisher. All rights reserved.
    //

#import <UIKit/UIKit.h>
@protocol YDSectionHeaderViewDelegate;
@interface YDSectionHeaderView : UIView
 
@property (nonatomic,assign) BOOL expanded;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic,assign) NSInteger numberOfRows;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) id <YDSectionHeaderViewDelegate> delegate;
//initializer
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <YDSectionHeaderViewDelegate>)delegate numrow:(NSInteger)numofRows;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
@end

@protocol YDSectionHeaderViewDelegate <NSObject>
@optional
-(void)sectionHeaderView:(YDSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(YDSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end