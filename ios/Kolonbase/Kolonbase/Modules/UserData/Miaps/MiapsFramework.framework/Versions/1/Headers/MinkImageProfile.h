//
//  MinkImageProfile.h
//  MinkUITest
//
//  Created by 호학 송 on 10. 4. 12..
//  Copyright 2010 씽크엠. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kImageProfile		@"ImageProfile"
#define kFieldURLKey		@"ImageProfileURL"
#define kFieldID			@"ImageProfileID"
#define kFieldServerID      @"ImageProfileServerID"
#define kFieldTotalPage		@"ImageProfileTotalPage"
#define KFieldPageStatus	@"ImageProfilePage"
#define kFieldCacheTime     @"ImageProfileCacheTime"

#define  DOCVIEW_TEMP_ROOT @"DocView"

@interface PageStatusInfo : NSObject
{
	BOOL bDownLoaded;
	float fX;
	float fY;
	float fZoom;
}
@property (nonatomic,assign) BOOL bDownLoaded;
@property (nonatomic,assign) float fX;
@property (nonatomic,assign) float fY;
@property (nonatomic,assign) float fZoom;


@end

@interface MinkImageProfile : NSObject <NSCoding,NSCopying> {
	NSString *mURL;
	NSString *mID;
	NSString *mServerID;
	NSNumber *mTotalPage;
	NSMutableArray  *mPageStatus; //Y(Y/N),0.0f,0.0f(Offset),1.7f(ZoomSize)
    
    NSNumber *mCacheTime;
}

@property (nonatomic,retain) NSString *mURL;
@property (nonatomic,retain) NSString *mID;
@property (nonatomic,retain) NSString *mServerID;
@property (nonatomic,retain) NSNumber *mTotalPage;
@property (nonatomic,retain) NSMutableArray *mPageStatus;
@property (nonatomic,retain) NSNumber *mCacheTime;


- (BOOL) SaveToFileName;

- (NSString*) getImageName:(int)nIndex;
- (NSString*) getImagePath:(int)nIndex;
- (NSString*) getImageThumbsPath:(int)nIndex;
- (NSInteger) getCachetime;

+ (id) LoadByFileName:(NSString*)sID;
+ (BOOL) IsDirecotry:(NSString*)folderName;


- (void) setPageStatusAtIndex:(int)nIndex Downloaded:(BOOL)bDownLoaded;
- (BOOL) getPageStatusAtIndex:(int)nIndex;
- (void) setTotalPage:(int)nPage;
@end
