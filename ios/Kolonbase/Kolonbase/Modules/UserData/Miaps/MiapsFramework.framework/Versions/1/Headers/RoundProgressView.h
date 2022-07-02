//
//  RoundProgressView.h
//
//  Created by Kang on 13. 02. 28..
//
//  Comment
//  1. 

enum
{
    ROUND_PROGRESS_WIDTH    = 300,
    ROUND_PROGRESS_HEIGHT   = 140,
};

#import <UIKit/UIKit.h>
@interface RoundProgressView : UIView
{
    UIColor           *_mStrokeColor; // Round Boarder Color
    UIColor           *_mRectColor;   // Round Box     Color
    UIProgressView    *m_progressView;
    UILabel           *m_LBtitle;     // Pointer Label Indicator Title
    UILabel           *m_LBPercent;   
    CGFloat           fProgressValue;
    CGFloat            _mStrokeWidth; // Round Boarder Width
    UIView            *m_pParentView;
    
}

@property (nonatomic, retain) UIColor           *strokeColor;
@property (nonatomic, retain) UIColor           *rectColor;
@property (nonatomic, assign) CGFloat            strokeWidth;

@property (nonatomic, retain) UILabel          *m_LBtitle;
@property (nonatomic, retain) UILabel          *m_LBPercent;
@property (nonatomic, retain) UIProgressView   *m_progressView;

@property (nonatomic, retain) UIView           *m_pParentView;

#pragma mark - View Initialization

- (id)initWithParenteView:(UIView *)pParentView title:(NSString *)title enableCancel:(BOOL)bCancel;


#pragma mark - Instance Mehtods

- (void)showProgressView;
- (void)hideProgressView;

// 0 ~ 100 %
- (void)setProgressValue:(CGFloat)fValue;
- (CGFloat)getProgressValue;

@end
