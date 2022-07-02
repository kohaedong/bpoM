//
//  TabScrollView.h
//  MiapsFramework
//
//  Created by Hohak Song on 2017. 4. 27..
//  Copyright © 2017년 thinkm. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ToolBarHeight   30
#define TabHeight       30
#define TabMinWidth     80

#define LeftInterval    20
#define RightInterval   20
@interface TabButtonInfo : NSObject
{
    long      mlID;
    NSString* msURL;
    NSString* msTitle;
    NSString* msData;
    long      mlData;
    UIView*   mButtonView;
    NSString* msScreenShotPath;
}
@property (nonatomic,retain) NSString* msURL;
@property (nonatomic,retain) NSString* msTitle;
@property (nonatomic,retain) NSString* msData;
@property (nonatomic,retain) UIView* mButtonView;
@property (nonatomic,retain) NSString* msScreenShotPath;
@property (assign) long mlID;
@property (assign) long mlData;
@end

@class WebMainView;
@interface TabButtonView : UIView
{
    UIScrollView*   mScrollView;
    NSMutableArray* mArrTabButtonInfo; //TabButtonInfo
    
    long            mlFocusTabCellID;
    WebMainView* mWebMainView;
}

-(void)AddTabButton:(TabButtonInfo*)info Animation:(BOOL)bAnimation;
-(void)RemoveTabButton:(long)lWebViewID Animation:(BOOL)bAnimation;
-(void) SetTabButtonText:(long)lWebViewID Title:(NSString*)sTitle;


-(void) SetFocusTabCellView:(long)FocusTabCellID;
@property (nonatomic,retain) UIScrollView* mScrollView;
@property (nonatomic,retain) NSMutableArray* mArrTabButtonInfo;
@property (nonatomic,retain) WebMainView* mWebMainView;

@end
