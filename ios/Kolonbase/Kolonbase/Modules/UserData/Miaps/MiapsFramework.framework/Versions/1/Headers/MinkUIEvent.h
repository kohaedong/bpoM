//
//  MinkUIEvent.m
//  MinkCore
//
//  Created by 호학 송 on 10. 4. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@protocol MinkUIEvent

-(BOOL) OnHActive:(NSObject*)objData Backword:(BOOL)bBack;

@optional
-(void) OnHReceive:(id)anArgument;
-(NSObject*) OnThreadExecute:(id)anArgument;
@end

