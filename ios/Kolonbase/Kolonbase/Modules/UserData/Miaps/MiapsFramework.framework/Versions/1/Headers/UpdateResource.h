//
//  UpdateResource.h
//  MiapsFramework
//
//  Created by Hohak Song on 2016. 10. 21..
//  Copyright © 2016년 thinkm. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 resource.inf (서버에서 make info : 명칭 (Resource Maker)로 돌렸을때 나오는 파일)
 2016.10.12.20.20   //년월일시분초 : 가장 처음
 파일명,파일패스,년.월.일.시.분.초
 파일명,파일패스,년.월.일.시.분.초
 파일명,파일패스,년.월.일.시.분.초
 파일명,파일패스,년.월.일.시.분.초
 */
@protocol UpdateResourceDelegate <NSObject>
-(void) Start;
-(void) SetProgressMaxCount:(int) nMaxCount;
-(void) IncrementProgress;
-(void) SetMaxFileSize:(long) lFileSize;
-(long) GetMaxFileSize;
-(void) End;
-(void) SetTitle:(NSString*) sTitle;
@end


@interface NSUpdateResourceInfo : NSObject
{
    NSString* sFileName;
    NSString* sFilePath;
    NSString* sFileTime;
}
@property (nonatomic,retain) NSString* sFileName;
@property (nonatomic,retain) NSString* sFilePath;
@property (nonatomic,retain) NSString* sFileTime;
@end

@interface UpdateResource : NSObject
{
    
    NSMutableDictionary*   mLocolMap;
    NSString*       mLocolUpdateDate;
    NSString*       mServerUpdateDate;
    NSMutableArray* mlstUpdates;
    //NSThread*           mThread;
    NSString*           msURL;
    NSString*           msRootPath;
    NSURLConnection*    mConn;
    int                 mnResponseCode;
    long                mlRcvSize;
}
- (void) UpdateResource:(NSString*)sURL Path:(NSString*)sLocolPath;
@property (nonatomic, retain) id<UpdateResourceDelegate> delegate;
@end
