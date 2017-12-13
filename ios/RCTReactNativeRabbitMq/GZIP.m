//
//  GZIP.m
//  RCTReactNativeRabbitMq
//
//  Created by nawin on 12/12/17.
//  Copyright © 2017 Atticus White. All rights reserved.
//

#import "GZIP.h"
#import <zlib.h>

#pragma clang diagnostic ignored "-Wcast-qual"

@implementation GZip

+ (NSData *)compress:(NSData * _Nonnull)data
{
//    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    if (data.length == 0 || [self isGzippedData:data])
    {
        return NULL;
    }
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)data.length;
    stream.next_in = (Bytef *)(void *)data.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    static const NSUInteger ChunkSize = 16384;
    
    NSMutableData *output = nil;
    int compression = Z_DEFAULT_COMPRESSION;
    if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
    {
        output = [NSMutableData dataWithLength:ChunkSize];
        while (stream.avail_out == 0)
        {
            if (stream.total_out >= output.length)
            {
                output.length += ChunkSize;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        output.length = stream.total_out;
    }
    return output;
}

+ (NSData *)decompress:(NSData * _Nonnull)data
{
//    NSData *data = [NSData dataWithBytes:&compressed length:sizeof(compressed)];
    if (data.length == 0 || ![self isGzippedData:data])
    {
        return NULL;
    }
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)data.length;
    stream.next_in = (Bytef *)data.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    NSMutableData *output = nil;
    if (inflateInit2(&stream, 47) == Z_OK)
    {
        int status = Z_OK;
        output = [NSMutableData dataWithCapacity:data.length * 2];
        while (status == Z_OK)
        {
            if (stream.total_out >= output.length)
            {
                output.length += data.length / 2;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            status = inflate (&stream, Z_SYNC_FLUSH);
        }
        if (inflateEnd(&stream) == Z_OK)
        {
            if (status == Z_STREAM_END)
            {
                output.length = stream.total_out;
            }
        }
    }
//    NSString *string = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
    return output;
}

+ (BOOL)isGzippedData:(NSData *)data
{
    const UInt8 *bytes = (const UInt8 *)data.bytes;
    return (data.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

@end
