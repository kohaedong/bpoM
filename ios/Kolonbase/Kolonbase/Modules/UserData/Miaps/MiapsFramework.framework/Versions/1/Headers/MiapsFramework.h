//
//  MiapsFramework.h
//  MiapsFramework
//
//  Created by itsme on 2015. 9. 1..
//  Copyright (c) 2015년 thinkm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MiapsFramework/WebViewEx.h>
#import <MiapsFramework/UpdateResource.h>
#import <MiapsFramework/RoundProgressView.h>
#import <MiapsFramework/HttpAsyncMan.h>
#import <MiapsFramework/AppDelegateEx.h>


#define RequestID_RegDevice     1   //@"RegDevice"
#define RequestID_VerCheck      2   //@"VerCheck"

#define RequestID_LICENSE       3   //@"LICENSE"
#define RequestID_WebViewReq    100 //@"WebView"

typedef enum _EncriptType
{
    AES256 = 0,
    AES128
}EncriptType;

typedef enum _MiapsFrameworkResult
{
    MiapsFramework_None = 0,
    MiapsFramework_UpgradeVersion_Automatic, //자동으로 업그레이드
    MiapsFramework_CheckVersion_Manually,    //수종으로 업그레이드
    MiapsFramework_SSOLogin //SSO Login
}MiapsFrameworkResult;

@protocol MiapsDelegate <NSObject>
- (void)onReceiveResult:(MiapsFrameworkResult)Type ResultDoc:(NSDictionary *)result;
- (void)onForceUpdate:(BOOL)bSuccess;
- (void)onUpdate:(BOOL)bSuccess;
@end

@protocol MiapsPushDelegate <NSObject>
- (void)onReceivePushData:(NSDictionary *)pushData;
@end


@interface HttpRequestMoreData : NSObject
{
    NSString* msID;
    NSString* msPwd;
    NSString* msUserNO;
    NSString* msGroupID;
}
@property (nonatomic,retain) NSString* msID;
@property (nonatomic,retain) NSString* msPwd;
@property (nonatomic,retain) NSString* msUserNO;
@property (nonatomic,retain) NSString* msGroupID;
@end


@class UpdateResource;
@interface MiapsFramework : NSObject <HttpAsyncDelegate>
{
    HttpAsyncMan*       mHttpMan;    
    NSString*           mszUpgreadPath;
    NSString*           mnsUpdateURL;//$$파라미터를 받는다.
    NSString*           msMinkServiceURL;//$$파라미터를 받는다.
    NSString*           msForceUpdate; // 강제업데이트 여부..
    MiapsFrameworkResult mResultType;
    UpdateResource*     mUpdateResource;
    HttpRequestMoreData* mpHttpMoreData;
    NSString*           msToken;
    int                 mReqID;
    
}

/* 메시지 박스에 들어갈 프로퍼티 */
@property (nonatomic, retain) NSString *msUpdateMsg;
@property (nonatomic, retain) NSString *msCancelTitle;
@property (nonatomic, retain) NSString *msOtherTitle;
@property (nonatomic, retain) NSString *msBoxTitle;
@property (nonatomic, retain) NSString *msForceMsg;
@property (nonatomic, retain) UpdateResource *mUpdateResource;
@property (nonatomic, assign) id<MiapsDelegate> delegate;
@property (nonatomic, assign) id<MiapsPushDelegate> pushDelegate;
@property (nonatomic, retain) HttpAsyncMan*       mHttpMan;
@property (nonatomic, retain) HttpRequestMoreData*       mpHttpMoreData;
@property (nonatomic, retain) NSString*       msToken;
@property (assign) int mReqID;
@property (nonatomic, retain) NSString *msPackageID;


/* 업데이트 리소스 */
+ (NSString*) GetResourceFolder;
+ (NSString*) GetServerURL;
- (void) UpdateResource:(NSString*)sURL Delegate:(id)delegagte;

/* 푸시관련 */
- (void)SetDeviceInfo:(NSString *)sURL userId:(NSString *)sID userPW:(NSString *)sPasswd deviceToken:(NSString *)token;
- (void)SetMiapsPushData:(NSDictionary *)pushInfo InsertEnable:(BOOL)bInsert;
//- (void)InsertPushData:(NSDictionary *)pushInfo;


/* 버전 체크 */
- (void) RequestCheckVersion:(NSString*)sURL WithPlatformCode:(NSString *)sPlatformCd;
- (void) RequestCheckVersionManually:(NSString*)sURL WithPlatformCode:(NSString *)sPlatformCd;
- (void) InstallApp:(NSString*)sURL;
- (void) SaveKeyChain:(NSString*)sAppID Group:(NSString*)sGroup Key:(NSString*)sKey Value:(NSString*)sValue;
- (void) appVerCheck:(NSString*)szRcvData;
//2021.01.18 같은 어드민센트의 다른 앱을 다운로드 설치
- (void) RequestCheckExAppVersion:(NSString*)sURL WithPlatformCode:(NSString *)sPlatformCd packageID:(NSString*)sPackageID;

/* 라이센스 체크*/
- (int) asyncMinkLicenseToUrl:(NSString*)sURL userID:(NSString *)uID userPassword:(NSString *)uPW userNo:(NSString*)uUserNo groupID:(NSString*)uGroupID deviceToken:(NSString *)token bIsMinkEncrypt:(BOOL)bEnc;


- (void)UpdateApplication;
- (void)ExecuteCommand:(NSString*)sURL;
- (void)ExecuteCommand:(long)lWebViewID URL:(NSString*)sURL;

- (NSString*) LoadKeyChain:(NSString*)sAppID Group:(NSString*)sGroup Key:(NSString*)sKey;
+ (NSString*) GetUniqueID;


+ (MiapsFramework *)GetInstance;
+ (void) Inidcator:(BOOL)bShow;
- (HttpRequestMoreData*) GetHttpMoreData;
- (void) SetHttpMoreData:(HttpRequestMoreData*)MoreData;
+ (void) CloseApp;

/* SSO */
+(NSString*) getSSO:(NSString*)sKey;
+(void) callSSO:(NSString*)myScheme Debug:(BOOL)bDebug;
+(void) saveSSOParam:(NSString*)Scheme Error:(NSError**)Error;
+(NSDictionary*) getSSOs;
+(BOOL) resultSSO:(id<MiapsDelegate>)miapDelegate URL:(NSURL*)url;

/* Encript/Decript*/
+(NSString*)Encrypt:(EncriptType)encType Data:(NSString*)sData;
+(NSString*)Decrypt:(EncriptType)encType Data:(NSString*)sData;


/* SampleEn */
+(NSString*) getAES256Sample:(NSString*)sData;
@end




