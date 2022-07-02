//
//  UIWebView+WebViewEx.h
//  MiapsFramework
//
//  Created by Hohak Song on 2016. 10. 20..
//  Copyright © 2016년 thinkm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@protocol WebViewExDelegate <NSObject>
- (void) OnStartNavigationAction:(long)lWebViewID;
- (BOOL) OnNavigationAction:(long)lWebViewID Request:(NSURLRequest*) request;
@end

@class RoundIndicatorView;
@class WebViewController;
@interface WebViewEx  : WKWebView <WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
{
    RoundIndicatorView* mIndicator;
    WebViewController*   mViewCon;
    
    
    NSMutableData*      mRcvData;
    NSURLConnection*    mConn;
    long                mlID;
    CGPoint             mptDragStart;
}

@property (nonatomic,retain)WebViewController* mViewCon;
@property (nonatomic,assign)id<WebViewExDelegate> delegate;
@property (assign) long mlID;

- (void)RequestURL:(NSString*)sURL PostData:(NSString*)sPostData;
- (void) ExecuteJavaScript:(NSString*)sFunctionJS;

@end
