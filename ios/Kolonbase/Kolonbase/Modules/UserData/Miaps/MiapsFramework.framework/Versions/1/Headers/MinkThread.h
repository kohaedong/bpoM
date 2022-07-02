//
//  MinkThread.h
//  MinkOSXCore
//
//  Created by 호학 송 on 10. 4. 7..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum MinkThreadStatus {
	MinkThread_Running,
	MinkThread_Stoped
};

@interface MinkThread : NSObject {
	
	enum MinkThreadStatus mStatus;
	NSThread* mcurThread;
	UIViewController* mrcvCon;
}
@property (nonatomic,assign) enum MinkThreadStatus mStatus;
@property (nonatomic,retain) NSThread* mcurThread;;
@property (nonatomic,retain) UIViewController* mrcvCon;		

- (void) RunThreadwithObject:(id)anArgument withReceiveController:(UIViewController*)rcvCon;
- (void) Run:(id)anArgument;
- (void)ThreadReceiver:(id)anArgument;
- (BOOL) IsRunning;
- (void) Cancel;
@end
