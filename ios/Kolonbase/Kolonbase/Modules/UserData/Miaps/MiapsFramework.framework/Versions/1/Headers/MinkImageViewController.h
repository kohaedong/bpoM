//
//  MinkImageViewController.h
//  MinkUITest
//
//  Created by 호학 송 on 10. 4. 9..
//  Copyright 2010 씽크엠. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"
#import "ThumbImageView.h"
#import "MinkImageViewEvent.h"
#import "MinkImageHttp.h"
#import "MinkUIEvent.h"

//#define MINK_VIEWER_SERVICE         @"/MinkTotal"
//#define MINK_VIEWER_SERVICE_NAME    @"/minkSvc"
#define MINK_VIEWER_SERVICE_PARAM   @"command=documentview"

#define MAX_FOLDERNAME_LENGTH  512

@interface MinkImageInfo : NSObject
{
	/*속성 추가*/
	NSString *mDocViewURL;
	
	NSString *mID;
	NSString *mURL;
	char     mType;             //'F','D'
	
	NSString *mCompany;			// 소속사 약어 (2010 09 06 추가)
    NSString *mSSO_URL;         // 사용자 인증 URL (2012.03.26 추가)
    NSMutableString *mPDID;     // SSO 인증키 (2012.3.14 추가)
    
    NSInteger mCacheTime;
    
    //Added By Song 2016.01.26 패스워드를 위해서
    NSInteger mnStartPage;
    NSInteger mnEndPage;

}
@property (nonatomic,copy) NSString *mDocViewURL;

@property (nonatomic,copy) NSString *mID;
@property (nonatomic,copy) NSString *mURL;
@property char mType;
@property (nonatomic,copy) NSString *mCompany;

@property (nonatomic,copy) NSString *mSSO_URL;
@property (strong, nonatomic) NSMutableString *mPDID;
@property (nonatomic, assign) NSInteger mCacheTime;

@property (nonatomic, assign) NSInteger mnStartPage;
@property (nonatomic, assign) NSInteger mnEndPage;


- (char)getTypeWithString:(NSString *)type;

@end


@interface MinkImageViewController : UIViewController 
<
    UIScrollViewDelegate, 
    TapDetectingImageViewDelegate,
    ThumbImageViewDelegate,
    MinkImageViewEvent,
    MinkUIEvent
> 
{
//	UIActivityIndicatorView     *activity;
	UIScrollView                *mImageScrollView;
//	TapDetectingImageView       *mImageView;
	CGRect                      imageViewFrame;
    
	//Gallery
	UIScrollView                *thumbScrollView;
    UIView                      *slideUpView; // Contains thumbScrollView and a label giving credit for the images.
    BOOL                        thumbViewShowing;
    
    NSTimer                     *autoscrollTimer;  // Timer used for auto-scrolling.
    float                       autoscrollDistance;  // Distance to scroll the thumb view when auto-scroll timer fires.
	
	
	//Http
	MinkImageHttp               *mHttp;
	MinkImageProfile            *mProfile;
	NSString                    *mCurrentID;
	NSMutableArray              *mImageNames;
	int                         mnCurrentPage;
	BOOL                        mbPickImageNaming;

	//어플전달 파라미터
	MinkImageInfo               *mInfo;
    
    //다음페이지 미리 가져오기 옵션
    BOOL                        bAheadOfNextPage;
    
    // 버튼
    UIButton                    *settingBtn;
    UIButton                    *togggleImgBtn;
    UIButton                    *nextBtn;
    UIButton                    *provBtn;
    
    UINavigationItem            *naviTitle;
    
    
    BOOL                        bInnerViewMode;
    CGRect                      m_innerFrame;
    
    BOOL                        m_bInnerModeCancel;

    // 옵션에 화면처리만 빼겠습니다.
    BOOL                        m_bNotUiMode;
    NSInteger                  m_cacheTime; // 분단위
    BOOL                        m_bBackground;
}

//@property (nonatomic,retain) UIActivityIndicatorView    *activity;
@property (nonatomic,retain) MinkImageInfo              *mInfo;

@property (nonatomic,retain) UIScrollView               *mImageScrollView;
//@property (nonatomic,retain) TapDetectingImageView    *mImageView;
@property (nonatomic,assign) CGRect                     imageViewFrame;
@property (nonatomic,retain) MinkImageHttp              *mHttp;
@property (nonatomic,retain) MinkImageProfile           *mProfile;
@property (nonatomic,retain) NSString                   *mCurrentID;
@property (nonatomic,retain) NSMutableArray             *mImageNames;

@property (nonatomic,retain) UIScrollView               *thumbScrollView;
@property (nonatomic,retain) UIView                     *slideUpView;
@property (nonatomic,assign) int                        mnCurrentPage;
@property (nonatomic,assign) BOOL                       mbPickImageNaming;

@property (nonatomic, assign) BOOL                      bAheadOfNextPage;

@property (nonatomic, retain) UIButton                  *settingBtn;
@property (nonatomic, retain) UIButton                  *toggleImgBtn;
@property (nonatomic, retain) UIButton                  *nextBtn;
@property (nonatomic, retain) UIButton                  *provBtn;
@property (nonatomic, retain) UIButton                  *optBtn;

@property (nonatomic, retain) UINavigationItem          *naviTitle;

@property (nonatomic,assign) CGRect                     m_innerFrame;

@property (nonatomic, assign) NSInteger                m_cacheTime;
@property (nonatomic, assign) BOOL                      m_bBackground;
- (void)addNavigationRightButton:(UINavigationBar *) naviBar;
- (void)addNavigationLeftButton:(UINavigationBar *) naviBar;
- (void)initSwipGestureRecognizer;
- (void)getNextImage:(int)nextImage;
- (void)getProvImage:(int)provPage;

- (void)onNextImage:(id)sender;
- (void)onProvImage:(id)sender;

-(void)loadDocViewEnviroment;


- (id)initWithImageInfo:(MinkImageInfo *)imgInfo;

- (void)setNaviBarTitle:(NSString *)szTitle;


//Add Kang..Document viewer innerView mode 로 생성시..
- (id)initWithInnerFrame:(CGRect)innerFrame;
-(void)InnerViewModeExitDocViewDelCachefile:(BOOL)bDelCache;

-(void)InnerViewModeCancelProc;
-(void)InnerViewModeRestart;

// 화면 없는 백그라운드 모드용으로 하나생성하였음.
-(id)initNoneUIModeWithImageInfo:(MinkImageInfo *)imgInfo;

//모덜뷰 현태로 화면을 보여준다.
+(void) presentModalView:(UIViewController*)RootViewCon DocServerURL:(NSString*)sDocServerURL Type:(char)cType DocURL:(NSString*)sDocURL GetPageCount:(int)nGetPageCount CacheMin:(int)nMinute;
//내부 번들의 내용에서 리소스 파일을 찾는데 사용한다.
+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension;

@end

