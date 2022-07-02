//
//  WebViewController.h
//  MiapsFramework
//
//  Created by Hohak Song on 2016. 11. 15..
//  Copyright © 2016년 thinkm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MiapsFramework/MiapsFramework.h>
@class WebMainView;
@interface WebViewController : UIViewController<UpdateResourceDelegate,MiapsDelegate,HttpAsyncDelegate,WebViewExDelegate>
{
    RoundProgressView* mProgressView;
    long               mResourceUdateCount;
    long               mResourcePos;
    long               mResourceFileSize;
    WebMainView* mWebMainView;
}

-(long) FindID:(WebViewEx*)WebView;
-(WebViewEx*) FindWebView:(long)lWebViewID;
-(void) SetTabButtonText:(long)lWebViewID Title:(NSString*)sTitle;
-(void) ShowToolBar:(BOOL)bShow Animation:(BOOL)bAnimation;
@end
