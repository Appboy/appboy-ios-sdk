#import "ABKSDWebImageProxy.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>

@implementation ABKSDWebImageProxy

+ (void)setImageForView:(UIImageView *)imageView
  showActivityIndicator:(BOOL)showActivityIndicator
                withURL:(nullable NSURL *)imageURL
       imagePlaceHolder:(nullable UIImage *)placeHolder
              completed:(nullable void (^)(UIImage * _Nullable image, NSError * _Nullable error, NSInteger cacheType, NSURL * _Nullable imageURL))completion {
  [imageView sd_setShowActivityIndicatorView:showActivityIndicator];
  [imageView sd_setImageWithURL:imageURL
               placeholderImage:placeHolder
                        options: (SDWebImageQueryDataWhenInMemory | SDWebImageQueryDiskSync)
                      completed:completion];
}

+ (void)prefetchURLs:(nullable NSArray *)imageURLs {
  [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageURLs];
}

+ (void)loadImageWithURL:(nullable NSURL *)url
                 options:(NSInteger)options
               completed:(nullable void (^)(UIImage *image, NSData *data, NSError *error, NSInteger cacheType, BOOL finished, NSURL *imageURL))completion {
  [[SDWebImageManager sharedManager] loadImageWithURL:url
                                              options:options
                                             progress:nil
                                            completed:completion];
}

+ (void)diskImageExistsForURL:(nullable NSURL *)url
                    completed:(nullable void (^)(BOOL isInCache))completion{
  [[SDWebImageManager sharedManager] diskImageExistsForURL:url
                                                completion:completion];
}

+ (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url {
  return [[SDWebImageManager sharedManager] cacheKeyForURL:url];
}

+ (void)removeSDWebImageForKey:(nullable NSString *)key {
  [[SDImageCache sharedImageCache] removeImageForKey:key withCompletion:nil];
}

+ (nullable UIImage *)imageFromCacheForKey:(nullable NSString *)key {
  return [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
}

+ (void)clearSDWebImageCache {
  [[SDImageCache sharedImageCache] clearMemory];
  [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

+ (BOOL)isSupportedSDWebImageVersion {
  BOOL imageViewMethodsExist = [UIImageView instancesRespondToSelector:@selector(sd_setShowActivityIndicatorView:)] &&
                               [UIImageView instancesRespondToSelector:@selector(sd_setImageWithURL:placeholderImage:completed:)];
  
  SDWebImagePrefetcher *prefetcher = [SDWebImagePrefetcher sharedImagePrefetcher];
  BOOL prefetcherMethodsExist = [prefetcher respondsToSelector:@selector(prefetchURLs:)];
  
  SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
  BOOL managerMethodsExist = [imageManager respondsToSelector:@selector(loadImageWithURL:options:progress:completed:)] &&
                             [imageManager respondsToSelector:@selector(diskImageExistsForURL:completion:)] &&
                             [imageManager respondsToSelector:@selector(cacheKeyForURL:)];
  
  SDImageCache *imageCache = [SDImageCache sharedImageCache];
  BOOL imageCacheMethodsExist = [imageCache respondsToSelector:@selector(removeImageForKey:withCompletion:)] &&
                                [imageCache respondsToSelector:@selector(clearDiskOnCompletion:)] &&
                                [imageCache respondsToSelector:@selector(clearMemory)] &&
                                [imageCache respondsToSelector:@selector(imageFromCacheForKey:)];
  
  return imageViewMethodsExist && prefetcherMethodsExist && managerMethodsExist && imageCacheMethodsExist;
}

@end
