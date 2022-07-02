//
//  NSString+Ex.h
//  MiapsFramework
//
//  Created by Hohak Song on 2017. 6. 7..
//  Copyright © 2017년 thinkm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Ex)
- (NSString*)UrlEncoding;
- (NSString*)UrlDecoding;
- (NSDictionary*)ToJSON;
@end
