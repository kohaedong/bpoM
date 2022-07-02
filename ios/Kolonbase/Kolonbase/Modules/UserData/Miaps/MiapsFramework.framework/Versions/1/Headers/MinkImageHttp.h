//
//  MinkImageHttp.h
//  MinkUITest
//
//  Created by 호학 송 on 10. 4. 13..
//  Copyright 2010 씽크엠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MinkHttp.h"
#import "MinkImageProfile.h"

@interface  RequestParam : NSObject
{
	char cCodeID;
	NSString *sID;
    NSString *sURI;
	NSString *sCompany;
	int nFromPage ;
	int nToPage; 
    UIViewController *rcvCon;
	
}

@property (nonatomic, retain) NSString		*sID;
@property (nonatomic, retain) NSString		*sURI;
@property (nonatomic, retain) NSString		*sCompany;
@property (nonatomic, retain) UIViewController		*rcvCon;
@property (nonatomic, assign) int		nFromPage;
@property (nonatomic, assign) int		nToPage;
@property (nonatomic, assign) char		cCodeID;


- (id)initReqParamWithcCodeID:(char)cCode 
						 sID:(NSString *)aID
						sURI:(NSString *)aURI
						sCompany:(NSString *)aCompany
						nFromPage:(int)aFromPage
						nToPage:(int)aToPage
					rcvCon:(UIViewController *)aRcvcon;


@end



@interface MinkImageHttp : MinkHttp {	
	NSString *msURL;
	BOOL	 mSMore;
	MinkImageProfile* mProfile;
	int		 mnCurrentPage;
}
@property (nonatomic,retain) NSString *msURL;
@property (nonatomic,retain) MinkImageProfile* mProfile;
@property (nonatomic,assign) int mnCurrentPage;

- (id) initWithURL:(NSString*)sURL;
- (BOOL) Request:(NSString*)sID RequestURI:(NSString*)sURI From:(int)nFromPage To:(int)nToPage RcvController:(UIViewController*)rcvCon;
- (void) ReceivedTotalPage:(NSNumber*)nTotalPage;
- (void) ReceivedPage:(NSNumber*)nPage;
- (void) ReceivedEnd;
- (BOOL) RequestWithCode:(char)cCode ID:(NSString*)sID RequestURI:(NSString*)sURI CompanyName:(NSString *)sComName  From:(int)nFromPage To:(int)nToPage RcvController:(UIViewController*)rcvCon;
- (BOOL) RequestWithCode:(char)cCode ID:(NSString*)sID RequestURI:(NSString*)sURI CompanyName:(NSString *)sComName From:(int)nFromPage To:(int)nToPage RcvController:(UIViewController*)rcvCon Password:(NSString*)sPassword;

- (void) RequestRetry:(id)reqParam;

/*스레드 종료(종료됨은 보장되지 못함..)*/
- (void) SelfThreadCanceling;
@end
