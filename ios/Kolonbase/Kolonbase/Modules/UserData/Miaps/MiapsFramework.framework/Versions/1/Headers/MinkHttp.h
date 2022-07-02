//
//  MinkHttp.h
//  MinkUITest
//
//  Created by 호학 송 on 10. 4. 14..
//  Copyright 2010 씽크엠. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MinkThread.h"

// error code.
#define     NO_PD_ID        @"NO_PD-ID";


@interface MinkHttp : MinkThread {
	BOOL mDone;
	BOOL mCanceled;
	BOOL mExit;
	
	NSURLConnection *mConn;
//	NSAutoreleasePool *mPool;
	NSMutableData *mRcvData;
    
    NSMutableString *mCookie;
}
@property (nonatomic,retain) NSURLConnection *mConn;
//@property (nonatomic,retain) NSAutoreleasePool *mPool;
@property (nonatomic,retain) NSMutableData *mRcvData;
@property (nonatomic,retain) NSMutableString *mCookie;
@property (nonatomic,assign) BOOL mCanceled;
@property (nonatomic,assign) BOOL mExit;


- (BOOL) RequestHttp:(NSString*)sURL Post:(NSString*)sPost;
- (NSString *)urlEncodeValue:(NSString *)str;
@end
