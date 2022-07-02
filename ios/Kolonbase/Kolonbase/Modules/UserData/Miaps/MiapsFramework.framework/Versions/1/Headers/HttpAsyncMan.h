//
//  HttpAsyncMan.h
//  MiapsFramework
//
//  Created by Hohak Song on 2016. 11. 15..
//  Copyright © 2016년 thinkm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURLConnectionEx : NSURLConnection
{
    int mnID;
    long mlWebViewID;
}
@property (assign) int mnID;
@property (assign) long mlWebViewID;
@end

@interface AsyncData : NSObject
{
    NSMutableData*      mRcvData;
    NSURLConnectionEx*  mConn;
    int                 mnStatusCode;
    int                 mnMinkEncryp;
    int                 mnUnCompressLen;
    NSString*           sTargetFunc;
    
}
@property (nonatomic,retain) NSString*      sTargetFunc;
@property (nonatomic,retain) NSMutableData*      mRcvData;
@property (nonatomic,retain) NSURLConnectionEx*    mConn;
@property (nonatomic,assign) int                 mnStatusCode;
@property (nonatomic,assign) int                 mnMinkEncryp;
@property (nonatomic,assign) int                 mnUnCompressLen;
@end


@protocol HttpAsyncDelegate <NSObject>
- (void)OnHttpResult:(long)lWebViewID CommandID:(int)ID ResultDoc:(AsyncData *)result;
@end



@class HttpRequestMoreData;
@interface HttpAsyncMan : NSObject
{
    NSMutableDictionary* mHttpMap;
}
@property (nonatomic, retain) id<HttpAsyncDelegate> delegate;

// 일반 HTTP 요청
-(void) RequestHttp:(int)nID URL:(NSString*)sURL Post:(NSString*)sPost;
// Miaps HTTP 요청
-(void) RequestHttpByMiAPS:(long)lWebViewID CommandID:(int)nID URL:(NSString*)sURL Post:(NSString*)sPost MoreData:(HttpRequestMoreData*)moreData;

-(void) RequestHttp:(int)nID URLRequest:(NSURLRequest*)URLRequest;
-(void) RequestHttp:(long)lWebViewID CommandID:(int)nID URLRequest:(NSURLRequest*)URLRequest TargetFunc:(NSString*)sTargetFunc;
-(void) CancelHttp:(int)nID;
@end
