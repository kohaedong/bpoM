/*
 *  MinkImageViewEvent.h
 *  MinkUITest
 *
 *  Created by 호학 송 on 10. 4. 13..
 *  Copyright 2010 씽크엠. All rights reserved.
 *
 */
@class MinkImageProfile;
@protocol MinkImageViewEvent
- (void) ReceivedProfile:(MinkImageProfile*)profile;
- (void) ReceivedTotalPage:(int)nTotalPage;
- (void) ReceivedPage:(int)nPage;
- (void) ReceivedEnd;
- (void) ReceivedError:(NSString*)sMessge;
- (void) ReceivedHttpError:(NSString*)sMessge;
@optional
- (void) NeedPassword;
@end