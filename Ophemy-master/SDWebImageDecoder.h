
#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

@protocol SDWebImageDecoderDelegate;

@interface SDWebImageDecoder : NSObject
{
    NSOperationQueue *imageDecodingQueue;
}

+ (SDWebImageDecoder *)sharedImageDecoder;
- (void)decodeImage:(UIImage *)image withDelegate:(id <SDWebImageDecoderDelegate>)delegate userInfo:(NSDictionary *)info;

@end

@protocol SDWebImageDecoderDelegate <NSObject>

- (void)imageDecoder:(SDWebImageDecoder *)decoder didFinishDecodingImage:(UIImage *)image userInfo:(NSDictionary *)userInfo;

@end

@interface UIImage (ForceDecode)

+ (UIImage *)decodedImageWithImage:(UIImage *)image;

@end