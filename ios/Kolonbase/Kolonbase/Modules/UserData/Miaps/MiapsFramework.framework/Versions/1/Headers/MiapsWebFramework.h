//
//  DongaSSO.h
//  DongaSSO
//
//  Created by SongHoHak on 2018. 7. 30..
//  Copyright © 2018년 ThinkM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WKWebView;
@class WKScriptMessage;
@class UIViewController;
@interface MiapsWebFramework : NSObject
+(MiapsWebFramework*)Share;
//-(NSString*) getSSO:(NSString*)sKey;
//-(void) callSSO:(NSString*)myScheme;
//-(void) saveSSOParam:(NSString*)Scheme Error:(NSError**)Error;
//-(NSDictionary*) getSSOs;


-(BOOL) resultSSO:(WKWebView*)WebView URL:(NSURL*)url;
-(void) userContentControllerEx:(UIViewController*)Controller Msg:(WKScriptMessage *)message;
@end
