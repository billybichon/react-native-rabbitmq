@import Foundation;

////! Project version number for GZIP.
//FOUNDATION_EXPORT double GZIPVersionNumber;
//
////! Project version string for GZIP.
//FOUNDATION_EXPORT const unsigned char GZIPVersionString[];
//
//#import <GZIP/NSData+GZIP.h>

#import <Foundation/Foundation.h>


@interface GZip : NSObject

+ (nullable NSData *)compress:(NSData * _Nonnull)data;
+ (nullable NSData *)decompress:(NSData * _Nonnull)data;
+ (BOOL)isGzippedData:(NSData * _Nonnull)data;

@end
