/*
 http://www.imcore.net | hosihito@gmail.com
 Developer. Kyoungbin Lee
 2012.05.25

 AES256 EnCrypt / DeCrypt
*/
 #import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface NSData (AESAdditions)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
- (void*)AES256EncryptWithKeyByte:(NSString*)key OutCompressedLen:(size_t*)pCompressedLen; //Added By Song 2014.11.07 인코딩.
- (void*)AES128EncryptWithKeyByte:(NSString*)key OutCompressedLen:(size_t*)pCompressedLen;
- (void*)AES256DecryptWithKeyBytes:(NSString*)key OutDeCompressedLen:(size_t*)pDeCompressedLen;
- (void*)AES128DecryptWithKeyBytes:(NSString*)key OutDeCompressedLen:(size_t*)pDeCompressedLen;
@end