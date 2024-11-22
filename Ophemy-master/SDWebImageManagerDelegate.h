
@class SDWebImageManager;
@class UIImage;

@protocol SDWebImageManagerDelegate <NSObject>

@optional

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image;
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error;

@end
