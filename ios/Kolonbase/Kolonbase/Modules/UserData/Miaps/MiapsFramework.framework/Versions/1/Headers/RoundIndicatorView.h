//
//  RoundIndicatorView.h
//
//  Created by Yeom SungHo on 11. 10. 20..
//  Copyright (c) 2011년 GlueSoft.Co.Ltd. All rights reserved.
//
//  Comment
//  1. 

typedef enum
{
    RoundIndicatorTypeDefault = 0, // Only Indicator
    RoundIndicatorTypeTitle   = 1, // Indicator And Title Label
    RoundIndicatorTypeButton  = 2, // Indicator And Button
}
RoundIndicatorType;

typedef enum
{
    InteractionTypeNone   = 0,
    InteractionTypeView   = 1,
    InteractionTypeWindow = 2,
}
InteractionType;


enum
{
    ROUND_INDICATOR_DEFAULT_TYPE_SIZE = 80,
    ROUND_INDICATOR_TITLE_TYPE_SIZE   = 140,
};


#import <UIKit/UIKit.h>

@interface RoundIndicatorView : UIView
{
    UIColor           *_mStrokeColor; // Round Boarder Color
    UIColor           *_mRectColor;   // Round Box     Color
    
    UILabel           *_pLBtitle;     // Pointer Label Indicator Title
    
    CGFloat            _mStrokeWidth; // Round Boarder Width
    
    RoundIndicatorType _mViewType;     // View Type
    
    @private
    
    UIActivityIndicatorView *mIndicator;
}

@property (nonatomic, retain) UIColor           *strokeColor;
@property (nonatomic, retain) UIColor           *rectColor;
@property (nonatomic, assign) CGFloat            strokeWidth;
@property (nonatomic, assign) RoundIndicatorType viewType;
@property (nonatomic, retain) UILabel           *pLBtitle;

#pragma mark - Class Methods

//+ (void)defaultWithSuperView:(UIView *)view;
//+ (void)defaultWithSuperView:(UIView *)view interationType:(InteractionType)type;

//+ (void)titleWithSuperView:(UIView *)view title:(NSString *)title;
//+ (void)nonTitleWithSuperView:(UIView *)view title:(NSString *)title;
+ (void)titleWithSuperView:(UIView *)view title:(NSString *)title interationType:(InteractionType)type;
//+ (void)titleWithSuperView:(UIView *)view title:(NSString *)title interationType:(InteractionType)type;

+ (void)stopWithSuperView:(UIView *)view;


#pragma mark - View Initialization
- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style WidthSize:(int)nWidthSize HeightSize:(int)nHeightSize;

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style;

- (id)initWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style title:(NSString *)title;


#pragma mark - Instance Mehtods

- (void)indicatorStart;
- (void)indicatorStop;

@end
