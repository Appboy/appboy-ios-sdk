#import "PushStoryViewController.h"
#import "AppboyKit.h"

@implementation PushStoryViewController

- (IBAction)showSamplePushStories:(id)sender {
  NSDictionary *samplePayload = @{@"aps" : @{@"content-available" : @1},
                                  @"ab" : @{@"type" : @7,
                                            @"c" : @"NTdlYWQxZGNmYmU3NmEzNjNhZTY3OWFiXzU3ZWFkMWRjZmJlNzZhMzYzYWU2NzlhZF9jbXA=",
                                            @"ab_carousel" : @1,
                                            @"apple" : @{@"alert" : @{@"title" : @"Carousel",
                                                                      @"body" : @"Carousel Testing",
                                                                      @"badge" : @10,
                                                                      @"sound" : @"default",
                                                                      @"title-loc-key" : @"Appboy.Stopwatch.test-view.appboy-version.message",
                                                                      @"title-loc-args" : @"3.9.9"}},
                                            @"c_items" : @[@{@"i" : @"https://appboy-staging-dashboard-uploads.s3.amazonaws.com/appboy/communication/assets/image_assets/images/59efaad09ad352042dd733df/original.?1508879056",
                                                             @"i_t" : @"png",
                                                             @"t" : @"Picture, Center Title Picture, Center Title Picture, Center Title Picture, Center Title Picture, Center Title Picture, Center Title",
                                                             @"t_j" : @"center",
                                                             @"st" : @"This text is left aligned",
                                                             @"uri" : @"stopwatch://push-story-image-1",
                                                             @"id" : @"item id 1",
                                                             @"st_j" : @"start"},
                                                           @{@"i" : @"https://appboy-staging-dashboard-uploads.s3.amazonaws.com/appboy/communication/marketing/ios_carousel_slides/images/59f0ea409ad352042dd73770/0c0ef21c4a3e08e4136f4ef63c4b8d6e3d9c160a/original.png?1508960843",
                                                             @"i_t" : @"png",
                                                             @"t" : @"Picture, Centered Title",
                                                             @"t_j" : @"center",
                                                             @"st" : @"This text is right aligned",
                                                             @"id" : @"item id 2",
                                                             @"st_j" : @"end"},
                                                            @{@"i" : @"https://appboy-staging-dashboard-uploads.s3.amazonaws.com/appboy/communication/assets/image_assets/images/59dd4bd464aa69042da719ea/original.?1507675092",
                                                              @"i_t" : @"jpg",
                                                              @"t" : @"Picture, Right Aligned Title",
                                                              @"t_j" : @"end",
                                                              @"uri" : @"stopwatch://push-story-image-3",
                                                              @"id" : @"item id 3",
                                                              @"st" : @"This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. This text is centered. ",
                                                              @"st_j" : @"center"}]}};
  [[Appboy sharedInstance] registerApplication:[UIApplication sharedApplication]
                  didReceiveRemoteNotification:samplePayload
                        fetchCompletionHandler:nil];
}

@end
